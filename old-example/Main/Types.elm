module Main.Types exposing (..)

import Material
import Layout.Types
import Menu.Types
import Typography.Types
import Buttons.Types
import Cards.Types
import Tables.Types
import Forms.Types
import Multiselect.Types
import Dialogs.Types


type alias Model =
    { mdl : Material.Model
    , typography : Typography.Types.Model
    , buttons : Buttons.Types.Model
    , cards : Cards.Types.Model
    , tables : Tables.Types.Model
    , forms : Forms.Types.Model
    , multiselect : Multiselect.Types.Model
    , dialogs : Dialogs.Types.Model
    , layout : Layout.Types.Model
    , menus : Menu.Types.Model
    , selectedTab : Int
    , transparentHeader : Bool
    , debugStylesheet : Bool
    }


type Msg
    = SelectTab Int
    | Mdl (Material.Msg Msg)
    | TypographyMsg Typography.Types.Msg
    | ButtonsMsg Buttons.Types.Msg
    | CardsMsg Cards.Types.Msg
    | TablesMsg Tables.Types.Msg
    | FormsMsg Forms.Types.Msg
    | MultiselectMsg Multiselect.Types.Msg
    | DialogsMsg Dialogs.Types.Msg
    | LayoutMsg Layout.Types.Msg
    | MenusMsg Menu.Types.Msg
    | ToggleHeader
    | ToggleDebug
