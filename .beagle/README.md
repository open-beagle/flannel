# flannel-io/flannel

<!-- https://github.com/flannel-io/flannel -->

```bash
git remote add upstream git@github.com:flannel-io/flannel.git

git fetch upstream

git merge v0.21.3
```

## build

```bash
# golang cache
docker run -it --rm \
-w /go/src/github.com/flannel-io/flannel \
-v $PWD/:/go/src/github.com/flannel-io/flannel \
registry.cn-qingdao.aliyuncs.com/wod/golang:1.19-alpine \
rm -rf vendor && go mod vendor

# golang build
docker run -it --rm \
-w /go/src/github.com/flannel-io/flannel \
-v $PWD/:/go/src/github.com/flannel-io/flannel \
-e TAG=v0.21.3 \
registry.cn-qingdao.aliyuncs.com/wod/golang:1.19 \
bash .beagle/build.sh

# alpine test
docker run -it --rm \
-w /go/src/github.com/flannel-io/flannel \
-v $PWD/:/go/src/github.com/flannel-io/flannel \
registry.cn-qingdao.aliyuncs.com/wod/alpine:3 \
dist/flanneld-linux-amd64 --version
```

## docker

```bash
# docker-arm64
docker build \
  --build-arg BASE=registry.cn-qingdao.aliyuncs.com/wod/alpine:3-arm64 \
  --build-arg AUTHOR=mengkzhaoyun@gmail.com \
  --build-arg VERSION=v0.21.3 \
  --build-arg TARGETOS=linux \
  --build-arg TARGETARCH=arm64 \
  --tag registry.cn-qingdao.aliyuncs.com/wod/flannel:v0.21.3-arm64 \
  --file .beagle/dockerfile .
```

## cache

```bash
# 构建缓存-->推送缓存至服务器
docker run --rm \
  -e PLUGIN_REBUILD=true \
  -e PLUGIN_ENDPOINT=$PLUGIN_ENDPOINT \
  -e PLUGIN_ACCESS_KEY=$PLUGIN_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$PLUGIN_SECRET_KEY \
  -e DRONE_REPO_OWNER="open-beagle" \
  -e DRONE_REPO_NAME="flannel" \
  -e PLUGIN_MOUNT=".git,vendor" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0

# 读取缓存-->将缓存从服务器拉取到本地
docker run --rm \
  -e PLUGIN_RESTORE=true \
  -e PLUGIN_ENDPOINT=$PLUGIN_ENDPOINT \
  -e PLUGIN_ACCESS_KEY=$PLUGIN_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$PLUGIN_SECRET_KEY \
  -e DRONE_REPO_OWNER="open-beagle" \
  -e DRONE_REPO_NAME="flannel" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0
```