module Forms.Types exposing (..)

import Material


type alias Model =
    { mdl : Material.Model
    , str4 : String
    }


type Msg
    = Mdl (Material.Msg Msg)
    | Upd4 String
