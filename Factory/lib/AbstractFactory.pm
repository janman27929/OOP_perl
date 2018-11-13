use strict; 
use warnings;

package abFactory {
sub valid_products  {wantarray ? @{$_[0]->{valid_products}} : $_[0]->{valid_products}}  
sub factory         {$_->{factory}} 

sub isValidProduct  { (grep {/^$_[1]$/} $_[0]->valid_products) ? 1 : 0} 

sub add_valid_product {
  my $self = shift;
  die ("FAIL: no product \n") unless my $product = shift;
  push @{$self->valid_products}, $product;
}

sub make_product {
  my $self  = shift;
  my %hParms = @_;
  die ("FAIL: no product parm\n") unless my $product = $hParms{product};
  delete $hParms{product};
  die ("FAIL: invalid product\n") unless $self->isValidProduct($product);
  my $cFactoryType = ref $self;
  my $cType = $product .'::'. $cFactoryType;
  if ($cType->can('new')) {
    return $cType->new(%hParms);
  } elsif ($product->can('new')) {
    return $product->new(%hParms);
  } else {
    die ("FAIL: canot create product:$product:\n");
  }
}

sub build {
  my $class  = shift;
  my %hParms = @_;
  die ("FAIL: no factory parm\n") unless $hParms{factory};
  die ("FAIL: no valid_products parm\n") unless $hParms{valid_products};
  my $self  = bless{
    %hParms,
  }, $class;
  $self;
}
}#-- abFactory


package Factory1 {
  use base 'abFactory';
  my @aValidProducts = qw(Product1 Product1::Factory1 Product2 );

  sub new { shift->build( valid_products=>\@aValidProducts, factory=>__PACKAGE__, @_) }  
}

package Factory2 {
  use base 'abFactory';
  my @aValidProducts = qw(Product1 Product2 );

  sub new { shift->build( valid_products=>\@aValidProducts, factory=>__PACKAGE__, @_) }  
}

package Factory3 {
  use base 'abFactory';
  my @aValidProducts = qw(Product1 Product2 Product3);

  sub new { shift->build( valid_products=>\@aValidProducts, factory=>__PACKAGE__, @_) }  
}

package Products {
  my @aProducts = qw(Product1 Product2 Product3);

  sub product {$_[0]->{product}}

  sub isValidProduct {
    my ($self, $product) = @_;
    return 0 unless $product;
    (grep {/^$product$/} @aProducts) ? 1 :0;
  }

  sub focus { (ref $_[0]).'::'. __PACKAGE__ . '::focus'}
  sub un_focus { (ref $_[0]).'::'. __PACKAGE__ . '::un_focus'}

  sub new { my $class = shift; bless {@_}, $class}
}

package Product1 { use base 'Products' }
package Product1::Factory1 { use base 'Product1'}
package Product2 { use base 'Products' }
package Product2::Factory2 { 
  use base 'Product2';
  sub focus { 
    my $cRtn = (ref $_[0]).'|'. __PACKAGE__ . '|focus'. "\n";
    $cRtn .= $_[0]->SUPER::focus;
    $cRtn;    
  }
}
package Product3 { use base 'Products' }



1;
