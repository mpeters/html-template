use strict;
use warnings;
use Test::More (tests => 3);
use Data::Dumper;
use File::Temp;

use_ok('HTML::Template');

my $tmp_dir = File::Temp->newdir();

my ($template, $output);

# test file cache - non automated, requires turning on debug watching STDERR!
$template = HTML::Template->new(
    path              => ['templates/'],
    filename          => 'simple.tmpl',
    double_file_cache => 1,
    file_cache_dir    => $tmp_dir,
);
$template->param(ADJECTIVE => sub { "3y"; });
$output = $template->output;

$template = HTML::Template->new(
    path              => ['templates/'],
    filename          => 'simple.tmpl',
    double_file_cache => 1,
    file_cache_dir    => $tmp_dir,
);

ok($output =~ /3y/, "double_file_cache option provides expected output");

$template = HTML::Template->new(
    path     => ['templates/'],
    filename => 'simple.tmpl',
    cache    => 1,
);
$template->param(ADJECTIVE => sub { return 't' . 'i' . '1m' . '2e' . '3l' . '4y'; });
$output = $template->output;

$template = HTML::Template->new(
    path              => ['templates/'],
    filename          => 'simple.tmpl',
    double_file_cache => 1,
    file_cache_dir    => $tmp_dir,
);
ok($output =~ /ti1m2e3l4y/, "double_file_cache option provides expected output");

=head1 NAME

t/07-double-file-cache.t

=head1 OBJECTIVE

Test the previous untested C<double_file_cache> option to 
C<HTML::Template::new()>.

    $template = HTML::Template->new(
        path => ['templates/'],
        filename => 'simple.tmpl',
        double_file_cache => 1,
        file_cache_dir => './blib/temp_cache_dir',
    );

=cut
