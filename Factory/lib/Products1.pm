package AbstractProducts {
  my %hProducts;
  
sub addProduct {
  my $self = shift; 
  my ($cFactory, $cProduct, $rcProd)  = @_;
  return 0 if exists $hProducts{makeProductKey($cProduct, $cFactory)};
  $self->set(@_);
  return 1;
}

sub delProduct {
  my ($self, $cFactory, $cProduct, $rcProd)  = @_;
  die ("FAIL: no cProduct\n")  unless $cProduct =~ /^\S+$/;
  die ("FAIL: no cFactory\n")  unless $cFactory =~ /^\S+$/;
  return delete $hProducts{makeProductKey($cProduct, $cFactory)}; 
}

sub getProducts {
  my ($self, $cFactory)  = @_;
  my @aKeys = 
    map  {s/^$cFactory|//}
    grep {$_ =~ /^$cFactory|/}
    sort keys %hProducts;
  return @aKeys;
}

sub getProductKeys {
  my ($self, $cFactory)  = @_;
  my @aKeys = 
    map {s/^$cFactory|//}
    grep {$_ =~ /^$cFactory|/}
    sort keys %hProducts;
  return @aKeys;
}

sub getProduct {
  my ($self, $cFactory, $cProduct, $rcProd)  = @_;
  $hProducts{makeProductKey($cProduct, $cFactory)}
}

sub setProduct {
  my ($self, $cFactory, $cProduct, $rcProd)  = @_;
  die ("FAIL: no cProduct\n")  unless $cProduct =~ /^\S+$/;
  die ("FAIL: no cFactory\n")  unless $cFactory =~ /^\S+$/;
  $rcProd ||= sub{($cFactory.$cProduct)->new(@_)};
  die ("FAIL: unsupported  rcProd\n") unless $rcProd && ref $rcProd eq 'CODE';
  $hProducts{makeProductKey($cProduct, $cFactory)} = $rcProd;
}

sub makeProductKey {
  return lc(join(@_,'|'));
}

1;
}


