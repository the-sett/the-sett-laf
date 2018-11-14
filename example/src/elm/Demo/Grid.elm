module Demo.Grid exposing (view)

import Css
import Grid exposing (auto, center, col, columns, grid, offset, row)
import Html.Styled exposing (a, div, h1, h4, li, styled, text, toUnstyled, ul)
import Html.Styled.Attributes exposing (class, href, id, src, title)
import Html.Styled.Lazy exposing (lazy)
import Logo exposing (logo)
import Responsive exposing (deviceStyle, rhythm)
import ResponsiveDSL exposing (lg, md, sm, styles, xl)
import Structure exposing (Template(..))
import Svg.Styled


view : Template msg model
view =
    (\devices ->
        div
            []
            [ div [ id "grids" ] []
            , styled h1
                [ Css.textAlign Css.center ]
                []
                [ text "Grids" ]
            , h4 [] [ text "Column Widths" ]
            , gridn devices widths
            , h4 [] [ text "Column Offsets" ]
            , gridn devices offsets
            , h4 [] [ text "CentecellStyle" ]
            , gridn devices centecellStyle
            , h4 [] [ text "End" ]
            , gridn devices end
            , h4 [] [ text "Auto Width" ]
            , gridn devices autoWidth
            , h4 [] [ text "Mixed Fixed and Auto Width" ]
            , gridn devices widthAndAuto
            ]
    )
        |> lazy
        |> Static


cellStyle =
    styles
        [ Css.backgroundColor <| Css.rgba 150 100 100 0.3
        , Css.property "box-shadow" "0 0 0 1px black inset"
        ]



-- Row generating functions


widths n =
    row []
        []
        [ col [ sm [ columns n, cellStyle ] ] [] [ text "cell" ] ]


offsets n =
    row []
        []
        [ col [ sm [ columns <| 13 - n, offset <| n - 1, cellStyle ] ] [] [ text "cell" ] ]


centecellStyle n =
    row [ sm [ center ] ]
        []
        [ col [ sm [ columns n, cellStyle ] ] [] [ text "cell" ] ]


end n =
    row [ sm [ Grid.end ] ]
        []
        [ col [ sm [ columns n, cellStyle ] ] [] [ text "cell" ] ]


autoWidth n =
    row []
        []
    <|
        List.repeat (floor n) (col [ sm [ auto, cellStyle ] ] [] [ text "cell" ])


widthAndAuto n =
    row []
        []
        [ col [ sm [ columns n, cellStyle ] ] [] [ text "cell" ]
        , col [ sm [ auto, cellStyle ] ] [] [ text "cell" ]
        ]



-- Grid generating functions


gridn devices rowFn =
    grid
        []
        []
        (List.map rowFn <| List.map toFloat <| List.filter (\v -> modBy 3 v == 0) <| List.range 1 12)
        devices
