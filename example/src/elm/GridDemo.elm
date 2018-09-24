module GridDemo exposing (view)

import Css
import Grid exposing (grid, row, col, sm, md, lg, xl, HAlign(..), VAlign(..))
import Html.Styled exposing (styled, h1, h4, text, div, a, li, ul)
import Html.Styled.Attributes exposing (title, class, name, src, href)
import Logo exposing (logo)
import Svg.Styled
import Structure exposing (Template)
import Responsive exposing (deviceStyle, rhythm)


view : Template msg model
view devices model =
    div
        []
        [ a [ name "grids" ] []
        , styled h1
            [ Css.textAlign Css.center ]
            []
            [ text "Grids" ]
        , h4 [] [ text "Column Widths" ]
        , gridn devices widths
        , h4 [] [ text "Column Offsets" ]
        , gridn devices offsets
        , h4 [] [ text "Centered" ]
        , gridn devices centered
        , h4 [] [ text "Header" ]
        , headerGrid devices
        ]


red el =
    styled el
        [ Css.backgroundColor (Css.rgb 255 50 50) ]


centered devices n =
    red
        (col devices
            [ { sm | columns = n, halign = Center }
            ]
        )
        []
        [ text "cell" ]


widths devices n =
    red
        (col devices
            [ { sm | columns = n }
            ]
        )
        []
        [ text "cell" ]


offsets devices n =
    red
        (col devices
            [ { sm | columns = 1, offset = n - 1 }
            ]
        )
        []
        [ text "cell" ]


gridn devices cellFn =
    grid
        []
        (List.map
            (\n ->
                row
                    []
                    [ (cellFn devices n) ]
            )
            (List.range 1 12)
        )


headerGrid devices =
    grid
        []
        [ styled row
            [ Css.alignItems Css.center ]
            []
            [ styled
                (col devices
                    [ { sm | columns = 1 } ]
                )
                [ Responsive.deviceStyles devices <|
                    \deviceProps ->
                        [ Css.height (Responsive.rhythm deviceProps 3)
                        , Css.width (Responsive.rhythm deviceProps 3)
                        ]
                ]
                []
                [ Svg.Styled.fromUnstyled logo
                ]
            , col devices
                [ { sm | columns = 12, halign = Center }
                , { md | columns = 10 }
                ]
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
