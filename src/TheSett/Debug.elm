module TheSett.Debug exposing (global)

{-| DebugStyle provides a debug stylesheet.

This stylesheet uses repeating background image functions in CSS to display borders
around different elements of a page in different colors, without chaging the size they
are rendered at (as setting a border 1px would do).

The vertical rhtythm is also drawn in as fitn background lines.


# The CSS snippet to add to the global style.

@docs global

-}

import Css
import Css.Global
import Html.Styled exposing (Html)
import Responsive exposing (DeviceStyle, ResponsiveStyle, rhythm)


{-| The debug CSS.
-}
global : ResponsiveStyle -> List Css.Global.Snippet
global devices =
    [ Css.Global.each
        [ Css.Global.h1
        , Css.Global.h2
        , Css.Global.h3
        , Css.Global.h4
        , Css.Global.h5
        , Css.Global.p
        , Css.Global.typeSelector "dialog"
        , Css.Global.div
        , Css.Global.nav
        , Css.Global.footer
        ]
        [ Css.backgroundPosition2 (Css.px 0) (Css.px 0)
        , Css.property "background-image" (box "rgba(0, 0, 255, .3)")
        ]
    , Css.Global.each
        [ Css.Global.table
        , Css.Global.td
        , Css.Global.th
        ]
        [ Css.property "background-image" (box "grey")
        ]
    , Css.Global.each
        [ Css.Global.canvas
        , Css.Global.typeSelector "object"
        , Css.Global.span
        ]
        [ Css.property "background-image" (box "rgba(255, 0, 0, .3)")
        ]
    , Css.Global.each
        [ Css.Global.li
        ]
        [ Css.property "background-image" (box "rgba(0, 255, 0, .3)")
        ]
    , Css.Global.each
        [ Css.Global.li
        , Css.Global.div
        , Css.Global.footer
        , Css.Global.header
        ]
        [ Css.backgroundColor Css.transparent |> Css.important
        ]
    , Css.Global.each
        [ Css.Global.typeSelector "dialog"
        , Css.Global.body
        ]
        [ Css.property "background-image" (lines "hsla(200, 100%, 50%, .2)")
        , Css.backgroundPosition2 (Css.px 0) (Css.px -1)
        , Css.backgroundRepeat Css.repeat
        , Responsive.deviceStyle devices <|
            \device -> Css.backgroundSize2 (rhythm 1 devices.commonStyle device) (rhythm 1 devices.commonStyle device)
        ]
    ]


box color =
    "linear-gradient(00deg, "
        ++ color
        ++ " 0px, transparent 1px), linear-gradient(90deg, "
        ++ color
        ++ " 0px, transparent 1px), linear-gradient(180deg, "
        ++ color
        ++ " 0px, transparent 1px), linear-gradient(270deg, "
        ++ color
        ++ " 0px, transparent 1px)"


lines color =
    "linear-gradient(to bottom, " ++ color ++ " 1px, transparent 1px)"
