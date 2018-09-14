module Layout exposing (layout)

import Html.Styled exposing (Html, node, text, div, button, a, nav, body)
import Html.Styled.Attributes exposing (attribute, class, href, id)
import Responsive exposing (Devices)
import Structure exposing (Template, Layout)


layout : Layout msg
layout template devices =
    pageBody template devices


pageBody : Template msg -> Devices -> Html msg
pageBody template devices =
    div [ class "mdl-layout mdl-js-layout mdl-layout--fixed-header" ]
        [ topHeader devices, template devices, footer devices ]


topHeader : Devices -> Html msg
topHeader devices =
    div [ class "mdl-layout__header mdl-layout__header--waterfall" ]
        [ div [ class "mdl-layout__header-row" ]
            [ a [ href "overview", id "thesett-logo" ]
                []
            , div [ class "mdl-layout-spacer" ]
                []
            , nav [ class "mdl-navigation" ]
                [ a [ class "mdl-navigation__link mdl-typography--text-uppercase", href "about" ]
                    [ text "What is this?" ]
                ]
            , div [ class "mdl-layout-spacer" ]
                []
            , a
                [ class "mdl-button mdl-button--colored", href "/editor/" ]
                [ text "Edit" ]
            ]
        ]


footer : Devices -> Html msg
footer devices =
    node "footer" [ class "thesett-footer mdl-mega-footer" ] []
