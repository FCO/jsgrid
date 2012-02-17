package jsgrid::Agent;

use Moose;
use Moose::Util::TypeConstraints;

with 'Mongoose::Document' => { -pk => [ qw/aid/ ]  } ;

my $encrease_percent = .5;
my $decrease_percent = .1;

has 'aid'             => ( is => 'ro', isa => 'Str', required => 1 ) ;
has 'runned'          => ( is => 'rw', isa => 'Mongoose::Join[jsgrid::Run]' ) ;
has 'running'         => ( is => 'rw', isa => 'jsgrid::Run' ) ;
has 'disconfiability' => ( is => 'ro', isa => 'Num', default => 0.1 ) ;
has 'state'           => ( is => 'rw', isa => enum( [ qw|idle waiting running done| ]), default => 'idle' ) ;
has 'active'          => ( is => 'rw', isa => 'Bool', default => 1 ) ;

sub encrease_confiability { 
   my $self = shift;

   $self->{disconfiability} *= 1 - $encrease_percent
} 

sub decrease_confiability { 
   my $self = shift;

   $self->{disconfiability} += $decrease_percent
} 

sub is_confiable { 
   my $self = shift;

   ($self->disconfiability < .05) || (rand() < 1 - $self->disconfiability)
} 

42
