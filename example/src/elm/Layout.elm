module Layout exposing (layout)

import Css
import Grid
import Html.Styled exposing (Html, a, button, div, input, li, nav, node, styled, text, ul)
import Html.Styled.Attributes exposing (attribute, checked, class, href, id, type_)
import Html.Styled.Events exposing (onClick)
import Responsive exposing (ResponsiveStyle)
import State exposing (Model, Msg(..), Page(..))
import Structure exposing (Layout, Template(..))
import Styles exposing (md, sm)
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
                [ Styles.styles
                    [ wrapper devices
                    , Responsive.deviceStyle devices <|
                        \device -> Css.height (Responsive.rhythm 3 devices.commonStyle device)
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
                        , Styles.styles
                            [ Responsive.deviceStyles devices <|
                                \device ->
                                    [ Css.height (Responsive.rhythm 3 devices.commonStyle device)
                                    , Css.width (Responsive.rhythm 3 devices.commonStyle device)
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
                            [ styled a [ Css.padding (Css.px 10) ] [ onClick <| SwitchTo Typography ] [ text "Typography" ] ]
                        , styled li
                            [ Css.display Css.inline ]
                            []
                            [ styled a [ Css.padding (Css.px 10) ] [ onClick <| SwitchTo Buttons ] [ text "Buttons" ] ]
                        , styled li
                            [ Css.display Css.inline ]
                            []
                            [ styled a [ Css.padding (Css.px 10) ] [ onClick <| SwitchTo Grid ] [ text "Grids" ] ]
                        , styled li
                            [ Css.display Css.inline ]
                            []
                            [ styled a [ Css.padding (Css.px 10) ] [ onClick <| SwitchTo Cards ] [ text "Cards" ] ]
                        , styled li
                            [ Css.display Css.inline ]
                            []
                            [ styled a [ Css.padding (Css.px 10) ] [ onClick <| SwitchTo Markdown ] [ text "Markdown" ] ]
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
                [ Css.right (Responsive.rhythm 2 devices.commonStyle device)
                , Css.top (Responsive.rhythm 1 devices.commonStyle device)
                ]
        , if model.debug then
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
        [ onClick <| Toggle (not model.debug) ]
        [ text "grid"
        ]


footer : ResponsiveStyle -> Html msg
footer devices =
    node "footer" [ class "thesett-footer mdl-mega-footer" ] []
