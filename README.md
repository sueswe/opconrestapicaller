# Using the OPCON REST-API - some examples

## use it (Work In Progress)

#### clone:

~~~ sh
git clone https://github.com/sueswe/opconrestapicaller.git
cd opconrestapicaller
~~~

#### setup

~~~ sh
bundle
~~~


#### configuration

~~~ sh
rake
~~~



<hr>
<hr>

> coming up:

## how it works

Based on DevOps-thoughts, you can add three configurations for Opcon-Servers: production, test and developement.
(you don't have to; the rake command will ask you to enter three server-adresses and three external tokens.)
You may leave them empty by hitting just enter ;  create a config-file by your own.

The configuration file is located at:

~~~ sh
$HOME/.opcontoken.yaml
~~~

and the layout of the file looks like:

~~~ yaml
server_teststage: "serveradress:port"
external_token_teststage: "tokenstring"
~~~
