#!/usr/bin/env bash
# exit on error
set -o errexit
bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
# bundle exec rails db:migrate:reset
#　db:seedを有効化 bundle exec rails db:migrate
#　db:seedを有効化で追加
DISABLE_DATABASE_ENVIRONMENT_CHECK=1
bundle exec rake db:migrate:reset 
bundle exec rake db:seed