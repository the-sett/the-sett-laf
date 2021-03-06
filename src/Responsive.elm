module Responsive exposing
    ( global
    , CommonStyle, DeviceProps, Device(..), DeviceSpec, ResponsiveStyle
    , ResponsiveFn, deviceStyle, deviceStyles
    , rhythm, rhythmPx, rhythmSplit
    , fontMediaStyles
    )

{-| The Responsive module provides a way of specifying sizing configurations for different devices,
and for applying those to create CSS with media queries.


# Global Style Snippet

@docs global


# Models for specifying devices and their basic responsive properties.

@docs CommonStyle, DeviceProps, Device, DeviceSpec, ResponsiveStyle


# Device dependant styling functions.

@docs ResponsiveFn, deviceStyle, deviceStyles


# Vertical rhythm

@docs rhythm, rhythmPx, rhythmSplit


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
type alias DeviceProps =
    { device : Device
    , baseFontSize : Float
    , breakWidth : Float
    , wrapperWidth : Float
    }


{-| Specifies the base styling properties accross all devices.
-}
type alias ResponsiveStyle =
    { commonStyle : CommonStyle
    , deviceStyles : DeviceSpec DeviceProps
    }


{-| Specifies the base styling properties for a single devices.
-}
type alias DeviceStyle =
    { commonStyle : CommonStyle
    , deviceProps : DeviceProps
    }



-- Device Dependant Styling functions.


{-| A responsive styling function takes the common style properties and the style
properties that are specific to a device, and produces some style related value.
-}
type alias ResponsiveFn a =
    DeviceStyle -> a


{-| Creates a single CSS property with media queries. Media queries will be
generated for each of the devices specified.
-}
deviceStyle : ResponsiveStyle -> ResponsiveFn Css.Style -> Css.Style
deviceStyle responsive styleFn =
    mapMixins (mediaMixins responsive (styleFn >> styleAsMixin)) []
        |> Css.batch


{-| Creates a set of CSS properties with media queries. Media queries will be
generated for each of the devices specified.
-}
deviceStyles : ResponsiveStyle -> ResponsiveFn (List Css.Style) -> Css.Style
deviceStyles responsive styleFn =
    mapMixins (mediaMixins responsive (styleFn >> stylesAsMixin)) []
        |> Css.batch



-- Vertical rhythm.


{-| Calculates the line height for a base styling.
-}
lineHeight : Float -> DeviceProps -> Float
lineHeight lineHeightRatio device =
    (lineHeightRatio * device.baseFontSize)
        |> floor
        |> toFloat


{-| Calculates a multiple of the line height for a base font.

This produces a result in px, which works the most accurately.

-}
rhythmPx : Float -> ResponsiveFn Css.Px
rhythmPx n device =
    Css.px <| rhythm n device


{-| Calculates a multiple of the line height for a base font.

This produces a float which is the size in pixels.

-}
rhythm : Float -> ResponsiveFn Float
rhythm n device =
    n * lineHeight device.commonStyle.lineHeightRatio device.deviceProps


{-| This function helps to get the vertical rhythm right in situations where
rounding errors are not allowing things to be positioned accurately, or where browsers
insert extra padding around certain elements, such as buttons.

Instead of setting a line-height for the rhythm, the requested rhythm is split into a
height and a margin which together add up to the correct size.

-}
rhythmSplit : Float -> Float -> ResponsiveFn (List Css.Style)
rhythmSplit ratio n device =
    let
        r1 =
            rhythm n device

        mt =
            r1 * ratio / 2

        hPlusMt =
            r1 * (ratio / 2 + (1 - ratio))

        h =
            hPlusMt - mt

        mb =
            r1 - hPlusMt
    in
    [ Css.marginTop (Css.px mt)
    , Css.height <| Css.px h
    , Css.marginBottom (Css.px mb)
    ]



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
mediaMinWidthMixin : ResponsiveFn Mixin
mediaMinWidthMixin device =
    Css.Media.withMedia [ Css.Media.all [ Css.Media.minWidth <| Css.px device.deviceProps.breakWidth ] ]
        >> List.singleton


{-| Given a set of devices, and a function to build mixins from the device properties,
creates a list of mixins, one for each device type.

The smallest (sm) device is applied without a media query, and the larger
sizes are successively applied with media queries on their break widths.

In this way, a mixin that is dependant on device properties can be applied accross
all device. Use `mapMixins` to apply the list of mixins over a list of base styles.

-}
mediaMixins : ResponsiveStyle -> ResponsiveFn Mixin -> List Mixin
mediaMixins responsive responsiveMixin =
    let
        { sm, md, lg, xl } =
            responsive.deviceStyles

        minWidthDevices =
            [ xl, lg, md ]

        minWidthMixin deviceMixin deviceProps =
            deviceMixin deviceProps
                >> mediaMinWidthMixin deviceProps

        minWidthMixins deviceMixin =
            List.map (minWidthMixin deviceMixin) <|
                List.map (\dProps -> { commonStyle = responsive.commonStyle, deviceProps = dProps }) minWidthDevices

        allMixins deviceMixin =
            deviceMixin { commonStyle = responsive.commonStyle, deviceProps = sm }
                :: minWidthMixins deviceMixin
    in
    allMixins responsiveMixin



-- Functions for generating responsive type scales.


fontSizePx : TypeScale -> FontSizeLevel -> DeviceProps -> Float
fontSizePx scale (FontSizeLevel sizeLevel) { baseFontSize } =
    (scale sizeLevel.level * baseFontSize)
        |> floor
        |> toFloat


{-| A mixin that for a given type scale and font size level, creates font-size
and line-height properties in keeping with the vertical rhythm.
-}
fontSizeMixin : FontSizeLevel -> ResponsiveFn Mixin
fontSizeMixin (FontSizeLevel sizeLevel) device =
    let
        pxVal =
            fontSizePx device.commonStyle.typeScale (FontSizeLevel sizeLevel) device.deviceProps

        numLines =
            max sizeLevel.minLines
                (ceiling (pxVal / lineHeight device.commonStyle.lineHeightRatio device.deviceProps))
    in
    Css.batch
        [ Css.fontSize (Css.px pxVal)
        , Css.lineHeight (rhythmPx (toFloat numLines) device)
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
            (fontSizeMixin level)
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
            \device -> Css.margin3 (Css.px 0) (Css.px 0) (rhythmPx 1 device)
        ]

    -- Consistent indenting for lists.
    , Css.Global.each
        [ Css.Global.dd
        , Css.Global.ol
        , Css.Global.ul
        ]
        [ deviceStyle responsive <|
            \device -> Css.margin2 (rhythmPx 1 device) (rhythmPx 1 device)
        ]
    ]
