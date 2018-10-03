module Main exposing (main)

import Body
import Browser
import Cards
import DebugStyle
import GridDemo
import Html.Styled exposing (div, input, text, toUnstyled)
import Html.Styled.Attributes exposing (checked, type_)
import Html.Styled.Events exposing (onCheck)
import Layout
import Logo
import MkDown
import State exposing (Model, Msg(..))
import Structure exposing (Template(..))
import TheSettLaf exposing (devices, fonts, responsiveMeta)
import Typography


main =
    Browser.document
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = \model -> { title = "The Sett LAF", body = [ view model ] }
        }


init () =
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
            , case
                Layout.layout <|
                    Body.view
                        [ Typography.view
                        , GridDemo.view
                        , Cards.view
                        , MkDown.view
                        ]
              of
                Dynamic fn ->
                    fn devices model

                Static fn ->
                    fn devices
            ]

        debugStyle =
            DebugStyle.style devices
    in
    case model of
        True ->
            div [] (debugStyle :: innerView)

        False ->
            div [] innerView
