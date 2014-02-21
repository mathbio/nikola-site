#!/bin/bash

COMMIT_FILE="last_commit"
NIKOLA_REPO="$HOME/github.io/"
PAGES_REPO="$HOME/mathbio.github.io/"
NIKOLA="$HOME/nikpy/bin/nikola"

check_new_posts(){
    pushd $NIKOLA_REPO
    for i in posts/*ipynb
    do
        if [ ! -e "${i%ipynb}meta" ]
        then
            TITLE=$(basename "$i" .ipynb)
            # we need to take the file out of the posts/ folder
            mv "$i" "${TITLE}.ipynb"
            # some trickery to get the metadata file name
            FNAME=$($NIKOLA new_post -f ipynb -t "$TITLE" | tail -n1 | rev | cut -d' ' -f1 | rev)
            mv "${TITLE}.ipynb" "$i"
            git mv -f "${TITLE}.ipynb" "${FNAME%meta}ipynb"
            git add \*ipynb posts/*
            git commit -m "AUTO: handling post ${TITLE}"
        fi
    done

    popd
}


pushd $NIKOLA_REPO
git pull

CUR=$(git log -n1 | head -n1 | cut -d' ' -f2)
OLD=$(<$COMMIT_FILE)

if [ "$CUR" != "$OLD" ]
then
    check_new_posts
    $NIKOLA build
    if [ $? -eq 0 ]
    then
        MESSAGE=$(git log --pretty=oneline  "${OLD}..HEAD" | cut -d' ' -f 2- | xargs echo -n)
        pushd $PAGES_REPO
        git add --all .
        git commit -a -m "AUTO: $MESSAGE"
        if [ $? -eq 0 ]
        then
            git push

            pushd $NIKOLA_REPO
            NEWCUR=$(git log -n1 | head -n1 | cut -d' ' -f2)
            echo "$NEWCUR" > $COMMIT_FILE
            popd
        fi
    else
        git checkout posts/
    fi
fi

popd 2
