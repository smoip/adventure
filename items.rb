# what does an item do?
# called by an owner object (character, dm)
# reports effects to owner
# owner executes effects
# are these instantiated objects that exist independently of owner?
# or are they a library whose effects are called from a module?

class Item
	# super class of all items, initializes with name
	# sends effects to Character
	
	def initialize
	end

	
end

class Potion < Item
	# single use items, disappear after use
	# potions, like spells, need a target
	
	def initialize
		@type = 'Potion'
	end
	
	potion_type = [:heal_potion, :magic_potion]
end

class Weapon < Item
	# persistent item, modifies attackPoints
	# persistent items need an owner
	
	def initialize
		@type = 'Weapon'
	end
	
	weapon_type = [:sword, :axe, :bow]
end

class Armor < Item
	# persistent item, modifies defensePoints
	# persistent items need an owner
	
	def initialize
	@type = 'Armor'
	end
	
	armor_type = [:plate, :chain, :leather]
end