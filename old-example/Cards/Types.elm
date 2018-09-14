module Cards.Types exposing (..)

import Material


type alias Model =
    { mdl : Material.Model
    }


type Msg
    = Mdl (Material.Msg Msg)
