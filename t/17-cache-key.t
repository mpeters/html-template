use strict;
use warnings;
use Test::More tests => 13;
use lib("./t/testlib");

use_ok('HTML::Template');
use_ok('IO::Capture::Stderr');
use_ok('_Auxiliary', qw{capture_template});

# Regression tests: templates loaded from the same file but with
# different parse-affecting options must not share a cache slot.

my %base = (
    path     => ['templates/'],
    filename => 'cache-key.tmpl',
    cache    => 1,
);

# default_escape vs no escape
my $escaped = HTML::Template->new(%base, default_escape => 'html');
$escaped->param(foo => '<b>');
like($escaped->output, qr/&lt;b&gt;/, 'default_escape=html object escapes');

my $raw = HTML::Template->new(%base);
$raw->param(foo => '<b>');
my $raw_output = $raw->output;
like($raw_output, qr/<b>/, 'no-escape object with same file+cache outputs raw value');
unlike($raw_output, qr/&lt;/, '... and did not inherit default_escape from the cache');

# case_sensitive vs case-insensitive
my $ci = HTML::Template->new(%base);
$ci->param(foo => 'x');

my $cs = HTML::Template->new(%base, case_sensitive => 1);
eval { $cs->param(FOO => 'case-works') };
is($@, '', 'case_sensitive object did not inherit lowercased cached param_map');
like($cs->output, qr/case-works/, '... and outputs the param');

# filter vs no filter
my $filter = sub { my $ref = shift; $$ref =~ s/%%BAR%%/<TMPL_VAR BAR>/g };
my $filtered = HTML::Template->new(%base, filter => $filter);
$filtered->param(foo => 'x', bar => 'filter-works');
like($filtered->output, qr/filter-works/, 'filtered object applies its filter');

my $unfiltered = HTML::Template->new(%base);
$unfiltered->param(foo => 'x');
like($unfiltered->output, qr/%%BAR%%/, 'unfiltered object with same file+cache keeps literal text');

# the key must be stable between cache fetch and commit even though
# _parse() deletes the filter option: an identical filtered object
# must get a cache HIT, not a fresh LOAD.
my $capture = IO::Capture::Stderr->new();
my ($t, $line) = capture_template($capture, {%base, filter => $filter, cache_debug => 1});
like($line, qr/CACHE HIT/, 'identical filtered template gets a cache hit (key is memoized)');

# parse-policy options: a cache hit must not bypass parse-time errors.
# no_includes is the important one - it's a security control.
my $permissive = HTML::Template->new(path => ['templates/'], filename => 'include.tmpl', cache => 1);
eval { HTML::Template->new(path => ['templates/'], filename => 'include.tmpl', cache => 1, no_includes => 1) };
like($@, qr/no_includes/, 'no_includes still croaks after a permissive object cached the template');

my $lenient = HTML::Template->new(path => ['templates/'], filename => 'cache-key-strict.tmpl', cache => 1, strict => 0);
eval { HTML::Template->new(path => ['templates/'], filename => 'cache-key-strict.tmpl', cache => 1) };
like($@, qr/Syntax error/, 'strict still croaks after a lenient object cached the template');

=head1 NAME

t/17-cache-key.t

=head1 OBJECTIVE

Regression tests for the cache key computed by C<_cache_key()>.
Historically the key omitted several options that change the compiled
template (C<default_escape>, C<case_sensitive>, C<filter>,
C<vanguard_compatibility_mode>, C<die_on_bad_params>), so two objects
using the same file with different settings silently shared one cache
entry - notably letting C<default_escape> turn escaping on or off for
the wrong object depending on load order.

=cut
