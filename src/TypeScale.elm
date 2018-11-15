module TypeScale exposing
    ( FontSizeLevel(..)
    , TypeScale
    , augmentedFourth
    , base
    , fontSizeMixin
    , fontSizePctMixin
    , goldenRatio
    , h1
    , h2
    , h3
    , h4
    , majorSecond
    , majorThird
    , milli
    , minorSecond
    , minorThird
    , perfectFifth
    , perfectFourth
    , typeScale
    )

import Css
import Css.Global
import Responsive exposing (BaseStyle, DeviceStyles, Mixin, lineHeight, mapMixins, mediaMixins, rhythm, styleAsMixin)



-- Type Scales.


type alias TypeScale =
    Int -> Float


typeScale : Float -> TypeScale
typeScale ratio n =
    ratio ^ toFloat (n - 1)


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
fontSizePx scale { baseFontSize } (FontSizeLevel sizeLevel) =
    (scale sizeLevel.level * baseFontSize)
        |> floor
        |> toFloat


fontSizeEm : TypeScale -> BaseStyle -> FontSizeLevel -> Float
fontSizeEm scale { baseFontSize } (FontSizeLevel sizeLevel) =
    scale sizeLevel.level * baseFontSize / 16.0


fontSizeMixin : TypeScale -> FontSizeLevel -> BaseStyle -> Mixin
fontSizeMixin scale (FontSizeLevel sizeLevel) deviceProps =
    let
        emVal =
            fontSizeEm scale deviceProps (FontSizeLevel sizeLevel)

        pxVal =
            fontSizePx scale deviceProps (FontSizeLevel sizeLevel)

        numLines =
            max sizeLevel.minLines
                (ceiling (pxVal / lineHeight deviceProps))
    in
    Css.batch
        [ Css.fontSize (Css.em emVal)

        --, Css.lineHeight (rhythm deviceProps (toFloat numLines))
        , Css.lineHeight <| Css.rem (1 * deviceProps.lineHeightRatio * toFloat numLines)
        ]
        |> styleAsMixin


fontSizePctMixin : TypeScale -> FontSizeLevel -> BaseStyle -> Mixin
fontSizePctMixin scale (FontSizeLevel sizeLevel) deviceProps =
    let
        emVal =
            fontSizeEm scale deviceProps (FontSizeLevel sizeLevel)

        pxVal =
            fontSizePx scale deviceProps (FontSizeLevel sizeLevel)

        numLines =
            max sizeLevel.minLines
                (ceiling (pxVal / lineHeight deviceProps))
    in
    Css.batch
        [ Css.fontSize <| Css.pct (emVal * 100.0)
        , Css.lineHeight (rhythm deviceProps (toFloat numLines))
        ]
        |> styleAsMixin
