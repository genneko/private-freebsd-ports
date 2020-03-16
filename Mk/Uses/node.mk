# $FreeBSD$
#
# Provides support for Node.js-based ports
#
# Feature:	node
# Usage:	USES=node[:ARGS]
# Valid ARGS:	<version>, build, run, test
#
# <version>:	Indicates a specific major version of Node the port uses. When
#		omitted, the port uses the current version of Node.
#
#		Examples:
#
#			USES=node:12	# Use Node 12 LTS
#			USES=node	# Use Node Current
#
# build:	Indicates Node is needed at build time and adds it to
#		BUILD_DEPENDS.
# run:		Indicates Node is needed at run time and adds it to
#		RUN_DEPENDS.
# test:		Indicates Node is needed at test time and adds it to
#		TEST_DEPENDS.
#
# NOTE: If the port specifies none of build, run or test, we assume the port
# requires all those dependencies.
#
# Variables, which can be set by a port:
#
# USE_NODE:		Indicates a Node package manager the port uses and
#			a list of additional features and functionalities to
#			enable. Supported package managers and features are:
#
#   Package Managers: {npm | yarn}
#
#	npm[:ARGS]	The port uses NPM as package manager.
#
#	yarn[:ARGS]	The port uses Yarn as package manager.
#
#	NOTE: A port must specify exactly a single package manager.
#
#	Valid ARGS:	fetch, extract, build, run, test
#
#		fetch:		Indicates the package manager is needed at
#				fetch time and adds it to FETCH_DEPENDS.
#		extract:	Indicates the package manager is needed at
#				extract time and adds it to EXTRACT_DEPENDS.
#		build:		Indicates the package manager is needed at
#				build time and adds it to BUILD_DEPENDS.
#		run:		Indicates the package manager is needed at
#				run time and adds it to RUN_DEPENDS.
#		test:		Indicates the package manager is needed at
#				test time and adds it to TEST_DEPENDS.
#
#				Examples:
#
#					USE_NODE=npm:fetch,build
#					USE_NODE=yarn:fetch,extract,build
#
#		NOTE: If the port specifies none of them, we assume the port
#		requires the package manager at build time only.
#
#   Features:
#
#	prefetch:	Downloads node modules the port uses according to the
#			pre-stored package.json (and package-lock.json or
#			yarn.lock depending on the node package manager used) in
#			PKGJSONSDIR. Downloaded node modules are archived into a
#			single tar file as one of the DISTFILES.
#
#		If the port uses this feature, the following variable must be
#		specified.
#
#		PREFETCH_TIMESTAMP:
#			A timestamp given to every directory, file or link in
#			the tar archive. This is necessary for reproducibility
#			of the archive file. You can use "date '+%s'" command to
#			acquire this value.
#
#	extract:	Installs the pre-fetched node modules into the port's
#			working source directory.
#
#	prebuild:	Rebuilds native node modules against the version of Node
#			installed before pre-build phase so that Node can
#			execute the native modules.
#
# MAINTAINER:	tagattie@yandex.com

.if !defined(_INCLUDE_USES_NODE_MK)
_INCLUDE_USES_NODE_MK=	yes

_VALID_NODE_VERSIONS=	8 10 12
_VALID_NODE_FEATURES=	npm yarn prefetch extract prebuild

_NODE_BASE_CMD=		node
_NPM_BASE_CMD=		npm
_NPX_BASE_CMD=		npx
_YARN_BASE_CMD=		yarn

_NODE_RELPORTDIR=	www/node
_NPM_RELPORTDIR=	www/npm
_YARN_RELPORTDIR=	www/yarn

# Detect a build, run or test time dependencies on Node
_NODE_ARGS=		${node_ARGS:S/,/ /g}
.if ${_NODE_ARGS:Mbuild}
_NODE_BUILD_DEP=	yes
_NODE_ARGS:=		${_NODE_ARGS:Nbuild}
.endif
.if ${_NODE_ARGS:Mrun}
_NODE_RUN_DEP=		yes
_NODE_ARGS:=		${_NODE_ARGS:Nrun}
.endif
.if ${_NODE_ARGS:Mtest}
_NODE_TEST_DEP=		yes
_NODE_ARGS:=		${_NODE_ARGS:Ntest}
.endif

# If the port does not specify any dependency, assume all are required
.if !defined(_NODE_BUILD_DEP) && !defined(_NODE_RUN_DEP) && \
    !defined(_NODE_TEST_DEP)
_NODE_BUILD_DEP=	yes
_NODE_RUN_DEP=		yes
_NODE_TEST_DEP=		yes
.endif

# Now _NODE_ARGS should be empty or contain a single major version
.if empty(_NODE_ARGS)	# Use Node current
_NODE_VERSION=		current
_NODE_PORTDIR=		${_NODE_RELPORTDIR}
_NPM_PORTDIR=		${_NPM_RELPORTDIR}
_YARN_PORTDIR=		${_YARN_RELPORTDIR}
.else			# Use specified major version of Node
.   if ${_VALID_NODE_VERSIONS:M${_NODE_ARGS}}
_NODE_VERSION=		${_NODE_ARGS}
_NODE_PORTDIR=		${_NODE_RELPORTDIR}${_NODE_VERSION}
_NPM_PORTDIR=		${_NPM_RELPORTDIR}-node${_NODE_VERSION}
_YARN_PORTDIR=		${_YARN_RELPORTDIR}-node${_NODE_VERSION}
.   else
IGNORE=	uses unknown USES=node arguments: ${_NODE_ARGS}
.   endif
.endif

# Detect features used with USE_NODE
.for var in ${USE_NODE}
.   if empty(_VALID_NODE_FEATURES:M${var:C/\:.*//})
_INVALID_NODE_FEATURES+=	${var}
.   endif
.endfor
.if !empty(_INVALID_NODE_FEATURES)
IGNORE=	uses unknown USE_NODE features: ${_INVALID_NODE_FEATURES}
.endif

# Make each individual feature and arguments available
# as _NODE_FEATURE_<FEATURENAME> and _NODE_FEATURE_<FEATURENAME>_ARGS
.for var in ${USE_NODE}
_NODE_FEATURE_${var:C/\:.*//:tu}=	${var}
_NODE_FEATURE_${var:C/\:.*//:tu}_ARGS= \
	${var:C/^[^\:]*(\:|\$)//:S/,/ /g}
.endfor # USE_NODE

.if defined(_NODE_FEATURE_NPM) && defined(_NODE_FEATURE_YARN)
IGNORE=	package manager npm and yarn are mutually exclusive
.elif defined(_NODE_FEATURE_NPM)
NODE_PKG_MANAGER=	npm
.elif defined(_NODE_FEATURE_YARN)
NODE_PKG_MANAGER=	yarn
.else
IGNORE= no package manager is specified
.endif

# Detect a fetch, extract, build, run or test time dependencies on package
# manager
.if ${_NODE_FEATURE_${NODE_PKG_MANAGER:tu}_ARGS:Mfetch}
_${NODE_PKG_MANAGER:tu}_FETCH_DEP=	yes
_NODE_FEATURE_${NODE_PKG_MANAGER:tu}_ARGS:= \
	${_NODE_FEATURE_${NODE_PKG_MANAGER:tu}_ARGS:Nfetch}
.endif
.if ${_NODE_FEATURE_${NODE_PKG_MANAGER:tu}_ARGS:Mextract}
_${NODE_PKG_MANAGER:tu}_EXTRACT_DEP=	yes
_NODE_FEATURE_${NODE_PKG_MANAGER:tu}_ARGS:= \
	${_NODE_FEATURE_${NODE_PKG_MANAGER:tu}_ARGS:Nextract}
.endif
.if ${_NODE_FEATURE_${NODE_PKG_MANAGER:tu}_ARGS:Mbuild}
_${NODE_PKG_MANAGER:tu}_BUILD_DEP=	yes
_NODE_FEATURE_${NODE_PKG_MANAGER:tu}_ARGS:= \
	${_NODE_FEATURE_${NODE_PKG_MANAGER:tu}_ARGS:Nbuild}
.endif
.if ${_NODE_FEATURE_${NODE_PKG_MANAGER:tu}_ARGS:Mrun}
_${NODE_PKG_MANAGER:tu}_RUN_DEP=	yes
_NODE_FEATURE_${NODE_PKG_MANAGER:tu}_ARGS:= \
	${_NODE_FEATURE_${NODE_PKG_MANAGER:tu}_ARGS:Nrun}
.endif
.if ${_NODE_FEATURE_${NODE_PKG_MANAGER:tu}_ARGS:Mtest}
_${NODE_PKG_MANAGER:tu}_TEST_DEP=	yes
_NODE_FEATURE_${NODE_PKG_MANAGER:tu}_ARGS:= \
	${_NODE_FEATURE_${NODE_PKG_MANAGER:tu}_ARGS:Ntest}
.endif
.if !empty(_NODE_FEATURE_${NODE_PKG_MANAGER:tu}_ARGS)
IGNORE=	uses unknown USE_NODE feature arguments: \
	${_NODE_FEATURE_${NODE_PKG_MANAGER:tu}_ARGS}
.endif

# If the port does not specify any dependency, assume it is required at build
# time
.if !defined(_${NODE_PKG_MANAGER:tu}_FETCH_DEP) && \
    !defined(_${NODE_PKG_MANAGER:tu}_EXTRACT_DEP) && \
    !defined(_${NODE_PKG_MANAGER:tu}_BUILD_DEP) && \
    !defined(_${NODE_PKG_MANAGER:tu}_RUN_DEP) && \
    !defined(_${NODE_PKG_MANAGER:tu}_TEST_DEP)
_${NODE_PKG_MANAGER:tu}_BUILD_DEP=	yes
.endif

# Setup dependencies
.for stage in BUILD RUN TEST
.   if defined(_NODE_${stage}_DEP)
${stage}_DEPENDS+=	${_NODE_BASE_CMD}:${_NODE_PORTDIR}
.   endif
.endfor

.for feat in ${_VALID_NODE_FEATURES}
.   for stage in FETCH EXTRACT BUILD RUN TEST
.	if defined(_${feat:tu}_${stage}_DEP)
${stage}_DEPENDS+=	${_${feat:tu}_BASE_CMD}:${_${feat:tu}_PORTDIR}
.	endif
.   endfor
.endfor

NODE_VERSION=		${_NODE_VERSION}
NODE_PORTDIR=		${_NODE_PORTDIR}
NPM_PORTDIR=		${_NPM_PORTDIR}
YARN_PORTDIR=		${_YARN_PORTDIR}
#NODE_PKG_MANAGER=	${_NODE_FEATURE}

NODE_CMD?=		${LOCALBASE}/bin/${_NODE_BASE_CMD}
NPM_CMD?=		${LOCALBASE}/bin/${_NPM_BASE_CMD}
NPX_CMD?=		${LOCALBASE}/bin/${_NPX_BASE_CMD}
YARN_CMD?=		${LOCALBASE}/bin/${_YARN_BASE_CMD}

PKGJSONSDIR?=		${FILESDIR}/packagejsons
PREFETCH_TIMESTAMP?=	0

.if defined(_NODE_FEATURE_PREFETCH)
_DISTFILE_prefetch=	${PORTNAME}${PKGNAMESUFFIX}-node-modules-${DISTVERSION}${EXTRACT_SUFX}
DISTFILES+=		${_DISTFILE_prefetch}:prefetch

.   if ${PREFETCH_TIMESTAMP} == 0
IGNORE= does not specify timestamp for pre-fetched modules
.   endif

FETCH_DEPENDS+= ${NODE_PKG_MANAGER}:${${NODE_PKG_MANAGER:tu}_PORTDIR}
_USES_fetch+=	490:node-fetch-node-modules
.endif # _FEATURE_NODE_PREFETCH

###
.   if ${NODE_PKG_MANAGER} == npm
node-fetch-node-modules:
	@${MKDIR} ${DISTDIR}/${DIST_SUBDIR}
	@if [ ! -f ${DISTDIR}/${DIST_SUBDIR}/${_DISTFILE_prefetch} ]; then \
		${ECHO_MSG} "===>  Pre-fetching and archiving node modules"; \
		${MKDIR} ${WRKDIR}/npm-cache; \
		${CP} -r ${PKGJSONSDIR}/* ${WRKDIR}/npm-cache; \
		cd ${PKGJSONSDIR} && \
		for dir in `${FIND} . -type f -name package.json -exec dirname {} ';'`; do \
			cd ${WRKDIR}/npm-cache/$${dir} && \
			${SETENV} HOME=${WRKDIR} ${NPM_CMD} ci --ignore-scripts --no-progress && \
			${RM} package.json package-lock.json; \
		done; \
		cd ${WRKDIR} && \
		${MTREE_CMD} -cbnSp npm-cache | ${MTREE_CMD} -C | ${SED} \
			-e 's:time=[0-9.]*:time=${PREFETCH_TIMESTAMP}.000000000:' \
			-e 's:\([gu]id\)=[0-9]*:\1=0:g' \
			-e 's:flags=.*:flags=none:' \
			-e 's:^\.:./npm-cache:' > npm-cache.mtree && \
		${TAR} -cz --options 'gzip:!timestamp' \
			-f ${DISTDIR}/${DIST_SUBDIR}/${_DISTFILE_prefetch} @npm-cache.mtree; \
		${RM} -r ${WRKDIR}; \
	fi
.   elif ${NODE_PKG_MANAGER} == yarn
node-fetch-node-modules:
	@${MKDIR} ${DISTDIR}/${DIST_SUBDIR}
	@if [ ! -f ${DISTDIR}/${DIST_SUBDIR}/${_DISTFILE_prefetch} ]; then \
		${ECHO_MSG} "===>  Pre-fetching and archiving node modules"; \
		${MKDIR} ${WRKDIR}; \
		${ECHO_CMD} 'yarn-offline-mirror "./yarn-offline-cache"' >> \
			${WRKDIR}/.yarnrc; \
		${CP} -r ${PKGJSONSDIR}/* ${WRKDIR}; \
		cd ${PKGJSONSDIR} && \
		for dir in `${FIND} . -type f -name package.json -exec dirname {} ';'`; do \
			cd ${WRKDIR}/$${dir} && \
			${SETENV} HOME=${WRKDIR} XDG_CACHE_HOME=${WRKDIR}/.cache \
				${YARN_CMD} --frozen-lockfile --ignore-scripts && \
			${RM} package.json yarn.lock; \
		done; \
		cd ${WRKDIR}; \
		${MTREE_CMD} -cbnSp yarn-offline-cache | ${MTREE_CMD} -C | ${SED} \
			-e 's:time=[0-9.]*:time=${PREFETCH_TIMESTAMP}.000000000:' \
			-e 's:\([gu]id\)=[0-9]*:\1=0:g' \
			-e 's:flags=.*:flags=none:' \
			-e 's:^\.:./yarn-offline-cache:' > yarn-offline-cache.mtree; \
		${TAR} -cz --options 'gzip:!timestamp' \
			-f ${DISTDIR}/${DIST_SUBDIR}/${_DISTFILE_prefetch} @yarn-offline-cache.mtree; \
		${RM} -r ${WRKDIR}; \
	fi
.   endif
###

.if defined(_NODE_FEATURE_EXTRACT)
.   if ${NODE_PKG_MANAGER} == npm
_USES_extract+=	900:node-install-node-modules
.   elif ${NODE_PKG_MANAGER} == yarn
EXTRACT_DEPENDS+= ${NODE_PKG_MANAGER}:${${NODE_PKG_MANAGER:tu}_PORTDIR}
_USES_extract+=	900:node-install-node-modules
.   endif
.endif # _NODE_FEATURE_EXTRACT

###
.   if ${NODE_PKG_MANAGER} == npm
node-install-node-modules:
	@${ECHO_MSG} "===>  Copying package.json and package-lock.json to WRKSRC"
	@cd ${PKGJSONSDIR} && \
	for dir in `${FIND} . -type f -name package.json -exec dirname {} ';'`; do \
		for f in package.json package-lock.json; do \
			if [ -f ${WRKSRC}/$${dir}/$${f} ]; then \
				${MV} -f ${WRKSRC}/$${dir}/$${f} ${WRKSRC}/$${dir}/$${f}.bak; \
			fi; \
			${CP} -f $${dir}/$${f} ${WRKSRC}/$${dir}; \
		done; \
	done
	@${ECHO_MSG} "===>  Moving pre-fetched node modules to WRKSRC"
	@cd ${PKGJSONSDIR} && \
	for dir in `${FIND} . -type f -name package.json -exec dirname {} ';'`; do \
		${MV} ${WRKDIR}/npm-cache/$${dir}/node_modules ${WRKSRC}/$${dir}; \
	done
.   elif ${NODE_PKG_MANAGER} == yarn
node-install-node-modules:
	@${ECHO_MSG} "===>  Copying package.json and yarn.lock to WRKSRC"
	@cd ${PKGJSONSDIR} && \
	for dir in `${FIND} . -type f -name package.json -exec dirname {} ';'`; do \
		for f in package.json yarn.lock; do \
			if [ -f ${WRKSRC}/$${dir}/$${f} ]; then \
				${MV} -f ${WRKSRC}/$${dir}/$${f} ${WRKSRC}/$${dir}/$${f}.bak; \
			fi; \
			${CP} -f $${dir}/$${f} ${WRKSRC}/$${dir}; \
		done; \
	done
	@${ECHO_MSG} "===>  Installing node modules from pre-fetched cache"
	@${ECHO_CMD} 'yarn-offline-mirror "../yarn-offline-cache"' >> ${WRKSRC}/.yarnrc
	@cd ${PKGJSONSDIR} && \
	for dir in `${FIND} . -type f -name package.json -exec dirname {} ';'`; do \
		cd ${WRKSRC}/$${dir} && ${SETENV} HOME=${WRKDIR} XDG_CACHE_HOME=${WRKDIR}/.cache \
			${YARN_CMD} --frozen-lockfile --ignore-scripts --offline; \
	done
.   endif
###

.if defined(_NODE_FEATURE_PREBUILD)
BUILD_DEPENDS+= ${NODE_PKG_MANAGER}:${${NODE_PKG_MANAGER:tu}_PORTDIR}
.   if ${NODE_PKG_MANAGER} == yarn
BUILD_DEPENDS+=	npm:${NPM_PORTDIR}	# npm is needed for node-gyp
.   endif

_USES_build+=	291:rebuild-native-node-modules
.endif # _NODE_FEATURE_PREBUILD

###
rebuild-native-node-modules:
	@${ECHO_MSG} "===>  Rebuilding native node modules"
	@cd ${PKGJSONSDIR} && \
	for dir in `${FIND} . -type f -name package.json -exec dirname {} ';'`; do \
		cd ${WRKSRC}/$${dir} && ${SETENV} ${MAKE_ENV} \
		npm_config_nodedir=${LOCALBASE} \
		${NPM_CMD} rebuild --no-progress; \
	done
###

.endif # _INCLUDE_USES_NODE_MK
