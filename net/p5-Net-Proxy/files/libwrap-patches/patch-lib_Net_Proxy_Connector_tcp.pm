--- lib/Net/Proxy/Connector/tcp.pm.orig	2019-10-09 05:32:49 UTC
+++ lib/Net/Proxy/Connector/tcp.pm
@@ -2,7 +2,7 @@ package Net::Proxy::Connector::tcp;
 $Net::Proxy::Connector::tcp::VERSION = '0.13';
 use strict;
 use warnings;
-use IO::Socket::INET;
+use IO::Socket::IP;
 
 use Net::Proxy::Connector;
 our @ISA = qw( Net::Proxy::Connector );
@@ -23,7 +23,7 @@ sub init {
 # OUT
 sub connect {
     my ($self) = @_;
-    my $sock = IO::Socket::INET->new(
+    my $sock = IO::Socket::IP->new(
         PeerAddr  => $self->{host},
         PeerPort  => $self->{port},
         Proto     => 'tcp',
