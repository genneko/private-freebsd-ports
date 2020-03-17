# $FreeBSD$

PORTNAME=	gh-home
DISTVERSIONPREFIX=	v
DISTVERSION=	2.0.1
CATEGORIES=	www

MAINTAINER=	genneko217@gmail.com
COMMENT=	Open the GitHub page of the given or current directory repo

LICENSE=	MIT
LICENSE_FILE=	${WRKSRC}/license

USES=		localbase:ldflags \
		node:12,build

USE_GITHUB=	yes
GH_ACCOUNT=	sindresorhus

SUB_FILES=	${PORTNAME}

USE_NODE=	npm prefetch extract prebuild

PREFETCH_TIMESTAMP=	1584179315

do-build:
	cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} ${NPM_CMD} install --production

do-install:
	${INSTALL_SCRIPT} ${WRKDIR}/${PORTNAME} ${STAGEDIR}${PREFIX}/bin
	${MKDIR} ${STAGEDIR}${DATADIR}
	cd ${WRKSRC} && \
		${COPYTREE_SHARE} . ${STAGEDIR}${DATADIR}

.include <bsd.port.mk>
