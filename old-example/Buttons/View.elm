module Buttons.View exposing (root)

import Html exposing (..)
import Html.Attributes exposing (title, class, type_)
import Material.Button as Button
import Material.Icon as Icon
import Buttons.Types exposing (..)


root : Model -> Html Msg
root model =
    div [ class "layout-fixed-width" ]
        [ h2 []
            [ text "Buttons" ]
        , Button.render Mdl
            [ 0 ]
            model.mdl
            [ Button.colored
            , Button.ripple
            ]
            [ text "Button" ]
        , Button.render Mdl
            [ 1 ]
            model.mdl
            [ Button.accent
            , Button.ripple
            ]
            [ text "Button" ]
        , h2 []
            [ text "Chips" ]
        , span [ class "mdl-chip mdl-chip__text" ]
            [ text "Basic Chip" ]
        , span [ class "mdl-chip mdl-chip--deletable mdl-chip__text" ]
            [ text "Deletable Chip"
            , button [ class "mdl-chip__action", type_ "button" ]
                [ i [ class "material-icons" ]
                    [ text "cancel" ]
                ]
            ]
        , h2 []
            [ text "Control Bar" ]
        , div [ class "control-bar" ]
            [ div [ class "control-bar__row" ]
                [ div [ class "control-bar__left-0" ]
                    [ span [ class "mdl-chip mdl-chip__text" ]
                        [ text "Basic Chip" ]
                    ]
                , div [ class "control-bar__left-3" ]
                    [ p []
                        [ text "Some text" ]
                    ]
                , div [ class "control-bar__right-0" ]
                    [ Button.render Mdl
                        [ 3 ]
                        model.mdl
                        [ Button.fab
                        , Button.colored
                        , Button.ripple
                        ]
                        [ Icon.i "add" ]
                    ]
                , div [ class "control-bar__right-0" ]
                    [ Button.render Mdl
                        [ 4 ]
                        model.mdl
                        [ Button.colored
                        , Button.ripple
                        ]
                        [ text "Button" ]
                    ]
                ]
            ]
        ]
