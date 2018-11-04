use strict; use warnings;

package AbstractFactory {
  my %factories = (
    Linux   => sub {LinuxFactory->new(@_)},
    Windows => sub {WindowsFactory->new(@_)},
    Mac     => sub {MacFactory->new(@_)},
    Android => sub {AndroidFactory->new(@_)},
  );

  sub getFactory {
    my $self = shift;
    my %hParms = @_;
    die ("FAIL: no factory\n") unless $hParms{factory}; 
    die ("FAIL: unsupported factory: $hParms{factory}:\n") unless my $rcFactory = $factories{$hParms{factory}}; 
    $rcFactory->(@_);
  }

  sub getFactories {
    return sort keys %factories;
  }
  
  sub isValidFactory {
    my ($self, $factory) = @_;
    (grep {$_ =~ /$factory/} keys %factories) ? 1 : 0;
  }
}

# this will be the concrete class for AbstractFactory 
package BigFactory  { 
  use base "AbstractFactory";
  sub new {my $class = shift; bless {@_},$class};
}

# these are "products" of AbstractFactory
package CommonFactory  { 
  use base 'Products', 'AbstractFactory';

  sub make_products { 
    my ($self, $raProducts) = @_;
    my @aProducts;
    for (@$raProducts) {
      push @aProducts, $self->make_product($self->factory, $_);
    }
    return \@aProducts;
  }

  sub products      { shift->{products} }
  sub factory       { shift->{factory}  }
  sub get_product   { $_[0]->products->[$_[1]] }    
  sub get_products  { shift->products }    
  sub add_product   { shift->insert_product(@_) }    
  sub insert_product {
    my $self = shift;
    my ($cProd, $nPos)  = @_;
    Products->insert_product($self->factory, $self->products, @_);
  }    
  sub delete_product {
    my $self = shift;
    Products->delete_product($self->products, @_);
  }    

  sub new {
    my ($class, $factory, $raProducts) = @_;
    die ("FAIL: invalid factory\n") unless AbstractFactory->isValidFactory($factory);   
    my $self = bless {
      factory => $factory,
    }, $class;
    $self->{products} = $self->make_products($raProducts); 
    return $self;
  }
}

package LinuxFactory  { 
  use base 'CommonFactory';
  my $factory = 'Linux';
  my @aProducts = qw(Button Textbox Scrollbar Button Button);
  
  sub new {$_[0]->SUPER::new($factory, \@aProducts)}  
}

package AndroidFactory {
  use base 'CommonFactory';
  my $factory = 'Android';
  my @aProducts = qw(Button Scrollbar Widget Wooget);

  sub new {$_[0]->SUPER::new($factory, \@aProducts)}
}

package WindowsFactory {
  use base 'CommonFactory';
  my $factory = 'Windows';  
  my @aProducts = qw (Button Scrollbar Textbox);

  sub new {$_[0]->SUPER::new($factory, \@aProducts)}
}
  
package MacFactory {
  use base 'CommonFactory';
  my $factory = 'Mac';
  my @aProducts = qw(Button Scrollbar Textbox);

  sub new {$_[0]->SUPER::new($factory, \@aProducts)}
}
1;
