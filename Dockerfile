FROM rockylinux/rockylinux:latest

RUN dnf upgrade -y && dnf install -y dnf-plugins-core epel-release && dnf upgrade -y

RUN dnf config-manager --set-enabled powertools

RUN dnf install -y git gcc make curl wget tar zlib procps-ng lua lua-libs diffutils \
                   zlib-devel glibc-devel openssl-devel  pcre-devel  lua-devel systemd-devel 

RUN mkdir /tmp/haproxy

WORKDIR /tmp/haproxy

RUN curl -#L "http://www.haproxy.org/download/2.5/src/haproxy-2.5.7.tar.gz" | tar --strip=1 -xzC "."

RUN make -C /tmp/haproxy -j $(nproc) TARGET=linux-glibc CPU=generic USE_PCRE2=1 USE_PCRE2_JIT=1 USE_OPENSSL=1 \
                            USE_TFO=1 USE_LINUX_TPROXY=1 USE_LUA=1 USE_GETADDRINFO=1 \
                            USE_PROMEX=1 USE_SLZ=1 USE_SYSTEMD=1 \
                            all