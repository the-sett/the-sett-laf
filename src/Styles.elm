module Styles exposing
    ( styles, empty
    , sm, md, lg, xl
    , height
    , visible, hidden
    )

{-| The Devices module provides device specific styling builders.


# Injecting constant CSS styles

@docs styles, empty


# Constant by device style builders

@docs sm, md, lg, xl


# Responsive by device properties style builders.

@docs height


# Generic styles

@docs visible, hidden

-}

import Css
import Responsive exposing (Device(..), rhythmPx)
import ResponsiveDSL
    exposing
        ( Builder(..)
        , ByDeviceBuilder
        , ConstDeviceBuilder
        , StyleBuilder
        )


{-| Adds any CSS style you like to a grid element.
-}
styles : List Css.Style -> StyleBuilder a ctx
styles styleList device ctx =
    ConstForDevice device ctx (always styleList)


{-| An empty style, for convenience when sketching out DSLs.
-}
empty : StyleBuilder a ctx
empty =
    \device ctx -> ConstForDevice device ctx (always [])


{-| Applies a responsive device to a list of StyleBuilders.
-}
applyDevice : Device -> List (Device -> ctx -> Builder a ctx) -> List (ctx -> Builder a ctx)
applyDevice device builders =
    List.map (\buildFn -> buildFn device) builders


{-| Small device grid property builder.
-}
sm : ConstDeviceBuilder a ctx
sm builders =
    applyDevice Sm builders


{-| Medium device grid property builder.
-}
md : ConstDeviceBuilder a ctx
md builders =
    applyDevice Md builders


{-| Large device grid property builder.
-}
lg : ConstDeviceBuilder a ctx
lg builders =
    applyDevice Lg builders


{-| Extra large device grid property builder.
-}
xl : ConstDeviceBuilder a ctx
xl builders =
    applyDevice Xl builders


{-| Sets the height property in rhythm units.
-}
height : Float -> ByDeviceBuilder a ctx
height n =
    [ \ctx -> ByDeviceProps ctx (\_ -> \device -> [ Css.height <| rhythmPx n device ])
    ]


{-| Content is visible.
-}
visible : StyleBuilder a ctx
visible =
    styles
        [ Css.visibility Css.visible
        , Css.display Css.block
        ]


{-| Content is hidden
-}
hidden : StyleBuilder a ctx
hidden =
    styles
        [ Css.visibility Css.hidden
        , Css.display Css.none
        ]
