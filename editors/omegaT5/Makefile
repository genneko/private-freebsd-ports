# $FreeBSD: head/editors/omegaT/Makefile 432773 2017-01-29 16:17:56Z rodrigo $

PORTNAME=	omegaT5
DISTVERSION=	5.1.0
CATEGORIES=	editors java x11
MASTER_SITES=	# fetch manually
DISTNAME=	OmegaT_${DISTVERSION}_Beta_Without_JRE

MAINTAINER=	rodrigo@FreeBSD.org
COMMENT=	Powerful translation memory application written in Java

LICENSE=	GPLv2

USES=		zip
NO_BUILD=	yes
USE_JAVA=	yes
JAVA_VENDOR=	openjdk
JAVA_VERSION=	1.7+
JAVA_RUN=	yes

DATADIR=	${JAVASHAREDIR}/${PORTNAME}
SUB_FILES=	omegaT.sh

DESKTOP_ENTRIES="OmegaT5" "Translation memory application" \
		"${DATADIR}/images/OmegaT.png" \
		"omegaT5" "Office;WordProcessor;Java;" \
		false

.include <bsd.port.pre.mk>

.if !exists(${DISTDIR}/${DISTNAME}${EXTRACT_SUFX})
IGNORE=		Please visit https://omegat.org/ja/download and download ${DISTFILES} into ${DISTDIR}
.endif

do-install:
	@${MKDIR} ${STAGEDIR}${DATADIR}
	@cd ${WRKSRC} && ${COPYTREE_SHARE} . ${STAGEDIR}${DATADIR}
	${INSTALL_SCRIPT} ${WRKDIR}/omegaT.sh ${STAGEDIR}${PREFIX}/bin/${PORTNAME}

.include <bsd.port.mk>
