use strict;
use Test::More (tests => 2);
use HTML::Template;

my ($output, $template, $result);

# test escapes with code-refs
$template = HTML::Template->new(
    path     => 'templates',
    filename => 'escape.tmpl'
);
$template->param(stuff => sub { q(<>"') });
$output = $template->output;
ok($output !~ /[<>"']/);    #"

# now with a closure that will increment a variable
my $count = 0;
$template->param(stuff => sub { ++$count });

$output = clean($template->output);
is($output, 'This should be a bunch of HTML-escaped stuff: 1 2 3 4', 'sub called multiple times');

sub clean {
    my $string = shift;
    $string =~ s/\s+/ /g;
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    return $string;
}

