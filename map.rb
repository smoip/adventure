# what does map do?
# generates 'terrain' as character 'moves'
# rather than tracking the location of objects,
# map tells dm what is present at each square as character moves into it.
# for now, a square only exists while a character is in it
# later versions may track explored terrain

# map decides what objects are present in a new square and reports back to dm

class Game_Map

	include QwertyIO

	def initialize
	end
	
	def new_space
	# defines a new space, its description, what kind of spaces it can lead
	# defines contents of new space
	# possible that what is in a space belongs to DM rather than map
	end
	
end