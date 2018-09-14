module Tables.Types exposing (..)

import Material
import Set exposing (..)


type alias Data =
    { material : String
    , quantity : String
    , unitPrice : String
    }


type alias Model =
    { mdl : Material.Model
    , selected : Set String
    , data : List Data
    }


type Msg
    = Mdl (Material.Msg Msg)
    | Toggle (String)
    | ToggleAll
    | Add
    | Delete
    | ConfirmDelete
    | Edit
