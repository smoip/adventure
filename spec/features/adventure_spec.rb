require 'minitest/autorun'
require "./adventure"


describe Game do
	it "should do things" do
		new_game = Game.new
		
		
		
		
		manual_dm = DungeonMaster.new
		manual_dm.new_player(Fighter, 'George', 0)
		player_one = manual_dm.character_list['George']
		
		player_one.name.must_equal 'George'
		
		test_room = Room.new(manual_dm)
		test_room.occupants[player_one.name] = player_one
		
		player_type = test_room.occupants[player_one.name].instance_of? Fighter
		player_type.must_equal true
		# objects in occupants are players
		
		test_table = []
		
		manual_dm.stub :current_location, test_room do
			test_table = manual_dm.initiative_table
		end
		
		name_type = test_table[0].instance_of? String
		name_type.must_equal true
		#confirms that returns from initiative_table are name strings from character input
		

		another_test_player = []
		
		manual_dm.stub :current_location, test_room do
			another_test_player = manual_dm.initiative(0)
		end
		
		another_test_player.name.must_equal 'George'
		#confirms that returns from initiative are Character objects

		
		manual_dm.new_monster(Minotaur)
		monster = manual_dm.character_list['Minotaur']

		monster.name.must_equal 'Minotaur'
		
		manual_dm.new_player(Mage, 'Phillip', 0)
		player_two = manual_dm.character_list['Phillip']
		player_two.currentHP.must_equal 8
		player_two.spell_list.must_equal ['fireball', 'heal']
				
		new_game.player_turn_counter.must_equal 0
		player_one.npc.must_equal 0
		
	
	
		player_one.stub :manage_input, 'yes' do
		# find weapon
			manual_dm.stub :random_item, Weapon do
				manual_dm.find_item(player_one, (rand(5)))
			end
		
		end
		
		player_one.stub :manage_input, 'yes' do
		# find potion
			manual_dm.stub :random_item, Potion do
				manual_dm.find_item(player_one, (rand(5)))
			end
		
		end
		
		player_one.stub :manage_input, 'yes' do
		# find armor
			manual_dm.stub :random_item, Armor do
				manual_dm.find_item(player_one, (rand(5)))
			end
		
		end
		
		player_two.stub :manage_input, 'yes' do
		# find potion
			manual_dm.stub :random_item, Potion do
				manual_dm.find_item(player_two, (rand(5)))
			end
		
		end
		
		manual_dm.new_room(true, manual_dm)
		manual_dm.new_room(false, manual_dm)
		(manual_dm.map_list[0]).type.must_equal 'entrance'
		puts manual_dm.map_list[1].description
		
	
		new_game.stub :manage_input, 'move' do
			manual_dm.stub :manage_input, 'forward' do
				new_game.player_action(manual_dm, player_one)
			end
		end
		
		manual_dm.map_list.length.must_equal 2
		manual_dm.map_location.must_equal 1
		
		new_game.player_turn_counter = 0
		
		new_game.stub :manage_input, 'move' do
			manual_dm.stub :manage_input, 'backward' do
				new_game.player_action(manual_dm, player_one)
			end
		end
		
		new_game.player_turn_counter = 0
		
		new_game.stub :manage_input, 'move' do
			manual_dm.stub :manage_input, 'forward' do
				new_game.player_action(manual_dm, player_one)
			end
		end
	
# 		new_game.stub :manage_input, 'item' do
# 			new_game.player_action(manual_dm, player_one)
# 		end
	
# 		new_game.stub :manage_input, 'spell' do
# 			new_game.player_action(manual_dm, player_one)
# 		end
		
# 		new_game.stub :manage_input, ('attack') do
# 			manual_dm.stub :manage_input, ('minotaur') do
# 				new_game.player_action(manual_dm, player_one)
# 			end
# 		end

# 		new_game.stub :manage_input, 'spell' do
# 			new_game.player_action(manual_dm, player_two)
# 		end
		
		manual_dm.map_location.must_equal 1
		new_game.player_turn_counter.must_equal 0
		
		puts 'Dm Char list:'
		manual_dm.character_list.each {|x| puts x.to_s}
		
		puts 'Map Char list:'
		manual_dm.current_location.occupants.each {|x| puts x.to_s}

		
# 		another_game = Game.new
# 	
# 		another_game.start_game
		
		
		
	end
end


# stub replaces a method's return
# puts is bad
# mock?
