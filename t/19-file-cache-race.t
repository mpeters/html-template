use strict;
use warnings;
use Test::More tests => 3;
use File::Temp;
use Errno;

# Simulate losing a mkdir race: for paths under our cache dir the
# directory gets created, but mkdir reports failure with EEXIST - just
# as if another process created it between HTML::Template's -d check
# and its mkdir call.  Under concurrent CGI load this used to croak.
my $cache_root = '';

BEGIN {
    *CORE::GLOBAL::mkdir = sub {
        my ($dir, $mode) = @_;
        my $ret = defined $mode ? CORE::mkdir($dir, $mode) : CORE::mkdir($dir);
        if ($cache_root && index($dir, $cache_root) == 0) {
            $! = Errno::EEXIST;
            return 0;
        }
        return $ret;
    };
}

use_ok('HTML::Template');

my $tmp_dir = File::Temp->newdir();
$cache_root = "$tmp_dir/cache";

my $template = eval {
    HTML::Template->new(
        path           => ['templates/'],
        filename       => 'simple.tmpl',
        file_cache     => 1,
        file_cache_dir => $cache_root,
    );
};
is($@, '', 'file_cache commit survives losing the mkdir race');

my @cache_files = glob("$cache_root/*/*");
is(scalar @cache_files, 1, 'cache file was written despite the lost race');

=head1 NAME

t/19-file-cache-race.t

=head1 OBJECTIVE

Regression test for the mkdir race in C<_commit_to_file_cache()>: when
two processes both pass the C<-d> check, the loser's C<mkdir> fails
with EEXIST and must be tolerated rather than croaking the request.

=cut
