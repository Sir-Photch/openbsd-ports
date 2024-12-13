COMMENT =		tunnel all your traffic over Websocket or HTTP2

GH_ACCOUNT =		erebe
GH_PROJECT =		wstunnel
GH_TAGNAME =		v10.1.7

CATEGORIES =		net

# 3BSD
PERMIT_PACKAGE =	Yes

WANTLIB +=		${MODCARGO_WANTLIB}

MODULES =		devel/cargo

CONFIGURE_STYLE =	cargo

SEPARATE_BUILD =	Yes

MODCARGO_RUSTFLAGS =	-C debuginfo=0

RELEASE_DIR =		${MODCARGO_TARGET_DIR}/release

do-install:
	${INSTALL_PROGRAM} ${RELEASE_DIR}/wstunnel ${PREFIX}/bin/

.include "crates.inc"

.include <bsd.port.mk>
