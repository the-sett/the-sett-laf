module TheSett.Id exposing (IdPath, pathToId)

{-| Unique identifiers for stateful elements.


# Identifiers for stateful elements.

@docs IdPath, pathToId

-}


type alias IdPath =
    List Int


pathToId path =
    List.map String.fromInt path
        |> String.join "-"
