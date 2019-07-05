#!/bin/bash
GH_REPO="@github.com/$TRAVIS_REPO_SLUG.git"
FULL_REPO="https://$GH_TOKEN$GH_REPO"
git config --global user.name "Travis CI"
git config --global user.email "tim.trice@gmail.com"
git clone https://github.com/timtrice/ncdc_storm_events.git --branch $TRAVIS_BRANCH --single-branch
cd ncdc_storm_events
# Since the data dir is ignored, it must be created in order for the database
# to be properly created.
# [Travis Build #66](https://travis-ci.org/timtrice/ncdc_storm_events/builds/554708489)
# [Install on Travis fails](https://github.com/JoshuaWise/better-sqlite3/issues/25)
mkdir output
Rscript --verbose code/03_load_data.R
Rscript -e 'workflowr::wflow_build()'

if [ ! -d "docs" ]
then
  echo "Docs directory does not exist"
  exit 1
fi

git add --force docs
MSG="Rebuild website #$TRAVIS_BUILD_NUMBER [skip ci]"
git commit -m "$MSG"
git push --force $FULL_REPO $TRAVIS_BRANCH
