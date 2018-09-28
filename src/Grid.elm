module Grid
    exposing
        ( -- Media sizes
          sm
        , md
        , lg
        , xl
          -- Grid constructors
        , grid
        , row
        , col
          -- Grid attributes
        , columns
        , offset
        , start
        , end
        , center
        , around
        , between
        , reverse
        , top
        , middle
        , bottom
        , first
        , last
        )

import Css
    exposing
        ( num
        , alignItems
        , boxSizing
        , wrap
        , borderBox
        , marginLeft
        , flexBasis
        , flexShrink
        , flexWrap
        , property
        , auto
        , displayFlex
        , marginRight
        , order
        , flexEnd
        , flexStart
        , flexDirection
        , flexGrow
        , rowReverse
        , columnReverse
        , justifyContent
        , spaceBetween
        , spaceAround
        , textAlign
        , pct
        , maxWidth
        )
import Html.Styled exposing (styled, div, Html, Attribute, text)
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


type Grid
    = Grid
    | Row
    | Column


type Builder a
    = Builder Device Grid (Grid -> List Css.Style)


applyDevice : Device -> List (Device -> Grid -> Builder a) -> List (Grid -> Builder a)
applyDevice device builders =
    List.map (\buildFn -> buildFn device) builders



--sm : List (Grid a -> List Css.Style) -> Builder a
-- where Builder a = Builder Device (Grid a -> List Css.stlye)


sm : List (Device -> Grid -> Builder a) -> List (Grid -> Builder a)
sm builders =
    applyDevice Sm builders


md : List (Device -> Grid -> Builder a) -> List (Grid -> Builder a)
md builders =
    applyDevice Md builders


lg : List (Device -> Grid -> Builder a) -> List (Grid -> Builder a)
lg builders =
    applyDevice Lg builders


xl : List (Device -> Grid -> Builder a) -> List (Grid -> Builder a)
xl builders =
    applyDevice Xl builders


styles buildersList devices =
    deviceStyles devices
        (\base ->
            List.map
                (\(Builder device grid fn) ->
                    if device == base.device then
                        fn grid
                    else
                        []
                )
                buildersList
                |> List.concat
        )


type alias GridT a msg =
    List (List (Grid -> Builder { a | grid : Compatible })) -> List (Attribute msg) -> List (DeviceStyles -> Html msg) -> DeviceStyles -> Html msg


grid : GridT a msg
grid builders attributes innerHtml devices =
    let
        flatBuilders =
            List.concat builders
                |> List.map (\gridFn -> gridFn Column)
    in
        (styled div)
            [ marginRight auto
            , marginLeft auto
            , styles flatBuilders devices
            ]
            []
            (List.map (\deviceStyleFn -> deviceStyleFn devices) innerHtml)


type alias RowT a msg =
    List (List (Grid -> Builder { a | row : Compatible })) -> List (Attribute msg) -> List (DeviceStyles -> Html msg) -> DeviceStyles -> Html msg


row : RowT a msg
row builders attributes innerHtml devices =
    let
        flatBuilders =
            List.concat builders
                |> List.map (\gridFn -> gridFn Column)
    in
        (styled div)
            [ boxSizing borderBox
            , displayFlex
            , property "flex" "0 1 auto"
            , flexDirection Css.row
            , flexWrap wrap
            , styles flatBuilders devices
            ]
            []
            (List.map (\deviceStyleFn -> deviceStyleFn devices) innerHtml)


type alias ColT a msg =
    List (List (Grid -> Builder { a | col : Compatible })) -> List (Attribute msg) -> List (Html msg) -> DeviceStyles -> Html msg


col : ColT a msg
col builders attributes innerHtml devices =
    let
        flatBuilders : List (Builder { a | col : Compatible })
        flatBuilders =
            List.concat builders
                |> List.map (\gridFn -> gridFn Column)
    in
        (styled div)
            [ boxSizing borderBox
            , flexShrink (num 0)
            , flexGrow (num 0)
            , styles flatBuilders devices
            ]
            []
            innerHtml


empty : Device -> Grid -> Builder a
empty =
    (\device grid -> Builder device grid (always []))


fixed : List Css.Style -> Device -> Grid -> Builder a
fixed styles device grid =
    Builder device grid (always styles)



-- Should work differently on column and grid.
-- On grid, sets the number of columns, on column sets width to fraction of columns.


columns : Float -> Device -> Grid -> Builder { a | row : Never }
columns n =
    if n > 0 then
        fixed
            [ flexBasis (pct (n / 12 * 100))
            , maxWidth (pct (n / 12 * 100))
            ]
    else
        fixed
            [ flexBasis (pct (n / 12 * 100))
            , maxWidth (pct 100)
            , flexGrow (num 1)
            ]


offset : Float -> Device -> Grid -> Builder { a | grid : Never, row : Never }
offset n =
    if n > 0 then
        fixed
            [ marginLeft (pct (n / 12 * 100)) ]
    else
        empty


start : Device -> Grid -> Builder { a | grid : Never, col : Never }
start =
    fixed
        [ justifyContent flexStart
        , textAlign Css.start
        ]


end : Device -> Grid -> Builder { a | grid : Never, col : Never }
end =
    fixed
        [ justifyContent flexEnd
        , textAlign Css.end
        ]


center : Device -> Grid -> Builder { a | grid : Never, col : Never }
center =
    fixed
        [ justifyContent Css.center
        , textAlign Css.center
        ]


around : Device -> Grid -> Builder { a | grid : Never, col : Never }
around =
    fixed [ justifyContent spaceAround ]


between : Device -> Grid -> Builder { a | grid : Never, col : Never }
between =
    fixed [ justifyContent spaceBetween ]


reverse : Device -> Grid -> Builder { a | grid : Never }
reverse device grid =
    Builder device grid <|
        \grid ->
            case grid of
                Row ->
                    [ flexDirection rowReverse ]

                Column ->
                    [ flexDirection columnReverse ]

                _ ->
                    []


top : Device -> Grid -> Builder { a | grid : Never, row : Never }
top =
    fixed [ alignItems flexStart ]


middle : Device -> Grid -> Builder { a | grid : Never, row : Never }
middle =
    fixed [ alignItems Css.center ]


bottom : Device -> Grid -> Builder { a | grid : Never, row : Never }
bottom =
    fixed [ alignItems flexEnd ]


first : Device -> Grid -> Builder { a | grid : Never }
first =
    fixed [ order (num -1) ]


last : Device -> Grid -> Builder { a | grid : Never }
last =
    fixed [ order (num 1) ]
