module Quarks exposing (..)

import Css
import Css.Foreign
import Utilities exposing (..)


headings =
    [ Css.Foreign.each
        [ Css.Foreign.h1
        , Css.Foreign.h2
        , Css.Foreign.h3
        , Css.Foreign.h4
        , Css.Foreign.h5
        ]
        [ Css.fontSize (Css.px mobileBaseSize)

        -- Css.color: $color__grey--dark !important;
        ]
    , Css.Foreign.each
        [ Css.Foreign.h1
        , Css.Foreign.h2
        , Css.Foreign.h3
        ]
        [ Css.fontWeight Css.bold
        , Css.textRendering Css.optimizeLegibility
        ]
    , Css.Foreign.h1
        [-- @include adjust-font-size-to($mobile-h1-size, 3);
         -- @include media-tablet {
         --      @include adjust-font-size-to($tablet-h1-size, 3);
         -- }
        ]
    , Css.Foreign.h2
        [-- @include adjust-font-size-to($mobile-h2-size, 2);
         -- @include media-tablet {
         --      @include adjust-font-size-to($tablet-h2-size, 2);
         -- }
        ]
    , Css.Foreign.h3
        [-- @include adjust-font-size-to($mobile-h3-size, 2);
         -- @include media-tablet {
         --      @include adjust-font-size-to($tablet-h3-size, 2);
         -- }
        ]
    , Css.Foreign.h4
        [-- @include adjust-font-size-to($mobile-h4-size, 2);
         -- @include media-tablet {
         --      @include adjust-font-size-to($tablet-h4-size, 2);
         -- }
        ]
    ]
