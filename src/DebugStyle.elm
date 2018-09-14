module DebugStyle exposing (debug, style)

import Css
import Css.Foreign
import Html.Styled exposing (Html)
import Responsive exposing (DeviceProps, Devices, rhythm)


{-| The CSS as an HTML <style> element.
-}
style : Devices -> Html msg
style devices =
    Css.Foreign.global <| debug devices


{-| The debug CSS.
-}
debug : Devices -> List Css.Foreign.Snippet
debug devices =
    [ Css.Foreign.each
        [ Css.Foreign.h1
        , Css.Foreign.h2
        , Css.Foreign.h3
        , Css.Foreign.h4
        , Css.Foreign.h5
        , Css.Foreign.p
        , Css.Foreign.typeSelector "dialog"
        , Css.Foreign.div
        , Css.Foreign.nav
        , Css.Foreign.footer
        ]
        [ Css.backgroundPosition2 (Css.px 0) (Css.px 0)
        , Css.property "background-image" (box "blue")
        ]
    , Css.Foreign.each
        [ Css.Foreign.table
        , Css.Foreign.td
        , Css.Foreign.th
        ]
        [ Css.property "background-image" (box "grey")
        ]
    , Css.Foreign.each
        [ Css.Foreign.canvas
        , Css.Foreign.typeSelector "object"
        , Css.Foreign.span
        ]
        [ Css.property "background-image" (box "red")
        ]
    , Css.Foreign.each
        [ Css.Foreign.li
        ]
        [ Css.property "background-image" (box "green")
        ]
    , Css.Foreign.each
        [ Css.Foreign.li
        , Css.Foreign.div
        , Css.Foreign.footer
        , Css.Foreign.header
        ]
        [ Css.backgroundColor Css.transparent |> Css.important
        ]
    , Css.Foreign.each
        [ Css.Foreign.typeSelector "dialog"
        , Css.Foreign.body
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
