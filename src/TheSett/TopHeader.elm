module TheSett.TopHeader exposing (topHeader)

import Css
import Grid
import Html.Styled exposing (Html, a, button, div, input, li, nav, node, styled, text, ul)
import Html.Styled.Attributes exposing (attribute, checked, class, href, id, type_)
import Html.Styled.Events exposing (onClick)
import Responsive exposing (ResponsiveStyle)
import Styles exposing (md, sm)
import Svg.Styled
import TheSett.Colors as Colors
import TheSett.Laf as Laf exposing (wrapper)
import TheSett.Logo as Logo


topHeader : ResponsiveStyle -> Html msg
topHeader responsive =
    styled div
        [ Css.backgroundColor Colors.paperWhite
        , Css.boxShadow5 (Css.px 0) (Css.px 0) (Css.px 1) (Css.px 0) (Css.rgba 0 0 0 0.25)
        ]
        []
        [ Grid.grid
            [ sm
                [ Grid.columns 12
                , Styles.styles
                    [ wrapper responsive
                    , Responsive.deviceStyle responsive <|
                        \device -> Css.height (Responsive.rhythmPx 4 device)
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
                            [ Responsive.deviceStyles responsive <|
                                \device ->
                                    [ Css.marginTop (Responsive.rhythmPx 0.5 device)
                                    , Css.height (Responsive.rhythmPx 3 device)
                                    , Css.width (Responsive.rhythmPx 3 device)
                                    ]
                            ]
                        ]
                    ]
                    []
                    [ Svg.Styled.fromUnstyled Logo.logo ]
                ]
            ]
            responsive
        ]
