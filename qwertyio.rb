module QwertyIO	
	
	def manage_input(good_answers)
		# remove input decisions from internal modules
		# good answers are arrays of strings supplied by caller
		good_answer = false
		until good_answer == true
			# this is super sloppy and could probably be replaced with .find
			input = gets.chomp.downcase.strip
			if good_answers == []
				return input
			end
			indexer = (good_answers.length)
			indexer.times do
				indexer -= 1
				if good_answers[indexer] == input
					good_answer = true
				end
				if good_answer == true
					return input
				end
			end	
			manage_output('Please make a valid choice')
			manage_output(good_answers.each { |x| x })
		end
		
	end
	
	def manage_output(things_to_print)
		# remove output decisions from internal modules
		# may eventually be real display handling
		puts things_to_print.to_s
	end

end