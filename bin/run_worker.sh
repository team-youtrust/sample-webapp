#!/bin/bash

set -euC -o pipefail

bundle exec sidekiq -C config/sidekiq.yml
