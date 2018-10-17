
package Factory{
my @aTypes = qw(Toyota Chev Ford Mazda);

sub getTypes {wantarray ? @aTypes : \@aTypes}

sub getProducts {
  my $self = shift;
  my $cBase = shift;
  my $raProducts;
  for (@aTypes) {
    next unless /::$/;
    my $cProduct = $cBase.$_;
    print join(":",$cBase,$cProduct), "\n";
    push @$raProducts, $cProduct;
    $raProducts = $self->getProducts($cProduct);
  }
  return $raProducts;
}

sub new  { 
  my $class=shift; 
  my %hParms = @_;
  my $cClass = sprintf "%s::%s::%s", $hParms{brand}, $hParms{type}, $hParms{model};
  for (qw(brand type model)) {
    delete $hParms{$_};
  }
  return $cClass->new(%hParms);
}
  
}

package Toyota {
our @ISA=qw(Factory);

my @aTypes = qw(Car Truck SUV Van);

sub getTypes {wantarray ? @aTypes : \@aTypes}

sub new  { 
  my $class=shift; 
  bless {@_}, $class;
}
}

package Toyota::Seats     { 
our @ISA=qw(Toyota); 

sub cheapVinyl {''}
}


package Toyota::Car     { 
our @ISA=qw(Toyota); 
my @aTypes = qw(Camry Prius Corrola);

sub getTypes {wantarray ? @aTypes : \@aTypes}
}
package Toyota::Truck   { our @ISA=qw(Toyota) }
package Toyota::SUV     { our @ISA=qw(Toyota) }
package Toyota::Van     { our @ISA=qw(Toyota) }

package Toyota::Car::Camry    { our @ISA=qw(Toyota::Car) }
package Toyota::Car::Prius    { our @ISA=qw(Toyota::Car) }
package Toyota::Car::Corrola  { our @ISA=qw(Toyota::Car) }


$DB::single = 1; 
my $cProducts = Factory::getProducts();
my $car1=Toyota::Car::Prius->new(
  brand   => 'Toyota',
  model   => 'Camry',
  engine  => '4cyl',
  color   => 'red',
);
my $o1=Factory->new(
  brand   => 'Toyota',
  type    => 'Car',
  model   => 'Camry',
  engine  => '4cyl',
  color   => 'red',
);
$DB::single = 1; 
$DB::single = 1; 

