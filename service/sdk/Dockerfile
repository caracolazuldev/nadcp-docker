ARG FROM_IMAGE=php-apache:8.0
FROM ${FROM_IMAGE}

# NB: arguments are scoped by build-stage
# so the following args must be declared after FROM

ARG LOGIN_UID=1000
ARG LOGIN_GID=${LOGIN_UID}
ARG USER_NAME=cividev

# NB: less is required by wp-cli
# leaving-out sudo because: why are you doing sysadmin inside a container?

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
  && apt-get install -y --no-install-recommends \
  acl \
  build-essential \
  bash-completion \
  default-mysql-client \
  git \
  less nano vim \
  nodejs \
  pandoc \
  ssh rsync \
  sudo \
  unzip zip \
  && rm -r /var/lib/apt/lists/*

USER root
WORKDIR /root
RUN git clone https://github.com/ginkgomzd/make-do.git
RUN make -C make-do install && rm -rf make-do

RUN addgroup --gid=$LOGIN_GID $USER_NAME
RUN useradd --create-home --uid ${LOGIN_UID} --gid ${LOGIN_GID} \
  --home-dir /home/${USER_NAME} ${USER_NAME}
COPY sudo /etc/sudoers.d/${USER_NAME}

RUN adduser ${USER_NAME} www-data

USER ${USER_NAME}
WORKDIR /home/${USER_NAME}
