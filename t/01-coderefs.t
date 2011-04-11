use strict;
use Test::More (tests => 1);
use HTML::Template;

my ($output, $template, $result);

# test escapes with code-refs
$template = HTML::Template->new(
    path     => 'templates',
    filename => 'escape.tmpl'
);
$template->param(STUFF => sub { q(<>"') });
$output = $template->output;
ok($output !~ /[<>"']/);    #"
