package AbstractTextbox {
  sub focus     { (ref $_[0]) ."::focus()";}
  sub create    { (ref $_[0]) ."::create()";}
  sub update    { (ref $_[0]) ."::update()";}
  sub delete    { (ref $_[0]) ."::delete()";}
}

package LinuxTextbox {
  use base "AbstractTextbox";
  sub new     { my $class= shift; bless{}, $class};
}
package WindowsTextbox {
  use base "AbstractTextbox";
  sub new     { my $class= shift; bless{}, $class};
}

package MacTextbox {
  use base "AbstractTextbox";
  sub new     { my $class= shift; bless{}, $class};
}

1;
