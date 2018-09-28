module GridDemo exposing (view)

import Css
import Grid exposing (grid, row, col, sm, md, lg, xl, center, columns, offset, styles)
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
            , h4 [] [ text "End" ]
            , gridn devices end
            ]
            |> toUnstyled
    )
        |> lazy
        |> Static


red =
    styles [ Css.backgroundColor <| Css.rgb 240 100 100 ]



-- Row generating functions


widths n =
    row []
        []
        [ col [ sm [ columns n, red ] ] [] [ text "cell" ] ]


offsets n =
    row []
        []
        [ col [ sm [ columns <| 13 - n, offset <| n - 1, red ] ] [] [ text "cell" ] ]


centered n =
    row [ sm [ center ] ]
        []
        [ col [ sm [ columns n, red ] ] [] [ text "cell" ] ]


end n =
    row [ sm [ Grid.end ] ]
        []
        [ col [ sm [ columns n, red ] ] [] [ text "cell" ] ]



-- Grid generating functions


gridn devices rowFn =
    grid
        []
        []
        (List.map rowFn <| List.map toFloat <| List.range 1 12)
        devices
