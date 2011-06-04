
use Test::More;
use HTML::Template;

my $t = HTML::Template->new;

like( $t->process('templates/simple.tmpl', { adjective => 'filename' }),
      qr/filename simple template/,
      "process('filename.tmpl')");

subtest 'Test non-filename sources' => sub {
      my ($template_string, @template_array);
      open $fh, 'templates/simple.tmpl'
          or die "Couldn't open simple.tmpl for reading: $!";
      {
          local $/;
          $template_string = <$fh>;
          seek $fh, 0, 0;
      }

      @template_array = <$fh>;
      seek $fh, 0, 0;

      like( $t->process($fh, { adjective => 'filehandle' }),
          qr/filehandle simple template/,
          'process($fh)');
      like( $t->process(\$template_string, { adjective => 'scalarref' }),
          qr/scalarref simple template/,
          'process(\$str)');
      like( $t->process(\@template_array, { adjective => 'arrayref' }),
          qr/arrayref simple template/,
          'process(\@array)');
};

subtest "Exceptions in param() output() and query() when new() lacks a source" => sub {
    my $t = HTML::Template->new;
    eval { $t->param(); };
    like($@, qr/\QHTML::Template->param() or query() called before new(/,
            "calling param() is not valid if new() was called without a template source");
    eval { $t->output(); };
    like($@, qr/\QHTML::Template->output() called before new(/,
            "calling output() is not valid if new() was called without a template source");
    eval { $t->query(); };
    like($@, qr/\QHTML::Template->param() or query() called before new(/,
            "calling query() is not valid if new() was called without a template source");
};

subtest "Combining caching with delayed template source" => sub {
    # This turned not not to require a code change to support.
    my $t;
    eval { $t = HTML::Template->new( cache => 1 ) };
    is($@, '', "combining cache with no source is OK");


};

subtest "Calling process multiple times starts with fresh params() each time" => sub {
    my $t = HTML::Template->new;
    like( $t->process('templates/medium.tmpl', { company_id => 'my_co_id' } ),
        qr/my_co_id/, "pre-test:  first call to process shows tmpl param" );

    my $out = $t->process('templates/medium.tmpl', { company_name => 'my_co_name' } );
    like( $out, qr/my_co_name/, "a different param in a second call to process with same file works" );
    unlike( $out, qr/my_co_id/, "params from first call are not present in second call to process() " );

};

subtest "A source is passed to new() and not passed to process()" => sub {
    my $t = HTML::Template->new( filename => 'templates/simple.tmpl' );
    eval { $t->process(undef, { adjective => 'BOOM?'}) };
    like($@,qr/source not defined/, "currently a source passed to new() is ignored.");
};

subtest "Calling process() without params" => sub {
    my $t = HTML::Template->new( die_on_bad_params => 0 );
    like( $t->process('templates/simple.tmpl'),
           qr/simple template/, "passing no params is OK");

};

done_testing();
