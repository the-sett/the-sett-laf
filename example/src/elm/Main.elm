module Main exposing (main)

import Body
import Browser
import Browser.Dom exposing (getViewportOf, setViewportOf)
import Css.Global
import Demo.Buttons
import Demo.Cards
import Demo.Grid
import Demo.MkDown
import Demo.Typography
import Html.Styled exposing (div, input, text, toUnstyled)
import Html.Styled.Attributes exposing (checked, type_)
import Html.Styled.Events exposing (onCheck)
import Layout
import State exposing (Model, Msg(..))
import Structure exposing (Template(..))
import Task
import TheSett.Debug
import TheSett.Laf as Laf
import TheSett.Logo


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
    case Debug.log "update" msg of
        Toggle state ->
            ( state, Cmd.none )

        ScrollTo id ->
            ( model, jumpToId id )

        NoOp ->
            ( model, Cmd.none )


jumpToId : String -> Cmd Msg
jumpToId id =
    Browser.Dom.getElement id
        |> Task.andThen (\info -> Browser.Dom.setViewport 0 (Debug.log "viewport" info).element.y)
        |> Task.attempt (\_ -> NoOp)


view model =
    styledView model
        |> toUnstyled


styledView model =
    let
        innerView =
            [ Laf.responsiveMeta
            , Laf.fonts
            , Laf.style Laf.devices
            , case
                Layout.layout <|
                    Body.view
                        [ Demo.Typography.view
                        , Demo.Buttons.view
                        , Demo.Grid.view
                        , Demo.Cards.view
                        , Demo.MkDown.view
                        ]
              of
                Dynamic fn ->
                    fn Laf.devices model

                Static fn ->
                    Html.Styled.map never <| fn Laf.devices
            ]

        debugStyle =
            Css.Global.global <|
                TheSett.Debug.global Laf.devices
    in
    case model of
        True ->
            div [] (debugStyle :: innerView)

        False ->
            div [] innerView
