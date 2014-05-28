# what does adventure do?
# main coordinator
# calls all other objects
# loads dependencies
# handles user-end display 
# In a future version, handles all IO issues (remove puts, print from internal objects)


# need to implement a 'turn' system
# what constitutes a turn?
# move, attack, item, spell

$LOAD_PATH.insert(0, "/users/roberts/documents/learning ruby/adventure")
require "character"
require "dm"
require "map"
require "magic"
require "items"
require "qwertyio"
include QwertyIO


class Game

	def initialize
	end
	
	
end

new_game = Game.new

guide = DungeonMaster.new
player = Mage.new('Thaddeus', 0)
monster = Minotaur.new

# guide.battle(player, monster)

manage_output(player.status_check)
guide.find_item(player, (rand(5)))
manage_output(player.status_check)
guide.find_item(player, 2)
manage_output(player.status_check)
guide.find_item(player, 3)
manage_output(player.status_check)
guide.find_item(player, (rand(2)))
manage_output(player.status_check)
guide.find_item(player, (rand(4)))
manage_output(player.status_check)
# come back to this later

manage_output("use potion?")
manage_input(['yes'])
player.use_potion('healing potion')
manage_output(player.status_check)
player.inventory_check
guide.check_game_items
