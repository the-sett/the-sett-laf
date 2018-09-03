module Utilities exposing (..)

import Array exposing (Array)
import Css exposing (..)


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
