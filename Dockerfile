# install build tools
FROM ubuntu:kinetic AS base
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && \
    apt-get install -y --no-install-recommends gnupg ca-certificates && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends nuget mono-runtime mono-devel msbuild curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN touch ~/.bashrc && chmod +x ~/.bashrc
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# customize build environment, add build script
FROM base as dotnetbuild
RUN mkdir -p /source
RUN mkdir -p /output
WORKDIR /source
COPY NuGet.Config /root/.nuget/NuGet/NuGet.Config
COPY Build.sh /Build.sh
CMD ["/bin/bash", "/Build.sh"]

# build this stage for global quote
FROM dotnetbuild as globalquotebuild
ENV NODEVERSION=14.16.1
RUN . ~/.nvm/nvm.sh && source ~/.bashrc && nvm install ${NODEVERSION} 

# build this stage for the rest of TF2 apps
FROM dotnetbuild as defaultbuild
ENV NODEVERSION=19.8.1
RUN . ~/.nvm/nvm.sh && source ~/.bashrc && nvm install ${NODEVERSION} 