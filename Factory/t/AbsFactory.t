use lib qw(. .. lib );
use Test::Most;
use strict; use warnings;

my $class = 'AbsFactory';
use_ok($class) or die ("could not open $class");
can_ok( 'BigFactory', 'new' ); 
my $oBigFactory = BigFactory->new();
my $o1 = $oBigFactory->getFactory( factory=>'Linux');
my $w1 = $oBigFactory->getFactory( factory=>'Windows');
my $m1 = $oBigFactory->getFactory( factory=>'Mac');

# verify object type
is ref $o1, 'LinuxFactory','get BigFactory ref';
#test edge conditions
dies_ok {$oBigFactory->getFactory()} 'dies BigFactory no Parms';
dies_ok {$oBigFactory->getFactory(asdas => 123)} 'dies BigFactory no/wrong Factory Parm';
dies_ok {$oBigFactory->getFactory(factory => 123)} 'dies BigFactory unsupported Factory Parm';

is  $w1->{products}[0]->focus, 'WindowsButton::focus()', 'for Windows button focus';
is  $o1->{products}[0]->focus, 'LinuxButton::focus()', 'for Linux button focus';
is  $m1->{products}[0]->focus, 'MacButton::focus()', 'for Mac button focus';

is $o1->num_products, 5, 'got 5 products for linux';
$o1->delete_product(1);
is $o1->num_products, 4, 'got 4 products after delete for linux';
$o1->add_product('Textbox');
is $o1->num_products, 5, 'got 5 products for linux';
is ref $o1->get_product(-1), 'LinuxTextbox', 'verified last product added'; 
$o1->update_product(-1, $o1->make_product('Widget'));
is ref $o1->get_product(-1), 'LinuxWidget', 'verified last product updated is a Widget'; 
is $o1->num_products, 5, 'got 5 products for linux';
dies_ok {$m1->add_product('Wooget')} 'dies on adding Wooget to Mac';
dies_ok {$m1->delete_product('Wooget')} 'dies on deleting Wooget to Mac';
like $@, qr#FAIL: bad nPos#,'confirm: dies on deleting Wooget to Mac';
my $oMacWidget = $m1->make_product('Widget');
is ref $oMacWidget, 'MacWidget', 'got MacWidget from make_product';
$DB::single = 1; 
$DB::single = 1; 
done_testing;


=cut


