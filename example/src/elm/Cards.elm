module Cards exposing (view)

import Css
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (title, class, name)
import Structure exposing (Template)


view : Template msg model
view devices model =
    div
        []
        [ a [ name "cards" ] []
        , styled h1
            [ Css.textAlign Css.center ]
            []
            [ text "Cards" ]
        ]
