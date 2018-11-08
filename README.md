# The Sett - Look and Feel

A collection of CSS definitions for styling The Sett Ltd. This package will not
be of direct interest outside of The Sett Ltd, but you may find some inspiration
from the source code.

Parts of this will eventually be split off into re-usable packages that will be
more widely usable, the responsive system, the grids and the debug stylesheets for
example.

Originally built with SASS this has been converted to `rtfeldman/elm-css`. I opted
to use `elm-css` over `mdgriffith/elm-ui` because I want to do server side rendering
and need to make use of CSS media queries, rather than do it dynamically using
javascript.
