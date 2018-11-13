use strict; use warnings;

package FactoryAdmin {
  my %hDispatch = (
    Linux   => sub {LinuxFactory->new(@_)},
    Windows => sub {WindowsFactory->new(@_)},
    Mac     => sub {MacFactory->new(@_)},
  );
  
  sub getFactory {
    my $self = shift;
    my %hParms = @_;
    die ("FAIL: no factory\n") unless my $factory = $hParms{factory};
    die ("FAIL: Unsupported factory:$factory:\n") unless my $rc = $hDispatch{$factory};
    $rc->(@_);
  }

  sub getFactories {
    return sort keys %hDispatch;
  }
  
  sub isValidFactory {
    my ($self, $factory) = @_;
    (grep {$_ =~ /$factory/} keys %hDispatch) ? 1 : 0;
  }
}

package BigFactory {
  use base 'FactoryAdmin';
  sub new {my $class = shift; bless {@_},$class}
}

package CommonFactory {

  sub products      { shift->{products} }
  sub factory       { shift->{factory}  }

  sub get_product   { $_[0]->products->[$_[1]] }    
  sub get_products  { wantarray ? @{shift->products} : shift->products }    

  sub has_product   { 
    my ($self, $product) = @_;
    return 0 unless $product;
    my @aTmp = 
      grep {/$product/} 
      @{$self->products};
    return @aTmp ? 1 : 0;
  }    

  sub get_product_list   { 
    my $self = shift;
    my $cList = '';    
    $cList .= (ref $_) ."\n" for ($self->get_products);
    return $cList;
  }    
 
  sub add_products { 
    my ($self, $raProducts) = @_;
    my @aProducts;
    for (@$raProducts) {
      $self->add_product($_);
    }
    return \@aProducts;
  }

  sub add_product { 
    my ($self, $cProduct) = @_;
    $self->insert_product($cProduct, $self->num_products);
  }

  sub insert_product { 
    my ($self, $cProduct, $nPos) = @_;
    splice (@{$self->products}, $nPos, 0, $self->make_product($cProduct));
  }

  sub make_product { 
    my ($self, $cProduct) = @_;
    die ("FAIL: invalid factory\n") unless FactoryAdmin->isValidFactory($self->factory);
    die ("FAIL: invalid product:$cProduct: for factory:$self->factory") unless Products->isValidProduct($cProduct);
    my $cFqdn = $self->factory . $cProduct; 
    die ("FAIL: no class for $cFqdn\n") unless $cFqdn->can('new');
    return $cFqdn->new();
  } 
  
  sub delete_product {
    my ($self, $nPos)  = @_;
    die ("FAIL: bad nPos\n") unless ($nPos 
      and $nPos =~ /^\d+$/ and $self->products->[$nPos]);
    my $oPrev = splice (@{$self->products}, $nPos, 1); 
  }    

  sub update_product {
    my ($self, $nPos, $oProduct)  = @_;
    die ("FAIL: bad nPos\n") unless ($nPos 
      and $nPos =~ /^-*\d+$/ and $self->products->[$nPos]);
    die ("FAIL: bad oProduct\n") unless ($oProduct and ref $oProduct);
    my $oPrev = splice (@{$self->products}, $nPos, 1, $oProduct); 
  }    

  sub new {
    my ($class, $factory, $raProducts) = @_;
    die ("FAIL: invalid factory\n") unless FactoryAdmin->isValidFactory($factory);   
    my $self = bless {
      factory => $factory,
      products => [],
      @_,
    }, $class;
    $self->add_products($raProducts); 
    return $self;
  }

  sub num_products { return scalar @{$_[0]->{products}}}
}

package LinuxFactory  { 
  use base 'CommonFactory';
  my $factory = 'Linux';
  my @aProducts = qw(Button );
  
  sub new {$_[0]->SUPER::new($factory, \@aProducts, @_)}  
}

package WindowsFactory {
  use base 'CommonFactory';
  my $factory = 'Windows';
  my @aProducts = qw(Button Jingler);
  sub new {$_[0]->SUPER::new($factory, \@aProducts, @_)}  
}

package MacFactory {
  use base 'CommonFactory';
  my $factory = 'Mac';
  my @aProducts = qw(Button );
  sub new {$_[0]->SUPER::new($factory, \@aProducts, @_)}  
}

package Products {
  my @aProducts = qw(Button Jingler CashMachine);

  sub isValidProduct   {
    my ($self, $cName) = @_;
    return 0 unless $cName;
    return (grep {$_ =~ /$cName/} @aProducts) ? 1 : 0;
  } 
};

package Button      { 
  use base 'Products' ;
  sub focus { return (ref $_[0]).'::focus'  }
};

package Jingler     { use base 'Products' };
package CashMachine { use base 'Products' };

package LinuxButton   { use base 'Button' ;sub new {my $class = shift; bless {@_},$class}};
package WindowsButton { use base 'Button' ;sub new {my $class = shift; bless {@_},$class}};
package MacButton     { use base 'Button' ;sub new {my $class = shift; bless {@_},$class}};

package WindowsJingler { use base 'Jingler' ;sub new {my $class = shift; bless {@_},$class}};
package LinuxJingler { use base 'Jingler' ;sub new {my $class = shift; bless {@_},$class}};

1;
