package AbstractWooget {
  sub blur          { (ref $_[0]) ."::blur()"}
  sub click         { (ref $_[0]) ."::click()"}
  sub focus         { ("this is " . ref $_[0]) ."::focus()"}
  sub unfocus       { (ref $_[0]) ."::unfocus()"}  
}

package AndroidWooget {
  use base 'AbstractWooget';
  sub new     { my $class= shift; bless{@_}, $class};
}

1;
