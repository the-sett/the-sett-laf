module Tables.State exposing (init, update, allSelected, someSelected, key)

import Platform.Cmd exposing (Cmd)
import Material
import Tables.Types exposing (..)
import Set as Set


log =
    Debug.log "accounts"


init : Model
init =
    { mdl = Material.model
    , selected = Set.empty
    , data =
        [ { material = "Acrylic (Transparent)", quantity = "25", unitPrice = "$2.90" }
        , { material = "Plywood (Birch)", quantity = "50", unitPrice = "$1.25" }
        , { material = "Laminate (Gold on Blue)", quantity = "10", unitPrice = "$2.35" }
        ]
    }


key : Data -> String
key =
    .material


allSelected : Model -> Bool
allSelected model =
    Set.size model.selected == List.length model.data


someSelected : Model -> Bool
someSelected model =
    Set.size model.selected > 0


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Mdl action_ ->
            Material.update action_ model

        ToggleAll ->
            { model
                | selected =
                    if allSelected model then
                        Set.empty
                    else
                        List.map key model.data |> Set.fromList
            }
                ! []

        Toggle k ->
            { model
                | selected =
                    if Set.member k model.selected then
                        Set.remove k model.selected
                    else
                        Set.insert k model.selected
            }
                ! []

        Add ->
            let
                d =
                    log "add"
            in
                ( model, Cmd.none )

        Delete ->
            let
                d =
                    log "delete"
            in
                ( model, Cmd.none )

        ConfirmDelete ->
            let
                d =
                    log "confirm delete"
            in
                ( model, Cmd.none )

        Edit ->
            let
                d =
                    log "edit"
            in
                ( model, Cmd.none )
