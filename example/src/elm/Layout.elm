module Layout exposing (layout)

import Css
import Devices exposing (md, sm)
import Grid
import Html.Styled exposing (Html, a, button, div, input, li, nav, node, styled, text, ul)
import Html.Styled.Attributes exposing (attribute, checked, class, href, id, type_)
import Html.Styled.Events exposing (onClick)
import Responsive exposing (ResponsiveStyle)
import State exposing (Model, Msg(..))
import Structure exposing (Layout, Template(..))
import Svg.Styled
import TheSett.Laf as Laf exposing (wrapper)
import TheSett.Logo as Logo


layout : Layout Msg Model
layout template =
    pageBody template


pageBody : Template Msg Model -> Template Msg Model
pageBody template =
    (\devices model ->
        div
            []
            [ debugToggle devices model
            , topHeader devices model
            , case template of
                Dynamic fn ->
                    fn devices model

                Static fn ->
                    Html.Styled.map never <| fn devices
            , footer devices
            ]
    )
        |> Dynamic


topHeader : ResponsiveStyle -> Model -> Html Msg
topHeader devices model =
    styled div
        [ Css.boxShadow5 (Css.px 0) (Css.px 0) (Css.px 6) (Css.px 0) (Css.rgba 0 0 0 0.75)
        ]
        []
        [ Grid.grid
            [ sm
                [ ResponsiveDSL.styles
                    [ wrapper devices
                    , Responsive.deviceStyle devices <|
                        \device -> Css.height (Responsive.rhythm devices.commonStyle device 3)
                    ]
                ]
            ]
            []
            [ Grid.row
                [ sm [ Grid.middle ] ]
                []
                [ Grid.col
                    [ sm
                        [ Grid.columns 1
                        , ResponsiveDSL.styles
                            [ Responsive.deviceStyles devices <|
                                \device ->
                                    [ Css.height (Responsive.rhythm devices.commonStyle device 3)
                                    , Css.width (Responsive.rhythm devices.commonStyle device 3)
                                    ]
                            ]
                        ]
                    ]
                    []
                    [ styled div
                        [ Css.height (Css.pct 90)
                        , Css.marginTop (Css.pct 4)
                        ]
                        []
                        [ Svg.Styled.fromUnstyled Logo.logo ]
                    ]
                , Grid.col
                    [ sm [ Grid.columns 8, Grid.center ]
                    , md [ Grid.columns 10, Grid.center ]
                    ]
                    []
                    [ styled ul
                        [ Css.display Css.inline ]
                        []
                        [ styled li
                            [ Css.display Css.inline ]
                            []
                            [ styled a [ Css.padding (Css.px 10) ] [ onClick <| ScrollTo "typography" ] [ text "Typography" ] ]
                        , styled li
                            [ Css.display Css.inline ]
                            []
                            [ styled a [ Css.padding (Css.px 10) ] [ onClick <| ScrollTo "buttons" ] [ text "Buttons" ] ]
                        , styled li
                            [ Css.display Css.inline ]
                            []
                            [ styled a [ Css.padding (Css.px 10) ] [ onClick <| ScrollTo "grids" ] [ text "Grids" ] ]
                        , styled li
                            [ Css.display Css.inline ]
                            []
                            [ styled a [ Css.padding (Css.px 10) ] [ onClick <| ScrollTo "cards" ] [ text "Cards" ] ]
                        , styled li
                            [ Css.display Css.inline ]
                            []
                            [ styled a [ Css.padding (Css.px 10) ] [ onClick <| ScrollTo "markdown" ] [ text "Markdown" ] ]
                        ]
                    ]
                ]
            ]
            devices
        ]


debugToggle devices model =
    styled div
        [ Css.position Css.fixed
        , Responsive.deviceStyles devices <|
            \device ->
                [ Css.right (Responsive.rhythm devices.commonStyle device 2)
                , Css.top (Responsive.rhythm devices.commonStyle device 1)
                ]
        , if model then
            Css.backgroundColor (Css.rgb 50 230 50) |> Css.important

          else
            Css.backgroundColor (Css.rgb 255 255 255)
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


footer : ResponsiveStyle -> Html msg
footer devices =
    node "footer" [ class "thesett-footer mdl-mega-footer" ] []
