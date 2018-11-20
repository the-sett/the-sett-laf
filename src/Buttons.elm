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
import TypeScale


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
        , Css.borderStyle Css.none
        , Css.borderRadius <| Css.px 2
        , Css.color <| Css.rgb 0 0 0
        , Css.padding2 (Css.px 0) (Css.em 0.8)
        , Css.textTransform Css.uppercase
        , Css.overflow Css.hidden
        , Css.outline Css.none
        , Css.textAlign Css.center
        , Css.verticalAlign Css.middle

        --, Css.batch [ TypeScale.fontMediaStyles devices scale TypeScale.milli ]
        -- , Css.fontSize <| Css.em 1.0
        -- , Css.lineHeight <| Css.em devices.commonStyle.lineHeightRatio -- * (1.0 / 0.7))
        -- Raised
        , Css.backgroundColor <| Css.rgba 158 158 158 0.2
        , Css.property "box-shadow" "0 2px 2px 0 rgba(0,0,0,.14), 0 3px 1px -2px rgba(0,0,0,.2), 0 1px 5px 0 rgba(0,0,0,.12)"
        ]
        attributes
        innerHtml
