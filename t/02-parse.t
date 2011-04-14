use strict;
use warnings;
use Test::More (tests => 9);
use_ok('HTML::Template');

# testing line 1978
my $tmpl_text = <<EOT;
         <TMPL_LOOP ESCAPE=HTML NAME=EMPLOYEE_INFO>
             Name: <TMPL_VAR NAME=NAME> <br>
             Job:  <TMPL_VAR NAME=JOB>  <p>
          </TMPL_LOOP>
EOT

eval { HTML::Template->new_scalar_ref(\$tmpl_text) };

like($@, qr/ESCAPE option invalid/, "Escape not in TMPL_VAR");

# testing line 1981
$tmpl_text = <<EOT;
         <TMPL_LOOP DEFAULT=foo NAME=EMPLOYEE_INFO>
             Name: <TMPL_VAR NAME=NAME> <br>
             Job:  <TMPL_VAR NAME=JOB>  <p>
          </TMPL_LOOP>
EOT

eval { HTML::Template->new_scalar_ref(\$tmpl_text) };

like($@, qr/DEFAULT option invalid/, "Escape not in TMPL_VAR");

# testing line 1984 else
# not quite checking 1984, deserves some sober attention
$tmpl_text = <<EOT;
     <TMPL_HUH NAME=ZAH>
         Name: <TMPL_VAR NAME=NAME> <br>
         Job:  <TMPL_VAR NAME=JOB>  <p>
      </TMPL_HUH>
EOT
ok(HTML::Template->new_scalar_ref(\$tmpl_text, strict => 0), "Ignores invalid TMPL tags with strict off");

# now with strict on
eval { HTML::Template->new_scalar_ref(\$tmpl_text, strict => 1) };
like($@, qr/Syntax error/, "Spits at invalid TMPL tag with strict on");

# make sure we can use <tmpl_var foo> and <tmpl_var foo /> syntax
my $tmpl = HTML::Template->new(scalarref => \'<tmpl_var foo>:<tmpl_var foo />');
$tmpl->param(foo => 'a');
my $output = $tmpl->output;
is($output, 'a:a', 'both var forms worked');

# attempting to check lines 1540-44
# test using HTML_TEMPLATE_ROOT with path
{
    my $file = 'four.tmpl';    # non-existent file
    local $ENV{HTML_TEMPLATE_ROOT} = "templates";
    eval { HTML::Template->new(path => ['searchpath'], filename => $file) };
    like($@, qr/Cannot open included file $file/, "Template file not found");
}

{
    my $file = 'four.tmpl';    # non-existent file
    local $ENV{HTML_TEMPLATE_ROOT} = "templates";
    eval { HTML::Template->new(filename => $file); };
    like($@, qr/Cannot open included file $file/, "Template file not found");
}

{
    my ($template, $output);
    local $ENV{HTML_TEMPLATE_ROOT} = "templates";
    $template = HTML::Template->new(filename => 'searchpath/three.tmpl');
    $output = $template->output;
    ok($output =~ /THREE/, "HTML_TEMPLATE_ROOT working without 'path' option being set");
}

=head1 NAME

t/02-parse.t

=head1 OBJECTIVE

Test previously untested code inside C<HTML::Template::_parse()>.  Much
remains to be done.

=cut

