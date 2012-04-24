use strict;
use Test::More qw(no_plan);
use_ok('HTML::Template');

my $template = HTML::Template->new(
    path     => 'templates',
    filename => 'query-test.tmpl',
);

my @results = sort $template->query();
is_deeply(\@results, [qw(example_loop var)], 'no args, returns top level items');

is($template->query(name => 'var'), 'VAR', 'name for a variable');
ok(!$template->query(name => 'var2'), 'no name for a non existent var');
is($template->query(name => 'example_loop'), 'LOOP', 'name for a loop');
is($template->query(name => ['example_loop', 'bop']), 'VAR', 'name for a var inside a loop');
is($template->query(name => ['example_loop', 'example_inner_loop']), 'LOOP', 'name for a loop inside a loop');
is($template->query(name => ['example_loop', 'example_inner_loop', 'inner_bee']),
    'VAR', 'name for a var inside a loop inside a loop');

@results = sort $template->query(loop => 'example_loop');
is_deeply(\@results, [qw(bee bop example_inner_loop)], 'loop on an outer loop');

@results = sort $template->query(loop => ['example_loop', 'example_inner_loop']);
is_deeply(\@results, [qw(inner_bee inner_bop)], 'loop on an inner loop');

eval { $template->query(loop => 'var') };
ok($@ =~ /error/, 'loop on a var fails');

# another template
$template = HTML::Template->new(path => 'templates', filename => 'query-test2.tmpl');
@results = sort $template->query();

is_deeply(\@results, [qw(loop_foo)], 'no args, returns only top level item');

is($template->query(name => 'loop_foo'), 'LOOP', 'name for a loop');
is($template->query(name => ['loop_foo', 'loop_bar']), 'LOOP', 'name for a loop inside a loop');
is($template->query(name => ['loop_foo', 'loop_bar', 'foo']),  'VAR', 'name for a var inside loop inside a loop');
is($template->query(name => ['loop_foo', 'loop_bar', 'bar']),  'VAR', 'name for a var inside loop inside a loop');
is($template->query(name => ['loop_foo', 'loop_bar', 'bash']), 'VAR', 'name for a var inside loop inside a loop');

@results = sort $template->query(loop => 'loop_foo');
is_deeply(\@results, [qw(loop_bar)], 'loop on a loop');

@results = sort $template->query(loop => ['loop_foo', 'loop_bar']);
is_deeply(\@results, [qw(bar bash foo)], 'loop on an innner loop');

