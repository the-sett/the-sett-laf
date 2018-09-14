module Multiselect.Types exposing (..)

import Dict exposing (Dict)
import Material


type alias Model =
    { mdl : Material.Model
    , data : Dict Int String
    , selected : Dict Int String
    }


type Msg
    = Mdl (Material.Msg Msg)
    | Selected (Result String Int)
    | Deselected (Result String Int)
