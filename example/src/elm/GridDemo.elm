module GridDemo exposing (view)

import Css
import Grid exposing (grid, row, col, sm, md, lg, xl, center, columns, offset)
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
            , gridn devices [] widths
            , h4 [] [ text "Column Offsets" ]
            , gridn devices [] offsets
            , h4 [] [ text "Centered" ]
            , gridn devices centered widths
            ]
            |> toUnstyled
    )
        |> lazy
        |> Static



-- Row generating functions


centered =
    [ sm [ center ] ]



-- Column generating functions


widths n =
    col [ sm [ columns n ] ] [] [ text "cell" ]


offsets n =
    col [ sm [ columns 1, offset <| n - 1 ] ] [] [ text "cell" ]



-- Grid generating functions


gridn devices rowProps cellFn =
    grid
        []
        []
        [ row
            rowProps
            []
            (List.map cellFn <| List.map toFloat <| List.range 1 12)
        ]
        devices
