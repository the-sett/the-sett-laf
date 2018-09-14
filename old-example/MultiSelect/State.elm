module Multiselect.State exposing (init, update)

import Dict
import Platform.Cmd exposing (Cmd)
import Material
import Multiselect.Types exposing (..)


init : Model
init =
    { mdl = Material.model
    , data =
        Dict.fromList
            [ ( 0, "Bold" )
            , ( 1, "Italic" )
            , ( 2, "Underline" )
            , ( 3, "Strikethrough" )
            ]
    , selected = Dict.empty
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case (Debug.log "multiselect" action) of
        Mdl action_ ->
            Material.update action_ model

        Selected result ->
            case result of
                Ok idx ->
                    case (Dict.get idx model.data) of
                        Just value ->
                            ( { model | selected = Dict.insert idx value model.selected }, Cmd.none )

                        Nothing ->
                            ( model, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        Deselected result ->
            case result of
                Ok idx ->
                    ( { model | selected = Dict.remove idx model.selected }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )
