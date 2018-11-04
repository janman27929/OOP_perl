package Diags {

sub whoami {
return sprintf("%s:%s", (caller(1))[3], (caller(0))[2]);
}
1;
}

