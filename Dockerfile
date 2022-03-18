FROM ubuntu:impish
RUN apt-get update && \
    apt install -y gnupg ca-certificates && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt install -y nuget mono-complete mono-devel msbuild
RUN DEBIAN_FRONTEND=noninteractive apt install -y nodejs npm

RUN mkdir -p /source
RUN mkdir -p /output
WORKDIR /source

ADD Build.sh /Build.sh
CMD ["/bin/bash", "/Build.sh"]

# Opruimen !!!