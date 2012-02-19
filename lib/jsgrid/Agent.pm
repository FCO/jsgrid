package jsgrid::Agent;

use Moose;
use Moose::Util::TypeConstraints;
use DateTime;
use Carp;

with 'Mongoose::Document';

my $encrease_percent = .5;
my $decrease_percent = .1;

has 'runned'          => ( is => 'rw', isa => 'Mongoose::Join[jsgrid::Run]' ) ;
has 'running'         => ( is => 'rw', isa => 'jsgrid::Run' ) ;
has 'disconfiability' => ( is => 'ro', isa => 'Num', default => 0.1 ) ;
has 'state'           => ( is => 'rw', isa => enum( [ qw|initializing idle waiting running done| ]), default => 'initializing' ) ;
has 'active'          => ( is => 'rw', isa => 'Bool', default => 1 ) ;
has 'connected_date'  => ( is => 'rw', isa => 'DateTime', traits => [ qw/Raw/ ], default => sub{ DateTime->now }   ) ;
has 'sock'            => ( is => 'rw', isa => 'Object' ) ;

before 'sock' => sub {
   my $self = shift;
   croak "Trying to change sock" if @_ and defined $self->{sock};
};

sub aid{
   my $self = shift;
   $self->save if not exists $self->{ _id };
   $self->_id
}

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
