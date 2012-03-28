# HTMLExcerpt.pl
# Author: Tom Keating, VP & CTO
# http://blog.tmcnet.com/blog/tom-keating/ - VoIP & Gadgets Blog
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# Plugin Home / Tutorial article:
# http://blog.tmcnet.com/blog/tom-keating/movabletype/htmlexcerpt-plugin-for-movable-type.asp
# Note: If you want a manual/OVERRIDE excerpt, just insert this code:
# <!-- pagebreak -->/ and this plugin will PULL ALL text up to the pagebreak.
# MT TinyMCE plugin has a 'button' to instantly insert a pagebreak. 
# see: http://plugins.movabletype.org/tinymce/
# Last Modified: 3/21/2012

use strict;
package MT::Plugin::HTMLExcerpt;
use MT::Template::Context;

# HTML Cleaner options: "Tidy" or "Lint". Default it "Tidy"
my $cleaner = "Tidy"; #change to Lint if want Lint to clean HTML/orphaned tags

if ($cleaner eq "Lint")
{
use HTML::Lint;
} else {
   use HTML::Tidy;
  }

use vars qw($VERSION);

$VERSION = '1.1';

use MT;
use MT::Plugin;

my $plugin;
eval {
   require MT::Plugin;
   $plugin = MT::Plugin->new({
       name => 'HTMLExcerpt',
       description => q{MTEntryExcerpt and the "words" attribute for the EntryBody tag strips html tags
       "HTMLExcerpt" plugin does NOT strip HTML. It's a global filter, so you can use it with other tags.
       HTMLExcerpt looks for # of sentences you specify in 'html_sentences' parameter
       e.g. <$MTEntryBody html_sentences="4"$> <-Pulls 4 sentences w/ HTML formatting.
Optionally you can allow only certain HTML tags like so:
<$MTEntryBody html_sentences="4" sanitize="a href,p,br,i,em,strong,blockquote,ol,ul,li,script"$>},
       author_name => 'Tom Keating',
       author_link => 'http://blog.tmcnet.com/blog/tom-keating/',
       version => $VERSION,
   });
   MT->add_plugin($plugin);
};

MT::Template::Context->add_global_filter('html_sentences' => \&x_html_sentences);

sub x_html_sentences
{
  my ($text, $sentences, @sentences, $max, $usepagebreak) = @_;
$usepagebreak = 0;
# Look for <!-- pagebreak --> and set sentences=1 if find it [1 large sentence block up to where pagebreak code is located.
if ($text =~ m/<!-- pagebreak -->/)
{
  $sentences = 1;
  $usepagebreak = 1;
}

if ($usepagebreak == 0) {
# NO PAGE BREAK - Look for .&nbsp;&nbsp; and convert to .{space}&nbsp;
# $sentences = number of array elements. Words, Punctuation, and spaces each get
# separate element PER sentence. Thus, each sentence = 3 array elements.
# Therefore have to multiply $sentences * 3 to get accurate number of sentences.
   $sentences = $sentences * 3;
   @sentences = split /\.&nbsp;&nbsp;+/, $text;
   $max = @sentences > $sentences ? $sentences : @sentences;
   $text = join '. &nbsp;', @sentences[0..$max-1];

# Summary: Separates punctuation followed by space, &nbsp, </span>, or <p> 
# Technical REGEX explanation:
# Match punctuation (. ? !) followed by 0 or more spaces followed by &nbsp; OR <p> OR </span> followed by 1 space. e.g.:

   @sentences = split(/([\.\?\!]\s*)(&nbsp;|<p>|<\/p>|<\/span>|\ )/,$text);

# Re-assign new max value since punctuation space more common than &nbsp;&nbsp;
   $max = @sentences > $sentences ? $sentences : @sentences;
# Re-join the array elements to $text stopping at max limit -1 [elements start at 0]
   $text = join '', @sentences[0..$max-1];
 # $text .= "..." if (@sentences > $sentences); # Uncomment if want ... ellipsis at end
} else {
    #PAGE BREAK Found. Grab entire HTML block of code up to pagebreak
    @sentences = split /<!-- pagebreak -->/, $text;
    $max = @sentences > $sentences ? $sentences : @sentences;
    $text = join ' ', @sentences[0..$max-1];
    }

if ($cleaner eq "Tidy")
 {
   my $params;
   $params->{output_html} = '1';
   $params->{doctype} = 'omit';
   my $tidy = HTML::Tidy->new($params);
   $text = $tidy->clean($text);
   $text =~ s/<html.*<body>//is; #strip <html - <body> prepended by Tidy
   $text =~ s/<\/body>.*<\/html>//is; #strip </body> - </html> appended by Tidy
 }
if ($cleaner eq "Lint")
 {
#Start Lint find orphaned tags
   my $lint = HTML::Lint->new( only_types => HTML::Lint::Error::STRUCTURE );
   $lint->parse( "<html><head><title></title></head><body>".$text."</body></html>" );
   $lint->eof;
   foreach( reverse($lint->errors) )
   {
     if ( $_->errcode() eq 'elem-unclosed' )
     {
       my $tag = $_->errtext();
       $tag =~ /.*<([^>|\s]*)>.*/;
       $text .= "</$1>";
     }
   }
#End Lint find orphaned tags
 } #Close Else

 $text; #return $text
}
