#!/bin/bash

rm -f tmp/pids/server.pid
bundle exec rails tmp:cache:clear

bundle exec rails s -p 3000 -b 0.0.0.0
