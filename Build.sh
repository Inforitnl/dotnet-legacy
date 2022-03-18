#!/bin/bash

ROOTDIRECTORY="/source"
BINDIRECTORY="${BINDIRECTORY:-"/source/server/Inforit.*.Web/bin"}"

# go to the workdir
if [ -n "$BITBUCKET_CLONE_DIR" ]
then
    cd "$BITBUCKET_CLONE_DIR" || return
    ROOTDIRECTORY="$BITBUCKET_CLONE_DIR"
else
    cd /source || return
fi

cd server

nuget restore
msbuild *.sln
mv $BINDIRECTORY /output/
cd $BINDIRECTORY
cd ..
mv Nlog.config /output/
mv appsettings.config /output/
mv Web.config /output/
mv connectionstrings.config /output/

cd $ROOTDIRECTORY/client
npm install
npm run build
mv ./dist /output/client