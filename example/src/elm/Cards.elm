module Cards exposing (view)

import Css
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (title, class, name, src)
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
        , styled div
            []
            []
            [ div [ class "mdl-grid" ]
                [ div [ class "mdl-cell mdl-cell--6-col mdl-cell--4-col-tablet mdl-cell--4-col-phone mdl-card mdl-shadow--3dp" ]
                    [ div [ class "mdl-card__media" ]
                        [ img [ src "images/more-from-4.png" ]
                            []
                        ]
                    , div [ class "mdl-card__title" ]
                        [ h4 [ class "mdl-card__title-text" ]
                            [ text "Card 2" ]
                        ]
                    , div [ class "mdl-card__supporting-text" ]
                        [ p []
                            [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. " ]
                        ]
                    , div [ class "mdl-card__actions" ]
                        [--  Button.render Mdl
                         --     [ 0 ]
                         --     model.mdl
                         --     [ Button.colored
                         --     , Button.ripple
                         --     ]
                         --     [ text "Link"
                         --     , i [ class "material-icons" ]
                         --         [ text "chevron_right" ]
                         --     ]
                        ]
                    ]
                , div [ class "mdl-cell mdl-cell--6-col mdl-cell--4-col-tablet mdl-cell--4-col-phone mdl-card mdl-shadow--3dp" ]
                    [ div [ class "mdl-card__media" ]
                        [ img [ src "images/more-from-3-large.png" ]
                            []
                        ]
                    , div [ class "mdl-card__title" ]
                        [ h4 [ class "mdl-card__title-text" ]
                            [ text "Card 4" ]
                        ]
                    , div [ class "mdl-card__supporting-text" ]
                        [ p []
                            [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. " ]
                        ]
                    , div [ class "mdl-card__actions" ]
                        [-- Button.render Mdl
                         --     [ 1 ]
                         --     model.mdl
                         --     [ Button.colored
                         --     , Button.ripple
                         --     ]
                         --     [ text "Link"
                         --     , i [ class "material-icons" ]
                         --         [ text "chevron_right" ]
                         --     ]
                        ]
                    ]
                ]
            ]
        ]
