use strict;
use warnings;
use Test::More (tests => 9);

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

=head1 NAME

t/10-param.t

=head1 OBJECTIVE

Test edge cases in use of C<HTML::Template::param()>.  More tests will
probably be added as we understand this function better.

=cut

