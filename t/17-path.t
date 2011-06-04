# test path vs include path

use Test::More;
use HTML::Template;

eval { my $t = HTML::Template->new( filename => 'simple.tmpl' ) };
isnt($@,''," missing path dies dies");

eval { my $t = HTML::Template->new( path => 'templates', filename => 'simple.tmpl' ) };
is($@,''," correct path succeeds");

eval { my $t = HTML::Template->new( include_path => 'templates', filename => 'simple.tmpl' ) };
is($@,''," correct include_path succeeds");

eval { my $t = HTML::Template->new( include_path => 'templates', path => 'templates', filename => 'simple.tmpl' ) };
isnt($@,'',"mixing a valid include_path and a valid path_still fails");

done_testing();
