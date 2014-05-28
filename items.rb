# what does an item do?
# called by an owner object (character, dm)
# reports effects to owner
# owner executes effects
# are these instantiated objects that exist independently of owner - yes
# or are they a library whose effects are called from a module - both

class Item
	# super class of all items, initializes with name
	# sends effects to Character
	
	def initialize(item_lev)
		@type = 'nothing'
		@sub_type = 'nothing'
		@name = 'nothing'
		@attack_mod = 0
		@defense_mod = 0
		@item_level = item_lev
	end

	attr_accessor :type, :sub_type, :attack_mod, :defense_mod, :item_level, :name
	
	def report_item_stats
		return [(@attack_mod + @item_level), (@defense_mod + @item_level)]
	end
	
end

class Potion < Item
	# single use items, disappear after use
	# for now, level does nothing
	
	
	def initialize(item_lev)
		super
		@type = 'potion'
		@sub_type_list = ['healing potion', 'magic potion']
		@sub_type = @sub_type_list.shuffle.first
		@name = @sub_type
	end

	def report_item_stats
		return [0, 0]
		# cancels out super - potions don't change stats
	end

end

class Weapon < Item
	# persistent item, modifies attackPoints
	# persistent items need an owner
	
	def initialize(item_lev)
		super
		@type = 'weapon'
		@sub_type_list = ['dagger', 'axe', 'sword']
		@sub_type = @sub_type_list.shuffle.first
		@name = "#{@sub_type} + #{item_lev}"
	end

	def report_item_stats
		@attack_mod = (@sub_type_list.index(@sub_type) + 1)
		@defense_mod = (-@item_level)
		super
	end

end

class Armor < Item
	# persistent item, modifies defensePoints
	# persistent items need an owner
	
	def initialize(item_lev)
		super
		@type = 'armor'
		@sub_type_list = ['leather armor', 'chain mail', 'plate armor']
		@sub_type = @sub_type_list.shuffle.first
		@name = "#{@sub_type} + #{item_lev}"
	end

	def report_item_stats
		@defense_mod = (@sub_type_list.index(@sub_type) + 1)
		@attack_mod = (-@item_level)
		super
	end

end