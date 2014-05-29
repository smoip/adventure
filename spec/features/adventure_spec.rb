require 'minitest/autorun'
require "./adventure"


describe Game do
	it "should do things" do
		new_game = Game.new
		
		
		guide = DungeonMaster.new
		new_game.new_player(guide, Fighter, 'George', 0)
		player = guide.character_list['George']
		
		player.name.must_equal 'George'
		
		new_game.new_monster(guide, Minotaur)
		monster = guide.character_list['Minotaur']

		monster.name.must_equal 'Minotaur'
		
		new_game.new_player(guide, Mage, 'Phillip', 0)
		player_two = guide.character_list['Phillip']
		player_two.currentHP.must_equal 8
		player_two.spell_list.must_equal ['fireball', 'heal']
				
		new_game.turn_counter.must_equal 0
		player.npc.must_equal 0
		
	
	
		player.stub :manage_input, 'yes' do
		# find weapon
			guide.stub :random_item, Weapon do
				guide.find_item(player, (rand(5)))
			end
		
		end
		
		player.stub :manage_input, 'yes' do
		# find potion
			guide.stub :random_item, Potion do
				guide.find_item(player, (rand(5)))
			end
		
		end
		
		player.stub :manage_input, 'yes' do
		# find armor
			guide.stub :random_item, Armor do
				guide.find_item(player, (rand(5)))
			end
		
		end
	
# 		new_game.stub :manage_input, 'move' do
# 			new_game.player_action(guide, player)
# 		end
	
# 		new_game.stub :manage_input, 'item' do
# 			new_game.player_action(guide, player)
# 		end
	
# 		new_game.stub :manage_input, 'spell' do
# 			new_game.player_action(guide, player)
# 		end
		
# 		new_game.stub :manage_input, ('attack') do
# 			guide.stub :manage_input, ('minotaur') do
# 				new_game.player_action(guide, player)
# 			end
# 		end

# 		new_game.stub :manage_input, 'spell' do
# 			new_game.player_action(guide, player_two)
# 		end
		
		new_game.player_action(guide, player_two)
		new_game.turn_counter.must_equal 1
		
	end
end


# stub replaces a method's return
# puts is bad
# mock?
