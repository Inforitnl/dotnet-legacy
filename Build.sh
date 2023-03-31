#!/bin/bash

# return failing exit code if any command fails
set -e

# enable nullglob - allows filename patterns which match no files to expand to a null string, rather than themselves
shopt -s nullglob

ROOTDIRECTORY="/source"
PROJECTDIRECTORY=Inforit.*.Web

# go to the workdir
if [ -n "$BITBUCKET_CLONE_DIR" ]
then
    cd "$BITBUCKET_CLONE_DIR" || return
    ROOTDIRECTORY="$BITBUCKET_CLONE_DIR"
else
    cd /source || return
fi

# Add nuget source if access token is set
if [ -n "$MYGET_ACCESS_TOKEN" ]
then
    echo "Adding private myget source"
    SOURCE="https://www.myget.org/F/inforit/auth/$MYGET_ACCESS_TOKEN/api/v3/index.json"
    VAR=$(sed "/<\/packageSources>/i <add key=\"inforit.org\" value=\"$SOURCE\" protocolVersion=\"3\" />" ~/.nuget/NuGet/NuGet.Config)
    echo "$VAR" > ~/.nuget/NuGet/NuGet.Config
fi

# Location of the back-end (always server in legacy projects)
cd server


echo "Building .NET solution"
nuget restore
msbuild *.sln

echo "Moving .NET artifact to output"
cd $PROJECTDIRECTORY
mv bin /output/

echo "Moving .NET configurations to output"
mv NLog.default.config /output/NLog.config
mv appsettings.default.config /output/appsettings.config
mv Web.config /output/
mv connectionstrings.default.config /output/connectionstrings.config

# build and copy the front-end artifact
cd "$ROOTDIRECTORY"/client
echo "Building node.js"
npm install
npm run build --if-present
npm run test --if-present

echo "Moving node.js artifact to output"
mv ./dist /output/client