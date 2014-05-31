# what does map do?
# generates 'terrain' as character 'moves'
# rather than tracking the location of objects,
# map tells dm what is present at each square as character moves into it.
# for now, a square only exists while a character is in it
# later versions may track explored terrain

# map decides what objects are present in a new square and reports back to dm


# map knows when a monster is in a square
# sends back info to dm on query
# dm decides what monster, instantiates new monster
# dm figures out 'initiative'
# adventure keeps track of turn order

class Room

	include QwertyIO

	def initialize(dungeon_master)
		@type = 'nothing'
		@occupants = {}
		@room_items = {}
		@description = 'a room'
	end
	
		attr_accessor :type, :description
	
	def describe(name)
		manage_output("#{name} enters #{@description}.")
		# also tell what's inside
	end
	
	def creature_inside
		# is someone home?
		if rand(5) == 0
			return true
		else
			return false
		end
	end
	
	def treasure_inside
		# is there booty?
		if rand(8) == 0
			return true
		else
			return false
		end
	end 
	
end

class Hallway < Room

	def initialize(dungeon_master)
		super
		@type = 'hallway'
		@sub_type_one_list = ['narrow,', 'broad,', 'steep,']
		@sub_type_one = @sub_type_one_list.shuffle.first
		@sub_type_two_list = ['twisting', 'straight', 'gently curving']
		@sub_type_two = @sub_type_two_list.shuffle.first
		@description = "a #{@sub_type_one} #{@sub_type_two} hallway"
	end
	
end

class Chamber < Room
	
	def initialize(dungeon_master)
		super
		@sub_type_one_list = ['long,', 'compact,', 'cavernous,']
		@sub_type_one = @sub_type_one_list.shuffle.first
		@sub_type_two_list = ['vaulted', 'high-ceilinged', 'dusty']
		@sub_type_two = @sub_type_two_list.shuffle.first
		@description = "a #{@sub_type_one} #{@sub_type_two} chamber"	
	end

end

class Entrance < Room
	
	def initialize(dungeon_master)
		super
		@type = 'entrance'
		@description = 'the entrance to the dungeon'
	end
	
end
