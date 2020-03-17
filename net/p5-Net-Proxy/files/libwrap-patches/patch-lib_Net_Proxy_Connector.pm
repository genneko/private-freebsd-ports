--- lib/Net/Proxy/Connector.pm.orig	2014-11-02 22:58:47 UTC
+++ lib/Net/Proxy/Connector.pm
@@ -5,6 +5,7 @@ use warnings;
 use Carp;
 use Scalar::Util qw( refaddr );
 use Net::Proxy;
+use Authen::Libwrap qw ( hosts_ctl STRING_UNKNOWN );
 
 my %PROXY_OF;
 my $BUFFSIZE = 4096;
@@ -57,6 +58,17 @@ sub new_connection_on {
         return;
     }
 
+    # check hosts.allow
+    if( $self->{progname} ){
+        my $ok = hosts_ctl($self->{progname}, $sock->peerhostname, $sock->peerhost);
+        if( $ok ){
+            Net::Proxy->notice(sprintf("Access to [%s] allowed by libwrap: %s [%s]", $self->{progname}, $sock->peerhostname, $sock->peerhost));
+        }else{
+            Net::Proxy->error(sprintf("Access to [%s] denied by libwrap: %s [%s]", $self->{progname}, $sock->peerhostname, $sock->peerhost));
+            return;
+        }
+    }
+
     Net::Proxy->set_connector( $sock, $self );
     Net::Proxy->set_buffer( $sock, '' );
     Net::Proxy->set_callback( $sock, $self->{hook} ) if $self->{hook};
@@ -170,7 +182,7 @@ sub raw_write_to {
 # the most basic possible listen()
 sub raw_listen {
     my $self = shift;
-    my $sock = IO::Socket::INET->new(
+    my $sock = IO::Socket::IP->new(
         Listen    => 1,
         LocalAddr => $self->{host},
         LocalPort => $self->{port},
