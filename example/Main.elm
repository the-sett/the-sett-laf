module Main exposing (main)

import DebugStyle
import Html exposing (program)
import Html.Styled exposing (toUnstyled, div, input, text)
import Html.Styled.Attributes exposing (type_, checked)
import Html.Styled.Events exposing (onCheck)
import TheSettLaf exposing (fonts, responsiveMeta, devices)
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
    styledView model
        |> toUnstyled


styledView model =
    let
        innerView =
            [ responsiveMeta
            , fonts
            , TheSettLaf.style devices
            , debugControl model
            , Typography.view devices
            ]

        debugStyle =
            DebugStyle.style devices
    in
        case model of
            True ->
                div [] (debugStyle :: innerView)

            False ->
                div [] innerView


debugControl model =
    div []
        [ input
            [ type_ "checkbox"
            , checked model
            , onCheck Toggle
            ]
            []
        , text "debug"
        ]
