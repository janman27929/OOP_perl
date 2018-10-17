

package Computer {
sub new  { 
  my $class=shift; 
  bless {}, $class
}
sub description {"Dude! Your getting a computer"}

sub get_parts {
  my $self = shift; 
  my $raParts = shift;
  push @$raParts, ref $self unless $raParts;
  if (my $cPart = ref $self->{computer}) {
    push @$raParts, $cPart;
    $self->{computer}->get_parts($raParts);
  }
  return $raParts;
}

}

package Decorator {
our @ISA = qw(Computer);
sub description {die ("Abstract method")}
sub new  { 
  my $class=shift; 
  my $self = bless {computer => shift}, $class;
  $self;
}
}

package Disk {
our @ISA = qw(Decorator);
sub description {
  my $self = shift;
  my $cMsg = $self->{computer}->description . " and a disk drive";
  print "$cMsg\n";
  return $cMsg
}
}

package CD {
our @ISA = qw(Decorator);
sub description {
  my $self = shift;
  my $cMsg = $self->{computer}->description . " and a CD";
  print "$cMsg\n";
  return $cMsg
}
}

package Monitor {
our @ISA = qw(Decorator);
sub description {
  my $self = shift;
  my $cMsg = $self->{computer}->description . " and a Monitor";
  print "$cMsg\n";
  return $cMsg;
}

}


my $o1 = Computer->new();
$o1 = Disk->new($o1);
$o1 = Monitor->new($o1);
$o1 = CD->new($o1);
my $cRtn = $o1->description();
my $rajjs = $o1->get_parts();
$DB::single = 1; 
$DB::single = 1; 

