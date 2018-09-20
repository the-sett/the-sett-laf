module Cards exposing (view)

import Css
import Grid exposing (grid, row, col, sm, md, lg, xl)
import Html.Styled exposing (styled, div, text, h1, p, h4, img, a)
import Html.Styled.Attributes exposing (title, class, name, src)
import Structure exposing (Template)
import Responsive exposing (deviceStyle, rhythm)


view : Template msg model
view devices model =
    div
        []
        [ a [ name "cards" ] []
        , styled h1
            [ Css.textAlign Css.center ]
            []
            [ text "Cards" ]
        , grid
            []
            [ row
                []
                [ col devices
                    [ sm 6, md 4, lg 3 ]
                    []
                    [ card devices "Card1" "images/more-from-4.png" ]
                , col devices
                    [ sm 6, md 4, lg 3 ]
                    []
                    [ card devices "Card2" "images/more-from-3.png" ]
                ]
            ]
        ]


card devices title imgSrc =
    styled div
        [ Css.borderRadius (Css.px 2)
        , Css.property "box-shadow" "rgba(0, 0, 0, 0.14) 0px 3px 4px 0px, rgba(0, 0, 0, 0.2) 0px 3px 3px -2px, rgba(0, 0, 0, 0.12) 0px 1px 8px 0px"
        ]
        []
        [ styled div
            [ deviceStyle devices <|
                \deviceProps -> Css.height (rhythm deviceProps 6)
            ]
            [ class "mdl-card__media" ]
            [ styled img
                [ Css.maxHeight (Css.pct 100)
                , Css.width (Css.pct 100)
                ]
                [ src imgSrc ]
                []
            ]
        , div [ class "mdl-card__title" ]
            [ h4 [ class "mdl-card__title-text" ]
                [ text title ]
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
