#!/bin/bash

# error codes
# 2 Invalid base image

declare -A base_images
base_images[sid]=debian:sid-slim
base_images[trixie]=debian:trixie-slim
base_images[bookworm]=debian:bookworm-slim
base_images[bullseye]=debian:bullseye-slim
base_images[resolute]=ubuntu:resolute
base_images[noble]=ubuntu:noble

declare -A local_tag
local_tag[sid]=local-sid
local_tag[trixie]=local-trixie
local_tag[bookworm]=local-bookworm
local_tag[bullseye]=local-bullseye
local_tag[resolute]=local-resolute
local_tag[noble]=local-noble

DEFAULT_BASE_IMAGE=trixie
DEFAULT_TAG=local
DEFAULT_GIT_VERSION=version-0.24.13

tag=""
git_branch="$DEFAULT_GIT_VERSION"

while getopts b:t:p:g: flag
do
    case "${flag}" in
        b) base_image=${OPTARG};;
        t) tag=${OPTARG};;
        g) git_branch=${OPTARG};;
    esac
done

echo "base_image: $base_image";
echo "tag: $tag";
echo "git_branch: [$git_branch]";

if [ -z "${base_image}" ]; then
  base_image=$DEFAULT_BASE_IMAGE
fi

expanded_base_image=${base_images[$base_image]}
if [ -z "${expanded_base_image}" ]; then
  echo "invalid base image ["${base_image}"]"
  exit 2
fi

if [[ -z "$tag" ]]; then
  select_tag=${local_tag[$base_image]}
  if [[ -n "$select_tag" ]]; then
    tag=$select_tag
  else
    tag=$DEFAULT_TAG
  fi
fi

if [ -z "${git_branch}" ]; then
  git_branch="${DEFAULT_GIT_VERSION}"
fi

echo "Base Image: ["$expanded_base_image"]"
echo "Tag: ["$tag"]"
echo "Git Branch: ["$git_branch"]"

docker build . \
    --build-arg BASE_IMAGE=${expanded_base_image} \
    --build-arg USE_GIT_BRANCH=${git_branch} \
    -t giof71/mpd-compiler:$tag
