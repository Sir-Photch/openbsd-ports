COMMENT =		tunnel all your traffic over Websocket or HTTP2

DIST_TUPLE +=		github erebe wstunnel v10.1.7 .
DIST_TUPLE +=		github erebe fastwebsockets ef904598ec168d7748b28d77ec1803ba721932d8 fastwebsockets

CATEGORIES =		net

HOMEPAGE =		https://github.com/erebe/wstunnel

# BSD-3
PERMIT_PACKAGE =	Yes

WANTLIB =		${MODCARGO_WANTLIB} m

MODULES =		devel/cargo
MODCARGO_RUSTFLAGS =	-C debuginfo=0

CONFIGURE_STYLE =	cargo

SEPARATE_BUILD =	Yes

do-install:
	${INSTALL_PROGRAM} ${MODCARGO_TARGET_DIR}/release/wstunnel ${PREFIX}/bin/

.include "crates.inc"

.include <bsd.port.mk>
