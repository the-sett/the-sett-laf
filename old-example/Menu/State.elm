module Menu.State exposing (init, update)

import Platform.Cmd exposing (Cmd)
import Material
import Menu.Types exposing (..)


init : Model
init =
    { mdl = Material.model
    , selected = Nothing
    , icon = "more_vert"
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        MDL action_ ->
            Material.update action_ model

        MenuMsg idx action ->
            ( model, Cmd.none )

        Select n ->
            ( { model | selected = Just n }
            , Cmd.none
            )

        SetIcon s ->
            ( { model | icon = s }
            , Cmd.none
            )
