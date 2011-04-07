use Test::More ($] < 5.008000 ? (skip_all => 'force_untaint needs at least perl 5.8.0') : (tests => 2));
use_ok('HTML::Template');

my $text = 'foo';
eval { HTML::Template->new(debug => 0, scalarref => \$text, force_untaint => 1) };
like($@, qr/perl does not run in taint mode/, "force_untaint does not work without taint mode");
