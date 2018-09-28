module Cards exposing (view)

import Css
import Grid exposing (grid, row, col, sm, md, lg, xl, columns, offset)
import Html.Styled exposing (styled, toUnstyled, div, i, text, h1, p, h4, img, a)
import Html.Styled.Attributes exposing (title, class, name, src)
import Html.Styled.Lazy exposing (lazy)
import Structure exposing (Template(..))
import Responsive exposing (deviceStyle, deviceStyles, rhythm)


view : Template msg model
view =
    (\devices ->
        div
            []
            [ a [ name "cards" ] []
            , styled h1
                [ Css.textAlign Css.center ]
                []
                [ text "Cards" ]
            , grid
                []
                []
                [ row
                    []
                    []
                    [ col
                        [ sm [ columns 6 ]
                        , md [ columns 4, offset 2 ]
                        , lg [ columns 3, offset 3 ]
                        ]
                        []
                        [ card devices "Card1" "images/more-from-4.png" ]
                    , col
                        [ sm [ columns 6 ]
                        , md [ columns 4 ]
                        , lg [ columns 3 ]
                        ]
                        []
                        [ card devices "Card2" "images/more-from-3.png" ]
                    ]
                ]
                devices
            ]
            |> toUnstyled
    )
        |> lazy
        |> Static


card devices title imgSrc =
    styled div
        [ Css.borderRadius (Css.px 2)
        , Css.property "box-shadow" "rgba(0, 0, 0, 0.14) 0px 3px 4px 0px, rgba(0, 0, 0, 0.2) 0px 3px 3px -2px, rgba(0, 0, 0, 0.12) 0px 1px 8px 0px"
        , Css.marginLeft (Css.rem 0.5)
        , Css.marginRight (Css.rem 0.5)
        ]
        []
        [ styled div
            [ deviceStyle devices <|
                \deviceProps -> Css.height (rhythm deviceProps 6)
            ]
            []
            [ styled img
                [ Css.height (Css.pct 100)
                , Css.width (Css.pct 100)
                ]
                [ src imgSrc ]
                []
            ]
        , styled div
            [ Css.paddingLeft (Css.rem 1.5)
            , Css.paddingRight (Css.rem 1)
            ]
            []
            [ h4 []
                [ text title ]
            ]
        , styled div
            [ Css.paddingLeft (Css.rem 1)
            , Css.paddingRight (Css.rem 1)
            ]
            []
            [ p []
                [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. " ]
            ]
        , styled div
            [ Css.paddingLeft (Css.rem 1)
            , Css.paddingRight (Css.rem 1)
            , Css.paddingBottom (Css.rem 1)
            ]
            []
            [ text "button"

            --  Button.render Mdl
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
