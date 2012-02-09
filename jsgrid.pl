#!/usr/bin/perl

use Mojolicious::Lite;

my %agent;
my @jobs;
my %jnames;

websocket "/agent/:aid" => sub{
   my $self = shift;

   $agent{ $self->stash->{aid} } = shift;

   $self->on(message => sub{
   });
};

any "/add/job" => sub {
   my $self = shift;
   my $jname           = $self->param("jname");
   $jnames{ $jname } ||= $self->param("code") || die "no job code";
   push @jobs, $jname;
   $self->render_json({status => "OK"});
};

get "/job/:jid" => sub {
   my $self = shift;
   my $jname = $self->stash->{jid};
   return $self->render(text => $jnames{ $jname }) if exists $jnames{ $jname };
   $self->render(text => "404 - Not Found", status => 404);
};

app->start;
