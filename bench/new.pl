#!/usr/bin/env perl
use strict;
use warnings;
use Benchmark 'timethese';
use lib '../lib';
use HTML::Template;

timethese(
    1_000,
    {
        small_template => sub { HTML::Template->new(filename => 'templates/default.tmpl') },
        big_template   => sub { HTML::Template->new(filename => 'templates/long_loops.tmpl') }
    }
);

