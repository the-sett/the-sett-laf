module Forms.View exposing (root)

import Html exposing (..)
import Html.Attributes exposing (title, class, for, id, type_, pattern, action)
import Regex
import Material.Options as Options exposing (Style, css)
import Material.Button as Button
import Material.Textfield as Textfield
import Forms.Types exposing (..)


rx : String
rx =
    "[0-9]*"


rx_ : Regex.Regex
rx_ =
    Regex.regex rx


match : String -> Regex.Regex -> Bool
match str rx =
    Regex.find Regex.All rx str
        |> List.any (.match >> (==) str)


root : Model -> Html Msg
root model =
    div [ class "layout-fixed-width" ]
        [ h2 []
            [ text "Forms" ]
        , form [ action "#" ]
            [ Textfield.render Mdl
                [ 1 ]
                model.mdl
                [ Textfield.label "Text..."
                , Textfield.floatingLabel
                , Textfield.text_
                ]
            ]
        , form [ action "#" ]
            [ Textfield.render Mdl
                [ 2 ]
                model.mdl
                [ Textfield.label "Number.."
                , Textfield.floatingLabel
                , if not <| match model.str4 rx_ then
                    Textfield.error <| "Not a number"
                  else
                    Options.nop
                , Textfield.onInput Upd4
                ]
            ]
        , form [ action "#" ]
            [ Textfield.render Mdl
                [ 3 ]
                model.mdl
                [ Textfield.label "Text..."
                , Textfield.floatingLabel
                , Textfield.text_
                ]
            ]
        , div [ class "control-bar" ]
            [ div [ class "control-bar__row" ]
                [ div [ class "control-bar__left-0" ]
                    [ Button.render Mdl
                        [ 0 ]
                        model.mdl
                        [ Button.colored
                        , Button.ripple
                        ]
                        [ text "Submit" ]
                    ]
                ]
            ]
        ]
