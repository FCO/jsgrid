#!/usr/bin/perl

use Mojolicious::Lite;

my %agent;

websocket "/agent/:aid" => sub{
   my $self = shift;

   $agent{ $self->stash->{aid} } = shift;

   $self->on(message => sub{
   });
};

get "/job/:jid" => sub {
};

app->start;
