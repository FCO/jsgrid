package jsgrid::Agent::Manager;
use Moose;

use jsgrid::Agent;

has 'agent_collection' => ( is => 'ro', default => "jsgrid::Agent" ) ;

sub agents { 
   my $self = shift;
   $self->agent_collection->find->all;
} 

sub add_agent {
   my $self = shift;
   my $aid  = shift;
   my $new = jsgrid::Agent->new(aid => $aid);
   $new->save;
   $new
}

sub get_agent {
   my $self = shift;
   my $aid  = shift;
   $self->agent_collection->find_one( { aid => $aid } ); 
}

42
