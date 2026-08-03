use strict;
use warnings;
use Test::More tests => 6;

use_ok('HTML::Template');

# a minimal associate-compatible object with mutable values - we can't
# use CGI.pm here since it's no longer a core module
package MockQuery;

sub new { my ($class, %p) = @_; return bless {%p}, $class }

sub param {
    my ($self, $name) = @_;
    return keys %$self unless defined $name;
    return $self->{$name};
}

sub set { my ($self, $k, $v) = @_; $self->{$k} = $v }

package main;

# Regression test: with global_vars on, _unglobalize_vars used to wipe
# the user-supplied associate objects after the first output(), so any
# later output() on the same object lost its associated params.

my $q    = MockQuery->new(foo => 'first-value');
my $text = 'value: <TMPL_VAR FOO> loop:<TMPL_LOOP L><TMPL_VAR FOO>;</TMPL_LOOP>';
my $t    = HTML::Template->new(
    scalarref   => \$text,
    associate   => $q,
    global_vars => 1,
);
$t->param(l => [{}, {}]);

like($t->output, qr/value: first-value/, 'first output picks up associate value');
like($t->output, qr/first-value;first-value;/, 'global_vars propagates associate value into the loop');

is(scalar @{$t->{options}{associate}}, 1, 'associate list survives output() intact');

# simulate a fresh request against the same (persistent) object
$t->clear_params;
$t->param(l => [{}]);
$q->set(foo => 'second-value');

like($t->output, qr/value: second-value/, 'associate still consulted on a later output');
like($t->output, qr/second-value;/, '... including inside loops via global_vars');

=head1 NAME

t/03-associate-global-vars.t

=head1 OBJECTIVE

Regression test for the interaction of the C<associate> and
C<global_vars> options: C<_unglobalize_vars()> must remove only the
parent templates that C<_globalize_vars()> appended, not the
user-supplied associate objects.

=cut
