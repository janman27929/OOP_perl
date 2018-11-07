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

package BigFactory {
  use base 'AbstractFactory';
  sub new {my $class = shift; bless {@_},$class};
}

package CommonFactory  { 

  sub products      { shift->{products} }
  sub factory       { shift->{factory}  }

  sub get_product   { $_[0]->products->[$_[1]] }    
  sub get_products  { shift->products }    
 
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
    die ("FAIL: invalid product") unless Products->isValidProduct($cProduct);
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
      products => [],
    }, $class;
    $self->add_products($raProducts); 
    return $self;
  }

  sub num_products { return scalar @{$_[0]->{products}}}
}

package LinuxFactory  { 
  use base 'CommonFactory';
  my $factory = 'Linux';
  my @aProducts = qw(Button Textbox Widget Scrollbar Button );
  
  sub new {$_[0]->SUPER::new($factory, \@aProducts)}  
}

package WindowsFactory {
  use base 'CommonFactory';
  my $factory = 'Windows';
  my @aProducts = qw(Button Jingler);
  sub new {$_[0]->SUPER::new($factory, \@aProducts)}  
}

package MacFactory {
  use base 'CommonFactory';
  my $factory = 'Mac';
  my @aProducts = qw(Button CashMachine);
  sub new {$_[0]->SUPER::new($factory, \@aProducts)}  
}

package AndroidFactory {
  use base 'CommonFactory';
  my $factory = 'Android';
  my @aProducts = qw(Button Jingler);
  sub new {$_[0]->SUPER::new($factory, \@aProducts)}  
}

package Products  { 
  my @aProducts = qw(Button Scrollbar Textbox Wooget Widget Jingler CashMachine);

  sub isValidProduct   {
    my ($self, $cName) = @_;
    return (grep {$_ =~ /$cName/} @aProducts) ? 1 : 0;
  }  

}

package AbstractButton {
  use base 'Products';
  sub blur          { (ref $_[0]) ."::blur()"}
  sub click         { (ref $_[0]) ."::click()"}
  sub focus         { (ref $_[0]) ."::focus()"}
  sub unfocus       { (ref $_[0]) ."::unfocus()"}
  sub handleEvent   { (ref $_[0]) ."::handleEvent()"}
}

package LinuxButton {
  use base 'AbstractButton';
  sub new { my $class = shift; bless {@_}, $class }
}

package WindowsButton {
  use base 'AbstractButton';
  sub new {my $class = shift; bless {@_},$class};
}

package AndroidButton {
  use base 'AbstractButton';
  sub new {my $class = shift; bless {@_},$class};
}

package MacButton {
  use base 'AbstractButton';
  sub new {my $class = shift; bless {@_},$class};
}
#-------------
package AbstractWooget {
  sub blur          { (ref $_[0]) ."::blur()"}
  sub click         { (ref $_[0]) ."::click()"}
  sub focus         { ("this is " . ref $_[0]) ."::focus()"}
  sub unfocus       { (ref $_[0]) ."::unfocus()"}  
}

package AndroidWooget {
  use base 'AbstractWooget';
  sub new     { my $class= shift; bless{@_}, $class};
}

#-------------
package AbstractWidget {
  sub blur          { (ref $_[0]) ."::blur()"}
  sub click         { (ref $_[0]) ."::click()"}
  sub focus         { (ref $_[0]) ."::focus()"}
  sub unfocus       { (ref $_[0]) ."::unfocus()"}  

  sub new     {  my $class= shift; bless{@_}, $class};
}

package AndroidWidget { use base 'AbstractWidget'}
package LinuxWidget   { use base 'AbstractWidget'}
package MacWidget     { use base 'AbstractWidget'}
#-------------

package AbstractTextbox {
  sub focus     { (ref $_[0]) ."::focus()";}
  sub create    { (ref $_[0]) ."::create()";}
  sub update    { (ref $_[0]) ."::update()";}
  sub delete    { (ref $_[0]) ."::delete()";}
}

package LinuxTextbox {
  use base "AbstractTextbox";
  sub new     { my $class= shift; bless{}, $class};
}
package WindowsTextbox {
  use base "AbstractTextbox";
  sub new     { my $class= shift; bless{}, $class};
}

package MacTextbox {
  use base "AbstractTextbox";
  sub new     { my $class= shift; bless{}, $class};
}

1;
#-------------
package AbstractScrollbar {
  sub top     { (ref $_[0]) ."::top()";}
  sub bottom  { (ref $_[0]) ."::bottom()";} 
  sub pgUp    { (ref $_[0]) ."::pgUp()";}
  sub pgDn    { (ref $_[0]) ."::pgDn()";}
}

package LinuxScrollbar {
  use base "AbstractScrollbar";
  sub new     { my $class= shift; bless{}, $class};
}

package WindowsScrollbar {
  use base "AbstractScrollbar";
  sub new     { my $class= shift; bless{}, $class};
}

package MacScrollbar {
  use base "AbstractScrollbar";
  sub new     { my $class= shift; bless{}, $class};
}

package AndroidScrollbar {
  use base "AbstractScrollbar";
  sub new     { my $class= shift; bless{}, $class};
}

#-------------
package AbstractJingler {
  sub top     { (ref $_[0]) ."::top()";}
  sub bottom  { (ref $_[0]) ."::bottom()";}
  sub pgUp    { (ref $_[0]) ."::pgUp()";}
  sub pgDn    { (ref $_[0]) ."::pgDn()";}
}

package WindowsJingler {
  use base "AbstractJingler";
  sub new     { my $class= shift; bless{}, $class};
}

package AndroidJingler {
  use base "AbstractJingler";
  sub new     { my $class= shift; bless{}, $class};
}


#-------------
package AbstractCashMachine {
  sub top     { (ref $_[0]) ."::top()";}
  sub bottom  { (ref $_[0]) ."::bottom()";}
  sub pgUp    { (ref $_[0]) ."::pgUp()";}
  sub pgDn    { (ref $_[0]) ."::pgDn()";}
  sub focus   { (ref $_[0]) ."::focus()";}
}

package MacCashMachine {
  use base "AbstractCashMachine";
  sub new     { my $class= shift; bless{}, $class};
}

1;



