module TheSett.Logo exposing (logo)

{-| The Sett logo as SVG.

@docs logo

-}

import Svg exposing (Svg, defs, g, metadata, rect, svg, text, text_, tspan)
import Svg.Attributes exposing (d, height, id, shapeRendering, style, transform, version, viewBox, width, x, y)


{-| The Sett logo as SVG.
-}
logo : Svg msg
logo =
    svg
        [ height "100%"
        , viewBox "0 0 64.8 64.800003"
        , version "1.1"
        , id "svg8"
        ]
        [ defs [ id "defs2" ] []
        , metadata [ id "metadata5" ] []
        , g
            [ id "layer1"
            , transform "translate(-37.84667,-106.08756)"
            ]
            [ g [ id "g18805" ]
                [ g
                    [ transform "matrix(1.62,0,0,1.62,-43.552935,-85.862285)"
                    , id "g4499"
                    ]
                    [ rect
                        [ id "rect3680"
                        , width "40"
                        , height "40"
                        , x "50.24667"
                        , y "118.48756"
                        , style "stroke-width:0.21668023"
                        ]
                        []
                    , rect
                        [ id "rect3682"
                        , width "40"
                        , height "20"
                        , x "50.24667"
                        , y "138.48755"
                        , style "fill:#00b400;fill-opacity:1;stroke-width:0.20693107"
                        ]
                        []
                    ]
                , g
                    [ transform "matrix(1.62,0,0,1.62,-43.552935,-86.062269)"
                    , id "g14283"
                    ]
                    [ text_
                        [ style "font-style:normal;font-variant:normal;font-weight:normal;font-stretch:normal;font-size:12.66825008px;line-height:1.25;font-family:'Courier New';-inkscape-font-specification:'Courier New, Normal';font-variant-ligatures:normal;font-variant-caps:normal;font-variant-numeric:normal;font-feature-settings:normal;text-align:start;letter-spacing:0px;word-spacing:0px;writing-mode:lr-tb;text-anchor:start;fill:#ffffff;fill-opacity:1;stroke:#ffffff;stroke-width:0.31670624;stroke-opacity:1"
                        , x "52.988655"
                        , y "134.77873"
                        , id "text4491"
                        ]
                        [ tspan
                            [ id "tspan4489"
                            , x "52.988655"
                            , y "134.77873"
                            , style "font-style:normal;font-variant:normal;font-weight:normal;font-stretch:normal;font-size:12.66825008px;font-family:'Courier New';-inkscape-font-specification:'Courier New, Normal';font-variant-ligatures:normal;font-variant-caps:normal;font-variant-numeric:normal;font-feature-settings:normal;text-align:start;writing-mode:lr-tb;text-anchor:start;fill:#ffffff;fill-opacity:1;stroke:#ffffff;stroke-width:0.31670624;stroke-opacity:1"
                            ]
                            [ text "the" ]
                        ]
                    , text_ [ style "font-style:normal;font-variant:normal;font-weight:normal;font-stretch:normal;font-size:12.66825008px;line-height:1.25;font-family:'Courier New';-inkscape-font-specification:'Courier New, Normal';font-variant-ligatures:normal;font-variant-caps:normal;font-variant-numeric:normal;font-feature-settings:normal;text-align:start;letter-spacing:0px;word-spacing:0px;writing-mode:lr-tb;text-anchor:start;fill:#000000;fill-opacity:1;stroke:#000000;stroke-width:0.31720498;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1", x "52.61158", y "148.69533", id "text4495" ]
                        [ tspan
                            [ id "tspan4493"
                            , x "52.61158"
                            , y "148.69533"
                            , style "font-style:normal;font-variant:normal;font-weight:normal;font-stretch:normal;font-size:12.66825008px;font-family:'Courier New';-inkscape-font-specification:'Courier New, Normal';font-variant-ligatures:normal;font-variant-caps:normal;font-variant-numeric:normal;font-feature-settings:normal;text-align:start;writing-mode:lr-tb;text-anchor:start;fill:#000000;fill-opacity:1;stroke:#000000;stroke-width:0.31720498;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
                            ]
                            [ text "sett"
                            ]
                        ]
                    ]
                ]
            ]
        ]
