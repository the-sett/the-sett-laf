module Main exposing (main)

import Html
import Html.Styled
import TheSettLaf
import Typography


main =
    Html.div []
        [ TheSettLaf.style |> Html.Styled.toUnstyled
        , Typography.view
        ]
