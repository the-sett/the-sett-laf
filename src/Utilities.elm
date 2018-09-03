module Utilities exposing (..)

import Array exposing (Array)
import Css exposing (..)
import Css.Foreign


baseFontSize =
    16


baseLineHeight =
    24


rhythmUnit =
    "px"


defaultRhythmBorderWidth =
    1


baseSpacingUnit =
    baseLineHeight - 12


halfSpacingUnit =
    baseSpacingUnit // 2


quarterSpacingUnit =
    baseSpacingUnit // 4


lineHeightRatio =
    -- Minor third scale
    baseLineHeight / baseFontSize


typeScale =
    Array.fromList
        [ 0.833, 1, 1.2, 1.44, 1.728, 2.074 ]


rhythm n =
    px <| n * baseLineHeight



-- Reset


{-| No margin or padding.

Default on:

blockquote, caption, dd, dl, fieldset, form, h1, h2, h3, h4, h5, h6, hr, legend,
ol, p, pre, table, td, th, ul

-}
noMarginOrPadding =
    [ margin <| px 0
    , padding <| px 0
    ]


{-| Remove underlines from potentially troublesome elements.

Default on:

a, ins, u

-}
noDecoration =
    textDecoration none


{-| Apply faux underline via `border-bottom`.

Default on:

ins

-}
fauxUnderline =
    borderBottom2 (px 1) solid


{-| So that `alt` text is visually offset if images dont load.

Default on:

img

-}
italicAltText =
    fontStyle italic


{-| Remove borders from fieldset

Default on:

fieldset

-}
borderless =
    border2 (px 0) none


{-| Give form elements some cursor interactions...

Default on:

button, input:button, label, option, select

-}
defaultCursor =
    cursor pointer


{-| Default cursor and box style for text inputs. }

Default on:

.text-input:active, .text-input:focus, textarea:active, textarea:focus

-}
defaultTextInput =
    [ cursor text_, outline none ]


normalize : List Css.Foreign.Snippet
normalize =
    -- 1. Correct the line height in all browsers.
    -- 2. Prevent adjustments of font size after orientation changes in IE on Windows Phone and in iOS.
    [ Css.Foreign.html
        [ Css.lineHeight (Css.num 1.15) -- 1
        , Css.property "-ms-text-size-adjust" "100%" -- 2
        , Css.property "-webkit-text-size-adjust" "100%" -- 2
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
        , Css.Foreign.main_ -- 1
        ]
        [ Css.display Css.block ]

    --Add the correct margin in IE 8.
    , Css.Foreign.typeSelector "figure"
        [ Css.margin2 (Css.em 1) (Css.px 40) ]

    -- 1. Add the correct box sizing in Firefox.
    -- 2. Show the overflow in Edge and IE.
    , Css.Foreign.hr
        [ Css.boxSizing Css.contentBox -- 1
        , Css.height Css.zero -- 1
        , Css.overflow Css.visible -- 2
        ]

    -- 1. Correct the inheritance and scaling of font size in all browsers.
    -- 2. Correct the odd `em` font sizing in all browsers.
    , Css.Foreign.pre
        [ Css.fontFamilies [ "monospace", "monospace" ] -- 1
        , Css.fontSize (Css.em 1) -- 2
        ]

    -- 1. Remove the gray background on active links in IE 10.
    -- 2. Remove gaps in links underline in iOS 8+ and Safari 8+.
    , Css.Foreign.a
        [ Css.backgroundColor Css.transparent -- 1
        , Css.property "-webkit-text-decoration-skip" "objects" -- 2
        ]

    -- 1. Remove the bottom border in Chrome 57- and Firefox 39-.
    -- 2. Add the correct text decoration in Chrome, Edge, IE, Opera, and Safari.
    , Css.Foreign.typeSelector "abbr[title]"
        [ Css.property "border-bottom" "none" -- 1
        , Css.textDecoration Css.underline -- 2
        , Css.textDecoration2 Css.underline Css.dotted -- 2
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
        [ Css.fontFamilies [ "monospace", "monospace" ] -- 1
        , Css.fontSize (Css.em 1) -- 2
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
        [ Css.fontFamily Css.sansSerif -- 1
        , Css.fontSize (Css.pct 100) -- 1
        , Css.lineHeight (Css.num 1.15) -- 1
        , Css.margin Css.zero -- 2
        ]

    -- Show the overflow in IE.
    -- 1. Show the overflow in Edge.
    , Css.Foreign.each
        [ Css.Foreign.button
        , Css.Foreign.input -- 1
        ]
        [ Css.overflow Css.visible ]

    -- Remove the inheritance of text transform in Edge, Firefox, and IE.
    -- 1. Remove the inheritance of text transform in Firefox.
    , Css.Foreign.each
        [ Css.Foreign.button
        , Css.Foreign.select -- 1
        ]
        [ Css.property "text-transform" "none" ]

    -- 1. Prevent a WebKit bug where (2) destroys native `audio` and `video` controls in Android 4.
    -- 2. Correct the inability to style clickable types in iOS and Safari.
    , Css.Foreign.each
        [ Css.Foreign.button
        , Css.Foreign.typeSelector "html [type=\"button\"]" -- 1
        , Css.Foreign.typeSelector "[type=\"reset\"]"
        , Css.Foreign.typeSelector "[type=\"submit\"]"
        ]
        [ Css.property "-webkit-appearance" "button" -- 2
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
        [ Css.boxSizing Css.borderBox -- 1
        , Css.color Css.inherit -- 2
        , Css.display Css.table -- 1
        , Css.maxWidth (Css.pct 100) -- 1
        , Css.padding Css.zero -- 3
        , Css.property "white-space" "normal" -- 1
        ]

    -- 1. Add the correct display in IE 9-.
    -- 2. Add the correct vertical alignment in Chrome, Firefox, and Opera.
    , Css.Foreign.progress
        [ Css.display Css.inlineBlock -- 1
        , Css.verticalAlign Css.baseline -- 2
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
        [ Css.boxSizing Css.borderBox -- 1
        , Css.padding Css.zero -- 2
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
        [ Css.property "-webkit-appearance" "textfield" -- 1
        , Css.outlineOffset (Css.px -2) -- 2
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
        [ Css.property "-webkit-appearance" "button" -- 1
        , Css.property "font" "inherit" -- 2
        ]

    -- Add the correct display in IE 9-.
    -- 1. Add the correct display in Edge, IE, and Firefox.
    , Css.Foreign.each
        [ Css.Foreign.typeSelector "details" -- 1
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



-- Responsive Values


screenXs =
    px 480


screenSm =
    px 840


screenMd =
    px 960


screenLg =
    px 1280



-- Base Spacing


{-| Single direction margins.

Use this for:

address, blockquote, dl, fieldset, figure, ol, p, pre, table, ul, hr

-}
singleDirectionMargin =
    margin3 (px 0) (px 0) (rhythm 1)


{-| No margins on headings, the line spacing of the heading is sufficient.

Use this for:

h1, h2, h3, h4, h5, h6

-}
noMargin =
    margin3 (px 0) (px 0) (rhythm 0)


{-| Consistent indenting for lists.

Use this for:

dd, ol, ul

-}
listMargin =
    --     margin-left: pem(2 * $base-spacing-unit);
    margin2 (px <| 2 * baseSpacingUnit) (px <| 2 * baseSpacingUnit)
