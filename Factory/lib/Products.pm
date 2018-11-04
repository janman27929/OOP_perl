use strict; use warnings;

package Products {
  use base 'List';

  # update this list for valid products
  my @aProducts = qw(Button Scrollbar Textbox Wooget Widget);

  #sub get_product    {$_[0]->[$1]};
  sub get_products   {
    my $self = shift;
    return sort @aProducts;
  }  

  sub isValidProduct   {
    my ($self, $cName) = @_;
    return (grep {$_ =~ /$cName/} @aProducts) ? 1 : 0;
  }  

  sub make_product { 
    my $self = shift;
    my ($cFactory, $cProduct) = @_;
    return unless $self->isValidProduct($cProduct);
    die ("FAIL: no factory\n") unless AbstractFactory->isValidFactory($cFactory);
    my $cFqdn = $cFactory . $cProduct; 
    die ("FAIL: no class for $cFqdn\n") unless $cFqdn->can('new');
    my $oNew = $cFqdn->new(@_);
    return $oNew; 
  } 

  sub add_product { shift->insert_product(@_) }    

  sub insert_product {
    my ($self, $factory, $raProducts, $cProduct, $nPos)  = @_;
    my $oProduct = $self->make_product($factory, $cProduct);
    $self->add_item ($raProducts, $oProduct, $nPos); 
  }

  sub num_products {
    my ($self)  = @_;
    return scalar @{$self->{products}};
  }

  sub delete_product {
    my ($self, $raData, $nPos)  = @_;
    $self->delete_item($raData, $nPos);
  }

  sub update_product {
    my $self = shift; 
    my ($raData, $nPos, $oProd)  = @_;
    $self->update_item($raData, $nPos, $oProd);
  }
  
}  
1;
