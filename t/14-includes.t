use strict;
use warnings;
use Test::More tests => 14;

use_ok('HTML::Template');

# simple include
my $tmpl_string = q|1 2 3 <tmpl_include templates/included2.tmpl> |;
my $template    = HTML::Template->new_scalar_ref(\$tmpl_string);
my $output      = $template->output;
is(clean($output), '1 2 3 5 5 5', 'simple include');

# nested includes
$tmpl_string = q|1 2 3 <tmpl_include templates/included.tmpl> |;
$template    = HTML::Template->new_scalar_ref(\$tmpl_string);
$output      = $template->output;
is(clean($output), '1 2 3 4 4 4 5 5 5', 'nested includes');

# simple include w/path
$tmpl_string = q|1 2 3 <tmpl_include included2.tmpl> |;
$template    = HTML::Template->new_scalar_ref(\$tmpl_string, path => 'templates');
$output      = $template->output;
is(clean($output), '1 2 3 5 5 5', 'simple include w/path');

# nested includes w/path
$tmpl_string = q|1 2 3 <tmpl_include included.tmpl> |;
$template    = HTML::Template->new_scalar_ref(\$tmpl_string, path => 'templates');
$output      = $template->output;
is(clean($output), '1 2 3 4 4 4 5 5 5', 'nested includes w/path');

# multiple same includes
$tmpl_string = q|1 2 3 <tmpl_include templates/included2.tmpl> 6 <tmpl_include templates/included2.tmpl>|;
$template    = HTML::Template->new_scalar_ref(\$tmpl_string);
$output      = $template->output;
is(clean($output), '1 2 3 5 5 5 6 5 5 5', 'multiple same includes');

# multiple different includes
$tmpl_string = q|1 2 3 <tmpl_include templates/included2.tmpl> 6 <tmpl_include templates/included3.tmpl>|;
$template    = HTML::Template->new_scalar_ref(\$tmpl_string);
$output      = $template->output;
is(clean($output), '1 2 3 5 5 5 6 6 6 6', 'multiple different includes');

# multiple different includes w/path
$tmpl_string = q|1 2 3 <tmpl_include included2.tmpl> 6 <tmpl_include included3.tmpl>|;
$template    = HTML::Template->new_scalar_ref(\$tmpl_string, path => 'templates');
$output      = $template->output;
is(clean($output), '1 2 3 5 5 5 6 6 6 6', 'multiple different includes w/path');

# multiple same nested includes
$tmpl_string = q|1 2 3 <tmpl_include templates/included.tmpl> 6 <tmpl_include templates/included.tmpl>|;
$template    = HTML::Template->new_scalar_ref(\$tmpl_string);
$output      = $template->output;
is(clean($output), '1 2 3 4 4 4 5 5 5 6 4 4 4 5 5 5', 'multiple same nested includes');

# multiple same nested includes w/path
$tmpl_string = q|1 2 3 <tmpl_include included.tmpl> 6 <tmpl_include included.tmpl>|;
$template    = HTML::Template->new_scalar_ref(\$tmpl_string, path => 'templates');
$output      = $template->output;
is(clean($output), '1 2 3 4 4 4 5 5 5 6 4 4 4 5 5 5', 'multiple same nested includes w/path');

# multiple different nested includes
$tmpl_string = q|1 2 3 <tmpl_include templates/included.tmpl> 6 <tmpl_include templates/included2.tmpl>|;
$template    = HTML::Template->new_scalar_ref(\$tmpl_string);
$output      = $template->output;
is(clean($output), '1 2 3 4 4 4 5 5 5 6 5 5 5', 'multiple different nested includes');

# multiple different nested includes w/path
$tmpl_string = q|1 2 3 <tmpl_include included.tmpl> 6 <tmpl_include included2.tmpl>|;
$template    = HTML::Template->new_scalar_ref(\$tmpl_string, path => 'templates');
$output      = $template->output;
is(clean($output), '1 2 3 4 4 4 5 5 5 6 5 5 5', 'multiple different nested includes w/path');

# lots of different nested includes
$tmpl_string =
  q|1 2 3 <tmpl_include templates/included.tmpl> 6 <tmpl_include templates/included2.tmpl> 7 <tmpl_include templates/included3.tmpl>|;
$template = HTML::Template->new_scalar_ref(\$tmpl_string);
$output   = $template->output;
is(clean($output), '1 2 3 4 4 4 5 5 5 6 5 5 5 7 6 6 6', 'lots of different nested includes');

# lots of different nested includes w/path
$tmpl_string = q|1 2 3 <tmpl_include included.tmpl> 6 <tmpl_include included2.tmpl> 7 <tmpl_include included3.tmpl>|;
$template    = HTML::Template->new_scalar_ref(\$tmpl_string, path => 'templates');
$output      = $template->output;
is(clean($output), '1 2 3 4 4 4 5 5 5 6 5 5 5 7 6 6 6', 'lots of different nested includes w/path');

sub clean {
    my $string = shift;
    $string =~ s/\s+/ /g;
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    return $string;
}

=head1 NAME

t/14-loop-boolean.t

=head1 OBJECTIVE

Provide a test to show that loops (full or empty) should be able to be used as
booleans in a TMPL_IF along with using an empty loop.

=cut
