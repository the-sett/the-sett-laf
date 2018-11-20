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


{-| A function that maps a font 'level' to a scaling from the default size.
-}
type alias TypeScale =
    Int -> Float


{-| Build a TypeScale function from a ratio between font levels.
-}
typeScale : Float -> TypeScale
typeScale ratio n =
    ratio ^ toFloat (n - 1)


{-| The minor second ratio.
-}
minorSecond : TypeScale
minorSecond =
    typeScale 1.067


{-| The major second ratio.
-}
majorSecond : TypeScale
majorSecond =
    typeScale 1.125


{-| The minor third ratio.
-}
minorThird : TypeScale
minorThird =
    typeScale 1.2


{-| The major third ratio.
-}
majorThird : TypeScale
majorThird =
    typeScale 1.25


{-| The perfect fourth ratio.
-}
perfectFourth : TypeScale
perfectFourth =
    typeScale 1.333


{-| The augmented fourth ratio.
-}
augmentedFourth : TypeScale
augmentedFourth =
    typeScale 1.414


{-| The perfect fifth ratio.
-}
perfectFifth : TypeScale
perfectFifth =
    typeScale 1.5


{-| The golden ratio.
-}
goldenRatio : TypeScale
goldenRatio =
    typeScale 1.618


{-| Describes font sizes as a 'level'. The level is the number of steps from the base
level at 1. A minimum number of rhythm lines is also specified, to aid vertical spacing.
-}
type FontSizeLevel
    = FontSizeLevel
        { level : Int
        , minLines : Int
        }


{-| A level down from the base level.
-}
milli : FontSizeLevel
milli =
    FontSizeLevel
        { level = 0
        , minLines = 1
        }


{-| The base level
-}
base : FontSizeLevel
base =
    FontSizeLevel
        { level = 1
        , minLines = 1
        }


{-| The h1 level
-}
h1 : FontSizeLevel
h1 =
    FontSizeLevel
        { level = 5
        , minLines = 3
        }


{-| The h2 level
-}
h2 : FontSizeLevel
h2 =
    FontSizeLevel
        { level = 4
        , minLines = 2
        }


{-| The h3 level
-}
h3 : FontSizeLevel
h3 =
    FontSizeLevel
        { level = 3
        , minLines = 2
        }


{-| The h4 level
-}
h4 : FontSizeLevel
h4 =
    FontSizeLevel
        { level = 2
        , minLines = 2
        }
