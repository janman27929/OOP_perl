package Shape {
use Role::Tiny;
requires 'getArea';

sub color   {$_[0]->{color}}
sub getColor {
    my $self = shift;
    return $self->{color} ? $self->{color} : 'none';
}

sub setColor {
    my ($self, $color) = @_;
    $self->{color} = $color;
}

sub foo { print("foo\n")};
sub bar { print("bar\n")};
#sub baz { print("baz\n")};
before baz => sub { print("baz_before\n")};
after  baz => sub { print("baz_after\n")};

}

package Point {
use Role::Tiny::With;

with 'Shape';

sub new {
    my ($class, $x, $y) = @_;
    return bless {
                  x => $x,
                  y => $y,
                 }, $class;
}

sub getArea { return 1 }
sub baz { $_[0]->{baz} = 1;  print "baz_point\n" }

}


