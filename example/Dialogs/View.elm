module Dialogs.View exposing (root, dialog)

import Html exposing (..)
import Html.Attributes exposing (title, class, action)
import Material.Button as Button
import Material.Dialog as Dialog
import Material.Textfield as Textfield
import Material.Icon as Icon
import Dialogs.Types exposing (..)


root : Model -> Html Msg
root model =
    div [ class "layout-fixed-width" ]
        [ h2 [] [ text "Dialogs" ]
        , div [ class "control-bar__right-0" ]
            [ Button.render Mdl
                [ 0, 1 ]
                model.mdl
                [ Button.colored
                , Button.ripple
                , Dialog.openOn "click"
                ]
                [ text "Show Dialog" ]
            ]
        ]


dialog : Model -> Html Msg
dialog model =
    Dialog.view
        []
        [ Dialog.title [] [ h4 [ class "mdl-dialog__title-text" ] [ text "Log In" ] ]
        , Dialog.content []
            [ form [ action "#" ]
                [ Textfield.render Mdl
                    [ 1, 1 ]
                    model.mdl
                    [ Textfield.label "Username"
                    , Textfield.floatingLabel
                    , Textfield.text_
                    ]
                , Textfield.render Mdl
                    [ 1, 2 ]
                    model.mdl
                    [ Textfield.label "Password"
                    , Textfield.floatingLabel
                    , Textfield.text_
                    , Textfield.password
                    ]
                ]
            ]
        , Dialog.actions []
            [ div [ class "control-bar" ]
                [ div [ class "control-bar__row" ]
                    [ div [ class "control-bar__left-0" ]
                        [ Button.render Mdl
                            [ 1, 2 ]
                            model.mdl
                            [ Dialog.closeOn "click"
                            , Button.colored
                            ]
                            [ text "Login"
                            , Icon.i "chevron_right"
                            ]
                        ]
                    ]
                ]
            ]
        ]
