FROM rustlang/rust:nightly-slim AS builder

RUN apt update -qq && \
    apt install -y \
      curl \
      libcom-err2 \
      libffi8 \
      libgmp10 \
      libgnutls30 \
      libgssapi-krb5-2 \
      libhogweed6 \
      libidn2-dev \
      libk5crypto3 \
      libkeyutils1 \
      libkrb5-3 \
      libnettle8 \
      libp11-kit0 \
      libpq-dev \
      libsasl2-2 \
      libtasn1-6 \
      unzip

ARG ARCH=aarch64
ARG ARCH_VARIANT=arm64
ADD https://github.com/atkrad/wait4x/releases/download/v3.5.1/wait4x-linux-${ARCH_VARIANT}.tar.gz /tmp/dls/
RUN tar xf /tmp/dls/wait4x-linux-${ARCH_VARIANT}.tar.gz -C /usr/local/bin/ wait4x

WORKDIR /app/crawlcomply-serve

ADD https://github.com/SamuelMarks/rust-actix-diesel-auth-scaffold/archive/refs/heads/master.zip /app/rust-actix-diesel-auth-scaffold.zip
ADD https://github.com/crawlcomply/crawlcomply-backend/archive/refs/heads/master.zip /app/crawlcomply-backend.zip

RUN cd /app && for f in *.zip; do unzip -- "$f"; d="${f%*.zip}"; mv -- "$d"'-master' "$d"; done

COPY . .

# ENV RUSTFLAGS='-C relocation-model=static -C strip=symbols'
# ENV CC=musl-gcc
# ENV RUSTFLAGS='-C target-feature=+crt-static'
RUN cargo build --release

ENTRYPOINT ["/app/crawlcomply-serve/target/release/crawlcomply-serve"]
#FROM gcr.io/distroless/cc-debian12 AS runner
#
#ARG ARCH=aarch64
##ENV DATABASE_URL
##ENV REDIS_URL
#
#COPY --from=builder /app/target/release/crawlcomply-serve* /app/bin/
## libpq-dev:
##ENV LD_LIBRARY_PATH
##COPY --from=builder /usr/lib/*/libpq* /usr/lib/
#COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libpq* /usr/lib/${ARCH}-linux-gnu/
#COPY --from=builder /usr/include/postgresql /usr/include/
#COPY --from=builder /usr/bin/pg_config /usr/bin/
#
## libgssapi-krb5-2
#COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libgssapi_krb5* /usr/lib/${ARCH}-linux-gnu/
#
## libldap-2.5-0
#COPY --from=builder /usr/lib/${ARCH}-linux-gnu/liblber* /usr/lib/${ARCH}-linux-gnu/
#COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libldap* /usr/lib/${ARCH}-linux-gnu/
#
## libkrb5-3
##COPY --from=builder /usr/lib/krb5/plugins/preauth/spake.so /usr/lib/krb5/plugins/preauth/spake.so
#COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libkrb5* /usr/lib/${ARCH}-linux-gnu/
#
## libk5crypto3
#COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libk5crypto* /usr/lib/${ARCH}-linux-gnu/
#
## libcom-err2
#COPY --from=builder /lib/${ARCH}-linux-gnu/libcom_err* /lib/${ARCH}-linux-gnu/
#
## libsasl2-2
#COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libsasl2* /usr/lib/${ARCH}-linux-gnu/
#
## libgnutls30
#COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libgnutls* /usr/lib/${ARCH}-linux-gnu/
##COPY --from=builder /usr/share/locale/cs/LC_MESSAGES/gnutls30.mo /usr/share/locale/cs/LC_MESSAGES/gnutls30.mo
##COPY --from=builder /usr/share/locale/de/LC_MESSAGES/gnutls30.mo /usr/share/locale/de/LC_MESSAGES/gnutls30.mo
##COPY --from=builder /usr/share/locale/eo/LC_MESSAGES/gnutls30.mo /usr/share/locale/eo/LC_MESSAGES/gnutls30.mo
##COPY --from=builder /usr/share/locale/es/LC_MESSAGES/gnutls30.mo /usr/share/locale/es/LC_MESSAGES/gnutls30.mo
##COPY --from=builder /usr/share/locale/fi/LC_MESSAGES/gnutls30.mo /usr/share/locale/fi/LC_MESSAGES/gnutls30.mo
##COPY --from=builder /usr/share/locale/fr/LC_MESSAGES/gnutls30.mo /usr/share/locale/fr/LC_MESSAGES/gnutls30.mo
##COPY --from=builder /usr/share/locale/it/LC_MESSAGES/gnutls30.mo /usr/share/locale/it/LC_MESSAGES/gnutls30.mo
##COPY --from=builder /usr/share/locale/ka/LC_MESSAGES/gnutls30.mo /usr/share/locale/ka/LC_MESSAGES/gnutls30.mo
##COPY --from=builder /usr/share/locale/ms/LC_MESSAGES/gnutls30.mo /usr/share/locale/ms/LC_MESSAGES/gnutls30.mo
##COPY --from=builder /usr/share/locale/nl/LC_MESSAGES/gnutls30.mo /usr/share/locale/nl/LC_MESSAGES/gnutls30.mo
##COPY --from=builder /usr/share/locale/pl/LC_MESSAGES/gnutls30.mo /usr/share/locale/pl/LC_MESSAGES/gnutls30.mo
##COPY --from=builder /usr/share/locale/pt_BR/LC_MESSAGES/gnutls30.mo /usr/share/locale/pt_BR/LC_MESSAGES/gnutls30.mo
##COPY --from=builder /usr/share/locale/ro/LC_MESSAGES/gnutls30.mo /usr/share/locale/ro/LC_MESSAGES/gnutls30.mo
##COPY --from=builder /usr/share/locale/sr/LC_MESSAGES/gnutls30.mo /usr/share/locale/sr/LC_MESSAGES/gnutls30.mo
##COPY --from=builder /usr/share/locale/sv/LC_MESSAGES/gnutls30.mo /usr/share/locale/sv/LC_MESSAGES/gnutls30.mo
##COPY --from=builder /usr/share/locale/uk/LC_MESSAGES/gnutls30.mo /usr/share/locale/uk/LC_MESSAGES/gnutls30.mo
##COPY --from=builder /usr/share/locale/vi/LC_MESSAGES/gnutls30.mo /usr/share/locale/vi/LC_MESSAGES/gnutls30.mo
##COPY --from=builder /usr/share/locale/zh_CN/LC_MESSAGES/gnutls30.mo /usr/share/locale/zh_CN/LC_MESSAGES/gnutls30.mo
#
## libkeyutils1
#COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libkeyutils* /usr/lib/${ARCH}-linux-gnu/
#
## libp11-kit0
#COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libp11-kit* /usr/lib/${ARCH}-linux-gnu/
#
## libidn2-dev
#COPY --from=builder /usr/include/idn2.h /usr/include/
#COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libidn2* /usr/lib/${ARCH}-linux-gnu/
#
## libunistring2
#COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libunistring* /usr/lib/${ARCH}-linux-gnu/
#
## libtasn1-6
#COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libtasn1* /usr/lib/${ARCH}-linux-gnu/
#
## libnettle8
#COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libnettle* /usr/lib/${ARCH}-linux-gnu/
#
## libhogweed6
#COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libhogweed* /usr/lib/${ARCH}-linux-gnu/
#
## libgmp10
#COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libgmp* /usr/lib/${ARCH}-linux-gnu/
#
## libffi8
#COPY --from=builder /usr/lib/${ARCH}-linux-gnu/libffi* /usr/lib/${ARCH}-linux-gnu/
#
## wait4x (needed for Docker Compose)
#COPY --from=builder /usr/local/bin/wait4x /usr/local/bin/
#EXPOSE 3000
#ENTRYPOINT ["/app/bin/crawlcomply-serve"]
