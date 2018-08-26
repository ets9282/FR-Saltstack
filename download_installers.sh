#!/bin/bash

if [[ ! -d /src/installers ]]; then
        mkdir -p src/installers
fi


wget -O src/installers/openam.war https://s3-ap-southeast-2.amazonaws.com/forgerock-stack/openam.war
wget -O src/installers/apache-tomcat-8.5.27.tar.gz https://www.dropbox.com/s/864k0m2p6utbx6s/apache-tomcat-8.5.27.tar.gz
wget -O src/installers/opendj.zip https://s3-ap-southeast-2.amazonaws.com/forgerock-stack/opendj.zip
wget -O src/installers/openidm.zip https://s3-ap-southeast-2.amazonaws.com/forgerock-stack/openidm.zip
wget -O src/installers/openig.war https://s3-ap-southeast-2.amazonaws.com/forgerock-stack/openig.war
wget -O src/installers/jdk-8u161-linux-x64.tar.gz https://www.dropbox.com/s/bloohc8evzvnb9z/jdk-8u161-linux-x64.tar.gz
wget -O src/installers/SSOAdminTools-5.1.1.1.zip https://www.dropbox.com/s/7jfpx8gk7vteryl/SSOAdminTools-5.1.1.1.zip
wget -O src/installers/SSOConfiguratorTools-5.1.1.1.zip https://www.dropbox.com/s/kj0irydzycwki9q/SSOConfiguratorTools-5.1.1.1.zip
