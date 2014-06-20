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
require "art"
require "audio/music"

class Game

	include QwertyIO
	include Art


	def initialize
		@player_turn_counter = 0
		@game_turn_counter = 0
		@dm = []
		@exit_flag = false
	end
	
	attr_accessor :player_turn_counter, :game_turn_counter, :dm, :exit_flag
	
	def count_player_turn
		@player_turn_counter += 1
		# call temp_mod_checks
		@dm[0].current_location.occupants.each_value {|character| character.count_temp_mod}
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
	
	def welcome_text
		manage_output('')
		art_main_logo
    	manage_output('')
    	manage_output('by David Roberts')
    	manage_output('v1.0')
    	manage_output('')
    	manage_output('press \'enter\' to begin')
    	manage_input([])
    	manage_output('Welcome to Adventure!')
	end
	
	def start_game
		# initialize game variables, call dm, create character, display opening, create first room
		guide = DungeonMaster.new
		@dm << guide
		welcome_text
		player = guide.new_player_options
		guide.beginning_flavor_text(player)
		 enter_dungeon_first_time(guide, player)
		run_game
	end
	
	def end_game
		manage_output('Your journey has ended.')
		exit
	end
	
	def enter_dungeon_first_time(dungeon_master, player)
		dungeon_master.initial_room(player)
	end
	
	def any_player_chars_left?(dungeon_master)
		player_chk_ary = dungeon_master.current_location.occupants.each_value.collect {|character| (character.npc - 1).abs}
		indexer = 0
		player_flag = 0
		player_chk_ary.length.times do
			player_flag += player_chk_ary[indexer]
			indexer += 1
		end
		unless player_flag > 0
			@exit_flag = true
			return false
		end
		true
	end
	
	def execute_turn(dungeon_master)
		unless any_player_chars_left?(dungeon_master) == false
			chars_in_room = dungeon_master.current_location.occupants.length
			table = dungeon_master.initiative_table
			chars_in_room.times do
				
				player = dungeon_master.initiative(@game_turn_counter, table)
			
				player_action(dungeon_master, player)
				count_game_turn
				
				if dungeon_master.current_location.occupants.length != chars_in_room
					# early return if somebody died as a result of turn action
					# is also called when a new creatures appears as a result of movement
					return
				end
			end
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
# 		unless player.alive? == true
# 			reset_player_turn
# 			return
# 		end
# 		too loopish - fix this by popping dead characters out of the player list
		if player == nil
			return
		end
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
				
				player_take = Proc.new do
					if dungeon_master.player_takes(player) == true
						count_player_turn
					end
				end
				
				player_status = Proc.new do
					manage_output(player.status_check)
				end
				
				
				player_inventory = Proc.new do
					manage_output(player.inventory_check)
				end
				
				player_look = Proc.new do
					dungeon_master.player_looks(player)
				end
				
				player_rest = Proc.new do
					dungeon_master.player_rests(player)
				end
			
				action_choice = {'move' => player_move, 'm' => player_move, 'attack' => player_attack, 'a' => player_attack, 'item' => player_item, 'i' => player_item, 'spell' => player_spell, 's' => player_spell, 'take' => player_take, 'status' => player_status, 'inventory' => player_inventory, 'look' => player_look, 'rest' => player_rest}
				action_choice[manage_input(['move', 'm', 'attack', 'a', 'item', 'i', 'spell', 's', 'take', 'status', 'inventory', 'look', 'rest'])].call
			end
			
		elsif player.npc == 1
			dungeon_master.monster_attack(player)
			count_player_turn
		end
		reset_player_turn
	end
	
end

if __FILE__==$0
	new_game = Game.new
	new_game.start_game
end