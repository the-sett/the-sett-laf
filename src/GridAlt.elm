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


columns : Float -> Builder { a | row : Never }
columns n =
    empty


offset : Float -> Builder { a | grid : Never, row : Never }
offset n =
    empty


start : Builder { a | grid : Never, col : Never }
start =
    fixed
        [ justifyContent flexStart
        , textAlign Css.start
        ]


end : Builder { a | grid : Never, col : Never }
end =
    fixed
        [ justifyContent flexEnd
        , textAlign Css.end
        ]


center : Builder { a | grid : Never, col : Never }
center =
    fixed
        [ justifyContent Css.center
        , textAlign Css.center
        ]


around : Builder { a | grid : Never, col : Never }
around =
    fixed [ justifyContent spaceAround ]


between : Builder { a | grid : Never, col : Never }
between =
    fixed [ justifyContent spaceBetween ]


reverse : Builder { a | grid : Never }
reverse _ grid =
    case grid of
        Row ->
            [ flexDirection rowReverse ]

        Column ->
            [ flexDirection columnReverse ]

        _ ->
            []


top : Builder { a | grid : Never, row : Never }
top =
    fixed [ alignItems flexStart ]


middle : Builder { a | grid : Never, row : Never }
middle =
    fixed [ alignItems Css.center ]


bottom : Builder { a | grid : Never, row : Never }
bottom =
    fixed [ alignItems flexEnd ]


first : Builder { a | grid : Never }
first =
    fixed [ order (num -1) ]


last : Builder { a | grid : Never }
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
