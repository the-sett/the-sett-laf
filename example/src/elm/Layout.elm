module Layout exposing (layout)

import Css
import Grid exposing (grid, row, col, sm, md, lg, xl)
import Html.Styled exposing (Html, styled, node, text, div, button, a, nav, body, input, ul, li)
import Html.Styled.Attributes exposing (attribute, class, href, id, type_, checked)
import Html.Styled.Events exposing (onClick)
import Logo exposing (logo)
import Responsive exposing (DeviceStyles)
import Structure exposing (Template, Layout)
import State exposing (Model, Msg(..))
import Svg.Styled
import TheSettLaf exposing (wrapper)


layout : Layout Msg Model
layout template devices model =
    pageBody template devices model


pageBody : Template Msg Model -> DeviceStyles -> Model -> Html Msg
pageBody template devices model =
    div
        []
        [ debugToggle devices model
        , topHeader devices model
        , template devices model
        , footer devices
        ]


topHeader : DeviceStyles -> Model -> Html Msg
topHeader devices model =
    styled div
        [ Css.boxShadow5 (Css.px 0) (Css.px 0) (Css.px 6) (Css.px 0) (Css.rgba 0 0 0 0.75)
        ]
        []
        [ styled div
            [ Css.displayFlex
            , Css.justifyContent Css.spaceBetween
            , Css.alignItems Css.center
            , wrapper devices
            , Responsive.deviceStyle devices <|
                \deviceProps -> Css.height (Responsive.rhythm deviceProps 3)
            ]
            []
            [ styled div
                [ Css.height (Css.pct 90)
                ]
                []
                [ Svg.Styled.fromUnstyled logo
                ]
            , div
                []
                [ styled ul
                    [ Css.display Css.inline ]
                    []
                    [ styled li
                        [ Css.display Css.inline ]
                        []
                        [ styled a [ Css.padding (Css.px 10) ] [ href "#typography" ] [ text "Typography" ] ]
                    , styled li
                        [ Css.display Css.inline ]
                        []
                        [ styled a [ Css.padding (Css.px 10) ] [ href "#grids" ] [ text "Grids" ] ]
                    , styled li
                        [ Css.display Css.inline ]
                        []
                        [ styled a [ Css.padding (Css.px 10) ] [ href "#cards" ] [ text "Cards" ] ]
                    , styled li
                        [ Css.display Css.inline ]
                        []
                        [ styled a [ Css.padding (Css.px 10) ] [ href "#markdown" ] [ text "Markdown" ] ]
                    ]
                ]
            ]
        ]


debugToggle devices model =
    styled div
        [ Css.position Css.fixed
        , Responsive.deviceStyles devices <|
            \deviceProps ->
                [ Css.right (Responsive.rhythm deviceProps 2)
                , Css.top (Responsive.rhythm deviceProps 1)
                ]
        , Css.hover [ Css.backgroundColor (Css.rgb 50 210 50) ]
        , Css.padding2 (Css.px 5) (Css.px 10)
        , Css.margin (Css.px -5)
        , Css.boxShadow5 (Css.px 0) (Css.px 0) (Css.px 3) (Css.px 0) (Css.rgba 0 0 0 0.75)
        , Css.borderRadius (Css.px 4)
        , Css.property "user-select" "none"
        ]
        [ onClick <| Toggle (not model) ]
        [ text "grid"
        ]


footer : DeviceStyles -> Html msg
footer devices =
    node "footer" [ class "thesett-footer mdl-mega-footer" ] []
