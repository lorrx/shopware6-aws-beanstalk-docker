#!/bin/bash

if [ "${MODE}" == "dev" ]; then
  cat ./dev.env > .env
else
  cat ./prod.env > .env
fi
