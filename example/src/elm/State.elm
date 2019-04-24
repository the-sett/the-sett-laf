module State exposing (Model, Msg(..), Page(..))

import TheSett.Laf as Laf


{-| Keeping the update structure flat for this simple application.
-}
type Msg
    = LafMsg Laf.Msg
    | Toggle Bool
    | SwitchTo Page
    | NoOp
    | UpdateTextField String


type Page
    = Typography
    | Buttons
    | Textfield
    | Grid
    | Cards
    | Markdown


type alias Model =
    { laf : Laf.Model
    , debug : Bool
    , page : Page
    , textfield : String
    }
