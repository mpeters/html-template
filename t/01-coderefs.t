use strict;
use Test::More (tests => 40);
use HTML::Template;

my ($output, $template, $result);

# test a simple code-ref
$template = HTML::Template->new(path => 'templates', filename => 'var.tmpl');
$template->param(foo => sub { 'bar' });
$output = clean($template->output);
is($output, 'bar', 'correct value returned');

# test escapes with code-refs
$template = HTML::Template->new(path => 'templates', filename => 'escapes.tmpl');
$template->param(foo => sub { '<bar "foo">' });
$output = clean($template->output);
is($output, '<bar "foo"> <bar "foo"> &lt;bar &quot;foo&quot;&gt; <bar \"foo\"> %3Cbar%20%22foo%22%3E', 'correct value escaped');

# a coderef that will increment a variable
my $count = 0;
$template->param(foo => sub { ++$count });
$output = clean($template->output);
is($output, '1 2 3 4 5', 'sub called multiple times');
is($count, 5, 'correctly number of increments');

# a coderef that will increment a variable, but turn cache_lazy_vars on
$count = 0;
$template = HTML::Template->new(path => 'templates', filename => 'escapes.tmpl', cache_lazy_vars => 1);
$template->param(foo => sub { ++$count });
$output = clean($template->output);
is($output, '1 1 1 1 1', 'cache_lazy_vars works');
is($count, 1, 'correctly number of increments');
$output = clean($template->output);
is($output, '1 1 1 1 1', 'cache_lazy_vars works: output() called multiple times');
is($count, 1, 'correctly number of increments');

# a coderef for a non-existant variable
$count = 0;
$template = HTML::Template->new(path => 'templates', filename => 'var.tmpl', die_on_bad_params => 0);
$template->param(bar => sub { $count++ });
$output = clean($template->output);
is($output, '', 'no output');
is($count, 0, 'bar sub never called');

# a coderef used in conditionals and vars
$count = 0;
$template = HTML::Template->new(path => 'templates', filename => 'if.tmpl');
$template->param(bool => sub { $count++ });
$output = clean($template->output);
is($output, 'This is a line outside the if.', 'conditional false and then true');
is($count, 2, 'currect number of increments');
$template->param(bool => sub { --$count });
$output = clean($template->output);
is($output, 'This is a line outside the if. INSIDE the if unless', 'conditional true and then false');
is($count, 0, 'currect number of decrements');

# a coderef used in conditionals and vars, but turn cache_lazy_vars on
$count = 0;
$template = HTML::Template->new(path => 'templates', filename => 'if.tmpl', cache_lazy_vars => 1);
$template->param(bool => sub { $count++ });
$output = clean($template->output);
is($output, 'This is a line outside the if. unless', 'conditional false w/cache_lazy_vars');
is($count, 1, 'currect number of increments');

# a coderef returns false w/conditionals and vars, but turn cache_lazy_vars on
$count = 1;
$template = HTML::Template->new(path => 'templates', filename => 'if.tmpl', cache_lazy_vars => 1);
$template->param(bool => sub { $count-- });
$output = clean($template->output);
is($output, 'This is a line outside the if. INSIDE the if', 'conditional true w/cache_lazy_vars');
is($count, 0, 'currect number of decrements');

# try using a code ref on a TMPL_LOOP
$template = HTML::Template->new(path => 'templates', filename => 'loop.tmpl');
$template->param(loop_one => sub { [{var => 1}, {var => 2}] });
$output = clean($template->output);
is($output, '1 2', 'simple coderef for a loop');

# try using a code ref on a TMPL_LOOP w/cache_lazy_loops
$template = HTML::Template->new(path => 'templates', filename => 'loop.tmpl', cache_lazy_loops => 1);
$template->param(loop_one => sub { [{var => 1}, {var => 2}] });
$output = clean($template->output);
is($output, '1 2', 'simple coderef for a loop (cache_lazy_loops doesnt change anything)');

# a code ref that returns different things each time it's called
$count = 0;
$template->param(loop_one => sub { [{var => $count++}, {var => $count++}] });
$output = clean($template->output);
is($output, '0 1', 'loop coderef that returns something different each time');
is($count, 2, 'currect number of increments');

# a code ref that returns different things each time it's called w/cache_lazy_loops
$count = 0;
$template = HTML::Template->new(path => 'templates', filename => 'loop.tmpl', cache_lazy_loops => 1);
$template->param(loop_one => sub { [{var => $count++}, {var => $count++}] });
$output = clean($template->output);
is($output, '0 1', 'loop coderef that returns something different each time, w/cache_lazy_loops');
is($count, 2, 'currect number of increments');

# try using a code ref on a TMPL_LOOP that's also used as a conditional
$count = 0;
$template = HTML::Template->new(path => 'templates', filename => 'loop-if.tmpl');
$template->param(loop_one => sub { [{var => $count++}, {var => $count++}] });
$output = clean($template->output);
is($output, '2 3', 'loop coderef that returns something different each time');
is($count, 4, 'currect number of increments');

# try using a code ref on a TMPL_LOOP that's also used as a conditional w/cache_lazy_loops
$count = 1;
$template = HTML::Template->new(path => 'templates', filename => 'loop-if.tmpl', cache_lazy_loops => 1);
$template->param(loop_one => sub { [{var => $count++}, {var => $count++}] });
$output = clean($template->output);
is($output, '1 2', 'loop coderef that returns something different each time w/cache_lazy_loops');
is($count, 3, 'currect number of increments');

# a code ref (for a loop also used as a conditional) that returns a list the 1st time and an empty list the 2nd
$count = 1;
$template = HTML::Template->new(path => 'templates', filename => 'loop-if.tmpl');
$template->param(loop_one => sub { $count-- ? [{var => 1}, {var => 2}] : [] });
$output = clean($template->output);
is($output, '', 'no output because loop is blank the 2nd time');
is($count, -1, 'currect number of decrements');

# a code ref (for a loop also used as a conditional) that returns a list the 1st time and an empty list the 2nd w/cache_lazy_loops
$count = 1;
$template = HTML::Template->new(path => 'templates', filename => 'loop-if.tmpl', cache_lazy_loops => 1);
$template->param(loop_one => sub { $count-- ? [{var => 1}, {var => 2}] : [] });
$output = clean($template->output);
is($output, '1 2', 'loop isnt blank the 2nd time because of cache_lazy_loops');
is($count, 0, 'currect number of decrements');

# a code ref (for a loop also used as a conditional) that returns an empty list the 1st time and a list the 2nd
$count = 1;
$template = HTML::Template->new(path => 'templates', filename => 'loop-if.tmpl');
$template->param(loop_one => sub { $count-- ? [] : [{var => 1}, {var => 2}] });
$output = clean($template->output);
is($output, 'Loop not filled in!', 'coderef returns empty loop the first time and doesnt get called the 2nd');
is($count, 0, 'currect number of decrements');

# a code ref (for a loop also used as a conditional) that returns an empty list the 1st time and a list the 2nd w/cache_lazy_loops
$count = 1;
$template = HTML::Template->new(path => 'templates', filename => 'loop-if.tmpl', cache_lazy_loops => 1);
$template->param(loop_one => sub { $count-- ? [] : [{var => 1}, {var => 2}] });
$output = clean($template->output);
is($output, 'Loop not filled in!', 'coderef returns empty loop the first time and cache_lazy_loops caches it');
is($count, 0, 'currect number of decrements');

# a coderef for a non-existant loop
$count = 0;
$template = HTML::Template->new(path => 'templates', filename => 'loop.tmpl', die_on_bad_params => 0);
$template->param(loop_ten => sub { $count++; [{var => 1}, {var => 2}] });
$output = clean($template->output);
is($output, '', 'no output because loop doesnt exist');
is($count, 0, 'loop sub never called');

# a coderef for a loop that should never be executed
$template = HTML::Template->new(scalarref => \'<tmpl_if foo><tmpl_loop bar>0</tmpl_loop></tmpl_if>', die_on_bad_params => 0);
$template->param(bar => sub { $count++; [{var => 1}, {var => 2}] });
$output = clean($template->output);
is($output, '', 'no output because surrounding conditional is false');
is($count, 0, 'loop sub never called');

sub clean {
    my $string = shift;
    $string =~ s/\s+/ /g;
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    return $string;
}

