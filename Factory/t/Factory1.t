use lib qw(. .. lib );

use strict; use warnings;
use Test::Most;

my $class = 'Factory';
use_ok( $class) or die ("could not open $class");
can_ok( 'ShapeFactory', 'new' ) or 
  die ("could not create ShapeFactory object");
my $oShapeFactory = ShapeFactory->new();
is ref $oShapeFactory, 'ShapeFactory', 'ref ShapeFactory';
is_deeply [$oShapeFactory->getShapeNames()],
  [qw(circle rectangle square triangle)], 'is_deeply';
  
is ref (my $oCircle = $oShapeFactory->getShape('circle')), 
  'Circle', 'Circle';
dies_ok {$oShapeFactory->getShape(undef)} 'getShape undef';
like $@, qr/no shape defined/, 'getShape undef errMsg';
dies_ok {$oShapeFactory->getShape('bogus')} 'getShape undef';
like $@, qr/no shape defined in table/, 'unknown getShape errMsg';
is_deeply [$oCircle->getActions()],
  [qw(draw animate print)], 'is_deeply getactions circle';

$DB::single = 1; 
$DB::single = 1; 

done_testing;

=pod


sub capture_stdout {
  open (my $fh, '>', $_[0]) or die ("can't select variable");
  my $fh_prev = select $fh ;
  return ($fh_prev,$fh);
}

sub release_stdout {
  my ($fh_prev,$fh) = @_; 
  select $fh_prev ;
  close ($fh) or die ("can't close fh");
}
  
my $print_dump = '';
my ($fh_prev,$fh) = capture_stdout(\$print_dump);
print "jjs rulez\n";
release_stdout ($fh_prev,$fh);
like $print_dump, qr/jjs rulez/, 'print_dump';
=cut

