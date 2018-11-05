use strict; use warnings;

package Products {

  # update this list for valid products
  my @aProducts = qw(Button Scrollbar Textbox Wooget Widget);

  #sub get_product    {$_[0]->[$1]};
  sub get_products { return sort @aProducts; }  
  sub add_product { 
    my ($self, $cName) = @_;
    die ("FAIL: dup product\n") if $self->isValidProduct($cName);
    push @aProducts, $cName;
  }

  sub delete_product { 
    my ($self, $cName) = @_;
    die ("FAIL: dup product\n") unless  $self->isValidProduct($cName);
    $DB::single = 1; 
    my $nPos =  grep {$aProducts[$_] =~ /$cName/} [0 .. @aProducts];
    push @aProducts, $cName;
  }

  sub isValidProduct   {
    my ($self, $cName) = @_;
    return (grep {$_ =~ /$cName/} @aProducts) ? 1 : 0;
  }  


  
}  
1;
