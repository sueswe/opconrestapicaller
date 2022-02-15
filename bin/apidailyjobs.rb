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
  opts.on("-s","--scheduleName SN" ,"list daily jobs for a scheduleName.  Wildcards allowed (*,?)") do |y|
    options[:schedulename] = y
  end
  opts.on("-i","--idate scheduledate (imerominia) I" ,"list daily jobs for a schedule date (yyyy-MM-dd)") do |z|
    options[:scheduledate] = z
  end
  opts.on("-j","--jobname J" ,"list only spezific job(s) for a scheduleName. Wildcards allowed (*,?)") do |j|
    options[:jobname] = j
  end
end
optparse.parse!

logger.debug options

if options[:noproxy] == true
  ENV['https_proxy'] = ''
  ENV['http_proxy']  = ''
  ENV['HTTPS_PROXY'] = ''
  ENV['HTTP_PROXY']  = ''
  logger.info "proxy environment variables disabled."
end

sname = options[:schedulename].to_s
date = options[:scheduledate].to_s
jobname = options[:jobname].to_s

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

if sname.empty? || date.empty?
  logger.error "some options required."
  puts ""
  puts optparse
  exit 1
end

#logger.info "#{t}"
logger.info "#{serverurlport}"
Excon.defaults[:ssl_verify_peer] = false
if jobname.empty?
  response = Excon.get("https://#{serverurlport}/api/dailyjobs?scheduleName=#{sname}&dates=#{date}", :headers => {'Authorization' => "Token #{t}" })
else
  response = Excon.get("https://#{serverurlport}/api/dailyjobs?scheduleName=#{sname}&dates=#{date}&jobName=#{jobname}", :headers => {'Authorization' => "Token #{t}" })
end
puts response.body
logger.info "Response-status: " + response.status.to_s
