use strict;
use warnings;

package Stock {

sub new  { 
  my $class=shift; 
  bless {
    stock     => shift,
    quantity  => shift,
  }, $class
}

sub stock     { defined $_[1] ? $_[0]->{stock} = $_[1]    : $_[0]->{stock}}
sub quantity  { defined $_[1] ? $_[0]->{quantity} = $_[1] : $_[0]->{quantity}}

sub buy {
  my ($self, )  = @_;
  printf "Buy  Stock: %s Quantity: %s\n", $self->{stock}, $self->{quantity};
}

sub sell {
  my ($self, )  = @_;
  printf "Sell Stock: %s Quantity: %s\n", $self->{stock}, $self->{quantity};
}

}

package BuyStock {
our @ISA=qw(Stock);
sub execute { $_[0]->buy()}
}

package SellStock {
our @ISA=qw(Stock);
sub execute { $_[0]->sell()}
}

package Broker {
sub new { 
  my $class= shift;
  bless {orderList => []}, $class;        
}

sub takeOrder {
  my ($self, $order) = @_;
  push @{$self->{orderList}}, $order;
}

sub placeOrders(){
  my ($self) = @_;
  for (@{$self->{orderList}}) {
    $_->execute();
  }  
  $self->{orderList} = [];
}

}
#---------------------[ main ]---------------------
my $broker = new Broker();
my $cOrders =<<'EOF';
buy, abc, 10
sell, def, 100
buy, abc, 30
buy1, abc, 30
sell, ghi, 11
1sell, ghi, 11
junk, ghi, 11
EOF

sub getRecs {split("\n", $_[0])}

for (getRecs($cOrders)) {
  my @aTmp = split (/\s*,\s*/);
  if ($aTmp[0] =~ /^buy$/i) {
    $broker->takeOrder(BuyStock->new(@aTmp[1,2]));
  } elsif ($aTmp[0] =~ /^sell$/i) {
    $broker->takeOrder(SellStock->new(@aTmp[1,2]));
  } else {
    warn ("Unsupported rec:$_:");
  }
}

$broker->placeOrders();

