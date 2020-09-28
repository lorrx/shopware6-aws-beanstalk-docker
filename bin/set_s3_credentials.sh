#!/bin/bash

if [ "${S3_STORAGE}" == 1 ]; then
  cat ./s3.env >> .env
  mv ./config/packages/shopware."${MODE}".yml ./config/packages/shopware.yml
fi

