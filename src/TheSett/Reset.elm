module TheSett.Reset exposing (global)

{-| Provides a standard CSS reset stylesheet, aimed at getting consitent
behaviour accross browsers.


# The CSS snippet to add to the global style.

@docs global

-}

import Css
import Css.Global


{-| The CSS reset.
-}
global : List Css.Global.Snippet
global =
    [ -- Ensures <code> elements do not add extra height.
      Css.Global.each
        [ Css.Global.code ]
        [ Css.lineHeight (Css.px 0) ]

    -- Ensures tables do not add extra height.
    , Css.Global.each
        [ Css.Global.table ]
        [ Css.property "-webkit-border-vertical-spacing" "0px" ]

    -- No margin or padding.
    , Css.Global.each
        [ Css.Global.blockquote
        , Css.Global.caption
        , Css.Global.dd
        , Css.Global.dl
        , Css.Global.fieldset
        , Css.Global.form
        , Css.Global.h1
        , Css.Global.h2
        , Css.Global.h3
        , Css.Global.h4
        , Css.Global.h5
        , Css.Global.h6
        , Css.Global.hr
        , Css.Global.legend
        , Css.Global.ol
        , Css.Global.p
        , Css.Global.pre
        , Css.Global.table
        , Css.Global.td
        , Css.Global.th
        , Css.Global.ul
        ]
        [ Css.margin Css.zero
        , Css.padding Css.zero
        ]

    -- Remove underlines from potentially troublesome elements.
    , Css.Global.each
        [ Css.Global.a
        , Css.Global.typeSelector "ins"
        , Css.Global.typeSelector "u"
        ]
        [ Css.textDecoration Css.none ]

    -- Apply faux underline via `border-bottom`.
    , Css.Global.typeSelector "ins"
        [ Css.borderBottom2 (Css.px 1) Css.solid ]

    -- So that `alt` text is visually offset if images dont load.
    , Css.Global.img
        [ Css.fontStyle Css.italic ]

    -- Remove borders from fieldset
    , Css.Global.fieldset
        [ Css.border2 (Css.px 0) Css.none ]

    -- Give form elements some cursor interactions...
    , Css.Global.each
        [ Css.Global.button
        , Css.Global.typeSelector "input:button"
        , Css.Global.label
        , Css.Global.option
        , Css.Global.select
        ]
        [ Css.cursor Css.pointer ]

    -- Default cursor and box style for text inputs. }
    , Css.Global.each
        [ Css.Global.typeSelector ".text-input:active"
        , Css.Global.typeSelector ".text-input:focus"
        , Css.Global.typeSelector "textarea:active"
        , Css.Global.typeSelector "textarea:focus"
        ]
        [ Css.cursor Css.text_
        , Css.outline Css.none
        ]

    -- 1. Correct the line height in all browsers.
    -- 2. Prevent adjustments of font size after orientation changes in IE on Windows Phone and in iOS.
    , Css.Global.html
        [ Css.lineHeight (Css.num 1.15)

        -- 1
        , Css.property "-ms-text-size-adjust" "100%"

        -- 2
        , Css.property "-webkit-text-size-adjust" "100%"

        -- 2
        ]

    --Remove the margin in all browsers (opinionated).
    , Css.Global.body
        [ Css.margin Css.zero ]

    --Add the correct display in IE 9-.
    , Css.Global.each
        [ Css.Global.article
        , Css.Global.typeSelector "aside"
        , Css.Global.footer
        , Css.Global.header
        , Css.Global.nav
        , Css.Global.section
        ]
        [ Css.display Css.block ]

    -- Correct the font size and margin on `h1` elements within `section` and `article` contexts in Chrome, Firefox, and Safari.
    , Css.Global.h1
        [ Css.fontSize (Css.em 2)
        , Css.margin2 (Css.em 0.67) Css.zero
        ]

    --Add the correct display in IE 9-.
    -- 1. Add the correct display in IE.
    , Css.Global.each
        [ Css.Global.typeSelector "figcaption"
        , Css.Global.typeSelector "figure"
        , Css.Global.main_

        -- 1
        ]
        [ Css.display Css.block ]

    --Add the correct margin in IE 8.
    , Css.Global.typeSelector "figure"
        [ Css.margin2 (Css.em 1) (Css.px 40) ]

    -- 1. Add the correct box sizing in Firefox.
    -- 2. Show the overflow in Edge and IE.
    , Css.Global.hr
        [ Css.boxSizing Css.contentBox

        -- 1
        , Css.height Css.zero

        -- 1
        , Css.overflow Css.visible

        -- 2
        ]

    -- 1. Correct the inheritance and scaling of font size in all browsers.
    -- 2. Correct the odd `em` font sizing in all browsers.
    , Css.Global.pre
        [ Css.fontFamilies [ "monospace", "monospace" ]

        -- 1
        , Css.fontSize (Css.em 1)

        -- 2
        ]

    -- 1. Remove the gray background on active links in IE 10.
    -- 2. Remove gaps in links underline in iOS 8+ and Safari 8+.
    , Css.Global.a
        [ Css.backgroundColor Css.transparent

        -- 1
        , Css.property "-webkit-text-decoration-skip" "objects"

        -- 2
        ]

    -- 1. Remove the bottom border in Chrome 57- and Firefox 39-.
    -- 2. Add the correct text decoration in Chrome, Edge, IE, Opera, and Safari.
    , Css.Global.typeSelector "abbr[title]"
        [ Css.property "border-bottom" "none"

        -- 1
        , Css.textDecoration Css.underline

        -- 2
        , Css.textDecoration2 Css.underline Css.dotted

        -- 2
        ]

    -- Prevent the duplicate application of `bolder` by the next rule in Safari 6.
    , Css.Global.each
        [ Css.Global.typeSelector "b"
        , Css.Global.strong
        ]
        [ Css.fontWeight Css.inherit ]

    -- Add the correct font weight in Chrome, Edge, and Safari.
    , Css.Global.each
        [ Css.Global.typeSelector "b"
        , Css.Global.strong
        ]
        [ Css.fontWeight Css.bolder ]

    -- 1. Correct the inheritance and scaling of font size in all browsers.
    -- 2. Correct the odd `em` font sizing in all browsers.
    , Css.Global.each
        [ Css.Global.code
        , Css.Global.typeSelector "kbd"
        , Css.Global.typeSelector "samp"
        ]
        [ Css.fontFamilies [ "monospace", "monospace" ]

        -- 1
        , Css.fontSize (Css.em 1)

        -- 2
        ]

    -- Add the correct font style in Android 4.3-.
    , Css.Global.typeSelector "dfn"
        [ Css.fontStyle Css.italic ]

    -- Add the correct background and color in IE 9-.
    , Css.Global.typeSelector "mark"
        [ Css.backgroundColor (Css.hex "ff0")
        , Css.color (Css.hex "000")
        ]

    -- Add the correct font size in all browsers.
    , Css.Global.small
        [ Css.fontSize (Css.pct 80) ]

    -- Prevent `sub` and `sup` elements from affecting the line height in all browsers.
    , Css.Global.each
        [ Css.Global.typeSelector "sub"
        , Css.Global.typeSelector "sup"
        ]
        [ Css.fontSize (Css.pct 75)
        , Css.lineHeight Css.zero
        , Css.position Css.relative
        , Css.verticalAlign Css.baseline
        ]
    , Css.Global.typeSelector "sub"
        [ Css.bottom (Css.em -0.25) ]
    , Css.Global.typeSelector "sup"
        [ Css.top (Css.em -0.5) ]

    -- Add the correct display in IE 9-.
    , Css.Global.each
        [ Css.Global.audio
        , Css.Global.video
        ]
        [ Css.display Css.inlineBlock ]

    -- Add the correct display in iOS 4-7.
    , Css.Global.typeSelector "audio:not([controls])"
        [ Css.display Css.none
        , Css.height Css.zero
        ]

    -- Remove the border on images inside links in IE 10-.
    , Css.Global.img
        [ Css.borderStyle Css.none ]

    -- Hide the overflow in IE.
    , Css.Global.typeSelector "svg:not(:root)"
        [ Css.overflow Css.hidden ]

    -- 1. Change the font styles in all browsers (opinionated).
    -- 2. Remove the margin in Firefox and Safari.
    , Css.Global.each
        [ Css.Global.button
        , Css.Global.input
        , Css.Global.optgroup
        , Css.Global.select
        , Css.Global.textarea
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
    , Css.Global.each
        [ Css.Global.button
        , Css.Global.input

        -- 1
        ]
        [ Css.overflow Css.visible ]

    -- Remove the inheritance of text transform in Edge, Firefox, and IE.
    -- 1. Remove the inheritance of text transform in Firefox.
    , Css.Global.each
        [ Css.Global.button
        , Css.Global.select

        -- 1
        ]
        [ Css.property "text-transform" "none" ]

    -- 1. Prevent a WebKit bug where (2) destroys native `audio` and `video` controls in Android 4.
    -- 2. Correct the inability to style clickable types in iOS and Safari.
    , Css.Global.each
        [ Css.Global.button
        , Css.Global.typeSelector "html [type=\"button\"]"

        -- 1
        , Css.Global.typeSelector "[type=\"reset\"]"
        , Css.Global.typeSelector "[type=\"submit\"]"
        ]
        [ Css.property "-webkit-appearance" "button"

        -- 2
        ]

    -- Remove the inner border and padding in Firefox.
    , Css.Global.each
        [ Css.Global.typeSelector "button::-moz-focus-inner"
        , Css.Global.typeSelector "[type=\"button\"]::-moz-focus-inner"
        , Css.Global.typeSelector "[type=\"reset\"]::-moz-focus-inner"
        , Css.Global.typeSelector "[type=\"submit\"]::-moz-focus-inner"
        ]
        [ Css.borderStyle Css.none
        , Css.padding Css.zero
        ]

    -- Restore the focus styles unset by the previous rule.
    , Css.Global.each
        [ Css.Global.typeSelector "button:-moz-focusring"
        , Css.Global.typeSelector "[type=\"button\"]:-moz-focusring"
        , Css.Global.typeSelector "[type=\"reset\"]:-moz-focusring"
        , Css.Global.typeSelector "[type=\"submit\"]:-moz-focusring"
        ]
        [ Css.property "outline" "1px dotted ButtonText" ]

    -- Correct the padding in Firefox.
    , Css.Global.fieldset
        [ Css.padding3 (Css.em 0.35) (Css.em 0.75) (Css.em 0.625) ]

    -- 1. Correct the text wrapping in Edge and IE.
    -- 2. Correct the color inheritance from `fieldset` elements in IE.
    -- 3. Remove the padding so developers are not caught out when they zero out `fieldset` elements in all browsers.
    , Css.Global.legend
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
    , Css.Global.progress
        [ Css.display Css.inlineBlock

        -- 1
        , Css.verticalAlign Css.baseline

        -- 2
        ]

    -- Remove the default vertical scrollbar in IE.
    , Css.Global.textarea
        [ Css.overflow Css.auto ]

    -- 1. Add the correct box sizing in IE 10-.
    -- 2. Remove the padding in IE 10-.
    , Css.Global.each
        [ Css.Global.typeSelector "[type=\"checkbox\"]"
        , Css.Global.typeSelector "[type=\"radio\"]"
        ]
        [ Css.boxSizing Css.borderBox

        -- 1
        , Css.padding Css.zero

        -- 2
        ]

    -- Correct the cursor style of increment and decrement buttons in Chrome.
    , Css.Global.each
        [ Css.Global.typeSelector "[type=\"number\"]::-webkit-inner-spin-button"
        , Css.Global.typeSelector "[type=\"number\"]::-webkit-outer-spin-button"
        ]
        [ Css.height Css.auto ]

    -- 1. Correct the odd appearance in Chrome and Safari.
    -- 2. Correct the outline style in Safari.
    , Css.Global.typeSelector "[type=\"search\"]"
        [ Css.property "-webkit-appearance" "textfield"

        -- 1
        , Css.outlineOffset (Css.px -2)

        -- 2
        ]

    -- Remove the inner padding and cancel buttons in Chrome and Safari on macOS.
    , Css.Global.each
        [ Css.Global.typeSelector "[type=\"search\"]::-webkit-search-cancel-button"
        , Css.Global.typeSelector "[type=\"search\"]::-webkit-search-decoration"
        ]
        [ Css.property "-webkit-appearance" "none" ]

    -- 1. Correct the inability to style clickable types in iOS and Safari.
    -- 2. Change font properties to `inherit` in Safari.
    , Css.Global.typeSelector "::-webkit-file-upload-button"
        [ Css.property "-webkit-appearance" "button"

        -- 1
        , Css.property "font" "inherit"

        -- 2
        ]

    -- Add the correct display in IE 9-.
    -- 1. Add the correct display in Edge, IE, and Firefox.
    , Css.Global.each
        [ Css.Global.typeSelector "details"

        -- 1
        , Css.Global.typeSelector "menu"
        ]
        [ Css.display Css.block ]

    -- Add the correct display in all browsers.
    , Css.Global.typeSelector "summary"
        [ Css.display Css.listItem ]

    -- Add the correct display in IE 9-.
    , Css.Global.canvas
        [ Css.display Css.inlineBlock ]

    -- Add the correct display in IE.
    , Css.Global.typeSelector "template"
        [ Css.display Css.none ]

    -- Add the correct display in IE 10-.
    , Css.Global.typeSelector "[hidden]"
        [ Css.display Css.none ]
    ]
