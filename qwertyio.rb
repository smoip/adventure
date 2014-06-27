module QwertyIO	
	
	def manage_input(good_answers)
		good_answer = false
		until good_answer == true
			# still seems sloppy
			input = take_input
			input = split_words(input)
			if good_answers == []
				return input
			end
			indexer = (good_answers.length)
			indexer.times do
				indexer -= 1
				if good_answers[indexer] == input[0]
					good_answer = true
				end
				if good_answer == true
					return input
				end
			end	
			manage_output('Please make a valid choice')
			manage_output(good_answers)
		end
		
	end
	
	def take_input
		input = gets.chomp.downcase.strip
	end
	
	def split_words(input)
		input.split(' ')
	end
	
	def manage_output(things_to_print)
		things_to_print = format_output(things_to_print)
		puts things_to_print
	end
	
	def format_output(input)
		if input.is_a? Array
			outstring = ''
			last = input.pop.to_s
			input.each {|x| outstring += "#{x}, " }
			outstring += last
			return outstring
		else
			return input
		end
	end

end