module Cards.View exposing (root)

import Html exposing (..)
import Html.Attributes exposing (title, class, href, src)
import Material.Button as Button
import Cards.Types exposing (..)


root : Model -> Html Msg
root model =
    div []
        [ div [ class "layout-fixed-width" ]
            [ h2 []
                [ text "Cards" ]
            , div [ class "mdl-grid" ]
                [ div [ class "mdl-cell mdl-cell--6-col mdl-cell--4-col-tablet mdl-cell--4-col-phone mdl-card mdl-shadow--3dp" ]
                    [ div [ class "mdl-card__media" ]
                        [ img [ src "images/more-from-4-large.png" ]
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
                        [ Button.render Mdl
                            [ 0 ]
                            model.mdl
                            [ Button.colored
                            , Button.ripple
                            ]
                            [ text "Link"
                            , i [ class "material-icons" ]
                                [ text "chevron_right" ]
                            ]
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
                        [ Button.render Mdl
                            [ 1 ]
                            model.mdl
                            [ Button.colored
                            , Button.ripple
                            ]
                            [ text "Link"
                            , i [ class "material-icons" ]
                                [ text "chevron_right" ]
                            ]
                        ]
                    ]
                ]
            , h2 []
                [ text "One Card" ]
            ]
        , div [ class "layout-fixed-width--one-card" ]
            [ div [ class "mdl-grid" ]
                [ div [ class "mdl-cell mdl-cell--12-col mdl-cell--8-col-tablet mdl-cell--4-col-phone mdl-card mdl-shadow--3dp" ]
                    [ div [ class "mdl-card__media" ]
                        [ img [ src "images/more-from-4-large.png" ]
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
                        [ Button.render Mdl
                            [ 2 ]
                            model.mdl
                            [ Button.colored
                            , Button.ripple
                            ]
                            [ text "Link"
                            , i [ class "material-icons" ]
                                [ text "chevron_right" ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
