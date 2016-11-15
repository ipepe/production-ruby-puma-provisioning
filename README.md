# ruby-puma-production-predeployment-scripts
Scripts for setting up docker to host ruby on rails in container

# Goal
Scripts that will make clean ubuntu capable of running Ruby On Rails for production.
First steps are to setup properly Docker enviroment.

Inside of docker there will be:
 * rbenv - to manage ruby versions of code
 * ngnix - to manage requests by dns name to puma socket (with websockets support!)
 * puma(ruby) - all servers will be hosted on puma sockets
 * capristano - well, it will be on client side, but users and all that stuff will be prepared for that deployment gem
 * postgres - username for postgres will be provided by ENV variable
 * sqlite - alternative library for databasing
 
Docker will have outside directories for:
 * postgres
 * app logs

Docker will have ports for:
 * ssh for deployment
 * http for obvious reasons
 

# based on:
 * https://www.digitalocean.com/community/tutorials/deploying-a-rails-app-on-ubuntu-14-04-with-capistrano-nginx-and-puma
