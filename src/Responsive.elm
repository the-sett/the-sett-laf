module Responsive
    exposing
        ( responsive
          -- Devices
        , Device(..)
        , DeviceSpec
        , BaseStyle
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
          -- Device Dependant Styling
        , deviceStyle
        , deviceStyles
        )

import Array exposing (Array)
import Css
import Css.Media
import Css.Global


{-| The global CSS.
-}
responsive : TypeScale -> DeviceSpec -> List Css.Global.Snippet
responsive typeScale devices =
    (baseSpacing devices)
        ++ (typography devices typeScale)



-- Devices and their properties.


type Device
    = Sm
    | Md
    | Lg
    | Xl



-- What the user needs to supply
-- type alias BaseStyle =
--     { baseFontSize : Float
--     , breakWidth : Float
--     , minLineHeight : Float
--     }


type alias BaseStyle =
    -- This is really the internal model
    { device : Device
    , baseFontSize : Float
    , breakWidth : Float
    , baseLineHeight : Float
    , lineHeightRatio : Float
    , wrapperWidth : Float
    }


type alias DeviceSpec =
    { mobile : BaseStyle
    , tablet : BaseStyle
    , desktop : BaseStyle
    , desktopWide : BaseStyle
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


fontSizePx : TypeScale -> BaseStyle -> FontSizeLevel -> Float
fontSizePx typeScale { baseFontSize } (FontSizeLevel sizeLevel) =
    ((typeScale sizeLevel.level) * baseFontSize)
        |> floor
        |> toFloat



-- Vertical rhythm.


lineHeight : BaseStyle -> Float
lineHeight deviceProps =
    max
        deviceProps.baseLineHeight
        (deviceProps.lineHeightRatio * deviceProps.baseFontSize)
        |> floor
        |> toFloat


rhythm : BaseStyle -> Float -> Css.Px
rhythm deviceProps n =
    Css.px <| n * (lineHeight deviceProps)



-- Device Dependant Styling


deviceStyle : DeviceSpec -> (BaseStyle -> Css.Style) -> Css.Style
deviceStyle devices styleFn =
    mapMixins (mediaMixins devices (styleFn >> styleAsMixin)) []
        |> Css.batch


deviceStyles : DeviceSpec -> (BaseStyle -> List Css.Style) -> Css.Style
deviceStyles devices styleFn =
    mapMixins (mediaMixins devices (styleFn >> stylesAsMixin)) []
        |> Css.batch



-- Mixins


{-| A mixin is a function that adds styles into a list of styles.
-}
type alias Mixin =
    List Css.Style -> List Css.Style


styleAsMixin : Css.Style -> Mixin
styleAsMixin style styles =
    style :: styles


stylesAsMixin : List Css.Style -> Mixin
stylesAsMixin style styles =
    style ++ styles


mapMixins : List Mixin -> List Css.Style -> List Css.Style
mapMixins mixins styles =
    ((List.map (\mixin -> mixin styles) mixins) |> List.concat)



-- Media break points.


media2x : List Css.Style -> Css.Style
media2x styles =
    Css.Media.withMediaQuery
        [ "(-webkit-min-device-pixel-ratio: 1.3), (min-resolution: 1.3dppx)" ]
        styles


mediaMinWidthMixin : BaseStyle -> Mixin
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
mediaMixins : DeviceSpec -> (BaseStyle -> Mixin) -> List Mixin
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


fontSizeMixin : TypeScale -> FontSizeLevel -> BaseStyle -> Mixin
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



-- Responsive typography to fit all devices.


typography : DeviceSpec -> TypeScale -> List Css.Global.Snippet
typography devices typeScale =
    let
        fontMediaStyles fontSizeLevel =
            mapMixins (mediaMixins devices (fontSizeMixin typeScale fontSizeLevel)) []
    in
        [ -- Base font.
          Css.Global.each
            [ Css.Global.html ]
            [ Css.fontFamilies [ "Nobile", "Helvetica" ]
            , Css.fontWeight <| Css.int 400
            , Css.textRendering Css.optimizeLegibility
            ]

        -- Headings are grey and at least medium.
        , Css.Global.each
            [ Css.Global.h1
            , Css.Global.h2
            , Css.Global.h3
            , Css.Global.h4
            , Css.Global.h5
            ]
            [ Css.color greyDark |> Css.important
            , Css.fontWeight <| Css.int 500
            ]

        -- Biggest headings are bold.
        , Css.Global.each
            [ Css.Global.h1
            , Css.Global.h2
            , Css.Global.h3
            ]
            [ Css.fontWeight Css.bold ]

        -- Media queries to set all font sizes accross all devices.
        , Css.Global.html <| fontMediaStyles base
        , Css.Global.h1 <| fontMediaStyles h1
        , Css.Global.h2 <| fontMediaStyles h2
        , Css.Global.h3 <| fontMediaStyles h3
        , Css.Global.h4 <| fontMediaStyles h4
        ]



-- Responsive Spacing


baseSpacing : DeviceSpec -> List Css.Global.Snippet
baseSpacing devices =
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
        [ deviceStyle devices <|
            \deviceProps -> Css.margin3 (Css.px 0) (Css.px 0) (rhythm deviceProps 1)
        ]

    -- Consistent indenting for lists.
    , Css.Global.each
        [ Css.Global.dd
        , Css.Global.ol
        , Css.Global.ul
        ]
        [ deviceStyle devices <|
            \deviceProps -> Css.margin2 (rhythm deviceProps 1) (rhythm deviceProps 1)
        ]
    ]



-- Colors


greyDark =
    Css.hex "727272"
