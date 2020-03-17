# $FreeBSD$

PORTNAME=	clipboard-cli
DISTVERSIONPREFIX=	v
DISTVERSION=	2.0.0
CATEGORIES=	deskutils

MAINTAINER=	genneko217@gmail.com
COMMENT=	Cross-platform command-line clipboard (copy/paste) utility

LICENSE=	MIT
LICENSE_FILE=	${WRKSRC}/license

USES=		localbase:ldflags \
		node:12,build

USE_GITHUB=	yes
GH_ACCOUNT=	sindresorhus

SUB_FILES=	clipboard

USE_NODE=	npm prefetch extract prebuild

#RUN_DEPENDS=	xsel:x11/xsel-conrad

PREFETCH_TIMESTAMP=	1584179315

do-build:
	cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} ${NPM_CMD} install --production

do-install:
	${INSTALL_SCRIPT} ${WRKDIR}/clipboard ${STAGEDIR}${PREFIX}/bin
	${MKDIR} ${STAGEDIR}${DATADIR}
	cd ${WRKSRC} && \
		${COPYTREE_SHARE} . ${STAGEDIR}${DATADIR}

.include <bsd.port.mk>
