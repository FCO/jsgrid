#!/usr/bin/perl

use Mojolicious::Lite;
use lib "lib";
use jsgrid::Agent::Manager;

my %agent;
my @jobs;
my %jnames;

my $agent_manager = jsgrid::Agent::Manager->new;

get "/" => sub {
   my $self = shift;
   $self->render("index");
} => "index";

get "/agent" => sub {
   my $self = shift;

   my $new_agent = $agent_manager->new_agent;
   my $aid       = $new_agent->aid;
   my $url       = $self->url_for("websocket")->to_abs . $aid;
   $self->render( "agent", aid => $aid, url => $url );
} => "agent";

websocket "/agent/:aid" => sub{
   my $self = shift;

   my $agent = $agent_manager->get_agent( $self->stash->{aid} );
   $agent->sock( $self );

   app->log->debug("AID: " . $agent->aid);

   $self->on_message(sub{
      my $self = shift;
      my $msg  = shift;

      my($cmd, @pars) = split /\s+/, $msg;

      
   });
} => "websocket";

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

__DATA__

@@ index.html.ep
<html>
   <body>
      <script src="<%= url_for("agent.js") =%>"></script>
   </body>
</html>

@@ agent.js.ep
var ws = new WebSocket("<%= $url =%>");

