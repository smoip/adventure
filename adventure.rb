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
		@player_turn_counter = 0
		@game_turn_counter = 0
		@dm = []
		@exit_flag = false
	end
	
	attr_accessor :player_turn_counter, :game_turn_counter, :dm, :exit_flag
	
	def count_player_turn
		@player_turn_counter += 1
	end
	
	def reset_player_turn
		@player_turn_counter = 0
	end
	
	def count_game_turn
		@game_turn_counter += 1
	end
	
	def reset_game_turn
		@game_turn_counter = 0
	end
	
	def start_game
		# initialize game variables, call dm, create character, display opening, create first room
		guide = DungeonMaster.new
		@dm << guide
		player = guide.new_player_options
		guide.beginning_flavor_text(player)
		enter_dungeon(guide, player)
		run_game
	end
	
	def end_game
		manage_output('Your journey has ended.')
		exit
	end
	
	def enter_dungeon(dungeon_master, player)
		dungeon_master.initial_room(player)
	end
	
	def player_order(dungeon_master)
		player = dungeon_master.initiative(@game_turn_counter)
		return player
	end
	
	def execute_turn(dungeon_master)
		(dungeon_master.current_location.occupants.length).times do
			player = player_order(dungeon_master)
			player_action(dungeon_master, player)
			count_game_turn
		end
	end
	
	def run_game
		until @exit_flag == true
			execute_turn(dm[0])
			reset_game_turn
		end
		if @exit_flag == true
			end_game
		end
	end
	
	def player_action(dungeon_master, player)
		# player_turn_counter might go in here instead of instance var
		# then call is 0 at start, increment at end
		# or just reset it to zero at start, call player_action for as many players as there are
		if player.npc == 0
			until @player_turn_counter != 0
				dungeon_master.ask_player(player)
			
				player_move = Proc.new do
					if dungeon_master.player_moves(player) == true
						count_player_turn
					end
				end
			
				player_attack = Proc.new do
					# call a method from DM for this handling
					if dungeon_master.player_attacks(player) == true
						count_player_turn
					end
				end
	
				player_item = Proc.new do
					dungeon_master.player_uses_item(player)
					count_player_turn
				end
	
				player_spell = Proc.new do
					if dungeon_master.player_casts_spell(player) == true
						count_player_turn
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
			
		elsif player.npc == 1
			dungeon_master.monster_attack
		end
		reset_player_turn
	end
	
end

new_game = Game.new
new_game.start_game