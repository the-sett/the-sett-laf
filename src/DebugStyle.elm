module DebugStyle exposing (debug, style)

import Css
import Css.Global
import Html.Styled exposing (Html)
import Responsive exposing (DeviceProps, DeviceSpec, rhythm)


{-| The CSS as an HTML <style> element.
-}
style : DeviceSpec -> Html msg
style devices =
    Css.Global.global <| debug devices


{-| The debug CSS.
-}
debug : DeviceSpec -> List Css.Global.Snippet
debug devices =
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
        , Css.property "background-image" (box "blue")
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
        [ Css.property "background-image" (box "red")
        ]
    , Css.Global.each
        [ Css.Global.li
        ]
        [ Css.property "background-image" (box "green")
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
        [ Css.property "background-image" (lines "hsla(200, 100%, 50%, .3)")
        , Css.backgroundPosition2 (Css.px 0) (Css.px -1)
        , Css.backgroundRepeat Css.repeat
        , Responsive.deviceStyle devices <|
            \deviceProps -> Css.backgroundSize2 (rhythm deviceProps 1) (rhythm deviceProps 1)
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
