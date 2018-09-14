module Layout exposing (layout)

import Html.Styled exposing (Html, styled, node, text, div, button, a, nav, body, input)
import Html.Styled.Attributes exposing (attribute, class, href, id, type_, checked)
import Html.Styled.Events exposing (onCheck)
import Responsive exposing (Devices)
import Structure exposing (Template, Layout)
import State exposing (Model, Msg(..))
import TheSettLaf exposing (wrapper)


layout : Layout Msg Model
layout template devices model =
    pageBody template devices model


pageBody : Template Msg Model -> Devices -> Model -> Html Msg
pageBody template devices model =
    styled div
        [ wrapper devices ]
        []
        [ topHeader devices model, template devices model, footer devices ]


topHeader : Devices -> Model -> Html Msg
topHeader devices model =
    div []
        [ div []
            [ a [ href "/Main.elm" ]
                [ text "the-sett" ]
            , div []
                [ text "spacer" ]
            , nav []
                [ a [ href "/Main.elm" ]
                    [ text "What is this?" ]
                ]
            , div []
                [ text "spacer" ]
            , div []
                [ input
                    [ type_ "checkbox"
                    , checked model
                    , onCheck Toggle
                    ]
                    []
                , text "debug"
                ]
            ]
        ]


footer : Devices -> Html msg
footer devices =
    node "footer" [ class "thesett-footer mdl-mega-footer" ] []
