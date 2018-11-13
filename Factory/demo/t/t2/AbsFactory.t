#! /usr/bin/env perl

use lib qw(. .. lib );
use Test::Most;
use strict; use warnings;

my $class = 'AbsFactory';
use_ok($class) or die ("could not open $class");
can_ok( 'BigFactory', 'new' ); 
my $oBigFactory = BigFactory->new();
is Products->isValidProduct('Button'),1, 'Button is valid';
is Products->isValidProduct('button'),0, 'button is invalid';
is Products->isValidProduct(), 0, 'undef is invalid';

can_ok( 'LinuxButton', 'new' ); 
my $oLxButton = LinuxButton->new();
is $oLxButton->focus,'LinuxButton::focus()','got LinuxButton focus';
is ref $oLxButton,'LinuxButton','got LinuxButton type';
my $oLxButton2 = LinuxButton->new(color=>"red");
is $oLxButton2->{color}, "red", 'got Linux red button';

my $oLxFactory = $oBigFactory->getFactory(factory=>'Linux');
is ref $oLxFactory,'LinuxFactory','got LinuxFactory type';
dies_ok {$oBigFactory->getFactory(factory=>'sfvsdLinux')} 'bigfactory typo';
like $@, qr/Unsupported factory:/, 'verify die message';
dies_ok {$oBigFactory->getFactory()} 'empty parms bigfactory';
like $@, qr/no factory/, 'verify die message';
my $cStr = $oLxFactory->get_product_list;
like $cStr, qr/^LinuxButton/, 'got first linuxButton';
like $cStr, qr/LinuxButton$/, 'got last linuxButton';
$oLxFactory->add_product('Textbox', color=>'red');
like $oLxFactory->get_product_list, qr/LinuxTextbox$/, 'got last linuxTextbox';

#my $o1 = Point->new(1,2);

print "End of tests\n";
$DB::single = 1; 
$DB::single = 1; 
done_testing;
