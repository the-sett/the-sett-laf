module TheSett.Textfield exposing
    ( global
    , text, password
    , labelText, labelFloat, error, value, disabled, autocomplete
    , Model, Msg(..), update
    )

{-| For building text inputs.


# Global Snippet to add to the stylesheet.

@docs global


# Builders for building different kinds of textfields.

@docs text, password


# Builders for configuring textfields.

@docs labelText, labelFloat, error, value, disabled, autocomplete


# TEA model for the textfield (internal use).

@docs Model, Msg, update

-}

import Css
import Css.Global
import Html.Events
import Html.Styled exposing (Attribute, Html, div, label, span, styled)
import Html.Styled.Attributes exposing (classList, for, name, type_)
import Html.Styled.Events exposing (on, onBlur, onFocus, onInput)
import Json.Decode as Decoder
import Maybe.Extra
import Responsive
    exposing
        ( Device(..)
        , DeviceProps
        , DeviceSpec
        , ResponsiveFn
        , ResponsiveStyle
        , deviceStyle
        , deviceStyles
        )
import ResponsiveDSL
    exposing
        ( Builder(..)
        , ByDeviceBuilder
        , Compatible(..)
        , ConstDeviceBuilder
        , SimpleElementBuilder
        , StyleBuilder
        , applyDevicesToBuilders
        , chainCtxAcrossBuilders
        )
import Styles
import TheSett.Component as Component exposing (Index, Indexed, indexAsId)


{-| The global style snippet for text fields.
-}
global : ResponsiveStyle -> List Css.Global.Snippet
global responsive =
    [ Css.Global.class "er-textfield"
        [ Css.position Css.relative
        , Css.fontFamilies [ "Helvetica" ]
        , Responsive.deviceStyles responsive
            (\device ->
                [ Css.marginTop <| Responsive.rhythmPx 1 device
                , Css.paddingBottom <| Responsive.rhythmPx 1 device
                , Css.height <| Responsive.rhythmPx 1 device
                ]
            )
        ]
    , Css.Global.class "er-textfield--label"
        [ Css.position Css.absolute
        , Css.color <| Css.hex "999"
        , Css.left <| Css.px 0
        , Css.top <| Css.px 0
        , Css.property "transition" "all 0.2s ease"
        , Css.pointerEvents Css.none
        ]
    , Css.Global.class "er-textfield--label-floating"
        [ Responsive.deviceStyle responsive
            (\device -> Css.top <| Css.px (-1 * Responsive.rhythm 1 device))
        , Css.transform <| Css.scale 0.66
        , Css.property "transform-origin" "left center"
        , Css.left <| Css.px 0
        , Css.color <| Css.hex "4CAF50"
        ]
    , Css.Global.class "er-textfield--input"
        [ Css.border <| Css.px 0
        , Css.borderBottom3 (Css.px 1) Css.solid (Css.hex "666")
        , Css.display Css.block
        , Css.focus [ Css.outline Css.none ]
        , Css.backgroundColor Css.transparent
        , Css.width <| Css.pct 100
        ]
    , Css.Global.class "er-textfield--span"
        [ Css.position Css.relative
        , Css.display Css.block
        , Css.width <| Css.pct 100
        , Css.before
            [ Css.property "content" "''"
            , Css.height <| Css.px 2
            , Css.width <| Css.px 0
            , Css.bottom <| Css.px 0
            , Css.position Css.absolute
            , Css.backgroundColor <| Css.hex "4CAF50"
            , Css.property "transition" "all 0.2s ease"
            , Css.left <| Css.pct 50
            ]
        , Css.after
            [ Css.property "content" "''"
            , Css.height <| Css.px 2
            , Css.width <| Css.px 0
            , Css.bottom <| Css.px 0
            , Css.position Css.absolute
            , Css.backgroundColor <| Css.hex "4CAF50"
            , Css.property "transition" "all 0.2s ease"
            , Css.right <| Css.pct 50
            ]
        ]
    , Css.Global.typeSelector "input:focus"
        [ Css.Global.generalSiblings
            [ Css.Global.typeSelector "span:before"
                [ Css.width <| Css.pct 50
                ]
            ]
        ]
    , Css.Global.typeSelector "input:focus"
        [ Css.Global.generalSiblings
            [ Css.Global.typeSelector "span:after"
                [ Css.width <| Css.pct 50
                ]
            ]
        ]
    ]



-- State and state change logic.


type alias State =
    { focus : Bool
    , dirty : Bool
    }


default =
    { focus = False
    , dirty = False
    }


innerUpdate : (Msg -> msg) -> Msg -> State -> ( Maybe State, Cmd msg )
innerUpdate lift msg model =
    case msg of
        Focus ->
            ( Just { model | focus = True }, Cmd.none )

        Unfocus ->
            ( Just { model | focus = False }, Cmd.none )

        Input val ->
            let
                dirty =
                    val /= ""
            in
            if dirty == model.dirty then
                ( Nothing, Cmd.none )

            else
                ( Just { model | dirty = dirty }, Cmd.none )



-- The styling and configuration context.


type InputType
    = Text
    | Password


type alias Config =
    { inputType : InputType
    , labelText : Maybe String
    , labelFloat : Bool
    , error : Maybe String
    , value : Maybe String
    , disabled : Bool
    , autocomplete : Bool
    }


defaultConfig : Config
defaultConfig =
    { inputType = Text
    , labelText = Nothing
    , labelFloat = False
    , error = Nothing
    , value = Nothing
    , disabled = False
    , autocomplete = True
    }


type Textfield
    = Textfield Config



-- The textfield DSL builders.


{-| Creates a plain text field.
-}
text :
    (Component.Msg Msg -> msg)
    -> Index
    -> Model s
    -> SimpleElementBuilder { a | textfield : Compatible } Textfield msg
text =
    let
        ( get, set ) =
            Component.indexed .textfield (\x c -> { c | textfield = x }) default
    in
    Component.render get (view defaultConfig) Component.TextfieldMsg


{-| Creates a password text field.
-}
password :
    (Component.Msg Msg -> msg)
    -> Index
    -> Model s
    -> SimpleElementBuilder { a | textfield : Compatible } Textfield msg
password =
    let
        ( get, set ) =
            Component.indexed .textfield (\x c -> { c | textfield = x }) default
    in
    Component.render get (view { defaultConfig | inputType = Password }) Component.TextfieldMsg


{-| Sets the text for the label.
-}
labelText : String -> ByDeviceBuilder { a | textfield : Compatible } Textfield
labelText val =
    [ \(Textfield config) -> ByDeviceProps (Textfield { config | labelText = Just val }) (always <| always [])
    ]


{-| Makes the label float on focus or when the textfield contains some value.
-}
labelFloat : ByDeviceBuilder { a | textfield : Compatible } Textfield
labelFloat =
    [ \(Textfield config) -> ByDeviceProps (Textfield { config | labelFloat = True }) (always <| always [])
    ]


{-| Sets the error text for the input.
-}
error : String -> ByDeviceBuilder { a | textfield : Compatible } Textfield
error val =
    [ \(Textfield config) -> ByDeviceProps (Textfield { config | error = Just val }) (always <| always [])
    ]


{-| Sets the initial value for the input.
-}
value : String -> ByDeviceBuilder { a | textfield : Compatible } Textfield
value val =
    [ \(Textfield config) -> ByDeviceProps (Textfield { config | value = Just val }) (always <| always [])
    ]


{-| Makes the input disabled.
-}
disabled : ByDeviceBuilder { a | textfield : Compatible } Textfield
disabled =
    [ \(Textfield config) -> ByDeviceProps (Textfield { config | disabled = True }) (always <| always [])
    ]


{-| Sets autocomplete=off on the input.
-}
autocomplete : Bool -> ByDeviceBuilder { a | textfield : Compatible } Textfield
autocomplete state =
    [ \(Textfield config) -> ByDeviceProps (Textfield { config | autocomplete = state }) (always <| always [])
    ]



-- View rendering.


view : Config -> (Msg -> msg) -> State -> SimpleElementBuilder { a | textfield : Compatible } Textfield msg
view initialConfig lift model builders attributes innerHtml responsive =
    let
        id =
            -- indexAsId index
            "id"

        initialCtx =
            Textfield initialConfig

        ( flatBuilders, ctx ) =
            chainCtxAcrossBuilders initialCtx builders

        (Textfield config) =
            ctx

        optionalAttributes =
            [ Maybe.map Html.Styled.Attributes.value config.value
            ]
                |> Maybe.Extra.values

        dirty =
            case config.value of
                Just "" ->
                    False

                Just _ ->
                    True

                Nothing ->
                    model.dirty
    in
    styled div
        []
        ([ classList [ ( "er-textfield", True ) ] ]
            ++ attributes
        )
        [ styled label
            []
            [ for id
            , classList
                [ ( "er-textfield--label", True )
                , ( "er-textfield--label-floating", model.focus || dirty )
                ]
            ]
            innerHtml
        , styled Html.Styled.input
            []
            ([ classList [ ( "er-textfield--input", True ) ]
             , Html.Styled.Attributes.id id
             , name id
             , case config.inputType of
                Text ->
                    type_ "text"

                Password ->
                    type_ "password"
             , Html.Styled.Attributes.disabled config.disabled
             , Html.Styled.Attributes.autocomplete config.autocomplete
             , onFocus <| lift Focus
             , onBlur <| lift Unfocus
             , on "input" <|
                Decoder.map (Input >> lift) Html.Events.targetValue
             ]
                ++ optionalAttributes
            )
            []
        , styled span
            []
            [ classList [ ( "er-textfield--span", True ) ] ]
            []
        ]



-- TEA model for the textfield.


{-| The events that text fields produce and consume to maintain their internal state.
-}
type Msg
    = Focus
    | Unfocus
    | Input String


{-| Holds a mapping from ids to textfield state.
-}
type alias Model s =
    { s | textfield : Indexed State }


{-| Deals with text field messages, by locating a text field by its id, or creating a
new default state for that text field is one does not exist yet.

The internal message is then processed against that text fields state.

-}
update : (Component.Msg Msg -> msg) -> Msg -> Index -> Model s -> ( Maybe (Model s), Cmd msg )
update =
    let
        ( get, set ) =
            Component.indexed .textfield (\x c -> { c | textfield = x }) default
    in
    Component.react get
        set
        Component.TextfieldMsg
        innerUpdate
