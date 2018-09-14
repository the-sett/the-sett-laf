module Responsive
    exposing
        ( responsive
          -- Devices
        , Device(..)
        , Devices
        , DeviceProps
          -- Type scales
        , TypeScale
        , minorSecond
        , majorSecond
        , minorThird
        , majorThird
        , perfectFourth
        , augmentedFourth
        , perfectFifth
          -- Vertical Rhythm
        , rhythm
          -- Mixins
        , Mixin
        , mapMixins
        , mediaMixins
        , styleAsMixin
        , deviceStyle
        )

import Array exposing (Array)
import Css
import Css.Media
import Css.Foreign


{-| The global CSS.
-}
responsive : TypeScale -> Devices -> List Css.Foreign.Snippet
responsive typeScale devices =
    (baseSpacing devices)
        ++ (typography devices typeScale)



-- Devices and their properties.


type Device
    = Mobile
    | Tablet
    | Desktop
    | DesktopWide



-- What the user needs to supply
-- type alias DeviceProps =
--     { baseFontSize : Float
--     , breakWidth : Float
--     , minLineHeight : Float
--     }


type alias DeviceProps =
    -- This is really the internal model
    { device : Device
    , baseFontSize : Float
    , breakWidth : Float
    , baseLineHeight : Float
    , lineHeightRatio : Float
    }


type alias Devices =
    { mobile : DeviceProps
    , tablet : DeviceProps
    , desktop : DeviceProps
    , desktopWide : DeviceProps
    }



-- Type Scales.


type alias TypeScale =
    Int -> Float


typeScale : Float -> TypeScale
typeScale ratio n =
    (ratio ^ (toFloat (n - 1)))


minorSecond : TypeScale
minorSecond =
    typeScale 1.067


majorSecond : TypeScale
majorSecond =
    typeScale 1.125


minorThird : TypeScale
minorThird =
    typeScale 1.2


majorThird : TypeScale
majorThird =
    typeScale 1.25


perfectFourth : TypeScale
perfectFourth =
    typeScale 1.333


augmentedFourth : TypeScale
augmentedFourth =
    typeScale 1.414


perfectFifth : TypeScale
perfectFifth =
    typeScale 1.5


goldenRatio : TypeScale
goldenRatio =
    typeScale 1.618


type FontSizeLevel
    = FontSizeLevel
        { level : Int
        , minLines : Int
        }


milli =
    FontSizeLevel
        { level = 0
        , minLines = 1
        }


base =
    FontSizeLevel
        { level = 1
        , minLines = 1
        }


h1 =
    FontSizeLevel
        { level = 5
        , minLines = 3
        }


h2 =
    FontSizeLevel
        { level = 4
        , minLines = 2
        }


h3 =
    FontSizeLevel
        { level = 3
        , minLines = 2
        }


h4 =
    FontSizeLevel
        { level = 2
        , minLines = 2
        }


fontSizePx : TypeScale -> DeviceProps -> FontSizeLevel -> Float
fontSizePx typeScale { baseFontSize } (FontSizeLevel sizeLevel) =
    ((typeScale sizeLevel.level) * baseFontSize)
        |> floor
        |> toFloat



-- Vertical rhythm.


lineHeight : DeviceProps -> Float
lineHeight deviceProps =
    max
        deviceProps.baseLineHeight
        (deviceProps.lineHeightRatio * deviceProps.baseFontSize)
        |> floor
        |> toFloat


rhythm : DeviceProps -> Float -> Css.Px
rhythm deviceProps n =
    Css.px <| n * (lineHeight deviceProps)



-- Mixins


{-| A mixin is a function that adds styles into a list of styles.
-}
type alias Mixin =
    List Css.Style -> List Css.Style


styleAsMixin : Css.Style -> Mixin
styleAsMixin style styles =
    style :: styles


mapMixins : List Mixin -> List Css.Style -> List Css.Style
mapMixins mixins styles =
    ((List.map (\mixin -> mixin styles) mixins) |> List.concat)



-- Media break points.


media2x : List Css.Style -> Css.Style
media2x styles =
    Css.Media.withMediaQuery
        [ "(-webkit-min-device-pixel-ratio: 1.3), (min-resolution: 1.3dppx)" ]
        styles


mediaMinWidthMixin : DeviceProps -> Mixin
mediaMinWidthMixin { breakWidth } =
    Css.Media.withMedia [ Css.Media.all [ Css.Media.minWidth <| Css.px breakWidth ] ]
        >> List.singleton


{-| Given a set of devices, and a function to build mixins from the device properties,
creates a list of mixins, one for each device type.

The smallest (mobile) device is applied without a media query, and the larger
sizes are successively applied with media queries on their break widths.

In this way, a mixin that is dependant on device properties can be applied accross
all device. Use `mapMixins` to apply the list of mixins over a list of base styles.

-}
mediaMixins : Devices -> (DeviceProps -> Mixin) -> List Mixin
mediaMixins { mobile, tablet, desktop, desktopWide } deviceMixin =
    let
        minWidthDevices =
            [ desktopWide, desktop, tablet ]

        minWidthMixin deviceMixin deviceProps =
            deviceMixin deviceProps
                >> (mediaMinWidthMixin deviceProps)

        minWidthMixins deviceMixin =
            List.map (minWidthMixin deviceMixin) minWidthDevices

        allMixins deviceMixin =
            (deviceMixin mobile)
                :: (minWidthMixins deviceMixin)
    in
        allMixins deviceMixin


fontSizeMixin : TypeScale -> FontSizeLevel -> DeviceProps -> Mixin
fontSizeMixin typeScale (FontSizeLevel sizeLevel) deviceProps =
    let
        pxVal =
            fontSizePx typeScale deviceProps (FontSizeLevel sizeLevel)

        numLines =
            max sizeLevel.minLines
                (ceiling (pxVal / (lineHeight deviceProps)))
    in
        Css.batch
            [ Css.fontSize (Css.px pxVal)
            , Css.lineHeight (rhythm deviceProps (toFloat numLines))
            ]
            |> styleAsMixin


deviceStyle : Devices -> (DeviceProps -> Css.Style) -> Css.Style
deviceStyle devices styleFn =
    mapMixins (mediaMixins devices (styleFn >> styleAsMixin)) []
        |> Css.batch



-- Responsive typography to fit all devices.


typography : Devices -> TypeScale -> List Css.Foreign.Snippet
typography devices typeScale =
    let
        fontMediaStyles fontSizeLevel =
            mapMixins (mediaMixins devices (fontSizeMixin typeScale fontSizeLevel)) []
    in
        [ -- Base font.
          Css.Foreign.each
            [ Css.Foreign.html ]
            [ Css.fontFamilies [ "Nobile", "Helvetica" ]
            , Css.fontWeight <| Css.int 400
            , Css.textRendering Css.optimizeLegibility
            ]

        -- Headings are grey and at least medium.
        , Css.Foreign.each
            [ Css.Foreign.h1
            , Css.Foreign.h2
            , Css.Foreign.h3
            , Css.Foreign.h4
            , Css.Foreign.h5
            ]
            [ Css.color greyDark |> Css.important
            , Css.fontWeight <| Css.int 500
            ]

        -- Biggest headings are bold.
        , Css.Foreign.each
            [ Css.Foreign.h1
            , Css.Foreign.h2
            , Css.Foreign.h3
            ]
            [ Css.fontWeight Css.bold ]

        -- Media queries to set all font sizes accross all devices.
        , Css.Foreign.html <| fontMediaStyles base
        , Css.Foreign.h1 <| fontMediaStyles h1
        , Css.Foreign.h2 <| fontMediaStyles h2
        , Css.Foreign.h3 <| fontMediaStyles h3
        , Css.Foreign.h4 <| fontMediaStyles h4
        ]



-- Responsive Spacing


baseSpacing : Devices -> List Css.Foreign.Snippet
baseSpacing devices =
    [ -- No margins on headings, the line spacing of the heading is sufficient.
      Css.Foreign.each
        [ Css.Foreign.h1
        , Css.Foreign.h2
        , Css.Foreign.h3
        , Css.Foreign.h4
        , Css.Foreign.h5
        , Css.Foreign.h6
        ]
        [ Css.margin3 (Css.px 0) (Css.px 0) (Css.px 0) ]

    -- Single direction margins.
    , Css.Foreign.each
        [ Css.Foreign.blockquote
        , Css.Foreign.dl
        , Css.Foreign.fieldset
        , Css.Foreign.ol
        , Css.Foreign.p
        , Css.Foreign.pre
        , Css.Foreign.table
        , Css.Foreign.ul
        , Css.Foreign.hr
        ]
        [ deviceStyle devices <|
            \deviceProps -> Css.margin3 (Css.px 0) (Css.px 0) (rhythm deviceProps 1)
        ]

    -- Consistent indenting for lists.
    , Css.Foreign.each
        [ Css.Foreign.dd
        , Css.Foreign.ol
        , Css.Foreign.ul
        ]
        [ deviceStyle devices <|
            \deviceProps -> Css.margin2 (rhythm deviceProps 1) (rhythm deviceProps 1)
        ]
    ]



-- Colors


greyDark =
    Css.hex "727272"
