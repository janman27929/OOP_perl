use strict; use warnings;

package Shape {
  sub new     {bless {}, shift};
  sub getActions {qw(draw animate print)}
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
}

package Square    { our @ISA=qw(Shape) }
package Rectangle { our @ISA=qw(Shape) }
package Triangle  { our @ISA=qw(Shape) }
