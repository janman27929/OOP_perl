use strict;
use warnings;

package Factory::Data{

my %hEngines =(
);

my %hModels =( 
  prius   => [qw(Toyota Car)],
  corrola => [qw(Toyota Car)],
  camry   => [qw(Toyota Car)],
);

sub getModel {
  my ($self, $cModel)  = @_;
  return wantarray ? @{$hModels{_nmlz($cModel)}} :$hModels{_nmlz($cModel)}
}

sub setModel {
  my $self   = shift;
  my $cModel = shift;
  my %hParms = @_;
  die ("no model") unless defined $cModel;
  die ("no brand") unless defined $hParms{brand};
  die ("not type ") unless defined $hParms{type};
  return $hModels{_nmlz($cModel)} = [@hParms{qw(brand type)}];
}

sub delModel {
  delete $hModels{_nmlz($_[1])};
}

sub updateModel {setModel(@_)}
sub _nmlz {lc($_[0])}

} #----------[ Factory::Data ]-----------

package Factory{
my @aKeys = qw(brand type model);

sub getProducts {
}

sub new  { 
  my $class=shift; 
  my %hParms;
  my %hClass;
  @hClass{@aKeys} = split('::', $class);
  %hParms = (%hClass, @_);
  my $cDerivedClass = join ('::', @hParms{@aKeys});
  delete $hParms{$_} for (@aKeys);
  return bless {%hParms}, $cDerivedClass;
}

sub mk_vehicle  { 
  my $class=shift; 
  my %hParms = @_;
  my ($cBrand, $cType) = Factory::Data->getModel($hParms{model});
  my $cClass = join('::', $cBrand, $cType, $hParms{model};
  return $cClass->new(%hParms);
}
  
sub getModel    {shift; Factory::Data->getModel(@_)   }
sub addModel    {shift; Factory::Data->setModel(@_)   }
sub updateModel {shift; Factory::Data->updateModel(@_)}
sub delModel    {shift; Factory::Data->delModel(@_)   }
}

package Toyota { our @ISA=qw(Factory)}

package Toyota::Seats     { 
our @ISA=qw(Toyota); 

sub cheapVinyl {''}
}


package Ford                { our @ISA=qw(Factory) }
package Ford::Truck         { our @ISA=qw(Ford) }
package Ford::Truck::F150   { our @ISA=qw(Ford::Truck)}

package Toyota::Car         { our @ISA=qw(Toyota)}
package Toyota::Truck   { our @ISA=qw(Toyota) }
package Toyota::SUV     { our @ISA=qw(Toyota) }
package Toyota::Van     { our @ISA=qw(Toyota) }

package Toyota::Car::Camry    { our @ISA=qw(Toyota::Car) }
package Toyota::Car::Prius    { our @ISA=qw(Toyota::Car) }
package Toyota::Car::Corrola  { our @ISA=qw(Toyota::Car) }

my $o1=Toyota::Car::Prius->new(
  engine  => '4cyl',
  color   => 'red',
);
my $o2=Factory->new(
  brand   => 'Toyota',
  type    => 'Car',
  model   => 'Camry',
  engine  => '4cyl',
  color   => 'green',
);

my $o3=Factory->mk_vehicle(
  model   => 'Prius',
  engine  => '4cyl',
  color   => 'blue',
);

$DB::single = 1; 

Factory->addModel('F150', 'Ford', 'Car');
Factory->updateModel('F150', type => 'Truck');
$DB::single = 1; 
my $o4=Factory->mk_vehicle(
  model   => 'F150',
  engine  => '8-350',
  color   => 'green',
  seats   => 'denim',
  suspension => 'HD-3500',
);


$DB::single = 1; 
$DB::single = 1; 

