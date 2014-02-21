#!/bin/bash

COMMIT_FILE="last_commit"
NIKOLA_REPO="$HOME/github.io/"
PAGES_REPO="$HOME/mathbio.github.io/"

pushd $NIKOLA_REPO
git pull

CUR=$(git log -n1 | head -n1 | cut -d' ' -f2)
OLD=$(<$COMMIT_FILE)

if [ "$CUR" != "$OLD" ]
then
    nikola build
    pushd $PAGES_REPO
    MESSAGE=$(git log --pretty=oneline  ${CUR}..HEAD | cut -d' ' -f 2- | xargs echo -n)
    git add --all .
    git commit -a -m $MESSAGE
    git push

    popd
    echo "$CUR" > $COMMIT_FILE
fi

popd
