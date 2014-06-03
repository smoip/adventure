# what does dm do?
# dm talks to other objects
# dm coordinates between observer (adventure) and other game objects
# handles decisions outside purview of other objects
# map reports contents of current square to dm
# dm reports to user whether a move is valid
# dm tells map that character has moved
# handles narration and color text

class DungeonMaster

	include QwertyIO

	def initialize
	@game_items = []
	@character_list = {}
	@map_list = []
	@map_location = 0
	end

	attr_accessor :game_items, :character_list, :map_list, :map_location

	def ask_player(player)
		manage_output("What does #{player.name} do?")
	end

	def move_character_to_room(character)
		@character_list.delete(character.name)
		current_location.occupants["#{character.name}"] = character
	end

	def move_character_from_room(character)
		current_location.occupants.delete(character.name)
		@character_list["#{character.name}"] = character
	end	
	
	def initial_room(player)
		new_room(true, self)
		move_character_to_room(player)
		room = current_location
		room.describe(player.name)
	end
	
	def player_moves(player)
		manage_output('Move in which direction?')
		direction = manage_input(['forward', 'backward', 'cancel'])
		if direction == 'cancel'
			return false
		end
		
		move_character_from_room(player)
		
		if direction == 'forward'
			@map_location += 1
		elsif direction == 'backward'
			@map_location -= 1
		end
		
		if @map_location < 0
			manage_output "Leave the dungeon (and quit the game?)"
			input = manage_input(['yes', 'no'])
			if input == yes
				# is this a thing?
				caller.quit_game
			elsif input == no
				move_character_to_room(player)
				return false
			end
		end
		
		if @map_location > (@map_list.length - 1)
			new_room(false, self)
		end
		
		move_character_to_room(player)
		# moves player from dm character list to room occupants list
		
		room = current_location
		# who decides what's inside?
		if room.creature_inside == true
			monster = choose_monster(player)
		end
		# room.treasure_inside
		room.describe(player.name)
		
		
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
	
	def current_location
		@map_list[@map_location]
	end
	
	def monster_table
		monster_table = [Minotaur, GiantRat]
	end
	
	def monster_type(monster_table)
		monster_table.shuffle.first
	end
	
	def choose_monster(player)
		# this is a problem - needs to call a method from Game
		# should call Game.new_monster to place creature in characterlist
		# might have to move new_monster and new_character to dm
		
		monster = new_monster(monster_type(monster_table))
		level = (player.level + (rand(4)-1))
		if level < 0
			level == 0
		end
		level.times do
			monster.level_up
		end
		
		move_character_to_room(monster)
		# moves monster from dm character list to room occupants list
		
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
	
	def target_options(player, target_self, room)
		target_options = room.occupants.each_key.collect {|x| x.to_s.downcase }
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
		
		target = target_options(player, false, current_location)
		if target == 'cancel'
			return false
		end

		target = target.partition " "
		target = target.each.collect {|x| x.capitalize}
		target_formatted = ""
		target.each do |x|
			target_formatted += x
		end

		player.attack(current_location.occupants[target_formatted])
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
	
	def player_lives(player)
		if player.alive? == false
			if player.npc == 1
				valhalla = current_location.occupants.delete(current_location.occupants("#{player.name}"))
				player.name = "#{player.name}(dead)"
				current_location.room_items[player.name] = valhalla
			end
			if player.npc == 0
				return true
			end
			return false
		end
		
	end
	
	def player_casts_spell(player)
		spell_options = player.spell_list.dup
		spell_options << 'cancel'
		manage_output('Cast which spell?')
		
		spell = manage_input(spell_options)
		if spell == 'cancel'
			return false
		end
		
		manage_output("Cast #{spell} at what target?")
		target = target_options(player, true, current_location)
		if target == 'cancel'
			return false
		end
		
		target = target.partition " "
		target = target.each.collect {|x| x.capitalize}
		target_formatted = ""
		target.each do |x|
			target_formatted += x
		end
		
		player.cast_spell(spell, (current_location.occupants[target_formatted]))
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
	
	def monster_attack(monster)
		if monster.alive? == false
			return
		end
		indexer = 0
		occupants_ary = current_location.occupants.to_a.each.collect {|x| x[1]}
		monster_targets = []
		current_location.occupants.length.times do
			target = occupants_ary[indexer]
			if target.npc == 0
				# target is being pulled as a nil object...
				monster_targets << target
			end
			indexer += 1
		end
		monster.attack(monster_targets.shuffle.first)
	end
	
	def turn_order
		turn_order = []
	end
	
	def	initiative_table
	# send in a 'last player to move' object and remove that player from the list
	# that would prevent the same player from getting to go twice
	# would need error handling for 'nothing' last player
		turn_order = current_location.occupants.each_key.collect {|name| name}
		turn_order.shuffle!
		return turn_order
	end
	
	def initiative(game_turn_counter)
		player = current_location.occupants[(initiative_table[game_turn_counter])]
		return player
	end
	
	def beginning_flavor_text(player)
		manage_output("After months of travelling, #{player.name} finally arrives at some goddamn place or other in search of some goddamn thing or other.")
	end
	
	def playable_characters_name
		['fighter', 'mage']
	end
	
	def playable_characters(name_string)
		definitions = {'fighter' => Fighter,'mage' => Mage}
		definitions[name_string]
	end
	
	def new_player_options
		manage_output('Please choose a class for a new player:')
		class_type = playable_characters(manage_input(playable_characters_name))
		manage_output("Enter a name for a new #{class_type}:")
		name = manage_input([]).capitalize
		
		# String.new not allowed.  I solved this problem before - find it. SOLVED MOTHAFUCKA
		player = new_player(class_type, name, 0)
		manage_output(player.status_check)
		return player
	end
	
	def new_player(type, name, npc)
		player = type.new(name, npc)
		character_list["#{player.name}"] = player
	end
	
	def new_monster(type)
		monster = type.new
		character_list["#{monster.name}"] = monster
	end
	
end

