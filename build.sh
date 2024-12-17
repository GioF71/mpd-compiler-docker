#!/bin/bash

# error codes
# 2 Invalid base image
# 3 Invalid proxy parameter

declare -A base_images
base_images[sid]=debian:sid-slim
base_images[trixie]=debian:trixie-slim
base_images[bookworm]=debian:bookworm-slim
base_images[buster]=debian:buster-slim
base_images[bullseye]=debian:bullseye-slim
base_images[noble]=ubuntu:noble
base_images[mantic]=ubuntu:mantic
base_images[lunar]=ubuntu:lunar
base_images[kinetic]=ubuntu:kinetic
base_images[jammy]=ubuntu:jammy
base_images[focal]=ubuntu:focal
base_images[bionic]=ubuntu:bionic

declare -A local_tag
local_tag[sid]=local-sid
local_tag[trixie]=local-trixie
local_tag[bookworm]=local-bookworm
local_tag[buster]=local-buster
local_tag[bullseye]=local-bullseye
local_tag[noble]=local-noble
local_tag[mantic]=local-mantic
local_tag[lunar]=local-lunar
local_tag[kinetic]=local-kinetic
local_tag[jammy]=local-jammy
local_tag[focal]=local-focal
local_tag[bionic]=local-bionic

DEFAULT_BASE_IMAGE=bookworm
DEFAULT_TAG=local
DEFAULT_USE_PROXY=N
DEFAULT_GIT_VERSION=version-0.23.16

tag=""
git_branch="$DEFAULT_GIT_VERSION"

while getopts b:t:p:g: flag
do
    case "${flag}" in
        b) base_image=${OPTARG};;
        t) tag=${OPTARG};;
        p) proxy=${OPTARG};;
        g) git_branch=${OPTARG};;
    esac
done

echo "base_image: $base_image";
echo "tag: $tag";
echo "proxy: [$proxy]";
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

if [ -z "${proxy}" ]; then
  proxy="N"
fi

if [[ "${proxy}" == "Y" || "${proxy}" == "y" ]]; then  
  proxy="Y"
elif [[ "${proxy}" == "N" || "${proxy}" == "n" ]]; then  
  proxy="N"
else
  echo "invalid proxy parameter ["${proxy}"]"
  exit 3
fi

if [ -z "${git_branch}" ]; then
  git_branch="${DEFAULT_GIT_VERSION}"
fi

echo "Base Image: ["$expanded_base_image"]"
echo "Tag: ["$tag"]"
echo "Proxy: ["$proxy"]"
echo "Git Branch: ["$git_branch"]"

docker build . \
    --build-arg BASE_IMAGE=${expanded_base_image} \
    --build-arg USE_APT_PROXY=${proxy} \
    --build-arg USE_GIT_BRANCH=${git_branch} \
    -t giof71/mpd-compiler:$tag
