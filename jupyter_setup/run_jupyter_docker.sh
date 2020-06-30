#!/usr/bin/env bash

# runs docker from local laptop
docker run --rm -it -v $(pwd):/root/notebooks -p 8888:8888 simple-nb
