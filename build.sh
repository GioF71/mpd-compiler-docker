#!/bin/bash

# error codes
# 2 Invalid base image
# 3 Invalid proxy parameter

declare -A base_images
base_images[bookworm]=debian:bookworm-slim
base_images[buster]=debian:buster-slim
base_images[bullseye]=debian:bullseye-slim
base_images[jammy]=ubuntu:jammy
base_images[kinetic]=ubuntu:kinetic
base_images[focal]=ubuntu:focal
base_images[bionic]=ubuntu:bionic

declare -A local_tag
local_tag[bookworm]=local-bookworm
local_tag[buster]=local-buster
local_tag[bullseye]=local-bullseye
local_tag[jammy]=local-jammy
local_tag[kinetic]=local-kinetic
local_tag[focal]=local-focal
local_tag[bionic]=local-bionic

declare -A libfmt_dict
libfmt_dict[bullseye]=libfmt7
libfmt_dict[bookworm]=libfmt9

DEFAULT_BASE_IMAGE=bullseye
DEFAULT_TAG=local
DEFAULT_USE_PROXY=N
DEFAULT_GIT_VERSION=version-0.23.12

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

select_tag=${local_tag[$base_image]}
if [[ -n "$select_tag" ]]; then
  tag=$select_tag
else
  tag=$DEFAULT_TAG
fi

libfmt_package_name=${libfmt_dict[$base_image]}
if [ -z "${libfmt_package_name}" ]; then
  echo "Table entry for libfmt package is missing for ["${base_image}"], probably not needed, ignoring."
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
echo "Package name libfmt: [$libfmt_package_name]"
echo "Proxy: ["$proxy"]"
echo "Git Branch: ["$git_branch"]"

docker build . \
    --build-arg BASE_IMAGE=${expanded_base_image} \
    --build-arg USE_APT_PROXY=${proxy} \
    --build-arg USE_GIT_BRANCH=${git_branch} \
    --build-arg LIBFMT_PACKAGE_NAME=${libfmt_package_name} \
    -t giof71/mpd-compiler:$tag
