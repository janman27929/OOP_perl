#! /usr/bin/env perl

use lib qw(. .. lib );
use Test::Most 'no_plan';
use Data::Dump;
use strict; use warnings;

sub whoami {
  my @ajjs = ( caller(2) )[2,3];
  return wantarray ? @ajjs : \@ajjs;
}

sub getCurrSubName {
	my $cFullPath = (caller(1))[3];
	my ($cSub) = $cFullPath =~ /::(\S+)$/;
	return $cSub;
}


my $class = 'AbstractFactory';
use_ok($class) or die ("could not open $class");
can_ok( 'BigFactory', 'new' ); 
my $oBig = BigFactory->new(factory=>'Linux');
is ref $oBig, 'BigFactory', 'got BigFactory type';
my $oLx = $oBig->getFactory(factory=>'Linux', title=>'My Linux');
is ref $oLx, 'LinuxFactory', 'got LinuxFactory type';
is $oLx->{title}, 'My Linux', 'got Linux Title';
is ref (my $oWin = $oBig->getFactory(factory=>'Windows', title=>'My Windows')), 
  'WindowsFactory', 'got Windows ref'; 
is ref (my $oMac = $oBig->getFactory(factory=>'Mac', title=>'My Mac')), 
  'MacFactory', 'got myMac ref'; 
is $oWin->{title}, 'My Windows', 'got Windows Title';
is $oMac->{title}, 'My Mac', 'got Mac Title';

my $oLxButton = LinuxButton->new(color=>'blue', caption=>'My Caption');
is ref $oLxButton, 'LinuxButton', 'got LinuxButton type';
is $oLxButton->{color}, 'blue', 'got LinuxButton color';
is $oLxButton->{caption}, 'My Caption', 'got LinuxButton caption';
is $oLxButton->focus, 'LinuxButton::focus','got LinuxButton focus';

$oLx->add_product('Jingler');
is $oLx->has_product('Jingler'),1,' oLx has Jingler';
is $oLx->has_product('Jing'),1,' oLx has Jing';
is $oLx->has_product(),0,' oLx has_product fails on blank';
is $oMac->has_product('Jingler'),0,' oMac does not Jingler';
is $oMac->has_product('Button'),1,' oMac does have Button';


print "End of tests\n";
$DB::single = 1; 
$DB::single = 1; 
done_testing;

