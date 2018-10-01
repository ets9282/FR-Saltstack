# ForgeRock stack - Salt Scripts
This repository contains salt scripts to install ForgeRock components and related dependencies .

## Dependencies

- The binaries for ForgeRock artifacts can be stored on any artifact repository of choice and the links to download those artifacts must be provided in `./download_installers.sh` . Any updates to ForgeRock artifacts must be reflected in the  `./download_installers.sh`. 

- ForgeRock artifacts should be downloaded to src/installers folder. The  artifacts can be downloaded using script : `./download_installers.sh`
  

- Each ForgeRock server is defined and added in the `Vagrantfile` . Any modification to the servers IP address or hostname can be made using the `Vagrantfile`
  
- ForgeRock servers are added to the salt master as identifiable minions.


## Installing the App

* Clone the github repository
     ```sh
    $ git clone https://<username>@git.jcu.edu.au/bitbucket/scm/conf/salt-iam.git 

    $ cd salt-iam
     ```

* download the ForgeRock artifacts.
  
  ```sh
  $ ./download_installers.sh
  ```
* Copy the contents of the src folder (including the installers) to the state folder on the Salt master (/srv/salt)
* Copy the contents of the pillar folder to the pillar folder on the Salt master(/srv/pillar)

## Running Salt Scripts
- Configure the topfile by adding configuration for the ForgeRock servers.
- Edit the pillar `/srv/pillar/frstack.sls` and add the appropriate configuration to reflect the environment the ForgeRock servers are deployed to .
- Provision the VMs by 
  ```sh 
  $ Vagrant up
    ```
  
- SSH into salt master by  
    ```sh 
    $ Vagrant ssh master
    ```  
  then  
    
    ```sh
    $ salt-key --accept-all
    ```
  Now the salt master is ready to install other ForgeRock servers.

 - To apply the salt state to the servers. 
   ```sh
   $ sudo salt '*' state.apply
   ```
    This will install the ForgeRock following components on the minions:
    - OpenDJ Server - Java, OpenDJ
    - OpenAM Server - Java, Tomcat, OpenAM
    - OpenIDM Server - Java, OpenIDM
    - OpenIG Server - Java, OpenIG

## Testing the stack
* OpenAM -
    * SSH into the OpenAM server 
        ```sh
        $ vagrant ssh openam1
        ```
    * Make sure the tomcat service is started correctly
        ```sh
        $ sudo systemctl status tomcat
        ```
    * If tomcat is not running, start the tomcat service 
        ```sh 
      $ sudo systemctl start tomcat
        ```
    * Logon to openam by visiting `http://<openam.fqdn>:8080/openam`
   
* OpenIDM -
    * SSH into the OpenIDM server
       ```sh
       $ vagrant ssh openidm1
        ```
    * Make sure the openidm service is started correctly 
      ```sh
       $ sudo systemctl status openidm
      ```
    * If openidm is not running, start the openidm service 
       ```sh
        $ sudo systemctl start openidm
       ```
    * Logon to openam by visiting `http://<openidm.fqdn>:8080`
* OpenDJ
     * SSH into the OpenDJ server
       ```sh
        $ vagrant ssh opendj1
       ``` 
     * Make sure the opendj service is started correctly 
       ```sh
        $ sudo systemctl status opendj
       ```
     * If opendj is not running, start the opendj service 
       ```sh
        $ sudo systemctl start opendj
       ```
     * Goto `/opt/forgerock/opendj/bin` and execute `./status` to verify that OpenDJ is running.
* OpenIG -
     * SSH into the OpenIG server
       ```sh
        $ vagrant ssh openig1
       ```
     * Make sure the tomcat service is started correctly 
        ```sh
         $ sudo systemctl status tomcat
        ```

     * If tomcat is not running, start the tomcat service `sudo systemctl start tomcat`
     * Logon to openig by visiting `http://<openig.fqdn>:8080/`

## Troubleshooting:

- If any of the components encounter an error during installation , check the `/srv/pillar/frstack.sls`  to ensure correct environment settings are applied and adjust accordingly.  
-  Any of the component could be reinstalled by typing `sudo salt '<component name >' state.apply` for example:
   ```sh
   $ salt "openig1.local" state.apply
   ``` 
- To access tomcat server log files check the `catalina.out`  file located in the tomcats logs directory .


## References:

- https://backstage.forgerock.com/docs/ig/6.1/getting-started/index.html
- https://backstage.forgerock.com/docs/idm/6/install-guide/index.html
- https://backstage.forgerock.com/docs/ds/6/install-guide/
- https://docs.saltstack.com/en/getstarted/fundamentals/install.html
- 
