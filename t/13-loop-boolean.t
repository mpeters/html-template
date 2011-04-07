use strict;
use warnings;
use Test::More tests => 4;

use_ok('HTML::Template');

# normal loop with values
my $tmpl_string = '<tmpl_if my_loop>You have a loop<tmpl_else>Nope</tmpl_if><tmpl_loop my_loop> Foo: <tmpl_var foo></tmpl_loop>';
my $template = HTML::Template->new_scalar_ref( \$tmpl_string );
$template->param( my_loop => [{foo => 1}, {foo => 2}]);
my $output = $template->output;
is($output, 'You have a loop Foo: 1 Foo: 2', 'non-empty loop');

# a loop with an empty data structure
$template = HTML::Template->new_scalar_ref( \$tmpl_string );
$template->param( my_loop => []);
$output = $template->output;
is($output, 'Nope', 'empty loop');

# a loop with data inside the structure, but nothing in the template
$tmpl_string = '<tmpl_if my_loop>You have a loop<tmpl_else>Nope</tmpl_if><tmpl_loop my_loop></tmpl_loop>';
$template = HTML::Template->new_scalar_ref( \$tmpl_string, die_on_bad_params => 0 );
$template->param( my_loop => [{foo => 1}, {foo => 2}]);
$output = $template->output;
is($output, 'You have a loop', 'non-empty structure, but empty <tmpl_loop>');

=head1 NAME

t/13-loop-boolean.t

=head1 OBJECTIVE

Provide a test to show that loops (full or empty) should be able to be used as
booleans in a TMPL_IF along with using an empty loop.

=cut
