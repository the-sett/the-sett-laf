module DebugStyle exposing (debug, style)

import Css
import Css.Foreign
import Html.Styled exposing (Html)
import Utilities exposing (DeviceProps)


{-| The CSS as an HTML <style> element.
-}
style : DeviceProps -> Html msg
style deviceProps =
    Css.Foreign.global <| debug deviceProps


{-| The debug CSS.
-}
debug : DeviceProps -> List Css.Foreign.Snippet
debug deviceProps =
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
        , Css.property "background-image" "linear-gradient(00deg, blue 0px, transparent 1px), linear-gradient(90deg, blue 0px, transparent 1px), linear-gradient(180deg, blue 0px, transparent 1px), linear-gradient(270deg, blue 0px, transparent 1px)"
        ]
    , Css.Foreign.each
        [ Css.Foreign.table
        , Css.Foreign.td
        , Css.Foreign.th
        ]
        [ Css.property "background-image" "linear-gradient(0deg, grey 0px, transparent 1px), linear-gradient(90deg, grey 0px, transparent 1px), linear-gradient(180deg, grey 0px, transparent 1px), linear-gradient(270deg, grey 0px, transparent 1px)"
        ]
    , Css.Foreign.each
        [ Css.Foreign.canvas
        , Css.Foreign.typeSelector "object"
        , Css.Foreign.span
        ]
        [ Css.property "background-image" "linear-gradient(0deg, red 0px, transparent 1px), linear-gradient(90deg, red 0px, transparent 1px), linear-gradient(180deg, red 0px, transparent 1px), linear-gradient(270deg, red 0px, transparent 1px)"
        ]
    , Css.Foreign.each
        [ Css.Foreign.li
        ]
        [ Css.property "background-image" "linear-gradient(0deg, green 0px, transparent 1px), linear-gradient(90deg, green 0px, transparent 1px), linear-gradient(180deg, green 0px, transparent 1px), linear-gradient(270deg, green 0px, transparent 1px)"
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
        [ Css.property "background-image" "linear-gradient(to bottom, hsla(200, 100%, 50%, .3) 1px, transparent 1px)"
        , Css.backgroundPosition2 (Css.px 0) (Css.px -1)
        , Css.backgroundRepeat Css.repeat
        , Css.backgroundSize2 (Utilities.rhythm deviceProps 1) (Utilities.rhythm deviceProps 1)
        ]
    ]
