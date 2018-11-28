module TheSett.TextField exposing (global, input)

import Css
import Css.Global
import Html.Styled exposing (div, label, span, styled)
import Html.Styled.Attributes exposing (for, name)
import Responsive exposing (ResponsiveStyle, rhythmPx)


pathToId path =
    List.map String.fromInt path
        |> String.join "-"


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


input : List Int -> List (Html.Styled.Attribute msg) -> List (Html.Styled.Html msg) -> ResponsiveStyle -> Html.Styled.Html msg
input idPath attrs innerHtml responsive =
    let
        id =
            pathToId idPath
    in
    styled div
        [ Css.position Css.relative
        , Css.fontFamilies [ "Helvetica" ]
        , Responsive.deviceStyles responsive
            (\common device ->
                [ Css.marginTop <| Responsive.rhythmPx 1 common device
                , Css.paddingBottom <| Responsive.rhythmPx 1 common device
                , Css.height <| Responsive.rhythmPx 1 common device
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
            ([ Html.Styled.Attributes.id id, name id ] ++ attrs)
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
