module Demo.Textfield exposing (view)

import Css
import Html.Styled exposing (div, h1, h2, h3, h4, li, ol, p, styled, text, ul)
import Html.Styled.Attributes exposing (id)
import Html.Styled.Lazy exposing (lazy2)
import State exposing (Model, Msg(..))
import Structure exposing (Template(..))
import TheSett.Textfield as Textfield


view : Template Msg Model
view =
    (\devices model ->
        div
            []
            [ div [ id "textfield" ] []
            , styled h1
                [ Css.textAlign Css.center ]
                []
                [ text "Textfield" ]
            , Textfield.text
                LafMsg
                [ 1 ]
                model.laf
                [ Textfield.value "default" ]
                []
                [ text "Search" ]
                devices
            ]
    )
        |> lazy2
        |> Dynamic
