use strict;
use warnings;
use Test::More (tests => 11);

use_ok('HTML::Template');

my $tmpl_string = "";
my $template = HTML::Template->new_scalar_ref(\$tmpl_string);

# test for non existing param
eval { my $value = $template->param('FOOBAR') };
like(
    $@,
    qr/HTML::Template : Attempt to get nonexistent parameter/,
    "attempt to get nonexistent parameter caught with die_on_bad_params == 1"
);

$template = HTML::Template->new_scalar_ref(\$tmpl_string, die_on_bad_params => 0);

ok(!defined($template->param('FOOBAR')), "if bad params permitted, bad param results in undef");

$template->param('FOOBAR' => undef);

ok(!defined($template->param('FOOBAR')), "undef param results in undef");

# test for bad call to ->param with non scalar/non-hashref arg
# dha wants to send it a puppy
eval { my $value = $template->param(bless ['FOOBAR'], "Puppy") };
like($@, qr/Single reference arg to param\(\) must be a hash-ref/, "Single reference arg to param() must be a hash-ref!");

# test for passing
eval { $template->param(bless {'FOOBAR' => 42}, "Puppy") };
ok(!$@, "param() doesn't die with blessed hash as first arg");

# make sure we can't pass a reference to a reference
eval { $template->param(\{}) };
like($@, qr/must be a hash-ref/i, 'reference to a hash-ref is still bad');

# odd number of params
eval { my $value = $template->param('foo' => 1, 'bar') };
like($@, qr/You gave me an odd number of parameters to param/, "odd number of args to param");

# value is a reference to a reference
$template = HTML::Template->new_scalar_ref(\'<tmpl_var foo>');
eval { $template->param(foo => \{}) };
like($@, qr/a reference to a reference/i, 'trying to use a reference to a reference');

# setting multiple values, multiple calls
$template = HTML::Template->new_scalar_ref(\'<tmpl_var foo> <tmpl_var bar> <tmpl_var baz> <tmpl_loop frob><tmpl_var fooey>-<tmpl_var blah> </tmpl_loop>');
$template->param(foo => 1, baz => 2);
$template->param(bar => 2, baz => 3, frob => [{fooey => 'a', blah => 'b'}, {fooey => 'c', blah => 'd'}]);
is($template->output, '1 2 3 a-b c-d ', 'can set multiple params at once');

# an array-like object whose class name happens to contain "HASH" must
# still be accepted as loop data (regression: the old type-check regex
# was /^(CODE)|(HASH)|(SCALAR)$/, which anchors only the first and last
# alternatives, so "HASH" matched anywhere in the class name)
{

    package My::HASHish;
    sub new { return bless [{v => 'row1'}], shift }
    sub isa { my ($self, $what) = @_; return $what eq 'ARRAY' ? 1 : 0 }
}
$template = HTML::Template->new_scalar_ref(\'<tmpl_loop l><tmpl_var v></tmpl_loop>');
$template->param(l => My::HASHish->new);
is($template->output, 'row1', 'array-like object with HASH in its class name works as loop data');

=head1 NAME

t/10-param.t

=head1 OBJECTIVE

Test edge cases in use of C<HTML::Template::param()>.  More tests will
probably be added as we understand this function better.

=cut

