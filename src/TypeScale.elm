module TypeScale exposing
    ( TypeScale, FontSizeLevel(..), typeScale
    , minorSecond, majorSecond, minorThird, majorThird, perfectFourth, augmentedFourth
    , perfectFifth, goldenRatio
    , milli, base, h1, h2, h3, h4
    )

{-|


# For specifying the type scale and descibing font sizes in levels.

@docs TypeScale, FontSizeLevel, typeScale


# Type scales.

@docs minorSecond, majorSecond, minorThird, majorThird, perfectFourth, augmentedFourth
@docs perfectFifth, goldenRatio


# Font size levels.

@docs milli, base, h1, h2, h3, h4

-}

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
