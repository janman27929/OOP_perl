#---------------------[ GLOBAL ]---------------------
use strict; use warnings;

#---------------------[ CLASSES ]---------------------
package ShapeFactory {
  #use Shape
  my %hShapes = (
    circle    => sub {Circle->new()},
    rectangle => sub {Rectangle->new()},
    square    => sub {Square->new()},
    triangle  => sub {Triangle->new()},
  );

  sub getShapeNames {sort keys %hShapes}

  sub new {bless {}, shift};
  sub getShape {
    my ($self, $shape) = @_;
    die "no shape defined" unless $shape;
    die "no shape defined in table:$shape" unless my $rc1 = $hShapes{lc($shape)};
    $rc1->();
  }
}

package Shape {
  sub new     {bless {}, shift};
  sub draw    {printf "draw:Shape:%s\n", ref $_[0]}
  sub animate {printf "animate:Shape:%s\n", ref $_[0]}
  sub print   {printf "print:Shape:%s\n", ref $_[0]}
}

package Circle    { 
  our @ISA=qw(Shape); 
  sub draw    {
    my $self = shift;
    printf "draw:Circle:beforeParent:%s\n",  ref $self;
    $self->SUPER::draw();    
    printf "draw:Circle:afterParent:%s\n",  ref $self;
  }
  sub animate {print "animate:", ref shift, "\n"}
  sub print   {print "print:", ref shift, "\n"}
}

package Square    { our @ISA=qw(Shape) }
package Rectangle { our @ISA=qw(Shape) }
package Triangle  { our @ISA=qw(Shape) }

#---------------------[ main ]---------------------
my $oShapeFactory = ShapeFactory->new();
for ($oShapeFactory->getShapeNames()) {
  my $oShape = $oShapeFactory->getShape($_);
  $oShape->draw();
  $oShape->print();
  $oShape->animate();
  print "\n"; 
}

$DB::single = 1; 
$DB::single = 1; 


