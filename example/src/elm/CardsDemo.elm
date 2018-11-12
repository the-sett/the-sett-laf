module CardsDemo exposing (view)

import Cards exposing (card)
import Css
import Grid exposing (col, columns, grid, lg, md, offset, row, sm, xl)
import Html.Styled exposing (a, div, h1, h4, i, img, p, styled, text, toUnstyled)
import Html.Styled.Attributes exposing (class, id, name, src, title)
import Html.Styled.Lazy exposing (lazy)
import Responsive exposing (deviceStyle, deviceStyles, rhythm)
import Structure exposing (Template(..))


view : Template msg model
view =
    (\devices ->
        div
            []
            [ div [ id "cards" ] []
            , styled h1
                [ Css.textAlign Css.center ]
                []
                [ text "Cards" ]
            , grid
                []
                []
                [ row
                    []
                    []
                    [ col
                        [ sm [ columns 6 ]
                        , md [ columns 4, offset 2 ]
                        ]
                        []
                        [ card devices "Card1" "images/more-from-4.png" ]
                    , col
                        [ sm [ columns 6 ]
                        , md [ columns 4 ]
                        ]
                        []
                        [ card devices "Card2" "images/more-from-3.png" ]
                    ]
                ]
                devices
            ]
    )
        |> lazy
        |> Static
