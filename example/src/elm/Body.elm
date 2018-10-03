module Body exposing (view)

import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (class, title)
import Structure exposing (Template(..))
import TheSettLaf exposing (wrapper)


view : List (Template msg model) -> Template msg model
view templates =
    (\devices model ->
        styled div
            [ wrapper devices ]
            []
            (List.map
                (\template ->
                    case template of
                        Dynamic fn ->
                            fn devices model

                        Static fn ->
                            fn devices
                )
                templates
            )
    )
        |> Dynamic
