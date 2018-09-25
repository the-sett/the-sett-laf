module GridAlt exposing (..)

import Css exposing (..)
import Html.Styled exposing (styled, div, Html, Attribute)
import Responsive
    exposing
        ( Device(..)
        , DeviceSpec
        , DeviceStyles
        , BaseStyle
        , mapMaybeDeviceSpec
        , rhythm
        , deviceStyle
        , deviceStyles
        )


type Compatible
    = Compatible


type Grid a
    = Grid
    | Row
    | Column


type alias Builder a =
    Device -> Grid a -> List Css.Style


sm : List (Builder a) -> List (Grid a -> List Style)
sm builders =
    List.map (\builder -> builder Sm) builders


md : List (Builder a) -> List (Grid a -> List Style)
md builders =
    List.map (\builder -> builder Md) builders


lg : List (Builder a) -> List (Grid a -> List Style)
lg builders =
    List.map (\builder -> builder Lg) builders


xl : List (Builder a) -> List (Grid a -> List Style)
xl builders =
    List.map (\builder -> builder Xl) builders


grid : List (List (Grid { a | grid : Compatible } -> List Style)) -> List b -> List c -> DeviceStyles -> ()
grid _ _ _ _ =
    ()


row : List (List (Grid { a | row : Compatible } -> List Style)) -> List b -> List c -> ()
row _ _ _ =
    ()


col : List (List (Grid { a | col : Compatible } -> List Style)) -> List b -> List c -> ()
col _ _ _ =
    ()


empty =
    (\grid devices -> [])


fixed : List Css.Style -> Builder a
fixed styles _ _ =
    styles


columns : Float -> Builder { grid : c1, row : Never, col : c2 }
columns n =
    empty


offset : Float -> Builder { grid : Never, row : Never, col : c1 }
offset n =
    empty


start : Builder { grid : Never, row : c1, col : Never }
start =
    fixed
        [ justifyContent flexStart
        , textAlign Css.start
        ]


end : Builder { grid : Never, row : c1, col : Never }
end =
    fixed
        [ justifyContent flexEnd
        , textAlign Css.end
        ]


center : Builder { grid : Never, row : c1, col : Never }
center =
    fixed
        [ justifyContent Css.center
        , textAlign Css.center
        ]


around : Builder { grid : Never, row : c1, col : Never }
around =
    fixed [ justifyContent spaceAround ]


between : Builder { grid : Never, row : c1, col : Never }
between =
    fixed [ justifyContent spaceBetween ]


reverse : Builder { grid : Never, row : c1, col : c2 }
reverse _ grid =
    case grid of
        Row ->
            [ flexDirection rowReverse ]

        Column ->
            [ flexDirection columnReverse ]

        _ ->
            []


top : Builder { grid : Never, row : Never, col : c2 }
top =
    fixed [ alignItems flexStart ]


middle : Builder { grid : Never, row : Never, col : c2 }
middle =
    fixed [ alignItems Css.center ]


bottom : Builder { grid : Never, row : Never, col : c2 }
bottom =
    fixed [ alignItems flexEnd ]


first : Builder { grid : Never, row : c1, col : c2 }
first =
    fixed [ order (num -1) ]


last : Builder { grid : Never, row : c2, col : c2 }
last =
    fixed [ order (num 1) ]


ex devices =
    grid
        [ sm [ columns 12 ]
        ]
        []
        [ row
            [ sm [ center ]
            , lg [ start ]
            ]
            []
            [ col
                [ sm [ columns 1, offset 1 ]
                , md [ columns 2, offset 2 ]
                ]
                []
                []
            ]
        ]
        devices
