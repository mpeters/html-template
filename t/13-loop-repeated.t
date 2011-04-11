use strict;
use warnings;
use Test::More (tests => 7);

use_ok('HTML::Template');

# normal loop with values
my $tmpl_string = '<tmpl_loop foo><tmpl_var a>:<tmpl_var b> </tmpl_loop>';
my $template = HTML::Template->new_scalar_ref( \$tmpl_string );
$template->param( foo => [{a => 1, b =>2}, {a => 3, b => 4}]);
my $output = $template->output;
is(clean($output), '1:2 3:4', 'normal loop');

# repeated loop with same vars
$tmpl_string = '<tmpl_loop foo><tmpl_var a>:<tmpl_var b> </tmpl_loop><tmpl_loop foo><tmpl_var a>:<tmpl_var b> </tmpl_loop>';
$template = HTML::Template->new_scalar_ref( \$tmpl_string );
$template->param( foo => [{a => 1, b =>2}, {a => 3, b => 4}]);
$output = $template->output;
is(clean($output), '1:2 3:4 1:2 3:4', 'repeated loop, same vars');

# repeated loop with different vars: more in 1st
$tmpl_string = '<tmpl_loop foo><tmpl_var a>:<tmpl_var b> </tmpl_loop><tmpl_loop foo><tmpl_var a>:0 </tmpl_loop>';
$template = HTML::Template->new_scalar_ref( \$tmpl_string );
$template->param( foo => [{a => 1, b =>2}, {a => 3, b => 4}]);
$output = $template->output;
is(clean($output), '1:2 3:4 1:0 3:0', 'repeated loop, different vars, more in 1st');

# repeated loop with different vars: more in 2nd
$tmpl_string = '<tmpl_loop foo><tmpl_var a>:0 </tmpl_loop><tmpl_loop foo><tmpl_var a>:<tmpl_var b> </tmpl_loop>';
$template = HTML::Template->new_scalar_ref( \$tmpl_string );
$template->param( foo => [{a => 1, b =>2}, {a => 3, b => 4}]);
$output = $template->output;
is(clean($output), '1:0 3:0 1:2 3:4', 'repeated loop, different vars, more in 2nd');

# repeat loop 3 times with different vars in each
$tmpl_string = '<tmpl_loop foo><tmpl_var a>:0 </tmpl_loop><tmpl_loop foo><tmpl_var a>:<tmpl_var b> </tmpl_loop><tmpl_loop foo><tmpl_var b>:<tmpl_var c> </tmpl_loop>';
$template = HTML::Template->new_scalar_ref( \$tmpl_string );
$template->param( foo => [{a => 1, b =>2, c => 3}, {a => 3, b => 4, c => 5}]);
$output = $template->output;
is(clean($output), '1:0 3:0 1:2 3:4 2:3 4:5', 'repeated loop 3x, different vars');

# repeat loop 3 times with different vars and conditionals
$tmpl_string = q|
    <tmpl_loop foo>
      <tmpl_var a>:0 
    </tmpl_loop>
    <tmpl_loop foo>
      <tmpl_if d>?<tmpl_else>!</tmpl_if>
      <tmpl_var a>:<tmpl_var b>
    </tmpl_loop>
    <tmpl_loop foo>
      <tmpl_if e>!<tmpl_else>?</tmpl_if>
      <tmpl_var b>:<tmpl_var c>
    </tmpl_loop>
|;
$template = HTML::Template->new_scalar_ref( \$tmpl_string );
$template->param( foo => [{a => 1, b =>2, c => 3, d => 1}, {a => 3, b => 4, c => 5, e => 1}]);
$output = $template->output;
is(clean($output), '1:0 3:0 ? 1:2 ! 3:4 ? 2:3 ! 4:5', 'repeated loop 3x, w/conditionals');

sub clean {
    my $string = shift;
    $string =~ s/\s+/ /g;
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    return $string;
}


=head1 NAME

t/13-loop-boolean.t

=head1 OBJECTIVE

Provide a test to show that loops (full or empty) should be able to be used as
booleans in a TMPL_IF along with using an empty loop.

=cut
