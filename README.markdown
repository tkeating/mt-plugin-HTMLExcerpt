# HTMLEXCERPT 1.2 FOR MOVABLE TYPE #

## AUTHOR: Tom Keating
[Read Online Documentation](http://blog.tmcnet.com/blog/tom-keating/movabletype/htmlexcerpt-plugin-for-movable-type.asp)

## Overview
Allows fully formatted HTML excerpts by adding new global filter called html_sentences, allowing you to pull
X number of sentences with full HTML formatting, e.g. tables, hyperlinks, bold, italics, etc.
Any orphaned HTML tags will be corrected automatically.

## DEPENDENCIES ##
Requires the HTML::Tidy or HTML::Lint module. As of version 1.2, the `HTML::Lint` module is bundled into extlib. The HTML::Tidy module will be used if installed, otherwise it falls back to the HTML::Lint module. The author recommends you install HTML::Tidy from cpan if possible.

## CHANGELOG ##
- version 1.2: Bundled HTML::Lint into extlib.
- version 1.1: Initial commit.

## CONTRIBUTORS ##
[Richard Bychowski](https://github.com/hiranyaloka) bundled the HTML::Lint module in version 1.2.

## BUNDLED MODULES ##
[HTML::Lint](http://search.cpan.org/dist/HTML-Lint/)

# USAGE
- You can use the global filter 'html_sentences' in any MT tag you like, but most likely you will use it within <$MTEntryBody>
- Example use:
  <$MTEntryBody html_sentences="4"$> <-Pulls 4 sentences with HTML formatting.
- Optionally you can allow only certain HTML tags like so:
  <$MTEntryBody html_sentences="4" sanitize="a href,p,br,i,em,strong,blockquote,ol,ul,li,script"$>

Copyright 2005-2011 Andy Lester.

## HTMLExcerpt COPYRIGHT AND LICENSE ##

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

This software is offered "as is" with no warranty.

HTMLExcerpt is Copyright 2012, [Tom Keating](http://blog.tmcnet.com/blog/tom-keating/contact/).
All rights reserved.

