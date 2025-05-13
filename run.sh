docker run --privileged -it --rm \
  -v $(pwd)/volumes/guix_checkouts:/root/.cache/guix/checkouts \
  -v $(pwd)/volumes/guix_config:/root/.config/guix \
  -v $(pwd)/volumes/guix_profile:/root/.guix-profile \
  -v $(pwd)/volumes/guix_store:/gnu/store \
  -v $(pwd)/volumes/guix_cache:/root/.cache/guix \
  -v $(pwd)/volumes/guix_var:/var/guix \
  -v $(pwd)/volumes/artifacts:/artifacts \
  knots-guix:latest \
  bash
