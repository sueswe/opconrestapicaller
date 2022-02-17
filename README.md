# Using the OPCON REST-API - some examples

## Installation

#### clone:

~~~ sh
git clone https://github.com/sueswe/opconrestapicaller.git
cd opconrestapicaller
~~~

#### setup

For example, on apt-based Linux-installations:

~~~ sh
sudo apt install ruby-dev ruby-bundler
~~~

Now run bundler. This will install the necessary gems:

~~~ sh
bundle
~~~


#### configuration

This let you create a configuration file in your *$HOME* directory
and copies the rb-scripts from bin/ to **$HOME/bin/** :

~~~ sh
rake
~~~

You have always the possibility to edit the file (**$HOME/.opcontoken.yaml**) manually.
You can also just call a single task from the rakefile with `rake taskname`. You get a
list of tasks by hitting `rake -T `.

## Usage

You can call each script for one of the defined stages. There is also the possibility to deactivate
the use of the **PROXY** environment variables.

Usage by example:

~~~ sh
Usage: apiproperties.rb [options]
    -n, --no-proxy                   unset proxy environment variables
    -p, --production                 use production-stage - API
    -t, --test                       use test-stage - API
    -d, --developement               use dev-stage - API
~~~


## how it works

Based on a maybe common setup, you can add three configurations for Opcon-servers: production, test and developement.
(you don't have to; the rake command will ask you to enter three server-adresses and three external tokens.)
You may leave them empty by hitting just enter ;  create a config-file by your own.

The configuration file is located at:

~~~ sh
$HOME/.opcontoken.yaml
~~~

and the layout of the file looks like:

~~~ yaml
server_prodstage: "serveradress:port"
external_token_prodstage: "tokenstring"

server_teststage: "serveradress:port"
external_token_teststage: "tokenstring"

server_devstage: "serveradress:port"
external_token_devstage: "tokenstring"
~~~
