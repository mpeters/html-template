use strict;
use warnings;
use File::Temp qw(tempdir);
use Test::More ($] < 5.007001 ? (skip_all => 'open_mode needs at least perl 5.7.1') : (tests => 5));

use_ok('HTML::Template');
my $cache_dir = tempdir(CLEANUP => 1);

# test with raw encoding
my $tmpl = HTML::Template->new(
    path      => 'templates',
    filename  => 'utf8-test.tmpl',
    open_mode => '<:raw',
);
my $output = $tmpl->output;
is(sprintf('%vd', $output), "195.164.10", 'correct raw bytes');

# test with UTF-8 encoding
$tmpl = HTML::Template->new(
    path      => 'templates',
    filename  => 'utf8-test.tmpl',
    open_mode => '<:encoding(utf-8)',
);
$output = $tmpl->output;
chomp $output;
is($output, chr(228), 'correct UTF8 encoded character');

# same as before, this time we test file_cache
$tmpl = HTML::Template->new(
    path           => 'templates',
    filename       => 'utf8-test.tmpl',
    open_mode      => '<:encoding(utf-8)',
    cache          => 0,
    file_cache     => 1,
    file_cache_dir => $cache_dir,
);

# trigger cache storage:
$output = $tmpl->output;

# this time it will implicitly read from the cache
$tmpl = HTML::Template->new(
    path           => 'templates',
    filename       => 'utf8-test.tmpl',
    open_mode      => '<:encoding(utf-8)',
    cache          => 0,
    file_cache     => 1,
    file_cache_dir => $cache_dir,
);

$output = $tmpl->output;
chomp $output;

is($output, chr(228), 'correct UTF8 encoded character from cache');

# this time it will implicitly read from the cache w/out open_mode
# which means it won't be correct UTF8.
$tmpl = HTML::Template->new(
    path           => 'templates',
    filename       => 'utf8-test.tmpl',
    cache          => 0,
    file_cache     => 1,
    file_cache_dir => $cache_dir,
);

$output = $tmpl->output;
chomp $output;
is(sprintf('%vd', $output), "195.164", 'correct non-UTF8 bytes: different open_mode, no cache');
