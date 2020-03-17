# Created by: Philippe Audeoud <jadawin@tuxaco.net>
# $FreeBSD$

PORTNAME=	Net-Proxy
PORTVERSION=	0.13
PORTREVISION=	2
CATEGORIES=	net perl5
MASTER_SITES=	CPAN
PKGNAMEPREFIX=	p5-

MAINTAINER=	jadawin@FreeBSD.org
COMMENT=	Framework for proxying network connections in many ways

LICENSE=	ART10 GPLv1+
LICENSE_COMB=	dual

USES=		perl5
USE_PERL5=	configure

OPTIONS_DEFINE=	LIBWRAP
LIBWRAP_DESC=	Support access control with libwrap and IPv6
LIBWRAP_EXTRA_PATCHES=	${PATCHDIR}/libwrap-patches
LIBWRAP_RUN_DEPENDS=	security/p5-Authen-Libwrap>=0.23:security/p5-Authen-Libwrap
LIBWRAP_BUILD_DEPENDS=	${LIBWRAP_RUN_DEPENDS}

.include <bsd.port.mk>
