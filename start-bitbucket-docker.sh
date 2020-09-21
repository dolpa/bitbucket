#!/bin/bash -e

echo "==============================="
echo " User: "
id

echo "==============================="
echo " Environment:"
env

# Start Jenkins Master server

echo "==============================="
echo " Parameters: "
echo "user=${user}"
echo "group=${group}"
echo "uid=${uid}"
echo "gid=${gid}"
echo "http_port=${http_port}"

echo "==============================="
echo " Arguments:"
echo ${@}

echo "==============================="
echo " Check if folders exists and they permisions:"
ls -la /var/
ls -la ${BITBUCKET_HOME}

echo "==============================="
echo "Special BitBucket params:"

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/

# Start bitbucket server command
cd ${BITBUCKET_INSTALL_DIR}/bin/
if [ "${BITBUCKET_EMBEDDED_SEARCH}" = 'true' ]; then
    exec ./start-bitbucket.sh -fg
else
    exec ./start-bitbucket.sh --no-search -fg
fi