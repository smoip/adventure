# ---------------------------------
class Character
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
	
	attr_accessor(:name, :maxHP, :currentHP, :maxMP, :currentMP, :attackPoints, :defensePoints, :alive, :level, :charExp, :expValue)
	# same as defining methods to write/return @name, @currentHP, etc.
	
	def alive?
		if currentHP <= 0
			false
		else
			true
		end
	end
	
	
	def hp=(amount)
		currentHP += amount
		if currentHP > maxHP
			currentHP = maxHP
		end
		unless alive?
			puts "#{name} has perished."
		end
	end
	
	def mp=(amount)
		currentMP += amount
		if currentMP > maxMP
			currentMP = maxMP
		end
	end

	def statusCheck
		"Name: #{name}"
		"Level: #{level}"
		"Exp: #{charExp}"
		"Class: #{self.class}"
		"Hit Points: #{currentHP}/#{maxHP}"
		"Magic Points: #{currentMP}/#{maxMP}"
		"Attack: #{attackPoints}"
		"Defense: #{defensePoints}"
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
		unless npc == true
			puts self.name + ' gains ' + amount + ' experience.'
		end
		charExp += amount
		levelCheck
	end
	
	def levelCheck
		# checks current exp against level up table
		# performs level up if applicable
		if level < (charExp/10)
			levelUp
		end
	end
	
	def levelUp
		while level < (charExp/10)
			unless npc == true
			# don't print npc level up info
				puts self.name + ' gains a level!'
			end
			level += 1
			charExp -= (level * 10)
			statsUp
		end
	end
		
	def statsUp
		maxHP += 2
		maxMP += 2
		attackPoints += 1
		defensedefensePoints += 1
	end
	
	def castSpell spell
		puts self.name + ' casts ' + '!'
		spell.proc
	end	
	
end

#-----------------------


class Fighter < Character
	
	def initialize inName, npcFlag
		super
		@maxHP=(5)
		hp=(@maxHP)
		@maxMP += (-5)
		mp=(@maxMP)
		@attackPoints += 1
		@defensePoints += 1
	end

	def statsUp
		maxHP += 3
		maxMP += 1
		attackPoints += 2
		defensePoints += 2
	end
	
end

class Mage < Character
	
	def initialize inName, npcFlag
		super
		@maxHP -= 2
		hp=(@maxHP)
		@maxMP += 8
		mp=(maxMP)
	end
	
	def statsUp
		maxHP += 1
		maxMP += 3
		attackPoints += 2
		defensePoints += 1
	end
	
end

#--------------------

module Magic

fireBall = Proc.new do |target|
		self.mp=(-4)
		target.hp=(4 + (self.level))
		return 'fireball'
	end
	
	def heal target
		self.mp=(-2)
		target.hp=(2 + (self.level))
		return 'heal'
	end

end
	

puts 'Please enter a name for a new fighter.'	
playerChar = Fighter.new((gets.chomp.downcase.capitalize), 0)
puts "Name: #{playerChar.name}"
puts "MP: #{playerChar.currentMP}"

playerChar.hp=(-5)
puts "Ouch. HP now: #{playerChar.currentHP}"

playerChar.hp=(10)
puts "Much better. HP now: #{playerChar.currentHP}"

playerChar.hp=(-11)
playerChar.statusCheck

computerChar = Mage.new('Elrich', 1)
puts computerChar.statusCheck

playerChar.attack(computerChar)
playerChar.attack(computerChar)
playerChar.attack(computerChar)
computerChar.attack(playerChar)
playerChar.attack(computerChar)
computerChar.attack(playerChar)
computerChar.attack(playerChar)
puts computerChar.statusCheck.to_s

playerChar.gainExp(20)
puts playerChar.statusCheck.to_s