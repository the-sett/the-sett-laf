module State exposing (Model, Msg(..))

{-| Keeping the update structure flat for this simple application.
-}


type Msg
    = Toggle Bool
    | ScrollTo String
    | NoOp


type alias Model =
    Bool
