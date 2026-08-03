#!perl -T
use Test::More ($] < 5.008000 ? (skip_all => 'force_untaint needs at least perl 5.8.0') : (tests => 13));
use Scalar::Util qw(tainted);
use lib 'lib'; # needed for prove in taint mode
use_ok('HTML::Template');

my $text = qq{ <TMPL_VAR NAME="a"> };

my $template = HTML::Template->new(
    debug         => 0,
    scalarref     => \$text,
    force_untaint => 1,
);

# We can't manually taint a variable, can we?
# OK, let's use ENV{PATH} - it is usually set and tainted [sn]
ok(tainted($ENV{PATH}), "PATH environment variable must be set and tainted for these tests");

$template->param(a => $ENV{PATH});
eval { $template->output() };

like($@, qr/tainted value with 'force_untaint' option/, "set tainted value despite option force_untaint");

# coderef that returns a tainted value
$template->param(a => sub { return $ENV{PATH} });
eval { $template->output() };

like(
    $@,
    qr/'force_untaint' option but coderef returns tainted value/,
    "coderef returns tainted value despite option force_untaint"
);

# force_untaint => 2 must also catch tainted values behind an ESCAPE -
# these checks used to test the wrong variable and never fired
for my $escape (qw(HTML JS URL)) {
    my $esc_text     = qq{ <TMPL_VAR NAME="a" ESCAPE=$escape> };
    my $esc_template = HTML::Template->new(
        scalarref     => \$esc_text,
        force_untaint => 2,
    );

    $esc_template->param(a => $ENV{PATH});
    eval { $esc_template->output() };
    like($@, qr/tainted value with 'force_untaint' option/, "tainted value caught behind ESCAPE=$escape");

    $esc_template->param(a => sub { return $ENV{PATH} });
    eval { $esc_template->output() };
    like($@, qr/coderef returns tainted value/, "tainted coderef value caught behind ESCAPE=$escape");

    $esc_template->param(a => "safe");
    eval { $esc_template->output() };
    is($@, '', "untainted value passes ESCAPE=$escape with force_untaint=2");
}
