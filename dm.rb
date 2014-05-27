# what does dm do?
# dm talks to other objects
# handles decisions outside purview of other objects
# map reports contents of current square to dm
# dm reports to user whether a move is valid
# dm tells map that character has moved
# handles narration and color text
# dm could handle leveling up?

class DungeonMaster


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
	
	def battle(character_one, character_two)
		# parameters for handling encounters between Characters
		# based on initiative 
		# needs to check to see if character is player or NPC
		# can call NPC behavior if so
		# NPC then needs basic method telling it to attack
		# player character waits for input from 'adventure'
		battle_order = initiative(character_one, character_two)
		if (battle_order[0]).npc == 0
			# first is not npc
			while true
				puts "What does #{(battle_order[0]).name} do?"
				# call player attack automated for now
				# player  attacks  monster
				(battle_order[0]).attack(battle_order[1])
				if (battle_order[1]).alive? == false
					# puts 'test 1'
					(battle_order[0]).gainExp((battle_order[1]).expValue)
					break
				end
				# monster  attacks  player
				(battle_order[1]).attack(battle_order[0])
				if (battle_order[0]).alive? == false
					# puts 'test 2'
					(battle_order[1]).gainExp((battle_order[0]).expValue)
					break
				end
			end
		elsif (battle_order[0]).npc == 1
			# first is npc
			while true
				# monster  attacks  player
				(battle_order[0]).attack(battle_order[1])
				if (battle_order[1]).alive? == false
					# puts 'test 3'
					(battle_order[0]).gainExp((battle_order[1]).expValue)
					break
				end
				puts "What does #{(battle_order[1]).name} do?"
				# call player attack - automated for now
				# player  attacks  monster
				(battle_order[1]).attack(battle_order[0])
				if (battle_order[0]).alive? == false
					# puts 'test 4'
					(battle_order[1]).gainExp((battle_order[0]).expValue)
					break
				end				
			end
		end
	end
	
	def initiative(character_one, character_two)
		# decides which Character attacks first
		# puts characters in an array - returns ordered array to 'battle'
		# q & d implementation - later version could use character stats
		# a later version could use an internal proc to accept a variable number of characters
		battle_order = []
		if rand(2) == 0
			battle_order[0] = character_one
			battle_order[1] = character_two
		else
			battle_order[0] = character_two
			battle_order[1] = character_one
		end
		puts "#{(battle_order[0]).name} moves first!"
		return battle_order
	end
	
	
end

