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
	@type = item
	@sub_type = 'item'
	end

	attr_accessor :type, :sub_type
	
end

class Potion < Item
	# single use items, disappear after use
	# potions, like spells, need a target
	
	def initialize
		@type = 'potion'
		@sub_type = ['healing potion', 'magic potion'].shuffle.first
	end

end

class Weapon < Item
	# persistent item, modifies attackPoints
	# persistent items need an owner
	
	def initialize
		@type = 'weapon'
		@sub_type = ['sword', 'axe', 'bow'].shuffle.first
	end

end

class Armor < Item
	# persistent item, modifies defensePoints
	# persistent items need an owner
	
	def initialize
		@type = 'armor'
		@sub_type = ['plate', 'armor', 'leather'].shuffle.first
	end

end