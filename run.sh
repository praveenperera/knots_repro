
docker run --privileged -it --rm \
  -v guix_checkouts:/home/guix/.cache/guix/checkouts \
  -v guix_config:/home/guix/.config/guix \
  -v guix_profile:/home/guix/.guix-profile \
  -v guix_cache:/home/guix/.cache/guix \
  -v guix_store:/gnu/store \
  -v guix_var:/var/guix \
  -v $(pwd)/artifacts:/home/guix/artifacts \
  knots-guix:latest \
  bash
