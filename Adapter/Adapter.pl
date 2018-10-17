use warnings;
use strict;

package MediaPlayer  {
sub new { 
  my $class= shift;
  my $self = bless {
    type => shift,
  }, $class;        
}

sub play {
  my ($self, $filename) = @_;
  printf "%-20s: %-10s:Playing %s file: %-20s\n", 'MediaPlayer', ref $self, $self->{type}, $filename;
}

}

package Mp3Player { our @ISA=qw(MediaPlayer) }
package AdvancedMediaPlayer { our @ISA=qw(MediaPlayer)} 
package VlcPlayer { our @ISA=qw(AdvancedMediaPlayer)}
package Mp4Player { our @ISA=qw(AdvancedMediaPlayer) }

package AviPlayer {
our @ISA=qw(AdvancedMediaPlayer);

sub play {
  my ($self, $filename) = @_;
  printf "%-20s: %-10s:Playing %s file: %-20s\n", 'AviPlayer', ref $self, $self->{type}, $filename;
}

}

package MediaAdapter {
our @ISA = qw(MediaPlayer);

sub new {
  shift;
  my ($audioType) = @_;
  if($audioType =~ /vlc/i) {
    return VlcPlayer->new($audioType);			
  } elsif ($audioType =~ /mp3/i) {
    return Mp3Player->new($audioType);			
  } elsif ($audioType =~ /mp4/i) {
    return Mp4Player->new($audioType);			
  } elsif ($audioType =~ /avi/i) {
    return AviPlayer->new($audioType);			
  } else {
    die ("Unsupported audiotype: $audioType");
  }   
}
}


package AudioPlayer {
our @ISA = qw(MediaPlayer);

sub play {
  my ($self, $filename) = @_;
  my ($audioType) = $filename =~ /\.(\S+)$/;
  if ($audioType =~ /mp3|vlc|mp4|avi/i) {
    my $oAdapter = MediaAdapter->new($audioType);
    $oAdapter->play($filename);
  } else {
    print "Unsupported audio filetype:$audioType\n";
  }
}

}

#---------------------[ main ]---------------------
my $audioPlayer = new AudioPlayer();

$audioPlayer->play("beyond the horizon.mp3");
$audioPlayer->play("alone.mp4");
$audioPlayer->play("far far away.vlc");
$audioPlayer->play("mind me.avi");

