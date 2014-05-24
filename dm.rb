# what does dm do?
# dm talks to other objects
# handles decisions outside purview of other objects
# map reports contents of current square to dm
# dm reports to user whether a move is valid
# dm tells map that character has moved
# handles narration and color text
# dm could handle leveling up?

class Dungeon_Master

	def initialize
	@session_item_number = 0
	end

	def move_character
		# coordinates Character and Game_Map
	end
	
	def find_item(character)
		# decides what type of item has been found
		# random generation
		# use an array or hash with potion, weapon, armor
		item_type = [:Potion, :Weapon, :Armor]
		
		# These are the problem lines.  I'm doing something wrong with symbols
		"item_number_#{@session_item_number}".to_sym = (item_type[rand(3)]).new
		@session_item_number += 1
		# call Item.new with the appropriate info
		
		# assign Item to Character
		# report results to Adventure
		puts "item_number_#{@session_item_number}".to_sym.type
	end
	
	def battle
		# parameters for handling encounters between Characters
	end
	
	def initiative(character_one, character_two)
		# decides which Character attacks first
		# passes 'active' token to appropriate character
		# q & d implementation - later version could use character stats
		if rand(1) == 0
			# pass active token to character_one
		else
			# pass active token to character_two
		end
	end
	
	
end

