module Demo.Buttons exposing (view)

import Css
import Grid
import Html.Styled exposing (div, h1, styled, text)
import Html.Styled.Attributes exposing (id)
import Html.Styled.Lazy exposing (lazy)
import Structure exposing (Template(..))
import Styles exposing (lg, md, sm, xl)
import TheSett.Buttons as Buttons


view : Template msg model
view =
    (\devices ->
        div
            []
            [ div [ id "buttons" ] []
            , styled h1
                [ Css.textAlign Css.center ]
                []
                [ text "Buttons" ]
            , Grid.grid
                []
                []
                [ Grid.row
                    []
                    []
                    [ Grid.col
                        [ sm [ Grid.columns 6 ]
                        , md [ Grid.columns 4, Grid.offset 2 ]
                        ]
                        []
                        [ Buttons.button [] [] [ text "Button" ] devices ]
                    ]
                ]
                devices
            ]
    )
        |> lazy
        |> Static
