use strict;
use warnings;
#use Test::More tests => 4;
use Test::More skip_all => 'not implemented yet';

use_ok('HTML::Template');

# normal loop with values
my $tmpl_string = 'Hello<tmpl_comment> enemy</tmpl_comment> friend';
my $template = HTML::Template->new_scalar_ref( \$tmpl_string );
$template->param( name => 'Fred');
my $output = $template->output;
is($output, 'Hello friend', 'simple comment');

# comment with a var next to it
$tmpl_string = 'Hello<tmpl_comment> enemy</tmpl_comment> friend <tmpl_var name>';
$template = HTML::Template->new_scalar_ref( \$tmpl_string );
$template->param( name => 'Fred');
$output = $template->output;
is($output, 'Hello friend Fred', 'comment with var');

# comment with a var in it
$tmpl_string = 'Hello<tmpl_comment><tmpl_var name></tmpl_comment> friend';
$template = HTML::Template->new_scalar_ref( \$tmpl_string );
$template->param( name => 'Fred');
$output = $template->output;
is($output, 'Hello friend', 'comment hiding var');
