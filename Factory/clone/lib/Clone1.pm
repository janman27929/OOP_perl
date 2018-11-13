use strict; 
use warnings;

package abFactory {

sub valid_products  {wantarray ? @{$_[0]->{valid_products}} : $_[0]->{valid_products}}  
sub products  {wantarray ? @{$_[0]->{products}} : $_[0]->{products}}  
sub factory   {$_->{factory}} 

sub isValidProduct  { 
  (grep {/$_[1]/} $_[0]->valid_products) ? 1 : 0} 

sub add_valid_product {
  my $self = shift;
  die ("FAIL: no product \n") unless my $product = shift;
  push @{$self->valid_products}, $product;
}

sub add_product {
  my $self = shift;
  my %hParms = @_;

  my $add_base_prod = ($hParms{add_base_prod} or 0);
  delete $hParms{add_base_prod};
  die ("FAIL: no product\n") unless my $cProduct = $hParms{product};

  $self->add_valid_product($hParms{product}) if ($add_base_prod == 1);
  die ("FAIL: invalid product:$cProduct:\n") unless $self->isValidProduct($cProduct);
  my $oProduct = $cProduct->new(%hParms);
  push @{$self->products}, $oProduct;
}

sub build {
  my $class  = shift;
  my %hParms = @_;
  die ("FAIL: no factory parm\n") unless $hParms{factory};
  die ("FAIL: no valid_products parm\n") unless $hParms{valid_products};
  my $self  = bless{
    products  => [],
    %hParms,
  }, $class;
  $self;
}
}

package Factory1 {
  use base 'abFactory';
  my @aValidProducts = qw(Product1 Product2 Product3);

  sub new { shift->build( valid_products=>\@aValidProducts, factory=>'Factory1', @_) }  
}

package Factory2 {
  use base 'abFactory';
  my @aValidProducts = qw(Product1 Product2 );

  sub new { shift->build( valid_products=>\@aValidProducts, factory=>'Factory2', @_) }  
}

package Factory3 {
  use base 'abFactory';
  my @aValidProducts = qw(Product1 Product3 );

  sub new { shift->build( valid_products=>\@aValidProducts, factory=>'Factory3', @_) }  
}

package Products { 
  our  @aProducts = qw(Product1 Product2 Product3);

  sub product {$_[0]->{product}}
  sub new {my $class=shift; bless{@_}, $class}

  sub add_product {
    my ($self, $product, $rc) = @_;
    die ("FAIL: $product exists\n") if $self->isValidProduct($product);
  }

  sub focus { (ref $_[0]).'::'. __PACKAGE__ . '::focus'}

  sub isValidProduct {
    my ($self, $product) = @_;
    (grep {/$product/} @aProducts) ? 1 :0;
  }
}

package Product1 {
  use base 'Products'; 
  my $cProduct = 'Product1';

  sub new { my $class = shift; $class->SUPER::new( product => $cProduct, @_)}
}

package Factory1_Product1 {
  use base 'Product1'; 
  my $cProduct = 'Factory1_Product1';

  sub focus { 
    my ($self) = @_;
    my $cStr = $self->SUPER::focus()."\n";
    $cStr .= __PACKAGE__ .'::focus2'."\n";
    return $cStr;
  }

  sub new { my $class = shift; $class->SUPER::new( product => $cProduct, @_)}
}


package Product2 {
  use base 'Products';
  my $cProduct = 'Product2';

  sub new { my $class = shift; $class->SUPER::new( product => $cProduct, @_)}
}

package Factory2_Product2 {
  use base 'Product2'; 
  my $cProduct = 'Factory2_Product2';

  sub focus { 
    my ($self) = @_;
    my $cStr = $self->SUPER::focus()."\n";
    $cStr .= __PACKAGE__ .'::focus2'."\n";
    return $cStr;
  }

  sub new { my $class = shift; $class->SUPER::new( product => $cProduct, @_)}
}



package Product3 {
  use base 'Products';
  my $cProduct = 'Product3';

  sub new { my $class = shift; $class->SUPER::new( product => $cProduct, @_)}
}

1;
