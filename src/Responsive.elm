module Responsive exposing
    ( global
    , CommonStyle, DeviceStyle, Device(..), DeviceSpec, ResponsiveStyle
    , ResponsiveFn, deviceStyle, deviceStyles
    , rhythm, rhythmPx
    , fontMediaStyles
    )

{-| The Responsive module provides a way of specifying sizing configurations for different devices,
and for applying those to create CSS with media queries.


# Global Style Snippet

@docs global


# Models for specifying devices and their basic responsive properties.

@docs CommonStyle, DeviceStyle, Device, DeviceSpec, ResponsiveStyle


# Device dependant styling functions.

@docs ResponsiveFn, deviceStyle, deviceStyles


# Vertical rhythm

@docs rhythm, rhythmPx


# Functions for responsively scaling fonts

@docs fontMediaStyles

-}

import Array exposing (Array)
import Css
import Css.Global
import Css.Media
import Maybe.Extra
import TypeScale exposing (FontSizeLevel(..), TypeScale)



-- Devices and their properties.


{-| Defines the possible classes of device; "small", "medium", "large" or "extra large".
-}
type Device
    = Sm
    | Md
    | Lg
    | Xl


{-| Defines a mapping from devices to something else, that must always include a definition
for each device size.
-}
type alias DeviceSpec a =
    { sm : a
    , md : a
    , lg : a
    , xl : a
    }


{-| Defines the style parameters that are common accross all devices.
-}
type alias CommonStyle =
    { lineHeightRatio : Float
    , typeScale : TypeScale
    }


{-| Defines the style parameters that are device specific.
-}
type alias DeviceStyle =
    { device : Device
    , baseFontSize : Float
    , breakWidth : Float
    , wrapperWidth : Float
    }


{-| Specifies the base styling properties accross all devices.
-}
type alias ResponsiveStyle =
    { commonStyle : CommonStyle
    , deviceStyles : DeviceSpec DeviceStyle
    }



-- Device Dependant Styling functions.


{-| A responsive styling function takes the common style properties and the style
properties that are specific to a device, and produces some style related value.
-}
type alias ResponsiveFn a =
    CommonStyle -> DeviceStyle -> a


{-| Creates a single CSS property with media queries. Media queries will be
generated for each of the devices specified.
-}
deviceStyle : ResponsiveStyle -> ResponsiveFn Css.Style -> Css.Style
deviceStyle responsive styleFn =
    mapMixins (mediaMixins responsive (styleFn responsive.commonStyle >> styleAsMixin)) []
        |> Css.batch


{-| Creates a set of CSS properties with media queries. Media queries will be
generated for each of the devices specified.
-}
deviceStyles : ResponsiveStyle -> ResponsiveFn (List Css.Style) -> Css.Style
deviceStyles responsive styleFn =
    mapMixins (mediaMixins responsive (styleFn responsive.commonStyle >> stylesAsMixin)) []
        |> Css.batch



-- Vertical rhythm.


{-| Calculates the line height for a base styling.
-}
lineHeight : Float -> DeviceStyle -> Float
lineHeight lineHeightRatio device =
    (lineHeightRatio * device.baseFontSize)
        |> floor
        |> toFloat


{-| Calculates a multiple of the line height for a base font.

This produces a result in px, which works the most accurately.

-}
rhythmPx : Float -> ResponsiveFn Css.Px
rhythmPx n common device =
    Css.px <| rhythm n common device


{-| Calculates a multiple of the line height for a base font.

This produces a float which is the size in pixels.

-}
rhythm : Float -> ResponsiveFn Float
rhythm n common device =
    n * lineHeight common.lineHeightRatio device



-- Mixins


{-| A mixin is a function that adds styles into a list of styles.
-}
type alias Mixin =
    List Css.Style -> List Css.Style


{-| Turns a single CSS property into a mixin.
-}
styleAsMixin : Css.Style -> Mixin
styleAsMixin style styles =
    style :: styles


{-| Turns a set of CSS properties into a mixin.
-}
stylesAsMixin : List Css.Style -> Mixin
stylesAsMixin style styles =
    style ++ styles


{-| Applies a list of mixins to a set of CSS properties, to produce a new list of CSS properties
with all the mixins applied.

TODO: Is this right? Looks like each mixin is being added into each style, than all are being
concatentated together - which ought to lead to duplicates? I think perhaps the mixins should be
chained together, not applied single then concatenated.

-}
mapMixins : List Mixin -> List Css.Style -> List Css.Style
mapMixins mixins styles =
    List.map (\mixin -> mixin styles) mixins |> List.concat



-- Media break points.


{-| Media query to match high density devices.
-}
media2x : List Css.Style -> Css.Style
media2x styles =
    Css.Media.withMediaQuery
        [ "(-webkit-min-device-pixel-ratio: 1.3), (min-resolution: 1.3dppx)" ]
        styles


{-| Creates a media query that has its min width set to the break point for a device style.
-}
mediaMinWidthMixin : DeviceStyle -> Mixin
mediaMinWidthMixin { breakWidth } =
    Css.Media.withMedia [ Css.Media.all [ Css.Media.minWidth <| Css.px breakWidth ] ]
        >> List.singleton


{-| Given a set of devices, and a function to build mixins from the device properties,
creates a list of mixins, one for each device type.

The smallest (sm) device is applied without a media query, and the larger
sizes are successively applied with media queries on their break widths.

In this way, a mixin that is dependant on device properties can be applied accross
all device. Use `mapMixins` to apply the list of mixins over a list of base styles.

-}
mediaMixins : ResponsiveStyle -> (DeviceStyle -> Mixin) -> List Mixin
mediaMixins responsive devMixin =
    let
        { sm, md, lg, xl } =
            responsive.deviceStyles

        minWidthDevices =
            [ xl, lg, md ]

        minWidthMixin deviceMixin deviceProps =
            deviceMixin deviceProps
                >> mediaMinWidthMixin deviceProps

        minWidthMixins deviceMixin =
            List.map (minWidthMixin deviceMixin) minWidthDevices

        allMixins deviceMixin =
            deviceMixin sm
                :: minWidthMixins deviceMixin
    in
    allMixins devMixin



-- Functions for generating responsive type scales.


fontSizePx : TypeScale -> FontSizeLevel -> DeviceStyle -> Float
fontSizePx scale (FontSizeLevel sizeLevel) { baseFontSize } =
    (scale sizeLevel.level * baseFontSize)
        |> floor
        |> toFloat


{-| A mixin that for a given type scale and font size level, creates font-size
and line-height properties in keeping with the vertical rhythm.
-}
fontSizeMixin : FontSizeLevel -> CommonStyle -> DeviceStyle -> Mixin
fontSizeMixin (FontSizeLevel sizeLevel) common device =
    let
        pxVal =
            fontSizePx common.typeScale (FontSizeLevel sizeLevel) device

        numLines =
            max sizeLevel.minLines
                (ceiling (pxVal / lineHeight common.lineHeightRatio device))
    in
    Css.batch
        [ Css.fontSize (Css.px pxVal)
        , Css.lineHeight (rhythmPx (toFloat numLines) common device)
        ]
        |> styleAsMixin


{-| Creates font-size and line-height accross all media devices using media queries,
for a supplied font size level. These font sizings will be in keeping with the
vertical rhythm.
-}
fontMediaStyles : FontSizeLevel -> ResponsiveStyle -> List Css.Style
fontMediaStyles level responsive =
    mapMixins
        (mediaMixins responsive
            (fontSizeMixin level responsive.commonStyle)
        )
        []



-- Responsive Spacing


{-| A global CSS style sheet that sets up basic spaing for text, with single
direction margins.
-}
global : ResponsiveStyle -> List Css.Global.Snippet
global responsive =
    [ -- No margins on headings, the line spacing of the heading is sufficient.
      Css.Global.each
        [ Css.Global.h1
        , Css.Global.h2
        , Css.Global.h3
        , Css.Global.h4
        , Css.Global.h5
        , Css.Global.h6
        ]
        [ Css.margin3 (Css.px 0) (Css.px 0) (Css.px 0) ]

    -- Single direction margins.
    , Css.Global.each
        [ Css.Global.blockquote
        , Css.Global.dl
        , Css.Global.fieldset
        , Css.Global.ol
        , Css.Global.p
        , Css.Global.pre
        , Css.Global.table
        , Css.Global.ul
        , Css.Global.hr
        ]
        [ deviceStyle responsive <|
            \common device -> Css.margin3 (Css.px 0) (Css.px 0) (rhythmPx 1 common device)
        ]

    -- Consistent indenting for lists.
    , Css.Global.each
        [ Css.Global.dd
        , Css.Global.ol
        , Css.Global.ul
        ]
        [ deviceStyle responsive <|
            \common device -> Css.margin2 (rhythmPx 1 common device) (rhythmPx 1 common device)
        ]
    ]
