use strict;
use Test::More;
use HTML::Template;

{
    my $t = HTML::Template->new(
        scalarref      => \'<tmpl_var foo>',
        default_escape => 'html',
    );
    $t->param( foo => '<' );
    is( $t->output, '&lt;', "test default_escape => 'html'");
}
{
    my $t = HTML::Template->new(
        scalarref      => \'<tmpl_var foo>',
        default_escape => 'none',
    );
    $t->param( foo => '<' );
    is( $t->output, '<', "test default_escape => 'none'");
}

done_testing();
