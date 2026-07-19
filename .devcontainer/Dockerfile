FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

# --- System dependencies ---
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    openssh-client \
    tzdata \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    libyaml-dev \
    libpq-dev \
    libffi-dev \
    libxml2-dev \
    libxslt1-dev \
    imagemagick \
    libmagickwand-dev \
    file \
    fontconfig \
    wkhtmltopdf \
    wget \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# --- Node.js (LTS) + Yarn ---
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists/*

# --- Chromium (headless browser for Capybara/Cuprite system specs) ---
# Ubuntu's chromium/chromium-browser apt packages are snap stubs and don't work
# in containers. Google Chrome only ships amd64 .deb packages, but this image
# runs arm64 natively on Apple Silicon hosts, so Chrome isn't installable here.
# Playwright ships an officially-supported, real arm64 Linux Chromium build, so
# use that instead and expose it at a stable path.
ENV PLAYWRIGHT_BROWSERS_PATH=/opt/playwright-browsers
RUN npm install -g playwright && \
    playwright install --with-deps chromium && \
    ln -s "$(find $PLAYWRIGHT_BROWSERS_PATH -maxdepth 4 -name chrome -type f | head -n1)" /usr/local/bin/chromium

# --- Ruby via rbenv ---
ENV RBENV_ROOT=/usr/local/rbenv
ENV PATH=$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH
RUN git clone https://github.com/rbenv/rbenv.git $RBENV_ROOT && \
    git clone https://github.com/rbenv/ruby-build.git $RBENV_ROOT/plugins/ruby-build

ARG RUBY_VERSION=3.3.12
RUN rbenv install $RUBY_VERSION && rbenv global $RUBY_VERSION

RUN gem install bundler -v 2.4.22

# --- Non-root user (matches devcontainer convention) ---
ARG USERNAME=vscode
RUN useradd -m -s /bin/bash $USERNAME
RUN chown -R $USERNAME:$USERNAME $RBENV_ROOT $PLAYWRIGHT_BROWSERS_PATH
USER $USERNAME

WORKDIR /workspace