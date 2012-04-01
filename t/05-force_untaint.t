#!perl -T
use Test::More ($] < 5.008000 ? (skip_all => 'force_untaint needs at least perl 5.8.0') : (tests => 4));
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
