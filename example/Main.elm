module Main exposing (main)

import DebugStyle
import Html
import Html.Attributes
import Html.Events
import Html.Styled
import TheSettLaf
import Typography


main =
    Html.program
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


type alias Model =
    Bool


type Msg
    = Toggle Bool


init =
    ( False, Cmd.none )


subscriptions _ =
    Sub.none


update msg model =
    case msg of
        Toggle state ->
            ( state, Cmd.none )


view model =
    let
        innerView =
            [ TheSettLaf.fonts
            , TheSettLaf.style TheSettLaf.devices |> Html.Styled.toUnstyled
            , debugControl model
            , Typography.view
            ]

        debugStyle =
            DebugStyle.style TheSettLaf.devices |> Html.Styled.toUnstyled
    in
        case model of
            True ->
                Html.div [] (debugStyle :: innerView)

            False ->
                Html.div [] innerView


debugControl model =
    Html.div []
        [ Html.input
            [ Html.Attributes.type_ "checkbox"
            , Html.Attributes.checked model
            , Html.Events.onCheck Toggle
            ]
            []
        , Html.text "debug"
        ]
