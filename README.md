Role Name
=========

Installs OCS inventory agent from [Remi repository](http://rpms.famillecollet.com/).

Requirements
------------



Role Variables
--------------

Modify ansible variable _ocsinventory_launcher_

Example:
```
ocsinventory_launcher: "/usr/sbin/ocsinventory-agent -f --server=http://myocsserver.mydomain.com/ocsinventory"
```

Dependencies
------------

Role dependencies: 
- geerlingguy.repo-remi
- geerlingguy.repo-epel

Example Playbook
----------------

    - hosts: servers
      roles:
         - { 
             role: ocsinventory-agent, 
             ocsinventory_launcher: "/usr/sbin/ocsinventory-agent -f --server=http://myocsserver.mydomain.com/ocsinventory"
           }

License
-------

BSD

Author Information
------------------

https://www.romain-cabassot.fr/
