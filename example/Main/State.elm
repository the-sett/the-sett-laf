module Main.State exposing (init, update)

import Platform.Cmd exposing (..)
import Material
import Material.Helpers exposing (pure, lift, lift_, map1st, map2nd)
import Layout.State
import Menu.State
import Typography.State
import Buttons.State
import Cards.State
import Tables.State
import Forms.State
import Multiselect.State
import Dialogs.State
import Main.Types exposing (..)


log =
    Debug.log "top"


init : Model
init =
    { mdl = Material.model
    , typography = Typography.State.init
    , buttons = Buttons.State.init
    , cards = Cards.State.init
    , tables = Tables.State.init
    , forms = Forms.State.init
    , multiselect = Multiselect.State.init
    , dialogs = Dialogs.State.init
    , layout = Layout.State.init
    , menus = Menu.State.init
    , selectedTab = 0
    , transparentHeader = False
    , debugStylesheet = False
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        SelectTab k ->
            ( { model | selectedTab = k }, Cmd.none )

        ToggleHeader ->
            ( { model | transparentHeader = not model.transparentHeader }, Cmd.none )

        Mdl msg ->
            Material.update msg model

        TypographyMsg a ->
            lift .typography (\m x -> { m | typography = x }) TypographyMsg Typography.State.update a model

        ButtonsMsg a ->
            lift .buttons (\m x -> { m | buttons = x }) ButtonsMsg Buttons.State.update a model

        CardsMsg a ->
            lift .cards (\m x -> { m | cards = x }) CardsMsg Cards.State.update a model

        TablesMsg a ->
            lift .tables (\m x -> { m | tables = x }) TablesMsg Tables.State.update a model

        FormsMsg a ->
            Forms.State.update a model.forms
                |> Maybe.map (map1st (\x -> { model | forms = x }))
                |> Maybe.withDefault ( model, Cmd.none )
                |> map2nd (Cmd.map FormsMsg)

        MultiselectMsg a ->
            lift .multiselect (\m x -> { m | multiselect = x }) MultiselectMsg Multiselect.State.update a model

        DialogsMsg a ->
            lift .dialogs (\m x -> { m | dialogs = x }) DialogsMsg Dialogs.State.update a model

        LayoutMsg a ->
            lift .layout (\m x -> { m | layout = x }) LayoutMsg Layout.State.update a model

        MenusMsg a ->
            lift .menus (\m x -> { m | menus = x }) MenusMsg Menu.State.update a model

        ToggleDebug ->
            let
                d =
                    log "toggle debug"
            in
                ( { model | debugStylesheet = not model.debugStylesheet }, Cmd.none )
