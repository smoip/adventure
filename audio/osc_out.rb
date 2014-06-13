require 'rubygems'
require 'osc-ruby'
require 'osc-ruby/em_server'

# begin
# 	require 'osc-ruby'
# 	require 'osc-ruby/em_server'
# rescue LoadError
# 	puts 'Can\'t find dependencies for audio. Please check readme for details.'
# end

class OscServer
	
	def initialize
		# send OSC message over udp port 7575
		# audio program listens on 7575
		@server = OSC::EMServer.new(7575)
		@client = OSC::Client.new('localhost', 7575)

		Thread.new do
		  @server.run
		end
	end

	def send(router, int)
		@client.send(OSC::Message.new(router, int))
		# use 'router' to route messages in external audio program
	end

	
end