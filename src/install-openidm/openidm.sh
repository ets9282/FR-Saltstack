#!/bin/sh

# chkconfig: 345 95 5
# description: start/stop openidm

# clean up left over pid files if necessary
cleanupPidFile() {
  if [ -f $OPENIDM_PID_FILE ]; then
    rm -f "$OPENIDM_PID_FILE"
  fi
  trap - EXIT
  exit
}

JAVA_HOME={{ pillar['jdk']['java_home']}}
JAVA_BIN=${JAVA_HOME}/bin/java
OPENIDM_HOME={{ pillar['forgerock']['forgerock-home']}}/openidm
OPENIDM_PID_FILE=$OPENIDM_HOME/.openidm.pid
OPENIDM_OPTS=""

# Only set OPENIDM_OPTS if not already set
[ -z "" ] && OPENIDM_OPTS="-Xmx1024m -Xms1024m -Dfile.encoding=UTF-8"

cd ${OPENIDM_HOME}

# Set JDK Logger config file if it is present and an override has not been issued
if [ -z "$LOGGING_CONFIG" ]; then
  if [ -r "$OPENIDM_HOME"/conf/logging.properties ]; then
    LOGGING_CONFIG="-Djava.util.logging.config.file=$OPENIDM_HOME/conf/logging.properties"
  else
    LOGGING_CONFIG="-Dnop"
  fi
fi

CLASSPATH="$OPENIDM_HOME"/bin/*


case "${1}" in
start)
    nohup ${OPENIDM_HOME}/startup.sh > ${OPENIDM_HOME}/logs/server.out 2>&1 &
  	exit ${?}
  ;;
stop)
	sh ${OPENIDM_HOME}/shutdown.sh > /dev/null
	exit ${?}
  ;;
restart)
	sh ${OPENIDM_HOME}/shutdown.sh > /dev/null
    nohup startup.sh > ${OPENIDM_HOME}/logs/server.out 2>&1 &
  	exit ${?}
  ;;
*)
  echo "Usage: openidm { start | stop | restart }"
  exit 1
  ;;
esac