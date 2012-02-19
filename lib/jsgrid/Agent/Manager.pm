package jsgrid::Agent::Manager;

use Moose;
Mongoose->load_schema(  search_path=>'jsgrid', shorten=>1 );
use Mongoose;
Mongoose->db( "jsgrid2" ) ;
Mongoose->naming(  [ 'decamel','plural' ] );

use MongoDB::OID;

( undef ) = ( $Mongoose::singleton );

use jsgrid::Agent;

has 'agent_collection' => ( is => 'ro', default => "jsgrid::Agent" ) ;

sub agents { 
   my $self = shift;
   $self->agent_collection->find->all;
} 

sub new_agent {
   my $self = shift;
   my $new = $self->agent_collection->new;
   $new->connected_date( DateTime->now ) ;
   $new->save;
   $new
}

sub get_agent {
   my $self = shift;
   my $aid  = shift;
   my $id = $self->create_idobj( $aid );
   my $ret = $self->agent_collection->find_one( { _id => $id } ) ;
   die "This Agent does not exists..." unless $ret;
   $ret
}

sub create_idobj {
   my $self = shift;
   my $val  = shift;
   MongoDB::OID->new( value => $self->get_id_from( $val ) )
}

sub get_id_from {
   my $self = shift;
   my $aid  = shift;
   if( ref($aid) ) {
      if( $aid->isa( "MongoDB::OID" ) ) {
         return $aid->value;
         if( $aid->isa( __PACKAGE__ ) ) {
            return $aid->aid;
         } else {
            die "bla";
         }
      }
   } else {
      return $aid;
   }
}

42
