# $FreeBSD$

PORTNAME=	joplin
DISTVERSIONPREFIX=	v
DISTVERSION=	1.0.193
CATEGORIES=	deskutils
PKGNAMESUFFIX=	-terminal

MAINTAINER=	genneko217@gmail.com
COMMENT=	Terminal version of note taking and to-do application with synchronisation capabilities

LICENSE=	MIT
LICENSE_FILE=	${WRKSRC}/LICENSE

FETCH_DEPENDS=	git:devel/git
BUILD_DEPENDS=	rsync:net/rsync vips:graphics/vips

USES=		localbase:ldflags \
		node:12,build python:3.7,build gmake

USE_GITHUB=	yes
GH_ACCOUNT=	laurent22

BINARY_ALIAS=	python=${PYTHON_CMD}

SUB_FILES=	${PORTNAME}${PKGNAMESUFFIX}

DATADIR=	${PREFIX}/share/${PORTNAME}${PKGNAMESUFFIX}
DOCSDIR=	${PREFIX}/share/doc/${PORTNAME}${PKGNAMESUFFIX}
PORTDOCS=	BUILD.md CONTRIBUTING.md README.md SECURITY.md

OPTIONS_DEFINE=	DOCS

USE_NODE=	npm prefetch extract prebuild

PREFETCH_TIMESTAMP=	1584179315

BUILD_WRKSRC=	${WRKSRC}/CliClient

do-build:
	cd ${BUILD_WRKSRC} && ${SETENV} ${MAKE_ENV} ${NPM_CMD} run build
	cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} ${NPM_CMD} run build

do-install:
	${INSTALL_SCRIPT} ${WRKDIR}/${PORTNAME}${PKGNAMESUFFIX} ${STAGEDIR}${PREFIX}/bin
	${MKDIR} ${STAGEDIR}${DATADIR}
	cd ${BUILD_WRKSRC} && \
		${COPYTREE_SHARE} build ${STAGEDIR}${DATADIR} && \
		${COPYTREE_SHARE} node_modules ${STAGEDIR}${DATADIR}

do-install-DOCS-on:
	${MKDIR} ${STAGEDIR}${DOCSDIR}
	${INSTALL_MAN} ${PORTDOCS:S|^|${WRKSRC}/|} ${STAGEDIR}${DOCSDIR}

.include <bsd.port.mk>
