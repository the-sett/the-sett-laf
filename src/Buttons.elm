module Buttons exposing (button)

import Css
import Html.Styled as Html exposing (Attribute, Html, a, div, h1, h4, i, img, p, styled, text, toUnstyled)
import Html.Styled.Attributes as Attributes exposing (class, id, name, title)
import Responsive
    exposing
        ( Device(..)
        , DeviceSpec
        , DeviceStyle
        , ResponsiveStyle
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


{-| The button styling context.
-}
type Button
    = Button


{-| Creates a button.
-}
button : ElementBuilder { a | image : Compatible } Button msg
button builders attributes innerHtml devices =
    let
        flatBuilders =
            List.concat builders
                |> List.map (\ctxFn -> ctxFn Button)
    in
    styled Html.button
        [ applyDevicesToBuilders flatBuilders devices
        ]
        attributes
        innerHtml
