use strict;
use warnings;
use Test::More tests => 5;

use_ok('HTML::Template');

my $text = 'hello <TMPL_VAR NAME>';

# plain lexical filehandle (in-memory file)
my $buf = '';
open my $fh, '>', \$buf or die "cannot open in-memory file: $!";
my $t = HTML::Template->new(scalarref => \$text);
$t->param(name => 'world');
my $rv = $t->output(print_to => $fh);
close $fh;
is($rv,  undef,         'print_to returns undef');
is($buf, 'hello world', 'output delivered to a plain filehandle');

# tied filehandle - regression test: output used to accumulate in
# memory and get silently discarded when the target handle was tied
{

    package TiedFH;
    sub TIEHANDLE { my ($class, $ref) = @_; return bless {buf => $ref}, $class }
    sub PRINT { my $self = shift; ${$self->{buf}} .= join('', @_) }
}
my $captured = '';
tie *TFH, 'TiedFH', \$captured;
my $t2 = HTML::Template->new(scalarref => \$text);
$t2->param(name => 'world');
$rv = $t2->output(print_to => *TFH);
is($rv,       undef,         'print_to to tied handle returns undef');
is($captured, 'hello world', 'output delivered to a tied filehandle');

=head1 NAME

t/18-print-to.t

=head1 OBJECTIVE

Test C<< output(print_to => $fh) >> with both plain and tied
filehandles.  When the target handle is tied, HTML::Template cannot use
its scalar-tie streaming trick (that is what the C<tied *{...}> guard
in C<output()> is for), so it accumulates the output and must still
print it to the handle at the end instead of discarding it.

=cut
