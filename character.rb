$LOAD_PATH.insert(0, "/users/laevsky/documents/learning ruby/adventure")
require "magic.rb"

# ---------------------------------
class Character

include Magic

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
	end
	
	attr_accessor :name, :maxHP, :currentHP, :maxMP, :currentMP, :attackPoints, :defensePoints, :alive, :level, :charExp, :expValue
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
			puts "#{name} has perished."
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

	def statusCheck
		["Name: #{name}", "Level: #{level}", "Exp: #{charExp}", "Class: #{self.class}", "Hit Points: #{currentHP}/#{maxHP}", "Magic Points: #{currentMP}/#{maxMP}", "Attack: #{attackPoints}", "Defense: #{defensePoints}"]
	end
	
	def attack(target)
		if target.alive
			puts self.name + ' attacks ' + target.name + '.'
			if rand(target.defensePoints) == 0		
				puts target.name + " takes #{self.attackPoints} damage!"
				target.hp=(-(self.attackPoints))
					unless target.alive
						gainExp(target.expValue)
					end
			else
				puts self.name + ' misses!'
			end
		else
			puts target.name + ' is already dead.'
		end
	end
	
	def gainExp amount
		# adds exp to total
		# only prints for player character
		unless @npc == true
			puts "#{name} gains #{amount} experience."
		end
		@charExp += amount
		levelCheck
	end
	
	def levelCheck
		# checks current exp against level up table
		# performs level up if applicable
		if @level < (@charExp/10)
			levelUp
		end
	end
	
	def levelUp
		while level < (@charExp/10)
			unless @npc == true
			# don't print npc level up info
				puts self.name + ' gains a level!'
			end
			@level += 1
			@charExp -= (@level * 10)
			statsUp
		end
	end
		
	def statsUp
		@maxHP += 2
		@maxMP += 2
		@attackPoints += 1
		@defensedefensePoints += 1
		@expValue += 1
	end
	
	def castSpell(spell_name, target)
		puts "#{name} casts #{spell_name}."
		spell_effect = spells[spell_name]
		if self.currentMP < spell_effect['mp']
			puts 'Not enough MP.'
		else
			self.mp=(spell_effect['mp'])
			target.hp=(spell_effect['target_hp'])
			print "#{target.name} "
			if (spell_effect['target_hp']) > 0
				print 'gains '
			elsif (spell_effect['target_hp']) < 0
				print 'loses '
			end
			puts "#{(spell_effect['target_hp']).abs} hit points!"
		end
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

	def statsUp
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
	end
	
	def statsUp
		@maxHP += 1
		@maxMP += 3
		@attackPoints += 2
		@defensePoints += 1
	end
	
end

class Minotaur < Character
	
	def initialize inName, npcFlag
		super
		@maxHP += 5
		@maxMP -= 10
		@attackPoints += 1
		@expValue += 1
	end
end

#--------------------




puts 'Please enter a name for a new fighter.'	
playerChar = Fighter.new((gets.chomp.downcase.capitalize), 0)
puts "Name: #{playerChar.name}"
puts "MP: #{playerChar.currentMP}"
puts playerChar.statusCheck.to_s

playerChar.hp=(-5)
puts "Ouch. HP now: #{playerChar.currentHP}"

playerChar.hp=(10)
puts "Much better. HP now: #{playerChar.currentHP}"

playerChar.hp=(-11)
playerChar.statusCheck

computerChar = Mage.new('Elrich', 1)
puts computerChar.statusCheck

playerChar.castSpell('heal', playerChar)
playerChar.attack(computerChar)
computerChar.castSpell('fireball', playerChar)
playerChar.attack(computerChar)
computerChar.attack(playerChar)
playerChar.attack(computerChar)
computerChar.attack(playerChar)
computerChar.attack(playerChar)
puts computerChar.statusCheck.to_s

playerChar.gainExp(20)
puts playerChar.statusCheck.to_s