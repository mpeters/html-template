use strict;
use Test::More (tests => 117);
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
<TMPL_VAR foo>|<b>this is bold\n|&lt;b&gt;this is bold\n
<TMPL_VAR name=foo>|<b>this is bold\n|&lt;b&gt;this is bold\n
<TMPL_VAR name='foo'>|<b>this is bold\n|&lt;b&gt;this is bold\n
<TMPL_VAR NAME="foo">|<b>this is bold\n|&lt;b&gt;this is bold\n
<!-- TMPL_VAR foo -->|<b>this is bold\n|&lt;b&gt;this is bold\n
<!-- TMPL_VAR name=foo -->|<b>this is bold\n|&lt;b&gt;this is bold\n
<!-- TMPL_VAR NAME=foo -->|<b>this is bold\n|&lt;b&gt;this is bold\n
<!-- TMPL_VAR name='foo' -->|<b>this is bold\n|&lt;b&gt;this is bold\n
<!-- TMPL_VAR NAME="foo" -->|<b>this is bold\n|&lt;b&gt;this is bold\n

# use js escaping
<TMPL_VAR foo ESCAPE=JS>|<b>this is bold\n|<b>this is bold\\n
<TMPL_VAR ESCAPE=JS foo>|<b>this is bold\n|<b>this is bold\\n
<TMPL_VAR ESCAPE="JS" foo>|<b>this is bold\n|<b>this is bold\\n
<TMPL_VAR foo ESCAPE="JS">|<b>this is bold\n|<b>this is bold\\n
<TMPL_VAR NAME="foo" ESCAPE="JS">|<b>this is bold\n|<b>this is bold\\n
<TMPL_VAR ESCAPE="JS" NAME="foo">|<b>this is bold\n|<b>this is bold\\n
<TMPL_VAR ESCAPE='JS' foo>|<b>this is bold\n|<b>this is bold\\n
<TMPL_VAR foo ESCAPE='JS'>|<b>this is bold\n|<b>this is bold\\n
<TMPL_VAR NAME='foo' ESCAPE='JS'>|<b>this is bold\n|<b>this is bold\\n
<TMPL_VAR ESCAPE='JS' NAME='foo'>|<b>this is bold\n|<b>this is bold\\n
<!-- TMPL_VAR foo ESCAPE=JS -->|<b>this is bold\n|<b>this is bold\\n
<!-- TMPL_VAR ESCAPE=JS foo -->|<b>this is bold\n|<b>this is bold\\n
<!-- TMPL_VAR foo ESCAPE=JS -->|<b>this is bold\n|<b>this is bold\\n
<!-- TMPL_VAR ESCAPE="JS" foo -->|<b>this is bold\n|<b>this is bold\\n
<!-- TMPL_VAR foo ESCAPE="JS" -->|<b>this is bold\n|<b>this is bold\\n
<!-- TMPL_VAR NAME="foo" ESCAPE="JS" -->|<b>this is bold\n|<b>this is bold\\n
<!-- TMPL_VAR ESCAPE="JS" NAME="foo" -->|<b>this is bold\n|<b>this is bold\\n
<!-- TMPL_VAR ESCAPE='JS' foo -->|<b>this is bold\n|<b>this is bold\\n
<!-- TMPL_VAR foo ESCAPE='JS' -->|<b>this is bold\n|<b>this is bold\\n
<!-- TMPL_VAR NAME='foo' ESCAPE='JS' -->|<b>this is bold\n|<b>this is bold\\n
<!-- TMPL_VAR ESCAPE='JS' NAME='foo' -->|<b>this is bold\n|<b>this is bold\\n

#use url escaping
<TMPL_VAR foo ESCAPE=URL>|<b>this is bold\n|%3Cb%3Ethis%20is%20bold%5Cn
<TMPL_VAR ESCAPE=URL foo>|<b>this is bold\n|%3Cb%3Ethis%20is%20bold%5Cn
<TMPL_VAR foo ESCAPE=URL>|<b>this is bold\n|%3Cb%3Ethis%20is%20bold%5Cn
<TMPL_VAR ESCAPE="URL" foo>|<b>this is bold\n|%3Cb%3Ethis%20is%20bold%5Cn
<TMPL_VAR foo ESCAPE="URL">|<b>this is bold\n|%3Cb%3Ethis%20is%20bold%5Cn
<TMPL_VAR NAME="foo" ESCAPE="URL">|<b>this is bold\n|%3Cb%3Ethis%20is%20bold%5Cn
<TMPL_VAR ESCAPE="URL" NAME="foo">|<b>this is bold\n|%3Cb%3Ethis%20is%20bold%5Cn
<TMPL_VAR ESCAPE='URL' foo>|<b>this is bold\n|%3Cb%3Ethis%20is%20bold%5Cn
<TMPL_VAR foo ESCAPE='URL'>|<b>this is bold\n|%3Cb%3Ethis%20is%20bold%5Cn
<TMPL_VAR NAME='foo' ESCAPE='URL'>|<b>this is bold\n|%3Cb%3Ethis%20is%20bold%5Cn
<TMPL_VAR ESCAPE='URL' NAME='foo'>|<b>this is bold\n|%3Cb%3Ethis%20is%20bold%5Cn
<!-- TMPL_VAR foo ESCAPE=URL -->|<b>this is bold\n|%3Cb%3Ethis%20is%20bold%5Cn
<!-- TMPL_VAR ESCAPE=URL foo -->|<b>this is bold\n|%3Cb%3Ethis%20is%20bold%5Cn
<!-- TMPL_VAR foo ESCAPE=URL -->|<b>this is bold\n|%3Cb%3Ethis%20is%20bold%5Cn
<!-- TMPL_VAR ESCAPE="URL" foo -->|<b>this is bold\n|%3Cb%3Ethis%20is%20bold%5Cn
<!-- TMPL_VAR foo ESCAPE="URL" -->|<b>this is bold\n|%3Cb%3Ethis%20is%20bold%5Cn
<!-- TMPL_VAR NAME="foo" ESCAPE="URL" -->|<b>this is bold\n|%3Cb%3Ethis%20is%20bold%5Cn
<!-- TMPL_VAR ESCAPE="URL" NAME="foo" -->|<b>this is bold\n|%3Cb%3Ethis%20is%20bold%5Cn
<!-- TMPL_VAR ESCAPE='URL' foo -->|<b>this is bold\n|%3Cb%3Ethis%20is%20bold%5Cn
<!-- TMPL_VAR foo ESCAPE='URL' -->|<b>this is bold\n|%3Cb%3Ethis%20is%20bold%5Cn
<!-- TMPL_VAR NAME='foo' ESCAPE='URL' -->|<b>this is bold\n|%3Cb%3Ethis%20is%20bold%5Cn
<!-- TMPL_VAR ESCAPE='URL' NAME='foo' -->|<b>this is bold\n|%3Cb%3Ethis%20is%20bold%5Cn

# no escaping
<TMPL_VAR foo ESCAPE=0>|<b>this is bold\n|<b>this is bold\n
<TMPL_VAR ESCAPE=0 foo>|<b>this is bold\n|<b>this is bold\n
<TMPL_VAR foo ESCAPE=0>|<b>this is bold\n|<b>this is bold\n
<TMPL_VAR ESCAPE="0" foo>|<b>this is bold\n|<b>this is bold\n
<TMPL_VAR foo ESCAPE="0">|<b>this is bold\n|<b>this is bold\n
<TMPL_VAR NAME="foo" ESCAPE="0">|<b>this is bold\n|<b>this is bold\n
<TMPL_VAR ESCAPE="0" NAME="foo">|<b>this is bold\n|<b>this is bold\n
<TMPL_VAR ESCAPE='0' foo>|<b>this is bold\n|<b>this is bold\n
<TMPL_VAR foo ESCAPE='0'>|<b>this is bold\n|<b>this is bold\n
<TMPL_VAR NAME='foo' ESCAPE='0'>|<b>this is bold\n|<b>this is bold\n
<TMPL_VAR ESCAPE='0' NAME='foo'>|<b>this is bold\n|<b>this is bold\n
<!-- TMPL_VAR foo ESCAPE=0 -->|<b>this is bold\n|<b>this is bold\n
<!-- TMPL_VAR ESCAPE=0 foo -->|<b>this is bold\n|<b>this is bold\n
<!-- TMPL_VAR foo ESCAPE=0 -->|<b>this is bold\n|<b>this is bold\n
<!-- TMPL_VAR ESCAPE="0" foo -->|<b>this is bold\n|<b>this is bold\n
<!-- TMPL_VAR foo ESCAPE="0" -->|<b>this is bold\n|<b>this is bold\n
<!-- TMPL_VAR NAME="foo" ESCAPE="0" -->|<b>this is bold\n|<b>this is bold\n
<!-- TMPL_VAR ESCAPE="0" NAME="foo" -->|<b>this is bold\n|<b>this is bold\n
<!-- TMPL_VAR ESCAPE='0' foo -->|<b>this is bold\n|<b>this is bold\n
<!-- TMPL_VAR foo ESCAPE='0' -->|<b>this is bold\n|<b>this is bold\n
<!-- TMPL_VAR NAME='foo' ESCAPE='0' -->|<b>this is bold\n|<b>this is bold\n
<!-- TMPL_VAR ESCAPE='0' NAME='foo' -->|<b>this is bold\n|<b>this is bold\n

# no escaping
<TMPL_VAR foo ESCAPE=NONE>|<b>this is bold\n|<b>this is bold\n
<TMPL_VAR ESCAPE=NONE foo>|<b>this is bold\n|<b>this is bold\n
<TMPL_VAR foo ESCAPE=NONE>|<b>this is bold\n|<b>this is bold\n
<TMPL_VAR ESCAPE="NONE" foo>|<b>this is bold\n|<b>this is bold\n
<TMPL_VAR foo ESCAPE="NONE">|<b>this is bold\n|<b>this is bold\n
<TMPL_VAR NAME="foo" ESCAPE="NONE">|<b>this is bold\n|<b>this is bold\n
<TMPL_VAR ESCAPE="NONE" NAME="foo">|<b>this is bold\n|<b>this is bold\n
<TMPL_VAR ESCAPE='NONE' foo>|<b>this is bold\n|<b>this is bold\n
<TMPL_VAR foo ESCAPE='NONE'>|<b>this is bold\n|<b>this is bold\n
<TMPL_VAR NAME='foo' ESCAPE='NONE'>|<b>this is bold\n|<b>this is bold\n
<TMPL_VAR ESCAPE='NONE' NAME='foo'>|<b>this is bold\n|<b>this is bold\n
<!-- TMPL_VAR foo ESCAPE=NONE -->|<b>this is bold\n|<b>this is bold\n
<!-- TMPL_VAR ESCAPE=NONE foo -->|<b>this is bold\n|<b>this is bold\n
<!-- TMPL_VAR foo ESCAPE=NONE -->|<b>this is bold\n|<b>this is bold\n
<!-- TMPL_VAR ESCAPE="NONE" foo -->|<b>this is bold\n|<b>this is bold\n
<!-- TMPL_VAR foo ESCAPE="NONE" -->|<b>this is bold\n|<b>this is bold\n
<!-- TMPL_VAR NAME="foo" ESCAPE="NONE" -->|<b>this is bold\n|<b>this is bold\n
<!-- TMPL_VAR ESCAPE="NONE" NAME="foo" -->|<b>this is bold\n|<b>this is bold\n
<!-- TMPL_VAR ESCAPE='NONE' foo -->|<b>this is bold\n|<b>this is bold\n
<!-- TMPL_VAR foo ESCAPE='NONE' -->|<b>this is bold\n|<b>this is bold\n
<!-- TMPL_VAR NAME='foo' ESCAPE='NONE' -->|<b>this is bold\n|<b>this is bold\n
<!-- TMPL_VAR ESCAPE='NONE' NAME='foo' -->|<b>this is bold\n|<b>this is bold\n

#no escaping and default escaping
<TMPL_VAR foo ESCAPE=0> <TMPL_VAR foo>|<b>this is bold\n|<b>this is bold\n &lt;b&gt;this is bold\n
<!-- TMPL_VAR foo ESCAPE=0 --> <!-- TMPL_VAR foo -->|<b>this is bold\n|<b>this is bold\n &lt;b&gt;this is bold\n

# mixing escape and default
<TMPL_VAR foo default="UNKNOWN VALUE" ESCAPE=HTML>|fl<i>pper|fl&lt;i&gt;pper
<TMPL_VAR name="foo" default="UNKNOWN VALUE" escape="HTML">|fl<i>pper|fl&lt;i&gt;pper
<!-- TMPL_VAR NAME="foo" DEFAULT="UNKNOWN VALUE" ESCAPE="HTML" -->|fl<i>pper|fl&lt;i&gt;pper
<TMPL_VAR foo default="UNKNOWN VALUE" escape="HTML">|undef|UNKNOWN VALUE
<TMPL_VAR name="foo" default="UNKNOWN VALUE" ESCAPE='html'>|undef|UNKNOWN VALUE
<!-- TMPL_VAR NAME="foo" DEFAULT="UNKNOWN VALUE" ESCAPE="html" -->|undef|UNKNOWN VALUE
<TMPL_VAR foo ESCAPE=html default="UNKNOWN VALUE">|fl<i>pper|fl&lt;i&gt;pper
<TMPL_VAR name="foo" escape="HTML" default="UNKNOWN VALUE">|fl<i>pper|fl&lt;i&gt;pper
<!-- TMPL_VAR NAME="foo" ESCAPE='HTML' DEFAULT="UNKNOWN VALUE" -->|fl<i>pper|fl&lt;i&gt;pper
<TMPL_VAR foo escape='html' default="UNKNOWN VALUE">|undef|UNKNOWN VALUE
<TMPL_VAR name="foo" ESCAPE=HTML default="UNKNOWN VALUE">|undef|UNKNOWN VALUE
<!-- TMPL_VAR NAME="foo" ESCAPE="HTML" DEFAULT="UNKNOWN VALUE" -->|undef|UNKNOWN VALUE
<TMPL_VAR ESCAPE=html default="UNKNOWN VALUE" foo>|fl<i>pper|fl&lt;i&gt;pper
<TMPL_VAR escape="HTML" name="foo" default="UNKNOWN VALUE">|fl<i>pper|fl&lt;i&gt;pper
<!-- TMPL_VAR ESCAPE='HTML' DEFAULT="UNKNOWN VALUE" NAME="foo" -->|fl<i>pper|fl&lt;i&gt;pper
<TMPL_VAR escape='html' foo default="UNKNOWN VALUE">|undef|UNKNOWN VALUE
<TMPL_VAR ESCAPE=HTML name="foo" default="UNKNOWN VALUE">|undef|UNKNOWN VALUE
<!-- TMPL_VAR ESCAPE="HTML" DEFAULT="UNKNOWN VALUE" name="foo" -->|undef|UNKNOWN VALUE
