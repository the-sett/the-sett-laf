module Utilities exposing (..)

import Array exposing (Array)
import Css exposing (margin2, margin3, px)


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
    margin2 (px <| 2 * baseSpacingUnit) (px <| 2 * baseSpacingUnit)



-- {
--     margin-left: (2 * $base-spacing-unit);
--     margin-left: pem(2 * $base-spacing-unit);
-- }
