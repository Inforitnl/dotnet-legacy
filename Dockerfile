FROM ubuntu:lunar AS base
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && \
    apt-get install -y --no-install-recommends gnupg ca-certificates && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends nuget mono-runtime mono-devel msbuild && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

FROM base as build
RUN mkdir -p /source
RUN mkdir -p /output
WORKDIR /source
COPY NuGet.Config /root/.nuget/NuGet/NuGet.Config
COPY Build.sh /Build.sh
CMD ["/bin/bash", "/Build.sh"]