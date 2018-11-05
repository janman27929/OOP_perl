use strict; use warnings;
use Wooget;
use Textbox;
use Widget;
use Scrollbar;
use Button;
use Try::Tiny;

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
  #use base 'Products';

  my @aProducts = qw(Button Scrollbar Textbox Wooget Widget);
  sub isValidProduct   {
    my ($self, $cName) = @_;
    return (grep {$_ =~ /$cName/} @aProducts) ? 1 : 0;
  }  

  sub products      { shift->{products} }
  sub factory       { shift->{factory}  }
  sub get_product   { $_[0]->products->[$_[1]] }    
  sub get_products  { shift->products }    
  sub add_product   { shift->insert_product(@_) } 
  sub num_products {
    my ($self)  = @_;
    return scalar @{$self->{products}};
  }
  
  sub insert_product {
    my $self = shift;
    my ($cProd, $nPos)  = @_;
    $nPos ||= scalar @{$self->products};    
    splice (@{$self->products}, $nPos, 1, $self->make_product($cProd)); 
    $self;
  }    

  sub make_products { 
    my ($self, $raProducts) = @_;
    my @aProducts;
    for (@$raProducts) {
      push @aProducts, $self->make_product($_);
    }
    return \@aProducts;
  }

  sub make_product { 
    my ($self, $cProduct) = @_;
    die("FAIL: invalid product") unless $self->isValidProduct($cProduct);
    die ("FAIL: invalid factory\n") unless AbstractFactory->isValidFactory($self->factory);
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
  my @aProducts = qw(Button Textbox Widget Scrollbar Button);
  
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
