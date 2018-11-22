#!/bin/bash

APPID_PROD="28fa53f20fac4926be8257778d197870"
APPID_BETA="1f8d65a07bd84ea584e3ecb15ff66cf2"
APPID_DEV="38f0b83758044f7c1a628c484060da95"

case $1 in
  "dev")
    sed -i -r -e "s/(<iq:application[^\>]+id\=)\"(\w+)\"/\\1\"$APPID_DEV\"/" manifest.xml
    ;;
  "prod")
    sed -i -r -e "s/(<iq:application[^\>]+id\=)\"(\w+)\"/\\1\"$APPID_PROD\"/" manifest.xml
    ;;
  "beta")
    sed -i -r -e "s/(<iq:application[^\>]+id\=)\"(\w+)\"/\\1\"$APPID_BETA\"/" manifest.xml
    ;;
  *)
    echo "Flavor not recognized."
esac