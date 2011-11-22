#!/usr/bin/env perl
use strict;
use warnings;
use lib '../lib';
use Benchmark 'timethese';
use HTML::Template;

timethese(
    1_000,
    {
        small_template => sub {
            my $tmpl = HTML::Template->new(filename => 'templates/default.tmpl');
            $tmpl->param(
                a     => 'foo',
                cl    => 'bar',
                start => 'baz',
                sh    => 'blah',
            );
            $tmpl->output;
        },
        medium_template => sub {
            my $tmpl = HTML::Template->new(filename => 'templates/medium.tmpl');
            $tmpl->param(
                'alert'         => 'I am alert.',
                'company_name'  => "MY NAME IS",
                'company_id'    => "10001",
                'office_id'     => "10103214",
                'name'          => 'SAM I AM',
                'address'       => '101011 North Something Something',
                'city'          => 'NEW York',
                'state'         => 'NEw York',
                'zip'           => '10014',
                'phone'         => '212-929-4315',
                'phone2'        => '',
                'subcategories' => 'kfldjaldsf',
                'description' =>
                  "dsa;kljkldasfjkldsajflkjdsfklfjdsgkfld\nalskdjklajsdlkajfdlkjsfd\n\talksjdklajsfdkljdsf\ndsa;klfjdskfj",
                'website'       => 'http://www.assforyou.com/',
                'intranet_url'  => 'http://www.something.com',
                'remove_button' => "<INPUT TYPE=SUBMIT NAME=command VALUE=\"Remove Office\">",
                'company_admin_area' =>
                  "<A HREF=administrator.cgi?office_id=office_id&command=manage>Manage Office Administrators</A>",
                'casestudies_list' =>
                  "adsfkljdskldszfgfdfdsgdsfgfdshghdmfldkgjfhdskjfhdskjhfkhdsakgagsfjhbvdsaj hsgbf jhfg sajfjdsag ffasfj hfkjhsdkjhdsakjfhkj kjhdsfkjhdskfjhdskjfkjsda kjjsafdkjhds kjds fkj skjh fdskjhfkj kj kjhf kjh sfkjhadsfkj hadskjfhkjhs ajhdsfkj akj fkj kj kj  kkjdsfhk skjhadskfj haskjh fkjsahfkjhsfk ksjfhdkjh sfkjhdskjfhakj shiou weryheuwnjcinuc 3289u4234k 5 i 43iundsinfinafiunai saiufhiudsaf afiuhahfwefna uwhf u auiu uh weiuhfiuh iau huwehiucnaiuncianweciuninc iuaciun iucniunciunweiucniuwnciwe",
                'number_of_contacts' => "aksfjdkldsajfkljds",
                'country_selector'   => "klajslkjdsafkljds",
                'logo_link'          => "dsfpkjdsfkgljdsfkglj",
                'photo_link'         => "lsadfjlkfjdsgkljhfgklhasgh",
            );
            $tmpl->output;
        },
        large_template => sub {
            my $tmpl = HTML::Template->new(filename => 'templates/long_loops.tmpl');
            $tmpl->param(
                propname           => 'foo',
                javascript         => '<script type="text/javascript">aler("hi!")</script>',
                hotel_key          => 'bar&>?/',
                alert              => 'Danger!&!',
                new_comment_button => '<input type="button" name="new_comment">Click Me!</input>',
                comments           => [
                    {
                        color     => 'black',
                        posted_by => 'me & you',
                        posted_on => '<yesterday>',
                        stars     => '10',
                        comment   => 'Super & duper cool stuff!',
                        approval_button =>
                          '<input type="button" name="approve_comment">No, Click Me!</input>',
                        edit_button =>
                          '<input type="button" name="edit_comment">Hey, what about me!</input>',
                        delete_button =>
                          '<input type="button" name="delete_comment">Why am I always last?</input>',
                    },
                    {
                        color     => 'blue',
                        posted_by => 'you & I',
                        posted_on => '2 days <ago>',
                        stars     => '5',
                        comment   => 'It is ok <really>',
                        approval_button =>
                          '<input type="button" name="approve_comment">No, Click Me!</input>',
                        edit_button =>
                          '<input type="button" name="edit_comment">Hey, what about me!</input>',
                        delete_button =>
                          '<input type="button" name="delete_comment">Why am I always last?</input>',
                    },
                    {
                        color     => 'yellow',
                        posted_by => 'someone & someone else',
                        posted_on => '4 days <ago>',
                        stars     => '4',
                        comment   => 'It would not kill me to go back & spend more time there',
                        approval_button =>
                          '<input type="button" name="approve_comment">No, Click Me!</input>',
                        edit_button =>
                          '<input type="button" name="edit_comment">Hey, what about me!</input>',
                        delete_button =>
                          '<input type="button" name="delete_comment">Why am I always last?</input>',
                    },
                    {
                        color     => 'blue',
                        posted_by => 'someone else!&!',
                        posted_on => '<4 days ago>',
                        stars     => '6',
                        comment   => 'I enjoyed the <bed>',
                        approval_button =>
                          '<input type="button" name="approve_comment">No, Click Me!</input>',
                        edit_button =>
                          '<input type="button" name="edit_comment">Hey, what about me!</input>',
                        delete_button =>
                          '<input type="button" name="delete_comment">Why am I always last?</input>',
                    },
                    {
                        color     => 'red',
                        posted_by => 'someone else <&>',
                        stars     => '6',
                        approval_button =>
                          '<input type="button" name="approve_comment">No, Click Me!</input>',
                    },
                    {},
                ],
                comment_editor => [
                    {
                        color     => 'black',
                        posted_by => 'me',
                        posted_on => 'yesterday',
                        stars     => '10',
                        comment   => 'Super duper cool stuff!',
                        ok_button =>
                          '<input type="button" name="ok">I am totally fine with that.</input>',
                        cancel_button =>
                          '<input type="button" name="cancel">No you are not.</input>',
                    },
                    {
                        color     => 'blue',
                        posted_by => 'you',
                        posted_on => '2 days ago',
                        stars     => '5',
                        comment   => 'It is ok',
                        ok_button =>
                          '<input type="button" name="ok">I am totally fine with that.</input>',
                        cancel_button =>
                          '<input type="button" name="cancel">No you are not.</input>',
                    },
                    {
                        color     => 'yellow',
                        posted_by => 'someone',
                        posted_on => '4 days ago',
                        stars     => '4',
                        comment   => 'It would not kill me to go back',
                        ok_button =>
                          '<input type="button" name="ok">I am totally fine with that.</input>',
                        cancel_button =>
                          '<input type="button" name="cancel">No you are not.</input>',
                    },
                    {
                        color     => 'blue',
                        posted_by => 'someone else',
                        posted_on => '4 days ago',
                        stars     => '6',
                        comment   => 'I enjoyed the bed',
                        ok_button =>
                          '<input type="button" name="ok">I am totally fine with that.</input>',
                        cancel_button =>
                          '<input type="button" name="cancel">No you are not.</input>',
                    },
                    {
                        color     => 'red',
                        posted_by => 'someone else',
                        stars     => '6',
                        cancel_button =>
                          '<input type="button" name="cancel">No you are not.</input>',
                    },
                    {},
                ],
                comment_created => [
                    {posted_by => 'Fred'},
                    {posted_by => 'George'},
                    {posted_by => 'Thomas'},
                    {posted_by => 'Dan'},
                    {posted_by => 'Henry'},
                    {posted_by => 'Michael'},
                    {posted_by => 'Nelson'},
                    {posted_by => 'Brad'},
                    {posted_by => 'Rodney'},
                    {posted_by => 'Jose'},
                    {posted_by => 'Marie'},
                    {posted_by => 'Eric'},
                    {posted_by => 'Isaac'},
                    {posted_by => 'Rusty'},
                    {posted_by => 'Jacob'},
                    {posted_by => 'Alice'},
                    {posted_by => 'Kelly'},
                    {posted_by => 'Juan'},
                    {posted_by => 'Lewis'},
                    {posted_by => 'Fredrick'},
                    {posted_by => 'Manny'},
                    {posted_by => 'Dee'},
                    {posted_by => 'Nort'},
                    {posted_by => 'Jeanne'},
                    {posted_by => 'Oscar'},
                    {posted_by => 'Peter'},
                    {posted_by => 'Russel'},
                    {posted_by => 'Steve'},
                    {posted_by => 'Timmy'},
                    {posted_by => 'Vance'},
                    {},
                ],
            );
        },
    }
);

