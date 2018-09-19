module GridDemo exposing (view)

import Css
import Grid exposing (grid, row, col, sm, md, lg, xl)
import Html.Styled exposing (styled, h1, text, div, a)
import Html.Styled.Attributes exposing (title, class, name, src)
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
        , grid1 devices
        ]


grid1 devices =
    grid
        []
        [ row
            []
            [ col devices
                [ md 6, sm 12 ]
                []
                [ text "cell1" ]
            , col devices
                [ md 6, sm 12 ]
                []
                [ text "cell2" ]
            ]
        ]
