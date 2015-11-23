use strict;
use warnings;
use utf8;

use open ':std', ':encoding(utf8)';
use Test::More (tests => 2);
use_ok('HTML::Template');

while (<DATA>) {
    chomp;
    next if /^$/;
    next if /^#/;
    my ($text, $given, $wanted) = split /\|/;
    my $template = HTML::Template->new(
        scalarref      => \$text,
        default_escape => "HTML"
    );

    undef $given if $given eq 'undef';
    $template->param(foo => $given);
    my $output = $template->output;
    is($output, $wanted, $text);
}

# use pipe as the seperator between fields.
# the TMPL_VAR name should always be 'foo'
# fields: TMPL_VAR|given string|escaped string

__DATA__
# use default escaping
<TMPL_VAR foo>|<b>this is 字ñ\n|&lt;b&gt;this is 字ñ\n
<TMPL_VAR name=foo>|<b>this is 字ñ\n|&lt;b&gt;this is 字ñ\n
<TMPL_VAR name='foo'>|<b>this is 字ñ\n|&lt;b&gt;this is 字ñ\n
<TMPL_VAR NAME="foo">|<b>this is 字ñ\n|&lt;b&gt;this is 字ñ\n
<!-- TMPL_VAR foo -->|<b>this is 字ñ\n|&lt;b&gt;this is 字ñ\n
<!-- TMPL_VAR name=foo -->|<b>this is 字ñ\n|&lt;b&gt;this is 字ñ\n
<!-- TMPL_VAR NAME=foo -->|<b>this is 字ñ\n|&lt;b&gt;this is 字ñ\n
<!-- TMPL_VAR name='foo' -->|<b>this is 字ñ\n|&lt;b&gt;this is 字ñ\n
<!-- TMPL_VAR NAME="foo" -->|<b>this is 字ñ\n|&lt;b&gt;this is 字ñ\n
