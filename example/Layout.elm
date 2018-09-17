module Layout exposing (layout)

import Css
import Html.Styled exposing (Html, styled, node, text, div, button, a, nav, body, input, ul, li)
import Html.Styled.Attributes exposing (attribute, class, href, id, type_, checked)
import Html.Styled.Events exposing (onCheck)
import Logo exposing (logo)
import Responsive exposing (Devices)
import Structure exposing (Template, Layout)
import State exposing (Model, Msg(..))
import Svg.Styled
import TheSettLaf exposing (wrapper)


layout : Layout Msg Model
layout template devices model =
    pageBody template devices model


pageBody : Template Msg Model -> Devices -> Model -> Html Msg
pageBody template devices model =
    div
        []
        [ topHeader devices model, template devices model, footer devices ]


topHeader : Devices -> Model -> Html Msg
topHeader devices model =
    div
        []
        [ styled div
            [ Css.displayFlex
            , Css.justifyContent Css.spaceBetween
            , wrapper devices
            , Responsive.deviceStyle devices <|
                \deviceProps -> Css.height (Responsive.rhythm deviceProps 3)
            ]
            []
            [ div []
                [ Svg.Styled.fromUnstyled logo

                --  a [ href "/Main.elm" ]
                --     [ text "the-sett" ]
                ]
            , nav []
                [ styled ul
                    [ Css.display Css.inline ]
                    []
                    [ styled li
                        [ Css.display Css.inline ]
                        []
                        [ text "Typography" ]
                    , styled li
                        [ Css.display Css.inline ]
                        []
                        [ text "Buttons" ]
                    , styled li
                        [ Css.display Css.inline ]
                        []
                        [ text "Etc" ]
                    ]
                ]
            , div []
                [ input
                    [ type_ "checkbox"
                    , checked model
                    , onCheck Toggle
                    ]
                    []
                , text "grid"
                ]
            ]
        ]


footer : Devices -> Html msg
footer devices =
    node "footer" [ class "thesett-footer mdl-mega-footer" ] []
