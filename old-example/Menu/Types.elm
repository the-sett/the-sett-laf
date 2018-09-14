module Menu.Types exposing (..)

import Material
import Material.Menu as Menu exposing (..)


type alias Mdl =
    Material.Model


type alias Model =
    { mdl : Material.Model
    , selected : Maybe String
    , icon : String
    }


type Msg
    = MenuMsg Int Menu.Msg
    | MDL (Material.Msg Msg)
    | Select String
    | SetIcon String
