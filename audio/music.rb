if __FILE__==$0
	$: << File.expand_path(File.dirname("audio"))
	require "pitch_patterns"
	require "osc_out"
else
	require "audio/pitch_patterns"
	require "audio/osc_out"
end


class SoundTrack
	
	def initialize
		@osc = OscServer.new
		@pitches = PitchPattern.new
	end

	def sound_on
		@osc.send('vol', 1.0)
	end
	
	def sound_off
		@osc.send('vol', 0.0)
	end
	
	def volume(level) # float
		@osc.send('vol', level)
	end
	
	def new_situation(event)
		# gets information about current game events from adventure or dm
		# sends appropriate info to pitch_patterns
		# pitch patterns returns array of pitches
		# sends these numbers to osc_out and on to the synthesizer
		tempo = @pitches.choose_tempo(event)
		execute_tempo(tempo)
		chord = @pitches.choose_chord(event)
		execute_chord(chord)
	end
	
	# n = 10
	# n * 100^0, n * 100^1, n * 100^2, n * 100^3
	# x * 10^(0 * 2), x * 10^(1 * 2), x * 10^(2 * 2), x * 10^(3 * 2)
	# 55
	# 5600
	# 570000
	# 58000000
	#
	# 55 56 57 58
	
	#5655
	#1299
	
# 	100 * x = 10
# 	x = 1/10 (0.1)
# 	
# 	
# 	counter 0
# 	100/10 = 10
# 	counter 1
# 	10/10 = 1
# 	counter 2
# 	1/10 = 0.1 (0)
# 	counter 3
# 	
# 	350/10 = 35
# 	1
# 	35/10 = 3
# 	2
# 	3/10 = 0
# 	3

	


	def digit_calculator(integer)
		digits = 0
		while integer > 0
			integer = integer/10
			digits += 1
		end
		return digits
	end
	
	def unencode_pitches(encoded)
		double_digits = digit_calculator(encoded)/2
		index = double_digits
		output = 0
		chord = []
		double_digits.times do
			index -= 1
			output = encoded / 10**(index * 2)
			puts "index #{index} output #{output}"
			encoded -= output * 10**(index * 2)
			chord << output	
		end
		return chord
	end
	
	def encode_pitches(chord)
		index = 0
		encoded = 0
		# 'encode' members into a single integer to send over OSC at once
		# two digits for each number - DON'T GO ABOVE NN 99
		# reverses order.  Doesn't matter
		chord.length.times do
			encoded += chord[index] * (10**(index * 2))
			index += 1
		end
		return encoded
	end
		
	
	def execute_chord(chord)
		encoded = encode_pitches(chord)
		@osc.send('chord', encoded)
		sleep(0.1)
	end
	
	def execute_tempo(tempo)
		@osc.send('tempo', tempo)
		sleep(0.1)
	end

	
	

end

if __FILE__==$0
	st = SoundTrack.new
	st.new_situation('title')
	st.sound_on
	sleep(4)
	st.volume(0.4)
	sleep(4)
	st.sound_off
	encode = st.encode_pitches([20, 40, 60, 80])
	puts "encoded #{encode}"
	puts "unencoded #{st.unencode_pitches(encode)}"
end
