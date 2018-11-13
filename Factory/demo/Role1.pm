{
package Diags;
use Role::Tiny;

sub dDie {
  my ($cMsg, $xVal, $qr1) = @_;
  die ($cMsg) unless $xVal =~ $qr1;
}
}

{
package Tree;
use Role::Tiny;

sub type { $_[0]->{type} ||= "tree" }

sub pick {
  my ($self, )  = @_;
  print "Tree:Pick\n";
}

sub plant {
  my ($self, )  = @_;
  print "Tree:Plant\n";
}


}



{
package Eatable;
use Role::Tiny;

requires 'calories';

}

{
package Fruit;
use Role::Tiny;

sub colour { $_[0]->{colour} ||= "See-thru" }
}

{
package Banana;
use Role::Tiny::With;
use base 'Fruit';
with 'Eatable', 'Tree', 'Diags';

sub new  {my $class = shift;bless{@_}, $class}
sub quantity  { $_[0]->{quantity} ||= 1; dDie ("FAIL: not Int:\n",$_[0]->{quantity}, qr/^\d+$/); $_[0]->{quantity} }
sub paid      { $_[0]->{paid} ||= 30  }
sub calories {
  my ($self,@stuff) = @_;
  return 42;
}

}


$fruit = Banana->new(quantity => 3);
$cake = Banana->new(quantity => 3, paid => 47, colour => "Orange");

$qval = $fruit->quantity();
$pval = $fruit->paid();
$cval = $fruit->calories();
$clr = $fruit->colour();
$fruit->plant;
print "We bought $qval and paid $pval for them. $cval cals, $clr\n";

$qval = $cake->quantity();
$pval = $cake->paid();
$cval = $cake->calories();
$clr = $cake->colour();
print "We bought $qval and paid $pval for them. $cval cals, $clr\n";

__END__
