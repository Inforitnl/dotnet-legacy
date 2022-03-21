# DotnetNetBuildContainer

[![logo](./logo.jpg)](https://inforit.nl)

Docker image to automate legacy asp.net/angular builds

## Instructions

1. update dockerfile
2. build local version:

   ```sh
   docker build -t inforitnl/dotnet-legacy .
   ```

3. push new version to dockerhub:

   ```sh
   docker push inforitnl/dotnet-legacy
   ```

4. tag and push again (optional but recommended):

   ```sh
   docker tag inforitnl/dotnet-legacy inforitnl/dotnet-legacy:1
   docker push inforitnl/dotnet-legacy:1
   ```

## Usage

```sh
image: inforitnl/dotnet-legacy

pipelines:
  default:
    - step:
        script:
          - /Build.sh
```

## scripts

| Command | Description                         |
| ------- | ----------------------------------- |
| build   | build the container with latest tag |
| push    | pushes the container                |
