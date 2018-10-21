use strict; use warnings;


package MealBuilder {
  sub new {bless {}, shift}

  sub prepareVegMeal {
    my $meal = Meal->new();
    return $meal;
  }   

  sub prepareNonVegMeal {
    my $self = shift;
    my $meal = Meal->new();
    return $meal;
  }
}

package Meal {
  
  sub new {bless {items => []}, shift}

  sub items {$_[0]->{items}}

  sub addItem { push @{$_[0]->items}, $_[1] }

  sub getCost {
    my $self = shift;
    my $nCost = 0;
    for (@{$self->items}) {
      $nCost += $_->{price};
    }
    return $nCost;
  }
  
  sub showItems {
    my $self = shift;
    for (@{$self->items}) {
      showItem($_->{name}, ref $_->{packing} ,$_->{price});
    }
  }

  sub showItem {
    my ($cItem, $cPacking, $nPrice) = @_;
    print << "EOF";
   Item: $cItem      
Packing: $cPacking
  Price: $nPrice
EOF
  }

}

package Item {
  sub name {}
  sub price {}
  sub size {}
}

package Burger {
  our @ISA=qw(Item);
  sub new {
    my $self = shift; 
    bless {
      packing => Wrapper->new(),
      @_
    }, $self
  }
  sub price {die("abstract")}
}


package VegBurger {
  our @ISA=qw(Burger);
  sub new {$_[0]->SUPER::new (price=>2.5, name => "Veg Burger")}
}

package ChickenBurger {
  our @ISA=qw(Burger);  
  my %hChickenBurgerPrice = (
    xxxlarge => 4.5,
    xxlarge => 4,
    xlarge => 3.5,
    large => 3.5,
    med => 2.5,
    small => 1.5,
  );
  sub new {
    my $self = shift;
    my %hParms = @_;
    if ($hParms{size} =~ /^large$/i) {
      $hParms{price} = 3.5;
    } elsif ($hParms{size} =~ /^medium$/i) {
      $hParms{price} = 2.5;
    } else {
      $hParms{price} = 2.25;
    }

    $_[0]->SUPER::new (
      size  =>  $hParms{size},
      price =>  $hParms{price}, 
      name  =>  "Chicken Burger",
    )
  }
}

package Wrapper {
  our @ISA=qw(Packing);
  sub new {my $self = shift; bless {@_}, $self}
  sub pack {"wrapper"}
}

package SmallBox {
  our @ISA=qw(Packing);
  sub new {my $self = shift; bless {@_}, $self}
  sub pack {"SmallBox"}
}

package SmallToyBox {
  our @ISA=qw(Packing);
  sub new {my $self = shift; bless {@_}, $self}
}


package Packing {
  sub new {my $self = shift; bless {@_}, $self}
  sub pack {"wrapper"}
}

package Bottle {
  our @ISA=qw(Packing);
  sub pack {"Bottle"}
}

package HotDrinkCup{
  our @ISA=qw(Packing);
  sub pack {"HotDrinkCup"}
}


package ColdDrink {
  our @ISA=qw(Item);
  sub new {
    my $self = shift; 
    bless {
      price => 1.25,
      packing => Bottle->new(),
      @_
    }, $self
  }
  sub price {die("abstract")}
}

package HotDrink {
  our @ISA=qw(Item);
  sub new {
    my $self = shift; 
    bless {
      packing => HotDrinkCup->new(),
      @_
    }, $self
  }
  sub price {die("abstract")}
}


package Pepsi {
  our @ISA=qw(ColdDrink);
  sub new {$_[0]->SUPER::new (price=>1.5, name => "Pepsi")}
}

package Coke {
  our @ISA=qw(ColdDrink);
  sub new {$_[0]->SUPER::new (price=>1.40, name => "Coke")}
}

package Coffee {
  our @ISA=qw(HotDrink);
  sub new {$_[0]->SUPER::new (price=>2.40, name => "Coffee")}
}


#---------------------[ main ]---------------------
my $oMealBuilder = MealBuilder->new ();

$DB::single = 1; 
$DB::single = 1; 
