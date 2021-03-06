# Netzke tutorial - Rails 3

This is a port of the Netzke tutorial to run on Rails 3. It has been tested with Rails 3.beta4.

## Installation and configuration
                                     
### Install the netzke configurator gem:

<code>gem install netzke_config</code>  

### Configure netzke_config: 

Create netzke folder
<code>mkdir -p ~/netzke</code> 

<code>mate ~/netzke/modules.config</code> 

<pre># mate ~/netzke/modules.config
netzke-core:rails3-works@kristianmandrup, netzke-basepack:rails3-works@kristianmandrup
</pre>

### Clone the tutorial app (or clone your own fork!!!)
                                          
<code>gem clone http://github.com/kristianmandrup/netzke-tutorial-rails3.git</code> 

<code>$ cd netzke-tutorial-rails3</code> 

## Configure application using netzke_config

See *netzke_config* run options

<code>$ netzke_config --help</code> 

Run *netzke_config* from the root of the application (force overwrite of any pre-existin symbolic links and download extjs 3.2.1) 

<code>netzke-tutorial-rails3 $ netzke_config --force-links --download --extjs ~/netzke/extjs</code> 

Note: If you are have problems installing extjs via *netzke_config* do it manualluy and create a symbolic link to public/extjs in the app.

Example:
<code>netzke-tutorial-rails3 $ ln -s ~/netzke/extjs-3.2.1 public/extjs</code> 

### Install required gems in the Rails 3 app

<code>netzke-tutorial-rails3 $ bundle install</code> 

### Create database schema

<code>netzke-tutorial-rails3 $ rake db:migrate</code> 

### Populate database with data

<code>netzke-tutorial-rails3 $ rake db:seed</code> 

### Start server

<code>netzke-tutorial-rails3 $ rails s</code>  

## Future plans

* Make sure all parts of tutorial work under Rails 3
* Convert plugins into gems

* Create Netke scaffolders
* Create Netzke application generator
* Create more Netzke widget generators



 