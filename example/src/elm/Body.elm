module Body exposing (view)

import Html.Styled exposing (div, styled)
import Html.Styled.Attributes exposing (class, title)
import Structure exposing (Template(..))
import TheSettLaf


view : List (Template msg model) -> Template msg model
view templates =
    (\devices model ->
        styled div
            [ TheSettLaf.wrapper devices ]
            []
            (List.map
                (\template ->
                    case template of
                        Dynamic fn ->
                            fn devices model

                        Static fn ->
                            Html.Styled.map never <| fn devices
                )
                templates
            )
    )
        |> Dynamic
