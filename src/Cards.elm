module Cards exposing
    ( body
    , card
    , controls
    , height
    , image
    , src
    , title
    )

import Css
import Html.Styled exposing (Attribute, Html, a, div, h1, h4, i, img, p, styled, text, toUnstyled)
import Html.Styled.Attributes as Attributes exposing (class, id, name, title)
import Responsive
    exposing
        ( BaseStyle
        , Device(..)
        , DeviceSpec
        , DeviceStyles
        , deviceStyle
        , deviceStyles
        , mapMaybeDeviceSpec
        , rhythmEm
        )
import ResponsiveDSL
    exposing
        ( Builder(..)
        , Compatible(..)
        , ContainerBuilder
        , DeviceBuilder
        , ElementBuilder
        , StyleBuilder
        , applyDevice
        , applyDevicesToBuilders
        , empty
        , styles
        )


{-| The card styling context.
-}
type Card
    = Card
    | Image


card : ContainerBuilder { a | card : Compatible } Card msg
card builders attributes innerHtml devices =
    let
        flatBuilders =
            List.concat builders
                |> List.map (\gridFn -> gridFn Card)
    in
    styled div
        [ Css.borderRadius (Css.px 2)
        , Css.property "box-shadow" "rgba(0, 0, 0, 0.14) 0px 3px 4px 0px, rgba(0, 0, 0, 0.2) 0px 3px 3px -2px, rgba(0, 0, 0, 0.12) 0px 1px 8px 0px"
        , Css.marginLeft (Css.rem 0.5)
        , Css.marginRight (Css.rem 0.5)
        , applyDevicesToBuilders flatBuilders devices
        ]
        attributes
        (List.map (\deviceStyleFn -> deviceStyleFn devices) innerHtml)


image : ElementBuilder { a | image : Compatible } Card msg
image builders attributes innerHtml devices =
    let
        flatBuilders =
            List.concat builders
                |> List.map (\gridFn -> gridFn Image)
    in
    styled div
        [ applyDevicesToBuilders flatBuilders devices
        ]
        attributes
        innerHtml


title titleText _ =
    styled div
        [ Css.paddingLeft (Css.rem 1.5)
        , Css.paddingRight (Css.rem 1)
        ]
        []
        [ h4 []
            [ text titleText ]
        ]


body innerHtml _ =
    styled div
        [ Css.paddingLeft (Css.rem 1)
        , Css.paddingRight (Css.rem 1)
        ]
        []
        innerHtml


controls innerHtml _ =
    styled div
        [ Css.paddingLeft (Css.rem 1)
        , Css.paddingRight (Css.rem 1)
        , Css.paddingBottom (Css.rem 1)
        ]
        []
        innerHtml


height : Float -> StyleBuilder { a | card : Never } Card
height n device ctx =
    Builder device
        ctx
        (\_ baseProps ->
            [ Css.height <| rhythmEm baseProps n ]
        )


src : String -> StyleBuilder { a | card : Never } Card
src imageUrl =
    styles [ Css.backgroundImage (Css.url imageUrl) ]
