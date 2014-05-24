# what does adventure do?
# main coordinator
# calls all other objects
# loads dependencies
# handles user-end display 
# In a future version, handles all IO issues (remove puts, print from internal objects)

$LOAD_PATH.insert(0, "/users/laevsky/documents/learning ruby/adventure")
require "character.rb"
require "dm.rb"
require "map.rb"
require "magic.rb"
require "items.rb"


class Game


	def initialize
	end
	
end


guide = Dungeon_Master.new
player = Mage.new('Thaddeus', 0)

guide.find_item(player)
