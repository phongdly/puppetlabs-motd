#!/bin/bash

# Init
SCRIPT_PATH=$(pwd)
BASENAME_CMD="basename ${SCRIPT_PATH}"
SCRIPT_BASE_PATH=`eval ${BASENAME_CMD}`

if [ $SCRIPT_BASE_PATH = "test_run_scripts" ]; then
  cd ../
fi

# Work-around for RE-5005
export SSL_CERT_FILE=/usr/local/etc/openssl/cert.pem

export pe_upgrade_dir="http://enterprise.delivery.puppetlabs.net/2015.3/ci-ready"
export GEM_SOURCE=http://rubygems.delivery.puppetlabs.net

bundle install --without build development test --path .bundle/gems

bundle exec beaker \
  --no-provision \
  --host log/latest/hosts_preserved.yml \
  --debug \
  --pre-suite setup/upgrade.rb \
  --test acceptance/tests/file-sync/file-sync_commit.rb \
  --keyfile ~/.ssh/id_rsa-acceptance \
  --load-path lib
