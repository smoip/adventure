require 'rubygems'

begin
	require 'osc-ruby'
	require 'osc-ruby/em_server'
rescue LoadError
	puts 'Can\'t find dependencies for audio. Please check readme for details.'
end

# send OSC message over udp port 7575
# audio program listens on 7575

@client = OSC::Client.new('localhost', 7575)

@client.send( OSC::Message.new('/tag', 42))
