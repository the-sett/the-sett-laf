module Main exposing (main)

import DebugStyle
import Html
import Html.Styled
import TheSettLaf
import Typography


main =
    Html.div []
        [ TheSettLaf.fonts
        , TheSettLaf.style TheSettLaf.devices |> Html.Styled.toUnstyled

        --, DebugStyle.style TheSettLaf.devices |> Html.Styled.toUnstyled
        , Typography.view
        ]
