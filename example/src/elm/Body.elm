module Body exposing (view)

import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (title, class)
import TheSettLaf exposing (wrapper)
import Structure exposing (Template)


view : List (Template msg model) -> Template msg model
view templates devices model =
    styled div
        [ wrapper devices ]
        []
        (List.map (\template -> template devices model) templates)
