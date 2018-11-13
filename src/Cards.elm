module Cards exposing (card)

import Css
import Html.Styled exposing (a, div, h1, h4, i, img, p, styled, text, toUnstyled)
import Html.Styled.Attributes as Attributes exposing (class, id, name, title)
import Responsive exposing (deviceStyle, deviceStyles, rhythm)


card devices titleText imgSrc =
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
                [ Attributes.src imgSrc ]
                []
            ]
        , styled div
            [ Css.paddingLeft (Css.rem 1.5)
            , Css.paddingRight (Css.rem 1)
            ]
            []
            [ h4 []
                [ text titleText ]
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



--image : Device -> Grid -> Builder { a | grid : Never, column : Never }


crd _ _ =
    ()


image _ =
    ()


src _ =
    ()


title _ =
    ()


body _ =
    ()


controls _ =
    ()


height _ =
    ()


html : Html.Styled.Html msg
html =
    div [] []


test devices =
    crd
        [ image [ height 6, src "/whatever.png" ]
        , title "Title"
        , body [ html ]
        , controls [ html ]
        ]
        devices
