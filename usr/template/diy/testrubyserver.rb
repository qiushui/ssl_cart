#!/usr/bin/env ruby
require 'webrick'

servers = []
servers << WEBrick::HTTPServer.new(:Port => ENV['OPENSHIFT_DIY_PORT'], 
                                   :BindAddress => ENV['OPENSHIFT_DIY_IP'], 
                                   :DocumentRoot => File.join(ENV['OPENSHIFT_REPO_DIR'], 'diy'))

servers << WEBrick::HTTPServer.new(:Port => ENV['OPENSHIFT_DIY_SSL_PORT'], 
                                   :BindAddress => ENV['OPENSHIFT_DIY_SSL_IP'], 
                                   :DocumentRoot => File.join(ENV['OPENSHIFT_REPO_DIR'], 'diy'),
                                   :SSLEnable => true, 
                                   :SSLCertName => ENV['OPENSHIFT_GEAR_DNS'])

['INT', 'TERM'].each {|signal|
  trap(signal) {servers.each { |s| s.shutdown }}
}

threads = servers.map { |s| Thread.new { s.start } }

threads.each do |thr|
  thr.join
end
