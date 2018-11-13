#! /usr/bin/env perl

use lib qw(. .. lib );
use Test::Most 'no_plan';
use Data::Dump;
use strict; use warnings;

my $class = 'AbstractFactory';
use_ok($class) or die ("could not open $class");
can_ok( 'Factory1', 'new' ); 
my $f1 = Factory1->new();
my $f2 = Factory2->new(title=>'F2 title');
is $f2->{title}, 'F2 title', 'got F2 title';
is_deeply [$f2->valid_products], [qw(Product1 Product2)],  'got F2 valid_products';

my $p1 = Product1->new();
my $p11 = Product1->new(color=>'red');
is $p1->product, 'Product1', 'got product add';
is $p11->{color}, 'red', 'got red';

$f1->add_product(product=>'Product1');
$f1->add_product(product=>'Factory1_Product1', add_base_prod=>1, color=>'blue');
$f1->add_product(product=>'Product1', color=>'green');
is $f1->products->[-1]->{color}, 'green', 'got green';
ok $f1->isValidProduct('Factory1_Product1'), 'got validProduct for Factory1_Product1';
dies_ok {$f1->add_product(product=>'Factory2_Product2')} 'adding product wo add_base_prod';
dies_ok {$f1->add_product(product=>'Factory11_Product1', add_base_prod=>1)}
   'adding bogus product with  add_base_prod';
like $f1->products->[1]->focus, qr/Factory1_Product1::focus2$/,'verify Factory1_Product1';

print "\nEnd of tests\n";
$DB::single = 1; 
$DB::single = 1; 
done_testing;

