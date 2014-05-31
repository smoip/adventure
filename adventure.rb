# what does adventure do?
# main coordinator
# calls all other objects
# loads dependencies
# handles user-end display 
# In a future version, handles all IO issues (remove puts, print from internal objects)


# need to implement a 'turn' system
# what constitutes a turn?
# move, attack, item, spell

$: << File.expand_path(File.dirname("adventure"))

require "character"
require "dm"
require "map"
require "magic"
require "items"
require "qwertyio"


class Game

	include QwertyIO


	def initialize
		@turn_counter = 0
	end
	
	attr_accessor :turn_counter
	
	def count_turn
		@turn_counter += 1
	end
	
	def enter_dungeon(dungeon_master, player)
		dungeon_master.new_room(player)
	end
	
	def player_action(dungeon_master, player)
		if player.npc == 0
			until @turn_counter != 0
				dungeon_master.ask_player(player)
			
				player_move = Proc.new do
					if dungeon_master.player_moves(player) == true
						count_turn
					end
				end
			
				player_attack = Proc.new do
					# call a method from DM for this handling
					if dungeon_master.player_attacks(player) == true
						count_turn
					end
				end
	
				player_item = Proc.new do
					dungeon_master.player_uses_item(player)
					count_turn
				end
	
				player_spell = Proc.new do
					if dungeon_master.player_casts_spell(player) == true
						count_turn
					end
				end
			
				player_status = Proc.new do
					manage_output(player.status_check)
				end
				
				player_inventory = Proc.new do
					manage_output(player.inventory_check)
				end
			
				action_choice = {'move' => player_move, 'attack' => player_attack, 'item' => player_item, 'spell' => player_spell, 'status' => player_status, 'inventory' => player_inventory}
				action_choice[manage_input(['move', 'attack', 'item', 'spell', 'status', 'inventory'])].call
			end
		end
	end
	
# 	need something that decides active order (inititave)
# 	the one currently in dm sucks
# 	maybe dm checks the list of who is currently in the room (room.occupants)
# 	assigns 1-n to a new attribute (Character.initiative)
# 	Characters cycle through player_action (or a new monster_action) based on Character.initiative
# 	Once all characters have cycled through, reset turn_counter.
	

	
end



# new_game = Game.new
# 
# new_game.new_player(Fighter, 'George', 0)
# player = new_game.character_list['George']
# 
# new_game.new_monster(Minotaur)
# monster = new_game.character_list['Minotaur']
# 
# guide = DungeonMaster.new
# 
# player = Mage.new('Thaddeus', 0)
# 
# puts "npc Flag: #{player.npc}"
# puts "counter: #{new_game.turn_counter}"
# 
# guide.battle(player, monster)
# 
# guide.find_item(player, (rand(5)))
# 
# new_game.player_action(player)