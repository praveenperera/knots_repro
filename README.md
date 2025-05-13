## WIP

## Knots GUIX Deterministic Build

## Instructions

1. Clone this repo
2. Run `setup.sh` to download Xcode_15.xip
3. Build the docker image that will be used to build the knots with `sh build.sh`
4. Run the docker image with `sh run.sh`
5. Build the knots with `sh build.sh` (while inside the container), this will take a while
6. The artifacts will be in `artifacts` folder, sign them and make the PR (this part is left up to the reader)

### Cleanup

1. Remove the volumes with `sh clean.sh`
2. Remove downloaded Xcode_15.xip with `rm Xcode_15.xip`
3. Remove the docker image with `docker rmi knots-guix:latest`
