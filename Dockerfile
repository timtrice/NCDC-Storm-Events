FROM rocker/rstudio:3.6.0

ARG REPO_URL="https://github.com/timtrice/ncdc_storm_events.git"
ARG DIR="ncdc_storm_events"
ARG GIT_USER_NAME="Tim Trice"
ARG GIT_USER_EMAIL="tim.trice@gmail.com"

ENV ENV_REPO_URL=$REPO_URL
ENV ENV_DIR=$DIR
ENV ENV_GIT_USER_NAME=$GIT_USER_NAME
ENV ENV_GIT_USER_EMAIL=$GIT_USER_EMAIL

RUN apt-get update \
  && apt-get -y install --no-install-recommends \
    libgdal-dev \
    libpng-dev \
    libudunits2-dev \
    libxml2-dev \
    vim \
  && rm -rf /var/lib/apt/lists/*

RUN cd /home/rstudio \
  && git clone -v $ENV_REPO_URL --branch workflowr --single-branch \
  && cd $ENV_DIR \
  && Rscript -e 'install.packages(c("remotes"));' \
  && Rscript -e 'if (!all(c("remotes") %in% installed.packages())) { q(status = 1, save = "no")};' \
  && Rscript -e 'deps <- remotes::dev_package_deps(dependencies = NA);remotes::install_deps(dependencies = TRUE);if (!all(deps$package %in% installed.packages())) { message("missing: ", paste(setdiff(deps$package, installed.packages()), collapse=", ")); q(status = 1, save = "no")}' \
  && chown rstudio:rstudio . \
  && wget -q https://gist.githubusercontent.com/timtrice/7f5f5e403d6c3ec0ab5ef4b62caab0ca/raw/ad9ec1d526ee261d1cf7daaf23163d6334b39670/rstudio-server-global-options -O /home/rstudio/.rstudio/monitored/user-settings/user-settings \
  && git config --global user.name $(GIT_USER_NAME) \
  && git config --global user.email $(GIT_USER_EMAIL)
