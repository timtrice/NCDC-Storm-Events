#!/bin/bash
GH_REPO="@github.com/$TRAVIS_REPO_SLUG.git"
FULL_REPO="https://$GH_TOKEN$GH_REPO"
git config --global user.name "Travis CI"
git config --global user.email "tim.trice@gmail.com"
git clone https://github.com/timtrice/ncdc_storm_events.git
cd ncdc_storm_events
git checkout $TRAVIS_BRANCH
Rscript --verbose R/01_install_packages.R
rm -r docs
Rscript -e 'rmarkdown::render_site(".");'

if [ ! -d "docs" ]
then
  echo "Docs directory does not exist"
  exit 1
fi

git add --force docs
MSG="Rebuild website, (Travis Build #$TRAVIS_BUILD_NUMBER) [skip ci]"
git commit -m "$MSG"
git push --force $FULL_REPO $TRAVIS_BRANCH
Rscript -e 'remotes::install_github("karthik/holepunch");'
Rscript -e 'holepunch::build_binder();'
