**Maniest for Deploying My Demo Angular Website**

On Puppet Bolt 1.0 installations these should be installed to the modules directory under Plans/Templates accordingly. The default plans directory can be modified by using a bolt.yaml configuration files (https://puppet.com/docs/bolt/1.x/configuring_bolt.html). 

**By Default the directory is -** 
```/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/bolt-1.0.0/modules```

**Sample Command with no bolt.yaml applied -** 
```bolt plan run profiles::bootcampapp --nodes ip --no-host-key-check --user root --password pass```
