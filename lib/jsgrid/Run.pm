package jsgrid::Run;

use Moose;
use Moose::Util::TypeConstraints;

use jsgrid::Job;
use jsgrid::Agent;

with 'Mongoose::Document';

has 'job'            => ( is => 'rw', isa => 'jsgrid::Job' ) ;
has 'state'          => ( is => 'rw', isa => enum( [ qw|initial waiting running
sup_wait done | ] ), default => "initial" ) ;
has 'answer'         => ( is => 'rw', isa => 'Maybe[ Str ]', default => "" ) ;
has 'agent'          => ( is => 'rw', isa => 'jsgrid::Agent;' ) ;
has 'supervised'     => ( is => 'rw', isa => 'Bool' ) ;
has 'supervisor'     => ( is => 'rw', isa => __PACKAGE__ ) ;
has 'supervisioning' => ( is => 'rw', isa => __PACKAGE__ ) ;

around 'state' => sub { 
   my $orig  = shift;
   my $self  = shift;
   my $state = shift;

   if( $state eq 'done' ) { 
      if( $self->supervised and $self->supervisor->state ne 'done' ) { 
         $state = "sup_wait"
      } elsif($self->supervisioning and $self->supervisioning->state eq 'sup_wait') { 
         $self->supervisioning->state = 'done'
      }  
   } 
   $self->$orig( $state ) 
} ;

after 'answer' => sub{ 
   my $self = shift;
   return if @_;
   die "Job not done yet" if $self->state ne 'done';
   my $answer;
   if( not $self->supervised ) { 
      $answer = $self->{answer}
   } else { 
      $answer = $self->supervisor->answer;
      if( $self->{ answer } eq $answer ) { 
         $self->agent->encrease_confiability;
      } else { 
         $self->agent->decrease_confiability;
      } 
   } 
   return $answer
} ;

after agent => sub{ 
   my $self  = shift;
   my $agent = shift;

   return unless @_;
   $self->state( "waiting" ) ;
   $agent->running( $self ) if $agent->state eq "idle";

   if( ! $agent->is_confiable ) { 
      $self->set_supervised
   } 
}; 

sub set_supervised {
   my $self = shift;

   $self->supervised( 1 ) ;

   my $supervisor = __PACKAGE__->new( job => $self->job, supervisioning => $self );
   $self->supervisor( $supervisor ) ;
   $supervisor
} 


42
