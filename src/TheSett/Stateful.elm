module TheSett.Stateful exposing
    ( Msg(..)
    , Model
    )

{-| Stateful defines a model for holding state against UI elements that need it.


# Messages that stateful elements use to signal changes.

@docs Msg


# The stateful UI model.

@docs Model

-}

import Dict exposing (Dict)
import Maybe.Extra
import TheSett.Id exposing (IdPath)
import TheSett.TextField as TextField


type alias Model =
    { textFields : Dict IdPath TextField.Model }


type Msg
    = TextFieldMsg IdPath TextField.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        TextFieldMsg id tfMsg ->
            Dict.get id model.textFields
                |> Maybe.map (TextField.update tfMsg)
                |> Maybe.map (\newModel -> Dict.insert id newModel model.textFields)
                |> Maybe.map (\textFields -> { model | textFields = textFields })
                |> Maybe.withDefault model
