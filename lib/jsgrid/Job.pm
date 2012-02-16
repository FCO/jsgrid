package jsgrid::Job;

use Mongoose::Class;
use jsgrid::Job::Parameter;
use jsgrid::Run;

with 'Mongoose::Document' => {  -pk => [ qw/name/ ]  } ;

has 'name'       => ( is => 'rw', isa => 'Str' ) ;
has 'parameters' => ( is => 'ro', isa => 'jsgrid::Job::Parameter', default => sub{ jsgrid::Job::Parameter->new }  ) ;
has 'code'       => ( is => 'rw', isa => 'Str' ) ;
has_many 'runs' => 'jsgrid::Run' ;

after 'code' => sub {
   my $self = shift;
   if( @_ ) {
      chomp( $self->{ code } );
      #$self->{ code } =~ s/\b(\W+)\s+/$1/gsm;
      #$self->{ code } =~ s/\s+(\W+)(\b|$)/$1/gsm;
   }
};

around 'parameters' => sub {
   my $orig = shift;
   my $self = shift;
   if( @_ ) {
      return $self->{ parameters } = jsgrid::Job::Parameter->new( pars => [ @_ ]  )
   } else { 
      return $self->$orig
   } 
};

sub run { 
   my $self = shift;
   $self->runs->add( my $run = jsgrid::Run->new( job => $self )  ) ;
   $run
} 

sub call {
   my $self = shift;
   $self->name . $self->parameters->call( @_ ) ;
}

sub to_str {
   my $self = shift;
   my $code = "function " . $self->name;
   $code   .= $self->parameters->definition;
   $code   .= "{" . $self->code . "}";
}

42
