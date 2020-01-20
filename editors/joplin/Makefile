# $FreeBSD$

PORTNAME=	joplin
DISTVERSIONPREFIX=	v
DISTVERSION=	1.0.178
CATEGORIES=	editors

MAINTAINER=	genneko
COMMENT=	a note taking and to-do application with synchronization capabilities

LICENSE=	MIT

LIB_DEPENDS=	
BUILD_DEPENDS=	electron:devel/electron6 \
		node:www/node10 \
		npm:www/npm-node10 \
		rsync:net/rsync
RUN_DEPENDS=	electron:devel/electron6

OPTIONS_DEFINE=	PROXY
PROXY_EXTRA_PATCHES=	${PATCHDIR}/proxy-patches

USES=		python:3.7,build
USE_GITHUB=	yes
GH_ACCOUNT=	laurent22

PLIST_SUB=	WRKSRC=${WRKSRC}

SUB_FILES=	joplin-desktop

DESKTOP_ENTRIES="Joplin Desktop(Ports)" "Note-taking application" \
		"${DATADIR}/Assets/LinuxIcons/16x16.png" \
		"joplin-desktop" "Office;WordProcessor;" \
		false

post-extract:
	${MKDIR} -p ${WRKSRC}/ElectronClient/app/node_modules/.bin && \
		${LN} -fs /usr/local/bin/electron ${WRKSRC}/ElectronClient/app/node_modules/.bin/electron

do-build:
	@cd ${WRKSRC} && export HUSKY_SKIP_INSTALL=1 && \
		npm install && cd Tools && npm install && \
		cd .. && \
		npm run copyLib && \
		npm run tsc && \
		cd ElectronClient/app && \
		npm install

do-install:
	@${MKDIR} ${STAGEDIR}${DATADIR}
	@cd ${WRKSRC} && ${COPYTREE_SHARE} . ${STAGEDIR}${DATADIR}
	${INSTALL_SCRIPT} ${WRKDIR}/joplin-desktop ${STAGEDIR}${PREFIX}/bin/

.include <bsd.port.mk>
