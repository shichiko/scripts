#!/bin/bash

issue_key="${1:-}"
test -n "${issue_key}" && issue_key="${issue_key}: "

function die {
    >&2 echo "$1"
    exit "$2"
}

git checkout master || die "failed to checkout master"
git pull || die "failed to update master"
git branch -D dsmith
git checkout -b dsmith || die "failed to create dsmith" 1
touch dsmith.txt
git add dsmith.txt
git commit -m "${issue_key}adding dsmith.txt"
