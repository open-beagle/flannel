# /bin/bash

mkdir -p dist

set -ex
export GOARCH=amd64
make -e dist/flanneld
mv dist/flanneld dist/flanneld-linux-$GOARCH

export GOARCH=arm64 
export CC=aarch64-linux-gnu-gcc
make -e dist/flanneld
mv dist/flanneld dist/flanneld-linux-$GOARCH

export GOARCH=ppc64le 
export CC=powerpc64le-linux-gnu-gcc
make -e dist/flanneld
mv dist/flanneld dist/flanneld-linux-$GOARCH