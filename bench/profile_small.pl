#!/usr/bin/env perl
use strict;
use warnings;
use lib '../lib';
use HTML::Template;

my $tmpl = HTML::Template->new(filename => 'templates/default.tmpl');
$tmpl->param(
    a     => 'foo',
    cl    => 'bar',
    start => 'baz',
    sh    => 'blah',
);
$tmpl->output;

