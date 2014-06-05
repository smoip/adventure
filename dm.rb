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
	@world_map_list = []
	@world_map_location = 0
	end

	attr_accessor :game_items, :character_list, :map_list, :map_location

	def wait
		diff = 0
		until diff == 10000000
			diff += 1
		end
	end

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
		room.enter_description(player.name)
	end
	
	def player_looks(player)
		current_location.describe(player.name)
		false
	end
	
	def player_moves(player)
		manage_output('Move in which direction?')
		
		# handling for moving from 'outside' space back into dungeon
		if @map_location < 0
			direction = manage_input(['dungeon','cancel'])
			if direction == 'dungeon'
				move_character_from_room(player)
				@map_location += 1
				move_character_to_room(player)
				current_location.enter_description(player.name)
				return true
			elsif direction == 'cancel'
				return false
			end
		end

		direction = manage_input(['north', 'n', 'south', 's', 'cancel'])
		if direction == 'cancel'
			return false
		end
		
		if current_location.occupants.length > 1
			if rand(2 + player.agility) == 0
				manage_output "#{player.name} is attacked while fleeing the #{current_location.type}!"
				monster_options = current_location.occupants.each_key.collect {|x| x }
				# turn creature list into array
				monster_options.delete_at(monster_options.index(player.name))
				# remove player from actionable options
				monster_attack(monster_options.shuffle.first)
			end
		end
		
		move_character_from_room(player)
		
		if direction == 'north' or direction == 'n'
			@map_location += 1
		elsif direction == 'south' or direction == 's'
			@map_location -= 1
		end
		
		if @map_location < 0
			manage_output "Leave the dungeon?"
			input = manage_input(['yes', 'no'])
			if input == 'yes'
				leave_dungeon(player)
				return true
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
		room.enter_description(player.name)
		
		true
	end
	
	def current_location
		if @map_location >= 0
			return @map_list[@map_location]
		elsif @map_location < 0
			return @world_map_list[@world_map_location]
		end
	end
	
	
	def enter_dungeon(player)
		manage_output("#{player.name} descends once more into the dungeon's forbidding maw...")
		move_character_to_room(player)
	end
	
	def leave_dungeon(player)
		manage_output("#{player.name} climbs the long stair leading out of the dungeon and emerges blinking into the sunlight.")
		if @world_map_list == []
			new_outside_space(self)
		end
		move_character_to_room(player)
	end
	
	def monster_table
		monster_table = [Slime, GiantRat, Serpent, Skeleton, Minotaur, LizardMan, DemiLich, GreenDragon]
	end
	
	def monster_type(monster_table)
		# every five rooms shifts down one group of three possible enemies
		dungeon_depth = @map_location / 10
		max_length = monster_table.length - 2
		if dungeon_depth > max_length
			dungeon_depth = max_length
		end
		local_monsters = monster_table.values_at((dungeon_depth)..(dungeon_depth + 2))
		local_monsters.shuffle.first
	end
	
	def choose_monster(player)
		
		monster = new_monster(monster_type(monster_table))
		level = (player.level + (rand(4)-1))
		if level < 0
			level == 0
		end
		level.times do
			monster.force_level_up
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
	
	def new_outside_space(dungeon_master)
		room = Outside.new(dungeon_master)
		@world_map_list << room
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
		
		chosen_target = current_location.occupants[target_formatted]
		player.attack(chosen_target)
		if check_living(chosen_target) == false
			character_dies(player, chosen_target)
		end
		
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
	
	def player_takes(player)
	
		indexer = 0
		items_ary = current_location.room_items.to_a.each.collect {|x| x[1] if x[1].kind_of? Item}
		# convert room_items to array, remove 'name' key, return Object only if type is Item

		take_options = []
		if items_ary == []
			manage_output('There is nothing to take...')
			return
		end
		items_ary.length.times do
				take_options << items_ary[indexer].name
			indexer += 1
		end

		take_options << 'cancel'
		item = current_location.room_items[manage_input(take_options)]
		take_item(player, item)
	end
	
	def check_living(player)
		if player.alive? == false
			valhalla = current_location.occupants.delete("#{player.name}")
			player.name = "#{player.name}(dead)"
			current_location.room_items[player.name] = valhalla
			return false
		else
			return true
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
		
		chosen_target = current_location.occupants[target_formatted]
		player.cast_spell(spell, (chosen_target))
		if check_living(chosen_target) == false
			character_dies(player, chosen_target)
		end
		
		true
	end
	
	def item_type
		[Potion, Weapon, Armor]
	end
	
	def item_found?
		if rand(4) == 0
			return true
		else
			return false
		end
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
		
		take_item(character, item)
		# splitting this out into another method makes it accessible to 'take'
	
	end
	
	def take_item(character, item)
		
		character_decision = character.receive_item(item)
		
		if (character_decision[0]) == true
			@game_items.pop
			if character_decision[1].type != 'nothing'
				current_location.room_items[(character_decision[1]).name] = character_decision[1]
			end		
		elsif (character_decision[0]) == false
			left_item = @game_items.pop
			current_location.room_items[left_item.name] = left_item
		end
		
	end
	
	def player_rests(player)
		hp_diff = player.maxHP - player.currentHP
		mp_diff = player.maxMP - player.currentMP
		if hp_diff >= mp_diff
			rest_time = hp_diff
		elsif mp_diff > hp_diff
			rest_time = mp_diff
		end
		
		if current_location.occupants.length > 1
			manage_output("#{player.name} cannot rest while there are enemies about!")
			return true
		end
		
		wake_up = false
		manage_output("#{player.name} nods off...")
		rest_time.times do
			player.hp=(1)
			player.mp=(1)
			wait
			player.count_temp_mod
			manage_output('...')
			unless current_location.type == 'outside'
				if rand(3) == 0
					wake_up = true
					monster = choose_monster(player)
					manage_output("#{player.name} is woken suddenly by a #{monster.name}!")
					monster_attack(monster)
				end
			end
			if wake_up == true
				return true
			end
		end
		manage_output("#{player.name} awakes, feeling refreshed.")
		true
	end
	
	def drop_item(player, item)
		# take item from player.inventory and put in room_items
	end
	
	def check_game_items
		manage_output("Game Items: ")
		@game_items.each { |x| manage_output(x.name) }
	end
	
	def character_dies(slayer, slain)
		if item_found?
			manage_output("#{slayer.name} finds something on the body of the #{slain.name}!")
			find_item(slayer, slain.level)
		end
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
		chosen_target = monster_targets.shuffle.first
		if chosen_target == nil
			return
		end
		
		if monster.spell_list != []
			monster_spell = monster.spell_list.shuffle.first
			if monster.cast_spell(monster_spell, chosen_target) == false
				monster.attack(chosen_target)
			end
			
		else
			monster.attack(chosen_target)
		end
		
		check_living(chosen_target)
		wait
	end
	

	def	initiative_table
	# send in a 'last player to move' object and remove that player from the list
	# that would prevent the same player from getting to go twice
	# would need error handling for 'nothing' last player
		turn_order = current_location.occupants.each_key.collect {|name| name}
		turn_order.shuffle!
		return turn_order
	end
	
	def initiative(game_turn_counter, table)
		player = current_location.occupants[(table[game_turn_counter])]
		return player
	end
	
	def beginning_flavor_text(player)
		manage_output("After months of travelling, #{player.name} finally arrives at some goddamn place or other in search of some goddamn thing or other.")
	end
	
	def playable_characters_name
		['fighter', 'mage', 'thief']
	end
	
	def playable_characters(name_string)
		definitions = {'fighter' => Fighter,'mage' => Mage, 'thief' => Thief}
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

