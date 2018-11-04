use strict; use warnings;
package List {
sub append_item {
  my $self = shift;
  my ($raData, $oItem)  = @_;
  $self->add_item(@_);
}

sub add_item {
  my ($self, $raData, $oItem, $nPos)  = @_;
  die ("FAIL: no self \n") unless ($self and ref $raData);
  die ("FAIL: no raData\n") unless ($raData and ref $raData eq "ARRAY");
  die ("FAIL: no oItem\n") unless ($oItem and ref $oItem);
  # act as an append
  $nPos = @$raData unless defined $nPos;
  splice (@$raData, $nPos, 0, $oItem); 
  return $raData;
}

sub delete_item {
  my ($self, $raData,$nPos)  = @_;
  die ("FAIL: no self \n") unless ($self and ref $raData);
  die ("FAIL: no raData\n") unless ($raData and ref $raData eq "ARRAY");
  die ("FAIL: no raData at pos:$nPos:\n") unless ($raData->[$nPos]);
  splice (@$raData, $nPos, 1); 
  return $raData;
}

sub update_item {
  my ($self, $raData, $nPos, $oItem)  = @_;
  die ("FAIL: no self \n") unless ($self and ref $self);
  die ("FAIL: no raData\n") unless ($raData and ref $raData eq "ARRAY");
  die ("FAIL: no raData at pos:$nPos:\n") unless ($raData->[$nPos]);
  die ("FAIL: no oItem\n") unless ($oItem and ref $oItem);
  splice (@$raData, $nPos, 1, $oItem); 
  return $raData;  
}

sub get_item {
  my ($self, $raData, $nPos)  = @_;
  die ("FAIL: no self \n") unless ($self and ref $self);
  die ("FAIL: no raData\n") unless ($raData and ref $raData eq "ARRAY");
  return unless my $xData = ($raData->[$nPos]);
  return $xData;
}

sub find_item_qr {
  my ($self, $raData, $qr)  = @_;
}

sub find_item_cb {
  my ($self, $raData, $cb)  = @_;
}

1;

}

