#---------------------[ CLASSES ]---------------------
use strict; use warnings;
use lib qw(. .. lib);
use Shapes;

package ShapeFactory {
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
    die "no shape defined in table:$shape" 
      unless my $rc1 = $hShapes{lc($shape)};
    $rc1->();
  }
}


