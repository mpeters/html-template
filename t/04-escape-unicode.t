use strict;
use warnings;
use utf8;

use open ':std', ':encoding(utf8)';
use Test::More (tests => 12);
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

# ESCAPE=URL with characters above 0xFF - they used to be silently
# dropped because the byte-wise escape map has no entry for them.
# Wide characters are UTF-8 encoded before percent-escaping.
{
    my $text     = '<TMPL_VAR foo ESCAPE=URL>';
    my $template = HTML::Template->new(scalarref => \$text);
    $template->param(foo => "€5");
    is($template->output, '%E2%82%AC5', 'ESCAPE=URL percent-encodes wide chars as UTF-8 bytes');

    $template = HTML::Template->new(scalarref => \$text);
    $template->param(foo => "字ñ x");
    is($template->output, '%E5%AD%97%C3%B1%20x', 'ESCAPE=URL handles mixed wide string');
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
