romaincabassot.ansible-ocsinventory-agent
=========

Version : 1.0.1

Installs OCS inventory agent from a package repository and can setup the cron to launch the inventory.



Requirements
------------

A repository from which pull the Ocsinventory agent package (for example [remi repository](http://rpms.famillecollet.com/)).

Role Variables
--------------

    # Ocsinventory launch options
    # --------------------------
    # The command line to launch in order to make inventory of the host
    ocsinventory_launcher: "/usr/sbin/ocsinventory-agent --local=/var/lib/ocsinventory-agent"
    # Specify if Ocs should make inventory of the host after a new installation of the agent
    ocsinventory_launch_after_install: true
    
    # Cronjob options
    # ---------------
    # True to create a cronjob for host inventory
    ocsinventory_setup_cronjob: true
    # Name of the cronob task
    ocsinventory_cronjob_name: "ocsinventory-agent"
    # User running the job
    ocsinventory_cronjob_user: "root"
    # When to execute the job...
    ocsinventory_cronjob_month: "*"
    ocsinventory_cronjob_weekday: "*"
    ocsinventory_cronjob_day: "*"
    ocsinventory_cronjob_hour: "6"
    ocsinventory_cronjob_minute: "0"
    
    # Installation package configuration
    # ----------------------------------
    # Name of the package to install
    ocsinventory_package_name: "ocsinventory-agent"
    # Name of the package's repository
    ocsinventory_package_repository: "remi"


Dependencies
------------

None.  

Example Playbook
----------------

    - hosts: servers
      roles:
         - { 
             role: ocsinventory-agent, 
             ocsinventory_launcher: "/usr/sbin/ocsinventory-agent --server=http://myocsserver.domain.com/ocsinventory",
             ocsinventory_launch_after_install: true
             ocsinventory_setup_cronjob: true
             ocsinventory_cronjob_name: "ocsinventory-agent"
             ocsinventory_cronjob_user: "root"
             ocsinventory_cronjob_month: "*"
             ocsinventory_cronjob_weekday: "*"
             ocsinventory_cronjob_day: "*"
             ocsinventory_cronjob_hour: "6"
             ocsinventory_cronjob_minute: "0"
           }

License
-------

BSD

Author Information
------------------

Romain CABASSOT
