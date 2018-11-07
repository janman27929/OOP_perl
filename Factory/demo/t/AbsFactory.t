use lib qw(. .. lib );
use Test::Most;
use strict; use warnings;

my $class = 'AbsFactory';
use_ok($class) or die ("could not open $class");
can_ok( 'BigFactory', 'new' ); 
my $oBigFactory = BigFactory->new();


my $oMacFactory = $oBigFactory->getFactory(factory=>"Mac");
my $oWinFactory = $oBigFactory->getFactory(factory=>"Windows");
my $oLxFactory = $oBigFactory->getFactory(factory=>"Linux");
my $oAnFactory = $oBigFactory->getFactory(factory=>"Android");
is ref $oLxFactory, 'LinuxFactory','got linux factory';
is ref $oWinFactory, 'WindowsFactory','got Windows factory';
is ref $oMacFactory, 'MacFactory','got Mac factory';
is ref $oAnFactory, 'AndroidFactory','got Android factory';
is $oLxFactory->get_product(0)->focus, 'LinuxButton::focus()', 'Linux focus()';
is $oMacFactory->get_product(0)->focus, 'MacButton::focus()', 'Mac focus()';
is $oWinFactory->get_product(0)->focus, 'WindowsButton::focus()', 'Windows focus()';

is $oLxFactory->num_products, 5, 'got 5 products for linux';
$oLxFactory->delete_product(1);
is $oLxFactory->num_products, 4, 'got 4 products after delete for linux';
$oLxFactory->add_product('Textbox');
is $oLxFactory->num_products, 5, 'got 5 products for linux';
$oLxFactory->insert_product('Widget',1);
is ref $oLxFactory->get_product(1), 'LinuxWidget', 'verified product [1] is a Widget'; 
is $oLxFactory->num_products, 6, 'got 6 products for linux';
is ref $oLxFactory->get_product(-1), 'LinuxTextbox', 'verified last product added'; 
$oLxFactory->update_product(-1, $oLxFactory->make_product('Widget'));
is ref $oLxFactory->get_product(-1), 'LinuxWidget', 'verified last product updated is a Widget'; 
is $oLxFactory->num_products, 6, 'still have 6 products for linux';
dies_ok {$oMacFactory->add_product('Wooget')} 'dies on adding Wooget to Mac';
dies_ok {$oMacFactory->delete_product('Wooget')} 'dies on deleting Wooget to Mac';
like $@, qr#FAIL: bad nPos#,'confirm: dies on deleting Wooget to Mac';
my $oMacWidget = $oMacFactory->make_product('Widget');
is ref $oMacWidget, 'MacWidget', 'got MacWidget from make_product';

print "End of tests\n";
$DB::single = 1; 
$DB::single = 1; 
done_testing;
