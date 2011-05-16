#!/usr/bin/env perl
use strict;
use warnings;
use lib '../lib';
use HTML::Template;

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
