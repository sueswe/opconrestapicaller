#!/usr/bin/env ruby

require 'colorize'
require 'optparse'
require 'logger'
require 'excon'

$stdout.sync = true

myname = File.basename(__FILE__)

class Read_config
  require 'yaml'
  targetDir = ENV["HOME"] + "/"
  $config = targetDir  +  ".opcontoken.yaml"

  # server-URL:PORT
  def get_serverport_teststage
    config = YAML.load_file($config)
    host = config['server_teststage']
  end
  def get_token_teststage
    config = YAML.load_file($config)
    token = config['external_token_teststage']
    return token
  end
end

class ReadBatchuser

  def from_test
    logger = Logger.new(STDOUT)
    logger.formatter = proc do |severity, datetime, progname, msg|
      "#{severity} #{datetime}: #{msg}\n"
    end
    t = Read_config.new.get_token_teststage
    serverurlport = Read_config.new.get_serverport_teststage
    logger.info "#{t}"
    logger.info "#{serverurlport}"
    Excon.defaults[:ssl_verify_peer] = false
    response = Excon.get('https://' + serverurlport + '/api/globalproperties?sortBy=name', :headers => {'Authorization' => "Token #{t}" })
    puts response.body
    logger.info "Response-status: " + response.status.to_s
  end

end


ReadBatchuser.new.from_test
