module TheSett.TextField exposing (Model, Msg, global, init, textField, update)

import Css
import Css.Global
import Html.Styled exposing (div, label, span, styled)
import Html.Styled.Attributes exposing (for, name)
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
import TheSett.Component exposing (Index, indexAsId)


{-| The global snippet for text fields.
-}
global =
    [ Css.Global.class "er-textfield--focus-floating"
        [ Css.top <| Css.px -26
        , Css.transform <| Css.scale 0.75
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


init =
    { focus = False }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Focus ->
            { model | focus = True }

        Unfocus ->
            { model | focus = False }


{-| The text field styling context.
-}
type TextField
    = TextField


textField : Index -> SimpleElementBuilder { a | textField : Compatible } TextField msg
textField index builders attributes innerHtml responsive =
    let
        id =
            indexAsId index
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
            [ for id ]
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

             --  , onFocus Focus
             --  , onBlur Unfocus
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
