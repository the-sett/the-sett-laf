module Layout.Types exposing (..)

import Material
import Material.Color as Color


type alias Mdl =
    Material.Model


type HeaderType
    = Waterfall Bool
    | Seamed
    | Standard
    | Scrolling


type alias Model =
    { mdl : Material.Model
    , fixedHeader : Bool
    , fixedDrawer : Bool
    , fixedTabs : Bool
    , header : HeaderType
    , rippleTabs : Bool
    , transparentHeader : Bool
    , withDrawer : Bool
    , withHeader : Bool
    , withTabs : Bool
    , primary : Color.Hue
    , accent : Color.Hue
    }


type Msg
    = TemplateMsg
    | Update (Model -> Model)
    | Mdl (Material.Msg Msg)
