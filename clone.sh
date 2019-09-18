#!/bin/bash

set -u

function usage {
    echo "${0} repository"
    exit 1
}

function die {
    echo "${1}"
    exit 1
}

repository="${1:-}"
test -z "${repository}" && usage

dir_name="$( dirname "${0}" )"
config_file=config.properties
config_path="${dir_name}/${config_file}"
test -f "${dir_name}/config.properties" || die "ERROR: ${config_path} not found"

source "${config_path}"
test -z "${github_organization:-}" && die "ERROR: github_organization not set"
test -z "${github_username:-}" && die "ERROR: github_username not set"
test -z "${branches:-}" && die "ERROR: branches not set"

user_url="git@github.com:${github_username}/${repository}.git"
organization_url="git@github.com:${github_organization}/${repository}.git"

git clone "${user_url}" || die "failed to clone ${user_url}"
cd "${repository}"
git remote add "${github_organization}" "${organization_url}"
git fetch "${github_organization}"

for branch in ${branches}; do
    git checkout "${branch}"

    if [ $? -ne 0 ]; then
        git checkout "${github_organization}/${branch}" || continue
        git checkout -b "${branch}"
    fi

    git branch -u "${github_organization}/${branch}"
    git reset --hard "${github_organization}/${branch}"
    git pull
done
