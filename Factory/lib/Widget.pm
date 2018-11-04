package AbstractWidget {
  sub blur          { (ref $_[0]) ."::blur()"}
  sub click         { (ref $_[0]) ."::click()"}
  sub focus         { (ref $_[0]) ."::focus()"}
  sub unfocus       { (ref $_[0]) ."::unfocus()"}  

  sub new     {  my $class= shift; bless{@_}, $class};
}

package AndroidWidget { use base 'AbstractWidget'}
package LinuxWidget   { use base 'AbstractWidget'}


1;
