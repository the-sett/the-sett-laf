module Styles exposing
    ( styles, empty
    , sm, md, lg, xl
    , height
    )

{-| The Devices module provides device specific styling builders.


# Injecting constant CSS styles

@docs styles, empty


# Constant by device style builders

@docs sm, md, lg, xl


# Responsive by device properties style builders.

@docs height

-}

import Css
import Responsive exposing (Device(..), rhythm)
import ResponsiveDSL exposing (Builder(..), DeviceBuilder, StyleBuilder, applyDevice)


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


{-| Small device grid property builder.
-}
sm : DeviceBuilder a ctx
sm builders =
    applyDevice Sm builders


{-| Medium device grid property builder.
-}
md : DeviceBuilder a ctx
md builders =
    applyDevice Md builders


{-| Large device grid property builder.
-}
lg : DeviceBuilder a ctx
lg builders =
    applyDevice Lg builders


{-| Extra large device grid property builder.
-}
xl : DeviceBuilder a ctx
xl builders =
    applyDevice Xl builders


{-| Sets the height property in rhythm units.
-}
height : Float -> List (ctx -> Builder a ctx)
height n =
    [ \ctx -> ByDeviceProps ctx (\_ -> \common device -> [ Css.height <| rhythm n common device ])
    ]
