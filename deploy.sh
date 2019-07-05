#!/bin/bash
GH_REPO="@github.com/$TRAVIS_REPO_SLUG.git"
FULL_REPO="https://$GH_TOKEN$GH_REPO"
git config --global user.name "Travis CI"
git config --global user.email "tim.trice@gmail.com"
git clone https://github.com/timtrice/ncdc_storm_events.git --branch $TRAVIS_BRANCH --single-branch
cd ncdc_storm_events
git checkout $TRAVIS_BRANCH
Rscript -e 'remotes::install_deps();'
Rscript --verbose code/02_get_data.R
Rscript -e 'workflowr::build()'
git add --force docs
MSG="Rebuild website #$TRAVIS_BUILD_NUMBER [skip ci]"
git commit -m "$MSG"
git push --force $FULL_REPO $TRAVIS_BRANCH
