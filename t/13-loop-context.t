use strict;
use warnings;
#use Test::More tests => 4;
use Test::More 'no_plan';

use_ok('HTML::Template');
my @loop = ({bar => 'a'}, {bar => 'b'}, {bar => 'c'}, {bar => 'd'}, {bar => 'e'});

# no loop_context_vars
my $tmpl_string = '<tmpl_loop foo><tmpl_if __first__>1<tmpl_else>0</tmpl_if></tmpl_loop>';
my $template = HTML::Template->new(scalarref => \$tmpl_string, die_on_bad_params => 0);
$template->param(foo => \@loop);
my $output = $template->output;
is($output, '00000', 'no loop_context_vars');

# __first__ 
$tmpl_string = '<tmpl_loop foo><tmpl_if __first__>1<tmpl_else>0</tmpl_if></tmpl_loop>';
$template = HTML::Template->new(scalarref => \$tmpl_string, die_on_bad_params => 0, loop_context_vars => 1);
$template->param(foo => \@loop);
$output = $template->output;
is($output, '10000', '__first__');

# __last__ 
$tmpl_string = '<tmpl_loop foo><tmpl_if __last__>1<tmpl_else>0</tmpl_if></tmpl_loop>';
$template = HTML::Template->new(scalarref => \$tmpl_string, die_on_bad_params => 0, loop_context_vars => 1);
$template->param(foo => \@loop);
$output = $template->output;
is($output, '00001', '__last__');

# __inner__ 
$tmpl_string = '<tmpl_loop foo><tmpl_if __inner__>1<tmpl_else>0</tmpl_if></tmpl_loop>';
$template = HTML::Template->new(scalarref => \$tmpl_string, die_on_bad_params => 0, loop_context_vars => 1);
$template->param(foo => \@loop);
$output = $template->output;
is($output, '01110', '__inner__');

# __outer__ 
$tmpl_string = '<tmpl_loop foo><tmpl_if __outer__>1<tmpl_else>0</tmpl_if></tmpl_loop>';
$template = HTML::Template->new(scalarref => \$tmpl_string, die_on_bad_params => 0, loop_context_vars => 1);
$template->param(foo => \@loop);
$output = $template->output;
is($output, '10001', '__outer__');

# __odd__ 
$tmpl_string = '<tmpl_loop foo><tmpl_if __odd__>1<tmpl_else>0</tmpl_if></tmpl_loop>';
$template = HTML::Template->new(scalarref => \$tmpl_string, die_on_bad_params => 0, loop_context_vars => 1);
$template->param(foo => \@loop);
$output = $template->output;
is($output, '10101', '__odd__');

# __even__ 
$tmpl_string = '<tmpl_loop foo><tmpl_if __even__>1<tmpl_else>0</tmpl_if></tmpl_loop>';
$template = HTML::Template->new(scalarref => \$tmpl_string, die_on_bad_params => 0, loop_context_vars => 1);
$template->param(foo => \@loop);
$output = $template->output;
is($output, '01010', '__even__');

# __counter__ 
$tmpl_string = '<tmpl_loop foo><tmpl_var bar>:<tmpl_var __counter__> </tmpl_loop>';
$template = HTML::Template->new(scalarref => \$tmpl_string, die_on_bad_params => 0, loop_context_vars => 1);
$template->param(foo => \@loop);
$output = $template->output;
is($output, 'a:1 b:2 c:3 d:4 e:5 ', '__counter__');

# __index__ 
$tmpl_string = '<tmpl_loop foo><tmpl_var bar>:<tmpl_var __index__> </tmpl_loop>';
$template = HTML::Template->new(scalarref => \$tmpl_string, die_on_bad_params => 0, loop_context_vars => 1);
$template->param(foo => \@loop);
$output = $template->output;
is($output, 'a:0 b:1 c:2 d:3 e:4 ', '__index__');
