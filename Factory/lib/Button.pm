package AbstractButton {
  sub blur          { (ref $_[0]) ."::blur()"}
  sub click         { (ref $_[0]) ."::click()"}
  sub focus         { (ref $_[0]) ."::focus()"}
  sub unfocus       { (ref $_[0]) ."::unfocus()"}
  sub handleEvent   { (ref $_[0]) ."::handleEvent()"}
}

package LinuxButton {
  use base "AbstractButton";

  sub blur    { 
    my $self = shift;
    my $cMsg = "before parent\n";
    $cMsg .= $self->SUPER::blur(@_);
    $cMsg .= "after parent\n";
    return $cMsg;
  }

  sub new { 
    my $class =shift; 
    my %hParms = @_;
    bless {
      bk_color => 'blue',
      btn_color => $hParms{btn_color} || 'green' ,
    },$class;
  };
}

package WindowsButton {
  use base "AbstractButton";
  sub new     { my $class= shift; bless{}, $class};
}

package MacButton {
  use base "AbstractButton";
  sub new     { my $class= shift; bless{}, $class};
}

package AndroidButton {
  use base "AbstractButton";
  sub new { 
    my $class =shift; 
    my %hParms = @_;
    bless {
      bk_color => 'cyan',
      btn_color => $hParms{btn_color},
    },$class;
  };
}


1;
