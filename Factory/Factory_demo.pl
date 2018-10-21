#---------------------[ GLOBAL ]---------------------
use strict; use warnings;
use lib qw(. .. lib);
use Factory; 


#---------------------[ main ]---------------------
my $oShapeFactory = ShapeFactory->new();
for ($oShapeFactory->getShapeNames()) {
  my $oShape = $oShapeFactory->getShape($_);
  for my $cAction ($oShape->getActions()) {
    $oShape->$cAction();
  }
  print "\n"; 
}
$DB::single = 1; 
$DB::single = 1; 


