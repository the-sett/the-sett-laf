module GridDemo exposing (view)

import Css
import Grid exposing (grid, row, col, sm, md, lg, xl, HAlign(..), VAlign(..))
import Html.Styled exposing (styled, h1, h4, text, div, a, li, ul, toUnstyled)
import Html.Styled.Attributes exposing (title, class, name, src, href)
import Html.Styled.Lazy exposing (lazy)
import Logo exposing (logo)
import Svg.Styled
import Structure exposing (Template(..))
import Responsive exposing (deviceStyle, rhythm)


view : Template msg model
view =
    (\devices ->
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
            ]
            |> toUnstyled
    )
        |> lazy
        |> Static


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
