require "magic"
require "qwertyio"

class Character

	include Magic
	include QwertyIO

	def initialize (inName, npcFlag)
		@name = inName
		@npc = npcFlag
		@maxHP = 10
		@currentHP = maxHP
		@maxMP = 10
		@currentMP = maxMP
		@attackPoints = 1
		@defensePoints = 1
		@level = 0
		@charExp = 0
		@expValue = 1
		@alive = true
		@inventory = {'potion' => Item.new(0), 'weapon' => Item.new(0), 'armor' => Item.new(0)}
		@spell_list = []
	end
	
	attr_accessor :name, :maxHP, :currentHP, :maxMP, :currentMP, :attackPoints, :defensePoints, :level, :charExp, :expValue, :npc, :inventory, :npc, :spell_list
	# same as defining methods to write/return @name, @currentHP, etc.
	
	def alive?
		if @currentHP <= 0
			false
		else
			true
		end
	end
	
	
	def hp=(amount)
		@currentHP += amount
		if @currentHP > @maxHP
			@currentHP = @maxHP
		elsif @currentHP < 0
			@currentHP = 0
		end
		unless alive?
			manage_output("#{name} has perished.")
		end
	end
	
	def mp=(amount)
		@currentMP += amount
		if @currentMP > @maxMP
			@currentMP = @maxMP
		elsif @currentMP < 0
			@currentMP = 0
		end
	end

	def status_check
		["Name: #{name}", "Level: #{level}", "Exp: #{charExp}", "Class: #{self.class}", "Hit Points: #{currentHP}/#{maxHP}", "Magic Points: #{currentMP}/#{maxMP}", "Attack: #{attackPoints}", "Defense: #{defensePoints}"]
	end
	
	def attack(target)
		if target.alive?
			manage_output(self.name + ' attacks ' + target.name + '.')
			if rand(target.defensePoints) == 0		
				manage_output(target.name + " takes #{self.attackPoints} damage!")
				target.hp=(-(self.attackPoints))
					unless target.alive?
						gain_exp(target.expValue)
					end
			else
				manage_output(self.name + ' misses!')
			end
		else
			manage_output(target.name + ' is already dead.')
		end
	end
	
	def gain_exp amount
		# adds exp to total
		# only prints for player character
		unless @npc == 1
			manage_output("#{name} gains #{amount} experience.")
		end
		@charExp += amount
		level_check
	end
	
	def level_check
		# checks current exp against level up table
		# performs level up if applicable
		if @level < (@charExp/10)
			level_up
		end
	end
	
	def level_up
		while level < (@charExp/10)
			unless @npc == 1
			# don't print npc level up info
				manage_output(self.name + ' gains a level!')
			end
			@level += 1
			@charExp -= (@level * 10)
			stats_up
		end
	end
		
	def stats_up
		@maxHP += 2
		@maxMP += 2
		@attackPoints += 1
		@defensePoints += 1
		@expValue += 1
	end
	
	def cast_spell(spell_name, target)
		manage_output("#{name} casts #{spell_name}.")
		spell_effect = spells[spell_name]
		if self.currentMP < spell_effect['mp']
			manage_output('Not enough MP.')
		else
			self.mp=(-(spell_effect['mp']))
			target.hp=(spell_effect['target_hp'])
			effect_string = "#{target.name} "
			if (spell_effect['target_hp']) > 0
				effect_string += 'gains '
			elsif (spell_effect['target_hp']) < 0
				effect_string += 'loses '
			end
			effect_string += "#{(spell_effect['target_hp']).abs} hit points!"
			manage_output(effect_string)
		end
	end
	
	
	def use_potion(potion_name)
		if (@inventory['potion']).sub_type.to_s == potion_name
			manage_output("#{name} uses #{potion_name}.")
			potion_effect = potions[potion_name]
			self.hp=(potion_effect['hp'])
			self.mp=(potion_effect['mp'])
			manage_output("#{name} recovers #{potion_effect['hp']} hit points and #{potion_effect['mp']} magic points.")
			@inventory['potion'] = Item.new(0)
		else
			manage_output("#{name} does not have that potion.")
		end
	end
	
	
	def recieve_item(item)
		manage_output("#{@name} has found #{item.name}.")
		manage_output("Keep #{item.name} and replace #{(@inventory[item.type]).name}?")
		response = manage_input(['yes', 'no'])
		if response == 'yes'
			
			old_item = @inventory[item.type]
			apply_stats = old_item.report_item_stats
			@attackPoints -= apply_stats[0]
			@defensePoints -= apply_stats[1]
			
			@inventory[item.type] = item
			apply_stats = item.report_item_stats
			@attackPoints += apply_stats[0]
			@defensePoints += apply_stats[1]
			
			return [true, old_item]
		end
		if response == 'no'
			manage_output("#{@name} leaves the #{item.name}.")
			return [false, nil]
		end
	end
	
	def inventory_check
		manage_output("#{@name}'s Inventory: ")
		manage_output("Potion: #{@inventory['potion'].name}")
		manage_output("Weapon: #{@inventory['weapon'].name}")
		manage_output("Armor: #{@inventory['armor'].name}")
	end
	
end

#-----------------------


class Fighter < Character
	
	def initialize inName, npcFlag
		super
		@maxHP += 5
		@currentHP = @maxHP
		@maxMP -= 5
		@currentMP = @maxMP
		@attackPoints += 1
		@defensePoints += 1
	end

	def stats_up
		@maxHP += 3
		@maxMP += 1
		@attackPoints += 2
		@defensePoints += 2
	end
	
end

class Mage < Character
	
	def initialize inName, npcFlag
		super
		@maxHP -= 2
		@currentHP = @maxHP
		@maxMP += 8
		@currentMP = @maxMP
		@spell_list << 'fireball'
		@spell_list << 'heal'
	end
	
	def stats_up
		@maxHP += 1
		@maxMP += 3
		@attackPoints += 2
		@defensePoints += 1
	end
	
	def status_check
		status = super 
		status << ["Spells: #{@spell_list.each {|x| x.to_s}}"]
		status
	end
end

class Minotaur < Character
	
	def initialize
		super('Minotaur', 1)
		@maxHP += 5
		@currentHP = @maxHP
		@maxMP -= 10
		@attackPoints += 1
		@currentMP = @maxMP
		@expValue += 1
	end
end

class GiantRat < Character
	
	def initialize
		super('Giant Rat', 1)
		@maxHP -= 2
		@currentHP = @maxHP
		@maxMP -= 10
		@currentMP = @maxMP
	end
end
#--------------------




