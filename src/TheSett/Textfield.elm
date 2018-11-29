module TheSett.Textfield exposing (Model, Msg, global, react, render, textField, update)

import Css
import Css.Global
import Html.Styled exposing (Attribute, Html, div, label, span, styled)
import Html.Styled.Attributes exposing (classList, for, name)
import Html.Styled.Events exposing (onBlur, onFocus)
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
        , Compatible(..)
        , ConstDeviceBuilder
        , SimpleElementBuilder
        , StyleBuilder
        , applyDevicesToBuilders
        )
import Styles
import TheSett.Component as Component exposing (Index, Indexed, indexAsId)


{-| The global snippet for text fields.
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


{-| Events and state needed by text fields.
-}
type Msg
    = Focus
    | Unfocus


type alias Model =
    { focus : Bool }


default =
    { focus = False }


update : (Msg -> msg) -> Msg -> Model -> ( Maybe Model, Cmd msg )
update lift msg model =
    case msg of
        Focus ->
            ( Just { model | focus = True }, Cmd.none )

        Unfocus ->
            ( Just { model | focus = False }, Cmd.none )


{-| The text field styling context.
-}
type TextField
    = TextField


textField : (Msg -> msg) -> Model -> SimpleElementBuilder { a | textField : Compatible } TextField msg
textField lift model builders attributes innerHtml responsive =
    let
        id =
            -- indexAsId index
            "id"
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



-- COMPONENT


type alias Store s =
    { s | textfield : Indexed Model }


react : (Component.Msg Msg -> msg) -> Msg -> Index -> Store s -> ( Maybe (Store s), Cmd msg )
react =
    let
        ( get, set ) =
            Component.indexed .textfield (\x c -> { c | textfield = x }) default
    in
    Component.react get
        set
        Component.TextfieldMsg
        update


render :
    (Component.Msg Msg -> msg)
    -> Index
    -> Store s
    -> SimpleElementBuilder { a | textField : Compatible } TextField msg
render =
    let
        ( get, set ) =
            Component.indexed .textfield (\x c -> { c | textfield = x }) default
    in
    Component.render get textField Component.TextfieldMsg
