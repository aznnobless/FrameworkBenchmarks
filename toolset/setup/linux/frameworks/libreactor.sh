#!/bin/bash

RETCODE=$(fw_exists ${IROOT}/libreactor.installed)
[ ! "$RETCODE" == 0 ] || { \
  # Load environment variables
  source $IROOT/libreactor.installed
  return 0; }

LIBREACTOR_HOME=$IROOT/libreactor_techempower

git clone https://github.com/fredrikwidlund/libreactor_techempower
cd $LIBREACTOR_HOME
./autogen.sh
./configure
make

echo "export LIBREACTOR_HOME=${LIBREACTOR_HOME}" >> $IROOT/libreactor.installed
echo -e "export PATH=\$LIBREACTOR_HOME/:\$PATH" >> $IROOT/libreactor.installed

source $IROOT/libreactor.installed
