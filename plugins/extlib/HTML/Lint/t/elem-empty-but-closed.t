use warnings;
use strict;
require 't/LintTest.pl';

checkit( [
    [ 'elem-empty-but-closed' => qr/<hr> is not a container -- <\/hr> is not allowed/ ],
], [<DATA>] );
    
__DATA__
<HTML>
    <HEAD>
	<TITLE>Test stuff</TITLE>
    </HEAD>
    <BODY BGCOLOR="white">
	<HR>This is a bad paragraph</HR>
    </BODY>
</HTML>
