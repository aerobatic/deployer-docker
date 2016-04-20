FROM phusion/baseimage:0.9.18
MAINTAINER David Von Lehman <david@aerobatic.com>

ARG LC_ALL=C
ARG DEBIAN_FRONTEND=noninteractive

# Install the brightbox ruby repository
# https://www.brightbox.com/blog/2016/01/06/ruby-2-3-ubuntu-packages/
RUN apt-add-repository ppa:brightbox/ruby-ng

RUN apt-get update && apt-get install -y zlibc libgcrypt11-dev zlib1g-dev build-essential git

# Install native libraries used by build tools
RUN apt-get -y install imagemagick phantomjs

# Install ruby
RUN apt-get install -y -q ruby2.3 ruby2.3-dev

# Install bundler and ruby based static generators
RUN gem install rake bundler jekyll middleman --no-rdoc --no-ri

# Install nodejs
# https://github.com/nodesource/distributions
RUN curl --fail -ssL -o /tmp/setup-nodejs https://deb.nodesource.com/setup_4.x && \
  bash /tmp/setup-nodejs && rm -f /tmp/setup-nodejs

# Install nodejs and update npm to latest version
RUN apt-get install -y nodejs

# Install Python and pip
RUN apt-get install -y python2.7 python-dev python-pip

######## static site generators #####################

# Install common jekyll plugins
RUN gem install jekyll-scholar jekyll-seo-tag jekyll-assets jekyll-press jekyll-lunr-js-search --no-rdoc --no-ri

# Update npm and install node based static generators
RUN npm update npm -g && npm install hexo-cli gatsby wintersmith webpack gulp grunt -g

# Install Hugo
RUN curl --fail -ssL -o /tmp/setup-hugo https://github.com/spf13/hugo/releases/download/v0.15/hugo_0.15_amd64.deb && \
  dpkg -i /tmp/setup-hugo && rm -f /tmp/setup-hugo

# Install python based static site generators
RUN pip install pelican pygments

ENV NODE_ENV=production
ENV JEKYLL_ENV=production
ENV LC_ALL=en_US.UTF-8

# Install the Aerobatic deployer tool
RUN npm install -g aerobatic/aerobatic-cli
