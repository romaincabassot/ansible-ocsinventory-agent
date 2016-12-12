romaincabassot.ansible-ocsinventory-agent
=========

Version : 1.0.1

Installs OCS inventory agent from a package repository and can setup the cron to launch the inventory.



Requirements
------------

None.

Role Variables
--------------

- **ocsinventory_launcher**: /usr/sbin/ocsinventory-agent --local=/var/lib/ocsinventory-agent 
- **ocsinventory_launch_after_install**: true
- **ocsinventory_setup_cronjob**: true
- **ocsinventory_cronjob_name**: "ocsinventory-agent"
- **ocsinventory_cronjob_user**: "root"
- **ocsinventory_cronjob_month**: "*"
- **ocsinventory_cronjob_weekday**: "*"
- **ocsinventory_cronjob_day**: "*"
- **ocsinventory_cronjob_hour**: "6"
- **ocsinventory_cronjob_minute**: "0"
- **ocsinventory_package_name**: "ocsinventory-agent"
- **ocsinventory_package_repository**: "remi"

Dependencies
------------

A repository from which pull the ocsinventory-agent package (for example [remi repository](http://rpms.famillecollet.com/)).  

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
