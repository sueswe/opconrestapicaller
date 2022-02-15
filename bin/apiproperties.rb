#!/usr/bin/env ruby

require 'colorize'
require 'optparse'
require 'logger'
require 'excon'
require_relative 'readconfig'
include Read_config

logger = Logger.new(STDOUT)
logger.formatter = proc do |severity, datetime, progname, msg|
  "#{severity} #{datetime}: #{msg}\n"
end

$stdout.sync = true

myname = File.basename(__FILE__)

options = {}
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: #{myname} [options]"
  opts.on("-n", "--no-proxy", "unset proxy environment variables") do |v|
    options[:noproxy] = true
  end
  opts.on("-p","--production","use production-stage - API") do |x|
    options[:prod] = true
  end
  opts.on("-t","--test","use test-stage - API") do |x|
    options[:test] = true
  end
  opts.on("-d","--developement","use dev-stage - API") do |x|
    options[:dev] = true
  end
  
  opts.on("-n","--name N", "Find property by name. Wildcards allowed (*,?)") do |x|
	options[:name] = x
  end
  
end
optparse.parse!

logger.debug options

if options.empty?
  puts optparse
  exit
end

if options[:noproxy] == true
  ENV['https_proxy'] = ''
  ENV['http_proxy']  = ''
  ENV['HTTPS_PROXY'] = ''
  ENV['HTTP_PROXY']  = ''
  logger.info "proxy environment variables disabled."
end


if options[:test] == true
  t = Read_config.get_token_teststage
  serverurlport = Read_config.get_serverport_teststage
elsif options[:prod] == true
  t = Read_config.get_token_prodstage
  serverurlport = Read_config.get_serverport_prodstage
elsif options[:dev] == true
  t = Read_config.get_token_devstage
  serverurlport = Read_config.get_serverport_devstage
end

if options[:name].to_s.empty?
  propname = '*'
else
  propname = options[:name].to_s
end

logger.info "property name filter: #{propname}"

#logger.info "#{t}"
logger.info "#{serverurlport}"
Excon.defaults[:ssl_verify_peer] = false
response = Excon.get("https://#{serverurlport}/api/globalproperties?sortBy=name&name=#{propname}", :headers => {'Authorization' => "Token #{t}" })
puts response.body
logger.info "Response-status: " + response.status.to_s
