use strict;
use warnings;
use Test::More tests => 2;

use_ok('HTML::Template');

my $template;
my $tmpl_string = '<tmpl_if my_loop>You have a loop</tmpl_if><tmpl_loop my_loop></tmpl_loop>';

$template = HTML::Template->new_scalar_ref( \$tmpl_string, die_on_bad_params => 0 );

# test for non existing param
$template->param( my_loop => [{foo => 1}, {foo => 2}]);
my $output = $template->output;
is($output, 'You have a loop', 'you can use an empty loop as a boolean');

=head1 NAME

t/12-loop-boolean.t

=head1 OBJECTIVE

Provide a test to show that loops should be able to be used as
booleans in a TMPL_IF along with using an empty loop.

=cut
