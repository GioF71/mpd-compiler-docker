#!/usr/bin/env bash
set -euo pipefail

ref_type="${REF_TYPE:-}"
ref_name="${REF_NAME:-}"
ref="${REF:-}"
distro_id="${DISTRO_ID:-}"
git_branch="${GIT_BRANCH:-version-0.24.13}"
image_name="${DOCKER_IMAGE_NAME:-}"

printf 'REF_TYPE: [%s]\n' "$ref_type"
printf 'REF_NAME: [%s]\n' "$ref_name"
printf 'REF: [%s]\n' "$ref"

build_platforms="linux/amd64,linux/arm64/v8,linux/arm/v7"
if [[ "$distro_id" == "trixie" ]]; then
  build_platforms="${build_platforms},linux/arm/v6,linux/arm/v5"
fi

declare -A base_image_from_matrix
base_image_from_matrix[trixie]=debian:trixie-slim
base_image_from_matrix[noble]=ubuntu:noble

declare -A base_tag_from_matrix
base_tag_from_matrix[trixie]=trixie-slim
base_tag_from_matrix[noble]=noble

declare -A mpd_versions
mpd_versions[master]=0.24.13
mpd_versions[version-0.24.13]=0.24.13

declare -A special_tags
special_tags[trixie]="${image_name}:stable,${image_name}:latest"
special_tags[noble]="${image_name}:ubuntu-current-lts"
special_tags[noble]="${image_name}:ubuntu-current"

base_image="${base_image_from_matrix[$distro_id]}"
mpd_version="${mpd_versions[$git_branch]}"
base_image_tag="${base_tag_from_matrix[$distro_id]}"

tags=""
if [ "$ref_type" = "branch" ]; then
  echo "branch mode"
  if [ "$ref_name" = "main" ]; then
    echo "main branch"
    tags="${image_name}:main-${distro_id}-${mpd_version}"
    tags="${tags},${image_name}:main-${distro_id}-${mpd_version}"
  elif [ "$ref_name" = "devel" ]; then
    echo "devel branch"
    tags="${image_name}:devel-${distro_id}-${mpd_version}"
  else
    echo "other branch [${ref_name}]"
    tags="${image_name}:branch-${ref_name}-${distro_id}-${mpd_version}"
  fi
elif [ "$ref_type" = "tag" ]; then
  echo "tag mode"
  echo "tag is [${ref_name}]"
  tag_type=$(echo "$ref_name" | cut -d '/' -f 1)
  tag_name=$(echo "$ref_name" | cut -d '/' -f 2)
  if [ "$tag_type" = "release" ]; then
    echo "release tag"
    echo "Building now: [$distro_id]"
    tags="$image_name:${distro_id}"
    if [[ -n "$base_image_tag" ]]; then
      tags="${tags},$image_name:${base_image_tag}"
    fi
    tags="${tags},$image_name:${distro_id}-${mpd_version}"
    tags="${tags},$image_name:${distro_id}-${mpd_version}-${tag_name}"
    select_special_tags=${special_tags["${distro_id}"]:-}
    if [[ -n "$select_special_tags" ]]; then
      echo "Found special tags for [${distro_id}]=[${select_special_tags}]"
      tags="${tags},${select_special_tags}"
    else
      echo "No special tag found for [${distro_id}]"
    fi
  elif [ "$tag_type" = "main" ]; then
    echo "main tag"
    tags="${image_name}:main-${tag_name}-${distro_id}-${mpd_version}"
  elif [ "$tag_type" = "devel" ]; then
    echo "devel tag"
    tags="${image_name}:devel-${tag_name}-${distro_id}-${mpd_version}"
  elif [ "$tag_type" = "feature" ]; then
    echo "feature tag"
    tags="${image_name}:feature-${tag_name}-${distro_id}-${mpd_version}"
  elif [ "$tag_type" = "daily" ]; then
    echo "daily build"
    tags="${image_name}:daily-${distro_id}"
    if [[ -n "$base_image_tag" ]]; then
      tags="${tags},$image_name:daily-${base_image_tag}"
    fi
    tags="${tags},${image_name}:daily-${distro_id}-${mpd_version}"
  fi
fi

echo "Building tags: [${tags}]"
echo "RELEASE_TAGS=${tags}" >> "$GITHUB_OUTPUT"
echo "BASE_IMAGE=${base_image}" >> "$GITHUB_OUTPUT"
echo "GIT_BRANCH=${git_branch}" >> "$GITHUB_OUTPUT"
echo "BUILD_PLATFORMS=${build_platforms}" >> "$GITHUB_OUTPUT"
