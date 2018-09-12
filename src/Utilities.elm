module Utilities
    exposing
        ( Device(..)
        , Devices
        , DeviceProps
        , TypeScale
        , minorSecond
        , majorSecond
        , minorThird
        , majorThird
        , perfectFourth
        , augmentedFourth
        , perfectFifth
        , rhythm
        , styleSheet
        )

import Array exposing (Array)
import Css
import Css.Media
import Css.Foreign


{-| The global CSS.
-}
styleSheet : TypeScale -> Devices -> List Css.Foreign.Snippet
styleSheet typeScale devices =
    reset
        ++ normalize
        ++ (baseSpacing devices.mobile)
        ++ (typography devices typeScale)



-- Devices and their properties.


type Device
    = Mobile
    | Tablet
    | Desktop
    | DesktopWide


type alias DeviceProps =
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
    ratio ^ (toFloat (n - 1))


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
    (typeScale sizeLevel.level) * baseFontSize



-- Media break points.


mediaMinWidthMixin : DeviceProps -> Mixin
mediaMinWidthMixin { breakWidth } =
    Css.Media.withMedia [ Css.Media.all [ Css.Media.minWidth <| Css.px breakWidth ] ]
        >> List.singleton


media2x : List Css.Style -> Css.Style
media2x styles =
    Css.Media.withMediaQuery
        [ "(-webkit-min-device-pixel-ratio: 2), (min-resolution: 2dppx)" ]
        styles



-- Vertical rhythm.


lineHeight : DeviceProps -> Float
lineHeight deviceProps =
    max
        deviceProps.baseLineHeight
        (deviceProps.lineHeightRatio * deviceProps.baseFontSize)


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


fontSizeMixin : TypeScale -> DeviceProps -> FontSizeLevel -> Mixin
fontSizeMixin typeScale deviceProps (FontSizeLevel sizeLevel) =
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


typography : Devices -> TypeScale -> List Css.Foreign.Snippet
typography { mobile, tablet, desktop, desktopWide } typeScale =
    let
        minWidthDevices =
            [ desktopWide, desktop, tablet ]

        fontSizeMediaMixin fontSizeLevel deviceProps =
            fontSizeMixin typeScale deviceProps fontSizeLevel
                >> (mediaMinWidthMixin deviceProps)

        mediaMixins fontSizeLevel =
            List.map (fontSizeMediaMixin fontSizeLevel) minWidthDevices

        fontMixins fontSizeLevel =
            (fontSizeMixin typeScale mobile fontSizeLevel)
                :: (mediaMixins fontSizeLevel)

        mediaStylesForFontLevel fontSizeLevel =
            ((List.map (\mixin -> mixin []) (fontMixins fontSizeLevel)) |> List.concat)
    in
        [ -- Base font.
          Css.Foreign.each
            [ Css.Foreign.html ]
            [ Css.fontFamilies [ "Roboto", "Helvetica" ]
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
        , Css.Foreign.html <| mediaStylesForFontLevel base
        , Css.Foreign.h1 <| mediaStylesForFontLevel h1
        , Css.Foreign.h2 <| mediaStylesForFontLevel h2
        , Css.Foreign.h3 <| mediaStylesForFontLevel h3
        , Css.Foreign.h4 <| mediaStylesForFontLevel h4
        ]



-- Reset


reset : List Css.Foreign.Snippet
reset =
    [ -- No margin or padding.
      Css.Foreign.each
        [ Css.Foreign.blockquote
        , Css.Foreign.caption
        , Css.Foreign.dd
        , Css.Foreign.dl
        , Css.Foreign.fieldset
        , Css.Foreign.form
        , Css.Foreign.h1
        , Css.Foreign.h2
        , Css.Foreign.h3
        , Css.Foreign.h4
        , Css.Foreign.h5
        , Css.Foreign.h6
        , Css.Foreign.hr
        , Css.Foreign.legend
        , Css.Foreign.ol
        , Css.Foreign.p
        , Css.Foreign.pre
        , Css.Foreign.table
        , Css.Foreign.td
        , Css.Foreign.th
        , Css.Foreign.ul
        ]
        [ Css.margin Css.zero
        , Css.padding Css.zero
        ]

    -- Remove underlines from potentially troublesome elements.
    , Css.Foreign.each
        [ Css.Foreign.a
        , Css.Foreign.typeSelector "ins"
        , Css.Foreign.typeSelector "u"
        ]
        [ Css.textDecoration Css.none ]

    -- Apply faux underline via `border-bottom`.
    , Css.Foreign.typeSelector "ins"
        [ Css.borderBottom2 (Css.px 1) Css.solid ]

    -- So that `alt` text is visually offset if images dont load.
    , Css.Foreign.img
        [ Css.fontStyle Css.italic ]

    -- Remove borders from fieldset
    , Css.Foreign.fieldset
        [ Css.border2 (Css.px 0) Css.none ]

    -- Give form elements some cursor interactions...
    , Css.Foreign.each
        [ Css.Foreign.button
        , Css.Foreign.typeSelector "input:button"
        , Css.Foreign.label
        , Css.Foreign.option
        , Css.Foreign.select
        ]
        [ Css.cursor Css.pointer ]

    -- Default cursor and box style for text inputs. }
    , Css.Foreign.each
        [ Css.Foreign.typeSelector ".text-input:active"
        , Css.Foreign.typeSelector ".text-input:focus"
        , Css.Foreign.typeSelector "textarea:active"
        , Css.Foreign.typeSelector "textarea:focus"
        ]
        [ Css.cursor Css.text_
        , Css.outline Css.none
        ]
    ]


normalize : List Css.Foreign.Snippet
normalize =
    -- 1. Correct the line height in all browsers.
    -- 2. Prevent adjustments of font size after orientation changes in IE on Windows Phone and in iOS.
    [ Css.Foreign.html
        [ Css.lineHeight (Css.num 1.15)

        -- 1
        , Css.property "-ms-text-size-adjust" "100%"

        -- 2
        , Css.property "-webkit-text-size-adjust" "100%"

        -- 2
        ]

    --Remove the margin in all browsers (opinionated).
    , Css.Foreign.body
        [ Css.margin Css.zero ]

    --Add the correct display in IE 9-.
    , Css.Foreign.each
        [ Css.Foreign.article
        , Css.Foreign.typeSelector "aside"
        , Css.Foreign.footer
        , Css.Foreign.header
        , Css.Foreign.nav
        , Css.Foreign.section
        ]
        [ Css.display Css.block ]

    -- Correct the font size and margin on `h1` elements within `section` and `article` contexts in Chrome, Firefox, and Safari.
    , Css.Foreign.h1
        [ Css.fontSize (Css.em 2)
        , Css.margin2 (Css.em 0.67) Css.zero
        ]

    --Add the correct display in IE 9-.
    -- 1. Add the correct display in IE.
    , Css.Foreign.each
        [ Css.Foreign.typeSelector "figcaption"
        , Css.Foreign.typeSelector "figure"
        , Css.Foreign.main_

        -- 1
        ]
        [ Css.display Css.block ]

    --Add the correct margin in IE 8.
    , Css.Foreign.typeSelector "figure"
        [ Css.margin2 (Css.em 1) (Css.px 40) ]

    -- 1. Add the correct box sizing in Firefox.
    -- 2. Show the overflow in Edge and IE.
    , Css.Foreign.hr
        [ Css.boxSizing Css.contentBox

        -- 1
        , Css.height Css.zero

        -- 1
        , Css.overflow Css.visible

        -- 2
        ]

    -- 1. Correct the inheritance and scaling of font size in all browsers.
    -- 2. Correct the odd `em` font sizing in all browsers.
    , Css.Foreign.pre
        [ Css.fontFamilies [ "monospace", "monospace" ]

        -- 1
        , Css.fontSize (Css.em 1)

        -- 2
        ]

    -- 1. Remove the gray background on active links in IE 10.
    -- 2. Remove gaps in links underline in iOS 8+ and Safari 8+.
    , Css.Foreign.a
        [ Css.backgroundColor Css.transparent

        -- 1
        , Css.property "-webkit-text-decoration-skip" "objects"

        -- 2
        ]

    -- 1. Remove the bottom border in Chrome 57- and Firefox 39-.
    -- 2. Add the correct text decoration in Chrome, Edge, IE, Opera, and Safari.
    , Css.Foreign.typeSelector "abbr[title]"
        [ Css.property "border-bottom" "none"

        -- 1
        , Css.textDecoration Css.underline

        -- 2
        , Css.textDecoration2 Css.underline Css.dotted

        -- 2
        ]

    -- Prevent the duplicate application of `bolder` by the next rule in Safari 6.
    , Css.Foreign.each
        [ Css.Foreign.typeSelector "b"
        , Css.Foreign.strong
        ]
        [ Css.fontWeight Css.inherit ]

    -- Add the correct font weight in Chrome, Edge, and Safari.
    , Css.Foreign.each
        [ Css.Foreign.typeSelector "b"
        , Css.Foreign.strong
        ]
        [ Css.fontWeight Css.bolder ]

    -- 1. Correct the inheritance and scaling of font size in all browsers.
    -- 2. Correct the odd `em` font sizing in all browsers.
    , Css.Foreign.each
        [ Css.Foreign.code
        , Css.Foreign.typeSelector "kbd"
        , Css.Foreign.typeSelector "samp"
        ]
        [ Css.fontFamilies [ "monospace", "monospace" ]

        -- 1
        , Css.fontSize (Css.em 1)

        -- 2
        ]

    -- Add the correct font style in Android 4.3-.
    , Css.Foreign.typeSelector "dfn"
        [ Css.fontStyle Css.italic ]

    -- Add the correct background and color in IE 9-.
    , Css.Foreign.typeSelector "mark"
        [ Css.backgroundColor (Css.hex "ff0")
        , Css.color (Css.hex "000")
        ]

    -- Add the correct font size in all browsers.
    , Css.Foreign.small
        [ Css.fontSize (Css.pct 80) ]

    -- Prevent `sub` and `sup` elements from affecting the line height in all browsers.
    , Css.Foreign.each
        [ Css.Foreign.typeSelector "sub"
        , Css.Foreign.typeSelector "sup"
        ]
        [ Css.fontSize (Css.pct 75)
        , Css.lineHeight Css.zero
        , Css.position Css.relative
        , Css.verticalAlign Css.baseline
        ]
    , Css.Foreign.typeSelector "sub"
        [ Css.bottom (Css.em -0.25) ]
    , Css.Foreign.typeSelector "sup"
        [ Css.top (Css.em -0.5) ]

    -- Add the correct display in IE 9-.
    , Css.Foreign.each
        [ Css.Foreign.audio
        , Css.Foreign.video
        ]
        [ Css.display Css.inlineBlock ]

    -- Add the correct display in iOS 4-7.
    , Css.Foreign.typeSelector "audio:not([controls])"
        [ Css.display Css.none
        , Css.height Css.zero
        ]

    -- Remove the border on images inside links in IE 10-.
    , Css.Foreign.img
        [ Css.borderStyle Css.none ]

    -- Hide the overflow in IE.
    , Css.Foreign.typeSelector "svg:not(:root)"
        [ Css.overflow Css.hidden ]

    -- 1. Change the font styles in all browsers (opinionated).
    -- 2. Remove the margin in Firefox and Safari.
    , Css.Foreign.each
        [ Css.Foreign.button
        , Css.Foreign.input
        , Css.Foreign.optgroup
        , Css.Foreign.select
        , Css.Foreign.textarea
        ]
        [ Css.fontFamily Css.sansSerif

        -- 1
        , Css.fontSize (Css.pct 100)

        -- 1
        , Css.lineHeight (Css.num 1.15)

        -- 1
        , Css.margin Css.zero

        -- 2
        ]

    -- Show the overflow in IE.
    -- 1. Show the overflow in Edge.
    , Css.Foreign.each
        [ Css.Foreign.button
        , Css.Foreign.input

        -- 1
        ]
        [ Css.overflow Css.visible ]

    -- Remove the inheritance of text transform in Edge, Firefox, and IE.
    -- 1. Remove the inheritance of text transform in Firefox.
    , Css.Foreign.each
        [ Css.Foreign.button
        , Css.Foreign.select

        -- 1
        ]
        [ Css.property "text-transform" "none" ]

    -- 1. Prevent a WebKit bug where (2) destroys native `audio` and `video` controls in Android 4.
    -- 2. Correct the inability to style clickable types in iOS and Safari.
    , Css.Foreign.each
        [ Css.Foreign.button
        , Css.Foreign.typeSelector "html [type=\"button\"]"

        -- 1
        , Css.Foreign.typeSelector "[type=\"reset\"]"
        , Css.Foreign.typeSelector "[type=\"submit\"]"
        ]
        [ Css.property "-webkit-appearance" "button"

        -- 2
        ]

    -- Remove the inner border and padding in Firefox.
    , Css.Foreign.each
        [ Css.Foreign.typeSelector "button::-moz-focus-inner"
        , Css.Foreign.typeSelector "[type=\"button\"]::-moz-focus-inner"
        , Css.Foreign.typeSelector "[type=\"reset\"]::-moz-focus-inner"
        , Css.Foreign.typeSelector "[type=\"submit\"]::-moz-focus-inner"
        ]
        [ Css.borderStyle Css.none
        , Css.padding Css.zero
        ]

    -- Restore the focus styles unset by the previous rule.
    , Css.Foreign.each
        [ Css.Foreign.typeSelector "button:-moz-focusring"
        , Css.Foreign.typeSelector "[type=\"button\"]:-moz-focusring"
        , Css.Foreign.typeSelector "[type=\"reset\"]:-moz-focusring"
        , Css.Foreign.typeSelector "[type=\"submit\"]:-moz-focusring"
        ]
        [ Css.property "outline" "1px dotted ButtonText" ]

    -- Correct the padding in Firefox.
    , Css.Foreign.fieldset
        [ Css.padding3 (Css.em 0.35) (Css.em 0.75) (Css.em 0.625) ]

    -- 1. Correct the text wrapping in Edge and IE.
    -- 2. Correct the color inheritance from `fieldset` elements in IE.
    -- 3. Remove the padding so developers are not caught out when they zero out `fieldset` elements in all browsers.
    , Css.Foreign.legend
        [ Css.boxSizing Css.borderBox

        -- 1
        , Css.color Css.inherit

        -- 2
        , Css.display Css.table

        -- 1
        , Css.maxWidth (Css.pct 100)

        -- 1
        , Css.padding Css.zero

        -- 3
        , Css.property "white-space" "normal"

        -- 1
        ]

    -- 1. Add the correct display in IE 9-.
    -- 2. Add the correct vertical alignment in Chrome, Firefox, and Opera.
    , Css.Foreign.progress
        [ Css.display Css.inlineBlock

        -- 1
        , Css.verticalAlign Css.baseline

        -- 2
        ]

    -- Remove the default vertical scrollbar in IE.
    , Css.Foreign.textarea
        [ Css.overflow Css.auto ]

    -- 1. Add the correct box sizing in IE 10-.
    -- 2. Remove the padding in IE 10-.
    , Css.Foreign.each
        [ Css.Foreign.typeSelector "[type=\"checkbox\"]"
        , Css.Foreign.typeSelector "[type=\"radio\"]"
        ]
        [ Css.boxSizing Css.borderBox

        -- 1
        , Css.padding Css.zero

        -- 2
        ]

    -- Correct the cursor style of increment and decrement buttons in Chrome.
    , Css.Foreign.each
        [ Css.Foreign.typeSelector "[type=\"number\"]::-webkit-inner-spin-button"
        , Css.Foreign.typeSelector "[type=\"number\"]::-webkit-outer-spin-button"
        ]
        [ Css.height Css.auto ]

    -- 1. Correct the odd appearance in Chrome and Safari.
    -- 2. Correct the outline style in Safari.
    , Css.Foreign.typeSelector "[type=\"search\"]"
        [ Css.property "-webkit-appearance" "textfield"

        -- 1
        , Css.outlineOffset (Css.px -2)

        -- 2
        ]

    -- Remove the inner padding and cancel buttons in Chrome and Safari on macOS.
    , Css.Foreign.each
        [ Css.Foreign.typeSelector "[type=\"search\"]::-webkit-search-cancel-button"
        , Css.Foreign.typeSelector "[type=\"search\"]::-webkit-search-decoration"
        ]
        [ Css.property "-webkit-appearance" "none" ]

    -- 1. Correct the inability to style clickable types in iOS and Safari.
    -- 2. Change font properties to `inherit` in Safari.
    , Css.Foreign.typeSelector "::-webkit-file-upload-button"
        [ Css.property "-webkit-appearance" "button"

        -- 1
        , Css.property "font" "inherit"

        -- 2
        ]

    -- Add the correct display in IE 9-.
    -- 1. Add the correct display in Edge, IE, and Firefox.
    , Css.Foreign.each
        [ Css.Foreign.typeSelector "details"

        -- 1
        , Css.Foreign.typeSelector "menu"
        ]
        [ Css.display Css.block ]

    -- Add the correct display in all browsers.
    , Css.Foreign.typeSelector "summary"
        [ Css.display Css.listItem ]

    -- Add the correct display in IE 9-.
    , Css.Foreign.canvas
        [ Css.display Css.inlineBlock ]

    -- Add the correct display in IE.
    , Css.Foreign.typeSelector "template"
        [ Css.display Css.none ]

    -- Add the correct display in IE 10-.
    , Css.Foreign.typeSelector "[hidden]"
        [ Css.display Css.none ]
    ]



-- Base Spacing


baseSpacing : DeviceProps -> List Css.Foreign.Snippet
baseSpacing deviceProps =
    [ -- Single direction margins.
      Css.Foreign.each
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
        [ Css.margin3 (Css.px 0) (Css.px 0) (rhythm deviceProps 1)
        ]

    -- No margins on headings, the line spacing of the heading is sufficient.
    , Css.Foreign.each
        [ Css.Foreign.h1
        , Css.Foreign.h2
        , Css.Foreign.h3
        , Css.Foreign.h4
        , Css.Foreign.h5
        , Css.Foreign.h6
        ]
        [ Css.margin3 (Css.px 0) (Css.px 0) (rhythm deviceProps 0) ]

    -- Consistent indenting for lists.
    , Css.Foreign.each
        [ Css.Foreign.dd
        , Css.Foreign.ol
        , Css.Foreign.ul
        ]
        [ Css.margin2 (rhythm deviceProps 1) (rhythm deviceProps 1)
        ]
    ]



-- Colors


greyDark =
    Css.hex "727272"
