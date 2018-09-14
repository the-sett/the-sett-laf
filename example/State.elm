module State exposing (Model, Msg(..))

{-| Keeping the update structure flat for this simple application.
-}


type Msg
    = Toggle Bool


type alias Model =
    Bool
