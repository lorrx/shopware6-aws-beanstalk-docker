#!/bin/bash
bin/console theme:compile
bin/console asset:install
bin/console sitemap:generate
bin/console cache:clear
bin/console http:cache:warm:up
