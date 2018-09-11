module Main exposing (main)

import DebugStyle
import Html
import Html.Styled
import TheSettLaf
import Typography


main =
    Html.div []
        [ TheSettLaf.fonts
        , TheSettLaf.style |> Html.Styled.toUnstyled
        , DebugStyle.style |> Html.Styled.toUnstyled
        , Typography.view
        ]
