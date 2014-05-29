require 'minitest/autorun'
require "./adventure"


describe Game do
	it "should do things" do
		new_game = Game.new
		
		

		new_game.new_player(Fighter, 'George', 0)
		player = new_game.character_list['George']

		new_game.new_monster(Minotaur)
		monster = new_game.character_list['Minotaur']

		guide = DungeonMaster.new
		
		new_game.turn_counter.must_equal 0
		player.npc.must_equal 0
		
		
		player.stub :manage_input, 'yes' do
			
			guide.stub :random_item, Weapon do
				guide.find_item(player, (rand(5)))
			end
			
		end
		
		new_game.stub :manage_input, 'move' do
			new_game.player_action(player)
		end
		
		new_game.turn_counter.must_equal 1
		
	end
end


# stub replaces a method's return
# puts is bad