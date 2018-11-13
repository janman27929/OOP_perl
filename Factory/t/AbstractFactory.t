#! /usr/bin/env perl

use lib qw(lib);
use Test::Most 'no_plan';
use strict; use warnings;

my $class = 'AbstractFactory';
use_ok($class) or die ("could not open $class");

my $f1 = Factory1->new(color=>'red');
is ref $f1, 'Factory1', 'Factory1 type';
is $f1->isValidProduct('Product1'),1,'got valid product:Product1';
is $f1->isValidProduct('Product3'),0,'got invalid product for Factory1:Product3';
is $f1->isValidProduct('Product11'),0,'got invalid product:Product11';
is $f1->{color}, 'red', 'got red';
dies_ok {$f1->add_product(product=>'Product13', color=>'orange')} 'dies on bad product';
my $f2 = Factory2->new();
is ref $f2, 'Factory2','Factory2 type';
my $f3 = Factory3->new();
is ref $f3, 'Factory3', 'Factory3 type';


my $p1 = Product1->new(color=>'blue');
is ref $p1, 'Product1', 'Product1 type';
my $p1f = Product1::Factory1->new(color=>'yellow');
is ref $p1f, 'Product1::Factory1', 'Product1::Factory1 type';
my $p2 = Product2->new(color=>'green');
is ref $p2, 'Product2', 'Product2 type';
my $p3 = Product3->new(color=>'white');
is ref $p3, 'Product3', 'Product3 type';
is $p3->{color}, 'white', 'p3 color = white';

is $p1->isValidProduct('Product1'), 1, 'product1 is validProduct';
is $p1->isValidProduct('Product11'), 0, 'product11 is not validProduct';
is $p1->isValidProduct(), 0, 'null is not validProduct';
is $p1->focus(), 'Product1::Products::focus', 'Product1 focus';
is $p2->un_focus(), 'Product2::Products::un_focus', 'Product2 un_focus';

my $p21 = $f2->make_product(product=>'Product2');
like $p21->focus, qr/\|focus/,'p21 focus';
my $of1_prod = $f1->make_product(product=>'Product1');
is ref $of1_prod,'Product1::Factory1','got valid Product1::Factory1';
my $of2_prod = $f2->make_product(product=>'Product2', size=>'XX');
is $of2_prod->{size},'XX','got of2 size';
is ref $of2_prod,'Product2::Factory2','got valid Product2';
dies_ok {$f2->make_product(product=>'Product3')} 'dies on invalid product';
like $@, qr/invalid product/, 'got right msg for invalid product';

print "\nEnd of tests\n";
$DB::single = 1; 
$DB::single = 1; 
done_testing;

