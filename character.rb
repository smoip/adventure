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
		@agility = 1
		@ap_mod = 0
		@dp_mod = 0
		@ag_mod = 0
		@level = 0
		@charExp = 0
		@exp_value = 1
		@alive = true
		@inventory = {'potion' => Item.new(0), 'weapon' => Item.new(0), 'armor' => Item.new(0)}
		@gold = 0
		@spell_list = []
		@spell_modifiers = {'attack' => [0, 0], 'defense' => [0, 0], 'agility' => [0, 0]}
		# spell mod - reference by mod attr, ary[0] is modifier, ary[1] is turns left (counted by count_player_turn)
		# and reset by 'rest'
	end
	
	attr_accessor :name, :maxHP, :currentHP, :maxMP, :currentMP, :attackPoints, :defensePoints, :agility, :level, :charExp, :exp_value, :npc, :inventory, :npc, :spell_list, :gold, :spell_modifiers, :ap_mod, :dp_mod, :ag_mod
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
		status = ["Name: #{name}", "Level: #{level}", "Exp: #{charExp}", "Class: #{self.class}", "Hit Points: #{currentHP}/#{maxHP}", "Magic Points: #{currentMP}/#{maxMP}", "Attack: #{real_attack_points}", "Defense: #{real_defense_points}", "Agility: #{real_agility_points}", "Gold: #{gold}"]
		if @spell_list != []
			status << ["Spells: #{@spell_list.each {|x| x.to_s}}"]
		end
		status
	end
	
	def learn_spell(spell)
		@spell_list << spell
		unless @npc == 1
			manage_output("#{@name} has learned the spell #{spell}!")
		end
	end
	
	def hit_ratio(target)
		hit_ratio = 0
		if real_agility_points > target.real_agility_points
			hit_ratio = 1
		elsif real_agility_points <= target.real_agility_points
			hit_ratio = target.real_agility_points - real_agility_points
			if hit_ratio < 2
				hit_ratio = 2
			end
		end
		return hit_ratio
	end
	
	def damage_amount(target)
		damage = real_attack_points - (target.real_defense_points/2)
		if damage <= 0
			damage = 1
		end
		return damage
	end
	
	def attack(target)
		if target.alive?
			manage_output(self.name + ' attacks ' + target.name + '.')
			if rand(hit_ratio(target)) == 0
				damage = damage_amount(target)
				manage_output(target.name + " takes #{damage} damage!")
				target.hp=(-(damage))
					unless target.alive?
						gain_exp(target.exp_value)
						gain_gold(target.gold_value)
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
	
	def gain_gold(amount)
		unless amount == 0
			unless @npc == 1
				manage_output("#{name} gains #{amount} gold.")
			end
			@gold += amount
		end
	end
	
	def gold_value
		value = ((self.level + 1) * (rand(self.exp_value) + 1)) + (rand(4) - 2)
		if value < 0
			value = 0
		end
		return value
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
	
	def force_level_up
		unless @npc == 1
		# don't print npc level up info
			manage_output(self.name + ' gains a level!')
		end
		@level += 1
		stats_up
	end
		
	def stats_up
		@maxHP += 2
		@maxMP += 2
		@attackPoints += 1
		@defensePoints += 1
		@agility += 1
		@exp_value += 1
		new_spells
	end
	
	def new_spells
		# not everybody learns spells... sad
	end
	
	def real_attack_points
		ap = @attackPoints + @ap_mod
		if ap < 0
			ap = 0
		end
		return ap
	end
	
	def real_defense_points
		dp = @defensePoints + @dp_mod
		if dp < 0
			dp = 0
		end
		return dp
	end
	
	def real_agility_points
		ag = @agility + @ag_mod
		if ag < 0
			ag = 0
		end
		return ag
	end
	
	def cast_spell(spell_name, target)
		spell_effect = spells[spell_name]
		if self.currentMP < spell_effect['mp']
			unless @npc == 1
				manage_output('Not enough MP.')
			end
			if @npc == 1
				return false
			end
		else
			manage_output("#{name} casts #{spell_name}.")
			self.mp=(-(spell_effect['mp']))
			
			if spell_effect['target_hp'] != nil
				hp_spell(spell_effect, target)
			elsif spell_effect['target_hp'] == nil
				temp_spell(spell_effect, target)
			end
			
			if @npc == 1
				return true
			end
		end
	end
	
	def hp_spell(spell_effect, target)
		spell_outcome = spell_effect['target_hp'] + (spell_effect['target_hp']/(spell_effect['target_hp'].abs) * rand(self.level + 1))
		effect_string = "#{target.name} "
		if spell_outcome > 0
			effect_string += 'gains '
		elsif spell_outcome < 0
			effect_string += 'loses '
		end
		effect_string += "#{spell_outcome.abs} hit points!"
		manage_output(effect_string)
		
		target.hp=(spell_outcome)
		
		unless target.alive?
			gain_exp(target.exp_value)
			gain_gold(target.gold_value)
		end
	end
	
	def temp_spell(spell_effect, target)
	
		['attack', 'defense', 'agility'].each do |type|
			unless spell_effect[type] == nil
				amount = spell_effect[type] + (spell_effect[type]/(spell_effect[type].abs) * rand(self.level + 1))
				duration = spell_effect['duration'] + rand(self.level + 1)
				target.store_temp_mod(type, amount, duration)
			end
		end
		manage_output("#{@name} is enchanted!")
	end
	
	def store_temp_mod(type, amount, duration)
		@spell_modifiers[type] = [amount, duration]
		# this should be the only place mods get applied
		attr_list = {'attack' => 0, 'defense' => 1, 'agility' => 2}
		temp_array = []
		temp_array[(attr_list[type])] = amount

		puts "before assignment #{ap_mod}"
		if type == 'attack'
			@ap_mod = temp_array[0]
		end
		if type == 'defense'
			@dp_mod = temp_array[1]
		end
		if type == 'agility'
			@ag_mod = temp_array[2]
		end
		puts "after assignment #{ap_mod}"
	end
	
	
	def count_temp_mod
		
		attr_list = {'attack' => @ap_mod, 'defense' => @dp_mod, 'agility' => @ag_mod}
		un_apply_flag = false
		
		['attack','defense','agility'].each do |x|
			unless @spell_modifiers[x][1] == 0
				puts @spell_modifiers[x][1]
				@spell_modifiers[x][1] -= 1
				if @spell_modifiers[x][1] < 0
					@spell_modifiers[x][1] = 0
				end
				if @spell_modifiers[x][1] == 0
					remove_temp_mod(x)
					un_apply_flag = true
				end
			end
		end
		if un_apply_flag == true
			manage_output("An enchantment has faded from #{@name}.")
		end	
	end
	
	def remove_temp_mod(type)
		if type == 'attack'
			@ap_mod = 0
		end
		if type == 'defense'
			@dp_mod = 0
		end
		if type == 'agility'
			@ag_mod = 0
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
	
	
	def receive_item(item)
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
		@attackPoints += 2
		@defensePoints += 2
	end

	def stats_up
		@maxHP += 3
		@maxMP += 1
		@attackPoints += 2
		@defensePoints += 1
		@agility += 1
	end
	
	def new_spells
		if @level == 10
			learn_spell('heal')
		end
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
		@maxMP += 4
		@attackPoints += 1
		@defensePoints += 1
		@agility += 1
		new_spells
	end
	
	def new_spells
		if @level == 2
			learn_spell('lightning')
		end
		if @level == 4
			learn_spell('cure')
		end
		if @level == 6
			learn_spell('strength')
		end
		if @level == 8
			learn_spell('weakness')
		end
	end
	
end

class Thief < Character
	
	def initialize inName, npcFlag
		super
		@defensePoints += 1
		@agility += 4
	end
	
	def stats_up
		@maxHP += 2
		@maxMP += 1
		@attackPoints += 1
		@defensePoints += 1
		@agility += 3
		@exp_value += 1
		new_spells
	end
	
	def new_spells
		if @level == 6
			learn_spell(heal)
		end
	end
	
end

class GreenDragon

	def initialize
		super('Green Dragon', 1)
		@maxHP += 2
		@currentHP = @maxHP
		@attackPoints += 2
		@defensePoints += 2
		@currentMP = @maxMP
		@agility += 1
		@exp_value += 5
		@spell_list << 'fire_breath'
	end

	def stats_up
		super
		@defensePoints += 2
		@maxHP += 2
		@currentHP = @maxHP
	end

end

class DemiLich < Character

	def initialize
		super('Demi Lich', 1)
		@maxHP += 2
		@currentHP = @maxHP
		@attackPoints += 1
		@defensePoints += 1
		@currentMP = @maxMP
		@exp_value += 4
		@spell_list << 'fireball'
	end

	def new_spells
		if @level == 4
			learn_spell('weakness')
		end
		if @level == 6
			learn_spell('lightning')
		end
	end

end

class LizardMan < Character

	def initialize
		super('Lizard Man', 1)
		@agility += 2
		@maxHP += 1
		@currentHP = @maxHP
		@maxMP -= 10
		@attackPoints += 1
		@defensePoints += 3
		@currentMP = @maxMP
		@exp_value += 3
	end
	
	def stats_up
		super
		@agility += 1
	end
end

class Minotaur < Character
	
	def initialize
		super('Minotaur', 1)
		@agility -= 1
		@maxHP += 5
		@currentHP = @maxHP
		@maxMP -= 10
		@attackPoints += 2
		@defensePoints += 1
		@currentMP = @maxMP
		@exp_value += 3
	end
	
	def stats_up
		super
		@maxHP += 1
		@currentHP = @maxHP
	end
end

class Skeleton < Character

	def initialize
		super('Skeleton', 1)
		@agility += 1
		@maxHP += 1
		@currentHP = @maxHP
		@maxMP -= 10
		@attackPoints += 1
		@currentMP = @maxMP
		@exp_value += 2
	end
end

class Serpent < Character
	
	def initialize
		super('Serpent', 1)
		@agility += 1
		@maxHP -= 2
		@currentHP = @maxHP
		@maxMP -= 10
		@currentMP = @maxMP
		@attackPoints += 1
		@attackPoints -= 1
		@exp_value += 2
	end
end
	
class GiantRat < Character
	
	def initialize
		super('Giant Rat', 1)
		@maxHP -= 2
		@currentHP = @maxHP
		@maxMP -= 10
		@currentMP = @maxMP
		@exp_value += 1
	end
end

class Slime < Character

	def initialize
		super('Slime', 1)
		@agility -= 1
		@maxHP -= 6
		@currentHP = @maxHP
		@maxMP -= 10
		@currentMP = @maxMP
	end
	
end
#--------------------




