module TheSett.Cards exposing
    ( card, image, title, body, controls
    , src
    )

{-| For building parts of a card:

@docs card, image, title, body, controls

For styling parts of a card:

@docs src

-}

import Css
import Html.Styled exposing (Attribute, Html, a, div, h1, h4, i, img, p, styled, text, toUnstyled)
import Html.Styled.Attributes as Attributes exposing (class, id, name, title)
import Responsive
    exposing
        ( Device(..)
        , DeviceProps
        , DeviceSpec
        , ResponsiveStyle
        , deviceStyle
        , deviceStyles
        , rhythmPx
        )
import ResponsiveDSL
    exposing
        ( Builder(..)
        , Compatible(..)
        , ConstDeviceBuilder
        , ElementBuilder
        , OuterBuilder
        , StyleBuilder
        , applyDevicesToBuilders
        )
import Styles


{-| The card styling context.
-}
type Card
    = Card
    | Image


{-| Creates a Card container.
-}
card : OuterBuilder { a | card : Compatible } Card msg
card builders attributes innerHtml responsive =
    let
        flatBuilders =
            List.concat builders
                |> List.map (\gridFn -> gridFn Card)
    in
    styled div
        [ Css.borderRadius (Css.px 2)
        , Css.property "box-shadow" "rgba(0, 0, 0, 0.14) 0px 3px 4px 0px, rgba(0, 0, 0, 0.2) 0px 3px 3px -2px, rgba(0, 0, 0, 0.12) 0px 1px 8px 0px"
        , Responsive.deviceStyles responsive
            (\device ->
                [ Css.marginLeft <| Responsive.rhythmPx 0.5 device
                , Css.marginRight <| Responsive.rhythmPx 0.5 device
                , Css.marginBottom <| Responsive.rhythmPx 1.0 device
                ]
            )
        , Css.overflow Css.hidden
        , applyDevicesToBuilders flatBuilders responsive
        ]
        attributes
        (List.map (\contentFn -> contentFn Card responsive) innerHtml)


{-| Creates an image on the card.
-}
image : ElementBuilder { a | image : Compatible } Card msg
image builders attributes innerHtml parentCtx responsive =
    let
        flatBuilders =
            List.concat builders
                |> List.map (\gridFn -> gridFn Image)
    in
    styled div
        [ Css.backgroundSize Css.cover
        , applyDevicesToBuilders flatBuilders responsive
        ]
        attributes
        innerHtml


{-| Creates a title on the card.
-}
title : String -> Card -> ResponsiveStyle -> Html msg
title titleText _ _ =
    styled div
        [ Css.paddingLeft (Css.rem 1.5)
        , Css.paddingRight (Css.rem 1)
        ]
        []
        [ h4 []
            [ text titleText ]
        ]


{-| Defines the body of the card.
-}
body : List (Html msg) -> Card -> ResponsiveStyle -> Html msg
body innerHtml _ _ =
    styled div
        [ Css.paddingLeft (Css.rem 1)
        , Css.paddingRight (Css.rem 1)
        ]
        []
        innerHtml


{-| Defines the controls on the card
-}
controls : List (Html msg) -> Card -> ResponsiveStyle -> Html msg
controls innerHtml _ _ =
    styled div
        [ Css.paddingLeft (Css.rem 1)
        , Css.paddingRight (Css.rem 1)
        , Css.paddingTop (Css.px 13)
        , Css.paddingBottom (Css.px 13)
        ]
        []
        innerHtml


{-| Sets the URL of the image.
-}
src : String -> StyleBuilder { a | card : Never } Card
src imageUrl =
    Styles.styles [ Css.backgroundImage (Css.url imageUrl) ]
