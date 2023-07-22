Blog
====

This is the source code for [my personal site][ruudva]. It is a static site
generated by a homemade generator written in Haskell.

The generator includes a tiny templating engine, an html and css minifier, and
an aggressive font subsetter. One of my objectives was to cut all the crap
(which almost by definition includes javascript) without compromising on
design. An average page of my site weighs less than jQuery alone (which
describes itself as “lightweight footprint”). That includes webfonts.

This is version three of my blog. Previously I used [Hakyll][hakyll] (available
in the `archived-hakyll` branch), and before that I used [Jekyll][jekyll].

[ruudva]: https://ruudvanasseldonk.com
[hakyll]: http://jaspervdj.be/hakyll/
[jekyll]: http://jekyllrb.com/

License
-------
The source code for this site is licensed under version 3 of the the
[GNU General Public Licence][gplv3]. See the `licence` file. The content of the
posts is licensed under the [Creative Commons BY SA][cc] licence. For the font
license details, see the readme in the fonts directory.

[gplv3]: https://gnu.org/licenses/gpl.html
[cc]:    https://creativecommons.org/licenses/by-sa/3.0/

Compiling
---------

All dependencies are available in a [Nix][nix] profile that you can enter with

    $ nix run --command $SHELL

This will bring a `python3` on the path with the right requirements for font
subsetting, as well as the blog generator itself, and tools for compressing
images.

The generator gets built as part of the development environment, but you can
also compile it manually with GHC if you like. Then build the site (requires
fonts to be present):

    $ ghc -o blog src/*.hs # Optional
    $ blog

[nix]: https://nixos.org/nix/
