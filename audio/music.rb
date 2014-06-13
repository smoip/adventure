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
		sleep(0.5)
		chord = @pitches.choose_chord(event)
		execute_chord(chord)
	end
	
	def execute_chord(chord)
		chord.each do |member|
			@osc.send('chord', member)
		end
	end
	
	def execute_tempo(tempo)
		@osc.send('tempo', tempo)
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
end
