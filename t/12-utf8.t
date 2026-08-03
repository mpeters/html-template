use strict;
use warnings;
use File::Temp qw(tempdir);
use Test::More ($] < 5.007001 ? (skip_all => 'utf8 needs at least perl 5.7.1') : (tests => 6));

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

# utf8 => 1 must use the strict UTF-8 layer: a template file with an
# ill-formed sequence (here a CESU-8 encoded surrogate) must not let
# invalid Unicode like U+D800 through into the output
my $bad_file = File::Temp->new(UNLINK => 1, SUFFIX => '.tmpl');
binmode($bad_file);
print $bad_file "x\xED\xA0\x80y\n";
close $bad_file;
$tmpl = HTML::Template->new(
    filename => $bad_file->filename,
    utf8     => 1,
);
{
    no warnings 'utf8';    # comparing against a surrogate
    unlike($tmpl->output, qr/\x{D800}/, 'ill-formed UTF-8 does not produce invalid Unicode in output');
}
