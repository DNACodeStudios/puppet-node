# Puppet Node

This is just a basic puppet setup for provisioning an Ubuntu 14.04 server
with everything needed to run a Node app on 5.7.0

This is easily changed however by opening up `puppet/manifests/site.pp` and changing the node version constant.

This uses NVM to install node, and works really well with `capistrano-nvm`
