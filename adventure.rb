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
include QwertyIO


class Game

	def initialize
		@turn_counter = 0
		@character_list = {}
	end
	
	attr_accessor :turn_counter, :character_list
	
	def count_turn
		@turn_counter += 1
	end
	
	def player_action(player)
		if player.npc == 0
			until @turn_counter ==1
				manage_output("What does #{player.name} do?")
			
				player_move = Proc.new do
					manage_output("#{player.name} moves.")
					count_turn
				end
			
				player_attack = Proc.new do
					manage_output('Attack what?')
					target_options = @character_list.each_key.collect {|x| x.to_s }
					target_options.shift
					target_options
					
					# problem line
					target = manage_input((target_options).capitalize)
					puts "#{player.name} attacks #{target}"
					count_turn
				end
	
				player_item = Proc.new do
					puts 'you use something'
					count_turn
				end
	
				player_spell = Proc.new do
					puts 'you cast something'
					count_turn
				end
			
				player_status = Proc.new do
					manage_output(player.status_check)
				end
				
				player_inventory = Proc.new do
					manage_output(player.inventory_check)
				end
			
				# this line is trouble - could be done with 'if's but I can't figure out how to call methods from the hash
				# maybe they should be done with procs
				action_choice = {'move' => player_move, 'attack' => player_attack, 'item' => player_item, 'spell' => player_spell, 'status' => player_status, 'inventory' => player_inventory}
				action_choice[manage_input(['move', 'attack', 'item', 'spell', 'status', 'inventory'])].call
			end
		end
	end
	
	def new_player(type, name, npc)
		player = type.new(name, npc)
		@character_list["#{player.name}"] = player
	end
	
	def new_monster(type)
		monster = type.new
		@character_list["#{monster.name}"] = monster
	end
	
end

new_game = Game.new

new_game.new_player(Fighter, 'George', 0)
player = new_game.character_list['George']

new_game.new_monster(Minotaur)
monster = new_game.character_list['Minotaur']

guide = DungeonMaster.new

#player = Mage.new('Thaddeus', 0)

puts "npc Flag: #{player.npc}"
puts "counter: #{new_game.turn_counter}"

# guide.battle(player, monster)

guide.find_item(player, (rand(5)))

new_game.player_action(player)