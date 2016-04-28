FROM phusion/baseimage:0.9.18
MAINTAINER David Von Lehman <david@aerobatic.com>

ARG LC_ALL=C
ARG DEBIAN_FRONTEND=noninteractive

# Install the brightbox ruby repository
# https://www.brightbox.com/blog/2016/01/06/ruby-2-3-ubuntu-packages/
RUN apt-add-repository ppa:brightbox/ruby-ng

RUN apt-get update && apt-get install -y zlibc libgcrypt11-dev zlib1g-dev build-essential git

# Install native libraries used by build tools
RUN apt-get -y install imagemagick=8:6.7.7.10-6ubuntu3 phantomjs=1.9.0-1

# Install ruby
RUN apt-get install -y -q ruby2.3 ruby2.3-dev

# Install bundler
RUN gem install rake bundler --no-rdoc --no-ri

# Download latest node 4.x distribution
# https://github.com/nodesource/distributions
RUN curl --fail -ssL -o /tmp/setup-nodejs https://deb.nodesource.com/setup_4.x && \
  bash /tmp/setup-nodejs && rm -f /tmp/setup-nodejs

# Install nodejs and update npm to latest version
RUN apt-get install -y nodejs && npm update npm -g

# Install Python and pip
RUN apt-get install -y python2.7 python-dev python-pip

######## static site generators #####################

# Install Jekyll and Middleman
RUN gem install \
  jekyll:3.1.3 \
  middleman:4.1.7 \
  --no-rdoc --no-ri

# Install common jekyll plugins
RUN gem install jekyll-scholar:5.8.0 \
  jekyll-seo-tag:1.4.0 \
  jekyll-assets:2.1.3 \
  jekyll-press:0.2.1 \
  jekyll-lunr-js-search:3.1.0 \
  pygments.rb:0.6.3 \
  rouge:1.10.1 \
  --no-rdoc --no-ri

# Update npm and install node based static generators
RUN npm install hexo-cli@1.0.1 \
 gatsby@0.10.0 \
 wintersmith@2.3.1 \
 metalsmith@2.1.0 \
 roots@4.1.0 \
 webpack@1.13.0 \
 gulp@3.9.1 \
 grunt@1.0.1 \
 bower@1.7.9 -g

# Install Hugo
RUN curl --fail -ssL -o /tmp/setup-hugo https://github.com/spf13/hugo/releases/download/v0.15/hugo_0.15_amd64.deb && \
  dpkg -i /tmp/setup-hugo && rm -f /tmp/setup-hugo

# Install pygments
RUN apt-get install python-pygments=1.6+dfsg-1ubuntu1
RUN pip install Pygments==2.1.3 \
  pygments-github-lexers==0.01

# Install python based static site generators
RUN pip install pelican==3.6.3 \
  lektor==2.2 \
  awscli==1.10.3

# Set common environment variables
ENV NODE_ENV=production
ENV JEKYLL_ENV=production
ENV LC_ALL=en_US.UTF-8

COPY install-cli.sh /
