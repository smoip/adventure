class PitchPattern

	def initialize
		@base_pitch = 60 + rand(12)
		@score_book = {'title' => [[0,4,5,7], 400]}
	end

	def available_pitches(event)
		chord_choices = @score_book[event][0]
		puts "from avail: #{chord_choices}"
		return chord_choices
	end

	def randomize_pitches(chord_choices)
		chord_members = []
	
		indexer = 0
		chord_choices.length.times do
			chord_members << (chord_choices.shuffle.first + @base_pitch)
		end
		puts "from rando1: #{chord_members}"
		
		chord_members.collect! do |x|
			if rand(5) == 0
				x + 12
			else 
				x
			end
		end
		puts "from rando2: #{chord_members}"
		return chord_members
	end
	
	def choose_chord(event)
		chord_choices = available_pitches(event)
		randomize_pitches(chord_choices)
	end
	
	def choose_tempo(event)
		tempo = @score_book[event][1] + ((rand(4)-2) * 10)
		return tempo
	end

end