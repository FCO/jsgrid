package jsgrid::Job::Parameter;

use Moose;

with 'Mongoose::EmbeddedDocument';

has 'pars' => ( is => 'rw', isa => 'ArrayRef[ Str ] ', default => sub{ [] }  ) ;

sub call {
   my $self = shift;
   my @values = @_;

   "(" . join(",", @values) . ")"
}

sub definition {
   my $self = shift;

   "(" . join(",", @{ $self->pars } ) . ")"
}

42
