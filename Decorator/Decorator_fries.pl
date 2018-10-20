use strict;
use warnings;
use Test::Most;

package Order {
sub new  { 
  my $class=shift; 
  bless {}, $class;
}

sub prn_receipt {
  my $self = shift;
  _prnHdr();
  _prnBody();
  _prnFooter();
}


sub get_total {
  my $self = shift;
  my $nTotal = get_total($self->{order}) if $self->{order};
  if (exists $self->{qty} and exists $self->{unit_cost}) {
    $nTotal += ($self->{qty} * $self->{unit_cost});
    $nTotal *= (1 + $self->{fed_tax})   if $self->{fed_tax};
    $nTotal *= (1 + $self->{state_tax}) if $self->{state_tax};
    $nTotal *= (1 + $self->{city_tax})  if $self->{city_tax};
  }

  return sprintf "%0.2f", $nTotal if defined $nTotal;
}

}

package Decorator {
our @ISA = qw(Order);
sub new  { 
  my $class = shift; 
  my %hParms = @_;
  my $self  = bless {
    order     => $hParms{order},
    qty       => $hParms{qty},
    unit_cost => $hParms{unit_cost},
    fed_tax   => $hParms{fed_tax},
    state_tax => $hParms{state_tax},
    city_tax  => $hParms{city_tax},
  }, $class;
  $self;
}
}

package Hamburger {
our @ISA = qw(Decorator);
my $nCost = 3;
my $nFed = 0;
my $nState = .0325;
my $nCity = .11;

sub new  { 
  my $class=shift; 
  $nCost ||= shift;
  $class->SUPER::new(@_,
    unit_cost => $nCost, 
    fed_tax    => $nFed, 
    state_tax  => $nState, 
    city_tax   => $nCity,
  );
}

sub get_cost {$nCost}
}

package Hamburger::DoublePatty {
our @ISA = qw(Hamburger);
my $nCost = 1.75;

sub new  { 
  my $class=shift; 
  $nCost += $class->SUPER::get_cost();
  my $self = $class->SUPER::new(unit_cost =>$nCost, @_);
  $self;
}
}

package Hamburger::Cheese {
our @ISA = qw(Hamburger);
my $nCost = .75;
sub new  { 
  my $class=shift; 
  $nCost += $class->SUPER::get_cost();
  $DB::single = 1; 
  $class->SUPER::new(unit_cost =>$nCost, @_);
}

}
package Fries {
our @ISA = qw(Decorator);
my $nCost = 1;
my $nFed = 0.03;
my $nState = .0325;
my $nCity = .15;

sub new  { 
  my $class=shift; 
  $class->SUPER::new(@_,
    unit_cost => $nCost, 
    fed_tax    => $nFed, 
    state_tax  => $nState, 
    city_tax   => $nCity,
  );
}

}
package Fries::SuperSize {
our @ISA = qw(Fries);
my $nCost = 1.75;

sub new  { 
  my $class=shift; 
  $class->SUPER::new(cost=>$nCost, @_);
}
}

package Pepsi {
our @ISA = qw(Decorator);
my $nCost = 2;
my $nFed = 0.03;
my $nState = .0325;
my $nCity = .15;

sub new  { 
  my $class = shift; 
  my %hParms = @_;
  $class->SUPER::new(
    unit_cost   => $nCost, 
    fed_tax     => $nFed, 
    state_tax   => $nState, 
    city_tax    => $nCity,
    %hParms,
  );
}
}

package Pepsi::SuperSize {
our @ISA = qw(Pepsi);
my $nCost = 2.75;
sub new  { 
  my $class= shift; 
  $class->SUPER::new(unit_cost =>$nCost, @_);
}
}

my $cOrders = << 'EOF';
id,product,qty
1234,Pepsi,1
1234,Pepsi,1
1234,Chip,1
1234,Chip,1
1235,Pepsi,1
1235,Hamburger::Cheese,1
1235,Fries::SuperSize,1
1236,Fries::Bogus::SuperSize,1
1236,,1
1235,Fries::SuperSize,
EOF

my $o1 = Order->new();
is ref $o1, 'Order', 'passed Order check';
$o1 = Hamburger->new(order=>$o1,  qty=>3);
is ref $o1, 'Hamburger', 'passed hamburger add';
is ref $o1->{order}, 'Order', 'passed Order check 2';
$o1 = Hamburger::Cheese->new(order=>$o1,  qty=>1);
is ref $o1, 'Hamburger::Cheese', 'passed Hamburger::Cheese add';
$o1 = Fries::SuperSize->new(order=>$o1, qty=>2);
$o1 = Pepsi::SuperSize->new(order=>$o1, qty=>3);
is ref $o1->{order}{order}{order}, "Hamburger", "Hamburger as core order";
my $nTotal = $o1->get_total();
is $nTotal, 35.89, 'correct get_total';
#my $cReceipt = $o1->prn_receipt();
$DB::single = 1; 
$DB::single = 1; 
done_testing();

