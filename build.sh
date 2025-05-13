docker buildx build --platform linux/amd64 --build-arg XCODE_XIP=Xcode_15.xip --build-arg KNOTS_TAG=v28.1.knots20250305 -t knots-guix:latest .
