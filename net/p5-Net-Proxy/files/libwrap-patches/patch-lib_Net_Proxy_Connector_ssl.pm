--- lib/Net/Proxy/Connector/ssl.pm.orig	2019-10-11 00:10:29 UTC
+++ lib/Net/Proxy/Connector/ssl.pm
@@ -42,7 +42,7 @@ sub listen {
 
     # or as a standard TCP socket, which may be upgraded later
     else {
-        $sock = IO::Socket::INET->new(
+        $sock = IO::Socket::IP->new(
             Listen    => 1,
             LocalAddr => $self->{host},
             LocalPort => $self->{port},
@@ -101,7 +101,7 @@ sub connect {
 
     # or as a standard TCP socket, which may be upgraded later
     else {
-        $sock = IO::Socket::INET->new(
+        $sock = IO::Socket::IP->new(
             PeerAddr => $self->{host},
             PeerPort => $self->{port},
             Proto    => 'tcp',
