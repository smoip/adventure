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
	
		attr_accessor :type, :description, :occupants, :room_items
	
	def enter_description(name)
		descriptor_string = "#{name} enters #{@description}"
		if @occupants.length >= 2
			indexer = 0
			occupants_ary = @occupants.to_a.each.collect {|x| x[1]}
			# convert @occupants to array, remove 'name' key, return Character object only
			npc_occupants = []
			@occupants.length.times do
				if occupants_ary[indexer].npc == 1
					npc_occupants << occupants_ary[indexer]
				end
				indexer += 1
			end
			descriptor_string += " and encounters"
			indexer = 0
			npc_occupants.length.times do
				if indexer >= 1 
					descriptor_string += " and"
				end
				descriptor_string += " a #{npc_occupants[indexer].name}"
				indexer += 1
			end
			descriptor_string += "!"
		else 
			descriptor_string += "."
		end
		
		unless @room_items == {}
			descriptor_string += "  The #{@type} contains the following: "
			@room_items.each_key {|name| descriptor_string += "#{name}, "}
		end
		
		manage_output(descriptor_string)
		
	end
	
	def describe(name)
		descriptor_string = "#{name} is "
		if @occupants.length >= 2
			indexer = 0
			occupants_ary = @occupants.to_a.each.collect {|x| x[1]}
			# convert @occupants to array, remove 'name' key, return Character object only
			npc_occupants = []
			@occupants.length.times do
				if occupants_ary[indexer].npc == 1
					npc_occupants << occupants_ary[indexer]
				end
				indexer += 1
			end
			
			descriptor_string += "in #{@description} with a"
			npc_occupants.length.times do
				indexer = 0

				descriptor_string += " #{npc_occupants[indexer].name}!"
			end
		else
			descriptor_string += "alone in #{@description}."
		end
		
		unless @room_items == {}
			descriptor_string += "  The #{@type} contains the following: "
			@room_items.each_key {|name| descriptor_string += "#{name}, "}
		end
		
		manage_output(descriptor_string)
		
	end
	
	def creature_inside
		# hello?
		unless self.type == 'entrance'
			if rand(5) == 0
				return true
			else
				return false
			end
		end
		return false
	end
	
	def treasure_inside
		# booty?
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
		@type = 'chamber'
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

class Outside < Room
	
	def initialize(dungeon_master)
		super
		@type = 'outside'
		@description = 'a craggy wasteland tumbling out from the foot of a high cliff from which the entrance to the dungeon yawns ominously.  In spite of its inhospitability, it looks like it might be a safe place to rest'
	end
	
end
