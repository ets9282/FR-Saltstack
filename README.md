# Forgerock stack - Salt Scripts
This repository contains salt scripts to install forgerock components and related dependencies.

## Dependencies
- Forgerock installers should be downloaded to src/installers folder. The latest version of the installers can be downloaded using script : `./download_installers.sh`
- Forgerock servers are added to the salt master as identifiable minions.


## Installing the App

* Clone the github repository
    - `git clone https://github.com/ets9282/FR-Saltstack.git`
    - `cd FR-Saltstack`

* download the forgerock artifacts.
    - `./download_installers.sh`
* Copy the contents of the src folder (including the installers) to the state folder on the Salt master (/srv/salt)
* Copy the contents of the pillar folder to the pillar folder on the Salt master(/srv/pillar)

## Running Salt Scripts
- Configure the topfile by adding configuration for the forgerock servers.
- Edit the pillar /srv/pillar/frstack.sls and add the appropriate configuration.
- Run `sudo salt '*' state.apply` - To apply the salt state to the servers. This will install the forgerock following components on the minions:
    - OpenDJ Server - Java, OpenDJ
    - OpenAM Server - Java, Tomcat, OpenAM
    - OpenIDM Server - Java, OpenIDM
    - OpenDJ Server - Java, OpenIG

## Testing the stack
* OpenAM -
    * SSH into the OpenAM server
    * Make sure the tomcat service is started correctly `sudo systemctl status tomcat`
    * If tomcat is not running, start the tomcat service `sudo systemctl start tomcat`
    * Logon to openam by visiting `http://<openam.fqdn>:8080/openam`
* OpenIDM -
    * SSH into the OpenIDM server
    * Make sure the openidm service is started correctly `sudo systemctl status openidm`
    * If openidm is not running, start the openidm service `sudo systemctl start openidm`
    * Logon to openam by visiting `http://<openidm.fqdn>:8080`
* OpenDJ
     * SSH into the OpenDJ server
     * Make sure the opendj service is started correctly `sudo systemctl status opendj`
     * If opendj is not running, start the opendj service `sudo systemctl start opendj`
     * Goto `/opt/forgerock/opendj/bin` and execute `./status` to verify that OpenDJ is running.
