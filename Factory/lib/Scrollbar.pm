package AbstractScrollbar {
  sub top     { (ref $_[0]) ."::top()";}
  sub bottom  { (ref $_[0]) ."::bottom()";}
  sub pgUp    { (ref $_[0]) ."::pgUp()";}
  sub pgDn    { (ref $_[0]) ."::pgDn()";}
}

package LinuxScrollbar {
  use base "AbstractScrollbar";
  sub new     { my $class= shift; bless{}, $class};
}

package WindowsScrollbar {
  use base "AbstractScrollbar";
  sub new     { my $class= shift; bless{}, $class};
}

package MacScrollbar {
  use base "AbstractScrollbar";
  sub new     { my $class= shift; bless{}, $class};
}

package AndroidScrollbar {
  use base "AbstractScrollbar";
  sub new     { my $class= shift; bless{}, $class};
}

1;
