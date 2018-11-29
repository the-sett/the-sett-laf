module TheSett.Textfield exposing
    ( global
    , text
    , labelText, labelFloat, error, value, disabled
    , Model, Msg(..), update
    )

{-| For building text inputs.


# Global Snippet to add to the stylesheet.

@docs global


# Builders for building different kinds of textfields.

@docs text


# Builders for configuring textfields.

@docs labelText, labelFloat, error, value, disabled


# TEA model for the textfield (internal use).

@docs Model, Msg, update

-}

import Css
import Css.Global
import Html.Styled exposing (Attribute, Html, div, label, span, styled)
import Html.Styled.Attributes exposing (classList, for, name)
import Html.Styled.Events exposing (onBlur, onFocus)
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
    [ Css.Global.class "er-textfield--focus-floating"
        [ Responsive.deviceStyle responsive
            (\device -> Css.top <| Css.px (-1 * Responsive.rhythm 1 device))
        , Css.transform <| Css.scale 0.66
        , Css.property "transform-origin" "left center"
        , Css.left <| Css.px 0
        , Css.color <| Css.hex "4CAF50"
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
    { focus : Bool }


default =
    { focus = False }


innerUpdate : (Msg -> msg) -> Msg -> State -> ( Maybe State, Cmd msg )
innerUpdate lift msg model =
    case msg of
        Focus ->
            ( Just { model | focus = True }, Cmd.none )

        Unfocus ->
            ( Just { model | focus = False }, Cmd.none )



-- The styling and configuration context.


type alias Config =
    { labelText : Maybe String
    , labelFloat : Bool
    , error : Maybe String
    , value : Maybe String
    , disabled : Bool
    }


defaultConfig : Config
defaultConfig =
    { labelText = Nothing
    , labelFloat = False
    , error = Nothing
    , value = Nothing
    , disabled = False
    }


type Textfield
    = Textfield Config



-- The textfield DSL builders.


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
    Component.render get view Component.TextfieldMsg


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



-- View rendering.


view : (Msg -> msg) -> State -> SimpleElementBuilder { a | textfield : Compatible } Textfield msg
view lift model builders attributes innerHtml responsive =
    let
        id =
            -- indexAsId index
            "id"

        initialCtx =
            Textfield defaultConfig

        ( flatBuilders, ctx ) =
            chainCtxAcrossBuilders initialCtx builders

        (Textfield config) =
            ctx

        optionalAttributes =
            [ Maybe.map Html.Styled.Attributes.value config.value ]
                |> Maybe.Extra.values
    in
    styled div
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
        []
        [ styled label
            [ Css.position Css.absolute
            , Css.color <| Css.hex "999"
            , Css.left <| Css.px 0
            , Css.top <| Css.px 0
            , Css.property "transition" "all 0.2s ease"
            , Css.pointerEvents Css.none
            ]
            [ for id
            , classList [ ( "er-textfield--focus-floating", model.focus ) ]
            ]
            innerHtml
        , styled Html.Styled.input
            [ Css.border <| Css.px 0
            , Css.borderBottom3 (Css.px 1) Css.solid (Css.hex "666")
            , Css.display Css.block
            , Css.focus [ Css.outline Css.none ]
            , Css.backgroundColor Css.transparent
            , Css.width <| Css.pct 100
            ]
            ([ Html.Styled.Attributes.id id
             , name id
             , onFocus <| lift Focus
             , onBlur <| lift Unfocus
             ]
                ++ optionalAttributes
                ++ attributes
            )
            []
        , styled span
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
            []
            []
        ]



-- TEA model for the textfield.


type Msg
    = Focus
    | Unfocus


type alias Model s =
    { s | textfield : Indexed State }


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
