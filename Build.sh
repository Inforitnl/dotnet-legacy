#!/bin/bash

# return failing exit code if any command fails
set -e

# enable nullglob - allows filename patterns which match no files to expand to a null string, rather than themselves
shopt -s nullglob

ROOTDIRECTORY="/source"

# go to the workdir
if [ -n "$BITBUCKET_CLONE_DIR" ]; then
    cd "$BITBUCKET_CLONE_DIR" || return
    ROOTDIRECTORY="$BITBUCKET_CLONE_DIR"
else
    cd /source || return
fi

# Add nuget source if access token is set
if [ -n "$MYGET_ACCESS_TOKEN" ]; then
    echo "Adding private myget source"
    SOURCE="https://www.myget.org/F/inforit/auth/$MYGET_ACCESS_TOKEN/api/v3/index.json"
    VAR=$(sed "/<\/packageSources>/i <add key=\"inforit.org\" value=\"$SOURCE\" protocolVersion=\"3\" />" ~/.nuget/NuGet/NuGet.Config)
    echo "$VAR" > ~/.nuget/NuGet/NuGet.Config
    echo -e "\n@inforit:registry=https://www.myget.org/F/inforit/npm/\n//www.myget.org/F/inforit/npm/:_authToken=$MYGET_ACCESS_TOKEN" >> ~/.npmrc
fi

CS_PROJECT_NAME="Api"
DIST="$ROOTDIRECTORY/dist"

# change project name from default "Api"
if [ -n "$PROJECT_NAME" ]; then
  CS_PROJECT_NAME="$PROJECT_NAME"
fi

PROJECT_DIST="$DIST/$CS_PROJECT_NAME"
ARTIFACTS_DIST="$DIST/artifacts"

mkdir -p $ARTIFACTS_DIST

# Location of the back-end (always server in legacy projects)
cd server

echo "Building .NET solution"
nuget restore
msbuild *.sln

echo "Moving .NET artifact to output"
cd Inforit.*.Web
mv bin "$PROJECT_DIST"

echo "Moving .NET configurations to output"
find -type f -iname 'nlog.config' -exec cp {} $PROJECT_DIST \;
find -type f -iname 'appsettings.config'  -exec cp {} $PROJECT_DIST \;
find -type f -iname 'web.config'  -exec cp {} $PROJECT_DIST \;
find -type f -iname 'connectionstrings.config'  -exec cp {} $PROJECT_DIST \;

# build and copy the front-end artifact
cd "$ROOTDIRECTORY"/client
echo "Building the front-end artifact"

# nodejs is managed via nvm, it must be started to use nodejs commands
. ~/.nvm/nvm.sh
source ~/.bashrc
nvm use ${NODEVERSION}

npm install
npm run build --if-present
npm run test --if-present

echo "Moving the front-end artifact to output"
mv ./dist "$PROJECT_DIST"/client

# generate artifacts dir
echo "generating artifacts"
zip -r "$ARTIFACTS_DIST/$CS_PROJECT_NAME.zip" "$PROJECT_DIST/"
