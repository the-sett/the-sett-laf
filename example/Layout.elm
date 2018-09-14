module Layout exposing (layout)

import Html.Styled exposing (Html, styled, node, text, div, button, a, nav, body)
import Html.Styled.Attributes exposing (attribute, class, href, id)
import Responsive exposing (Devices)
import Structure exposing (Template, Layout)
import TheSettLaf exposing (wrapper)


layout : Layout msg
layout template devices =
    pageBody template devices


pageBody : Template msg -> Devices -> Html msg
pageBody template devices =
    styled div
        [ wrapper devices ]
        []
        [ topHeader devices, template devices, footer devices ]


topHeader : Devices -> Html msg
topHeader devices =
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
            , a
                [ href "/Main.elm" ]
                [ text "Button" ]
            ]
        ]


footer : Devices -> Html msg
footer devices =
    node "footer" [ class "thesett-footer mdl-mega-footer" ] []
