# what does adventure do?
# main coordinator
# calls all other objects
# loads dependencies
# handles user-end display 
# In a future version, handles all IO issues (remove puts, print from internal objects)

$LOAD_PATH.insert(0, "/users/laevsky/documents/learning ruby/adventure")
require "character"
require "dm"
require "map"
require "magic"
require "items"


class Game

	def initialize
	end
	
	def manage_input(good_answers)
		# remove input decisions from internal modules
		# good answers are arrays of strings supplied by caller
		# - this might not be a good way to do it
		# manage_input probably shouldn't be associated with an object
		good_answer = false
		while good_answer != true
			# this is super sloppy and could probably be replaced with .find
			input = gets.chomp.downcase.strip
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

new_game = Game.new

new_game.manage_output('Choose yes or no')
new_game.manage_output(new_game.manage_input(['yes', 'no']))
new_game.manage_output('Thanks!')

guide = DungeonMaster.new
player = Mage.new('Thaddeus', 0)
monster = Minotaur.new

guide.battle(player, monster)


# guide.find_item(player)
# come back to this later
