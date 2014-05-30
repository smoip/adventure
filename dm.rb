# what does dm do?
# dm talks to other objects
# dm coordinates between observer (adventure) and other game objects
# handles decisions outside purview of other objects
# map reports contents of current square to dm
# dm reports to user whether a move is valid
# dm tells map that character has moved
# handles narration and color text
# dm could handle leveling up?

class DungeonMaster

	include QwertyIO

	def initialize
	@game_items = []
	@character_list = {}
	@map_list = []
	end

	attr_accessor :game_items, :character_list, :map_list

	def ask_player(player)
		manage_output("What does #{player.name} do?")
	end

	def player_moves(player)
		manage_output('Move in which direction?')
		direction = manage_input(['forward', 'backward', 'cancel'])
		if direction == 'cancel'
			return false
		end
# 		if forward ...
# 		increment a placement counter
# 		if backward...
# 		decrement a placement counter
# 		check the map_list.length against placement counter
# 		if placement counter is larger, call a new room (new_room)
# 		if placement counter is less than or equal, we are now in map_list.index(counter) room
# 		if placement counter is less than 0, display some text that you are leaving the dungeon (and ending the game)
# 		still need to figure out what's in the room (use room.occupants)
# 		call some descriptive text from room.description
# 		manage_output("#{player.name} moves.")
		true
	end
	
	def new_room(entrance_flag, dungeon_master)
		if entrance_flag == true
			room = Entrance.new(dungeon_master)
		elsif entrance_flag == false
			room = random_room.new(dungeon_master)
		end
		@map_list << room
	end
	
	def random_room
		room_type.shuffle.first
	end
	
	def room_type
		[Hallway, Chamber]
	end
	
	def target_options(player, target_self)
		target_options = @character_list.each_key.collect {|x| x.to_s.downcase }
		# turn creature list into array
		
		if target_self == false
			target_options.delete_at(target_options.index(player.name.downcase))
			# remove player from targetable options
		end
		
		target_options << 'cancel'
		target = manage_input(target_options)
		return target
	end
	
	def player_attacks(player)
		manage_output('Attack what?')
		
		target = target_options(player, false)
		if target == 'cancel'
			return false
		end
		
		player.attack(@character_list[target.capitalize])
		true
	end
	
	def player_uses_item(player)
		item_options = []
		item_options << player.inventory['potion'].name
		# if multiple useable items become a thing, this needs to be an array.each.name
		
		item_options << 'cancel'
		
		unless item_options.index('nothing') == nil
			item_options.delete_at(item_options.index('nothing'))
			# remove default object from options if present
		end
		
		manage_output('Use what item?')
		item = manage_input(item_options)
		if item == 'cancel'
			return false
		end
		
		player.use_potion(item)
		true
	end
	
	def player_casts_spell(player)
		spell_options = player.spell_list
		spell_options << 'cancel'
		manage_output('Cast which spell?')
		spell = manage_input(spell_options)
		if spell == 'cancel'
			return false
		end
		
		manage_output("Cast #{spell} at what target?")
		target = target_options(player, true)
		if target == 'cancel'
			return false
		end
		
		player.cast_spell(spell, (@character_list[target.capitalize]))
		true
	end
	
	def item_type
		[Potion, Weapon, Armor]
	end
	
	def random_item
		item_type.shuffle.first
	end
	
	def find_item(character, item_level)
		# decides what type of item has been found
		
		item = random_item.new(item_level)
		# call Item.new with the appropriate info
		
		@game_items << item
		# store item
		
		character_decision = character.recieve_item(item)
		
		if (character_decision[0]) == true
			@game_items.pop
			if character_decision[1].type != 'nothing'
				@game_items << (character_decision[1])
			end		
		end
	
	end
	
	def drop_item(item)
	end
	
	def check_game_items
		manage_output("Game Items: ")
		@game_items.each { |x| manage_output(x.name) }
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
				manage_output("What does #{(battle_order[0]).name} do?")
				# call player attack automated for now
				# player  attacks  monster
				(battle_order[0]).attack(battle_order[1])
				if (battle_order[1]).alive? == false
					(battle_order[0]).gainExp((battle_order[1]).expValue)
					break
				end
				# monster  attacks  player
				(battle_order[1]).attack(battle_order[0])
				if (battle_order[0]).alive? == false
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
					(battle_order[0]).gainExp((battle_order[1]).expValue)
					break
				end
				manage_output("What does #{(battle_order[1]).name} do?")
				# call player attack - automated for now
				# player  attacks  monster
				(battle_order[1]).attack(battle_order[0])
				if (battle_order[0]).alive? == false
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
		manage_output("#{(battle_order[0]).name} moves first!")
		return battle_order
	end
	
	
end

