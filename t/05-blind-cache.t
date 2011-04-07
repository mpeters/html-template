use strict;
use warnings;
use File::Copy;
use File::Temp;
use File::Spec::Functions qw(curdir catfile);
use Test::More tests => 4;

use_ok('HTML::Template');

# use a temp file for the one that changes
my $tmp = File::Temp->new(UNLINK => 1, SUFFIX => '.tmpl');

ok(copy(catfile(curdir, 'templates', 'simple.tmpl'), $tmp), "copied simple.tmpl to temp file");

my ($output, $template);
# test cache - non automated, requires turning on debug watching STDERR!
$template = HTML::Template->new(
    filename    => $tmp,
    blind_cache => 1,
    debug       => 0,
    cache_debug => 0,
);
$template->param(ADJECTIVE => sub { return 'v' . '1e' . '2r' . '3y'; });
$output = $template->output;

sleep 1;

# overwrite our temp file with a different template
ok(copy(catfile(curdir, 'templates', 'simplemod.tmpl'), $tmp), "poured new content into template to test blind_cache");

$template = HTML::Template->new(
    filename    => $tmp,
    blind_cache => 1,
    debug       => 0,
    cache_debug => 0,
);
ok($output =~ /v1e2r3y/, "output unchanged as expected");

=head1 NAME

t/05-blind-cache.t

=head1 OBJECTIVE

Test the previously untested C<blind_cache> option to constructor 
C<HTML::Template::new()>.

    $template = HTML::Template->new(
        path => ['templates/'],
        filename => 'simple.tmpl',
        blind_cache => 1,
    );

=cut

