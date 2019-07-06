FROM rocker/rstudio:3.6.0

ARG REPO_URL="https://github.com/timtrice/ncdc_storm_events.git"
ARG DIR="ncdc_storm_events"

ENV ENV_REPO_URL=$REPO_URL
ENV ENV_DIR=$DIR

RUN apt-get update \
  && apt-get install -y \
    libgdal-dev \
    libpng-dev \
    libudunits2-dev \
    libxml2-dev \
    vim

RUN cd /home/rstudio \
  && git clone -v $ENV_REPO_URL --branch workflowr --single-branch \
  && cd $ENV_DIR \
  && Rscript -e 'install.packages(c("remotes"));' \
  && Rscript -e 'if (!all(c("remotes") %in% installed.packages())) { q(status = 1, save = "no")};' \
  && Rscript -e 'deps <- remotes::dev_package_deps(dependencies = NA);remotes::install_deps(dependencies = TRUE);if (!all(deps$package %in% installed.packages())) { message("missing: ", paste(setdiff(deps$package, installed.packages()), collapse=", ")); q(status = 1, save = "no")}'
