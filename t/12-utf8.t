use strict;
use warnings;
use File::Temp qw(tempdir);
use Test::More ($] < 5.007001 ? (skip_all => 'utf8 needs at least perl 5.7.1') : (tests => 5));

use_ok('HTML::Template');

# make sure we can't use along with open_mode
eval { HTML::Template->new(path => 'templates', filename => 'utf8-test.tmpl', utf8 => 1, open_mode => 1)};
like($@, qr/utf8 and open_mode cannot be used/i, 'cant use uft8 and open_mode at the same time');

my $tmpl = HTML::Template->new(
    path     => 'templates',
    filename => 'utf8-test.tmpl',
    utf8     => 1,
);
my $output = $tmpl->output;
chomp $output;

is($output, chr(228), 'correct UTF8 encoded character');

my $cache_dir = tempdir(CLEANUP => 1);

# same as before, this time we test  file_cache
$tmpl = HTML::Template->new(
    path           => 'templates',
    filename       => 'utf8-test.tmpl',
    utf8           => 1,
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
    utf8           => 1,
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
