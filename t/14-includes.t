use strict;
use warnings;
use File::Temp;
use Test::More (tests => 20);

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

# missing file
$tmpl_string = q|1 2 3 <tmpl_include imaginary_file.tmpl> 4 5 6|;
eval { HTML::Template->new_scalar_ref(\$tmpl_string) };
like($@, qr/Cannot open included file/i, 'missing included file');

# missing file with false die_on_missing_include
$template = eval { HTML::Template->new_scalar_ref(\$tmpl_string, die_on_missing_include => 0) };
$output = $template->output;
ok(!$@, 'didnt die');
is(clean($output), '1 2 3 4 5 6', 'missing include just gets ignored');

# missing include in a level down
my $tmp = File::Temp->new(UNLINK => 1, SUFFIX => '.tmpl');
print $tmp $tmpl_string;
close $tmp;
$tmpl_string = "0 0 <tmpl_include $tmp> 9 9";
eval { HTML::Template->new_scalar_ref(\$tmpl_string) };
like($@, qr/Cannot open included file/i, 'missing included file');

# missing include in a level down with false die_on_missing_include
$template = eval { HTML::Template->new_scalar_ref(\$tmpl_string, die_on_missing_include => 0) };
$output = $template->output;
ok(!$@, 'didnt die');
is(clean($output), '0 0 1 2 3 4 5 6 9 9', 'missing include in a level down just gets ignored');


sub clean {
    my $string = shift;
    $string =~ s/\s+/ /g;
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    return $string;
}
