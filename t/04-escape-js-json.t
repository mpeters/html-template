use strict;
use warnings;
use Test::More;
use HTML::Template;

sub render {
    my ($tpl, $value) = @_;
    my $t = HTML::Template->new(
        scalarref         => \$tpl,
        die_on_bad_params => 0,
    );
    $t->param(foo => $value);
    return $t->output;
}

# ESCAPE=JS: neutralize script-tag breakouts inside HTML script string embeds
{
    my $payload = '</' . 'script><img src=x onerror=alert(1)>';
    my $out = render(q{X=<TMPL_VAR foo ESCAPE=JS>}, $payload);
    unlike($out, qr{</script>}i, 'ESCAPE=JS removes raw script closer');
    like($out, qr{\\u003c}, 'ESCAPE=JS uses \\u003c for <');
    like($out, qr{\\/}, 'ESCAPE=JS escapes slashes');
}

# ESCAPE=JSON: only rewrite < in an otherwise intact JSON blob
{
    my $json = '{"a":"</' . 'script>","b":1}';
    my $out  = render(q{X=<TMPL_VAR foo ESCAPE=JSON>}, $json);
    is($out, 'X={"a":"\u003c/' . 'script>","b":1}', 'ESCAPE=JSON only rewrites <');
}

# ESCAPE=HTML / URL unchanged for a simple payload
{
    is(
        render(q{X=<TMPL_VAR foo ESCAPE=HTML>}, q{a&b <c> "d"}),
        q{X=a&amp;b &lt;c&gt; &quot;d&quot;},
        'ESCAPE=HTML unchanged'
    );
    is(
        render(q{X=<TMPL_VAR foo ESCAPE=URL>}, q{a&b}),
        q{X=a%26b},
        'ESCAPE=URL unchanged'
    );
}

# default_escape => 'json' is accepted
{
    my $t = HTML::Template->new(
        scalarref         => \q{<TMPL_VAR foo>},
        default_escape    => 'json',
        die_on_bad_params => 0,
    );
    $t->param(foo => q{"x":"<y>"});
    is($t->output, q{"x":"\u003cy>"}, 'default_escape => json');
}

done_testing();
