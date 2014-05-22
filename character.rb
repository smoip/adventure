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
	
	attr_reader :name, :maxHP, :currentHP, :maxMP, :currentMP, :attackPoints, :defensePoints, :alive, :level, :charExp, :expValue
	# same as defining methods to return @name, @hitPoints, etc.
	
	attr_writer :name, :maxHP, :currentHP, :maxMP, :currentMP, :attackPoints, :defensePoints, :alive, :level, :charExp, :expValue
	# same as defining methods to write @name, @hitPoints, etc.
	
	def alive?
		if @currentHP <= 0
			@alive = false
			puts @name + ' has perished.'
		end
	end
	
	def hpChange amount
		@currentHP += amount
		if @currentHP > @maxHP
			@currentHP = @maxHP
		end
		alive?
	end
	
	def mpChange amount
		@currentMP += amount
		if @currentMP > @maxMP
			@currentMP = @maxMP
		end
	end
	
	def hpMaxChange amount
		@maxHP += amount
	end
	
	def mpMaxChange amount
		@maxMP += amount
	end
	
	def attackChange amount
		@attackPoints += amount
	end
	
	def defenseChange amount
		@defensePoints += amount
	end

	def statusCheck
		puts "Name: #{@name}"
		puts "Level: #{@level}"
		puts "Exp: #{@charExp}"
		puts "Class: #{self.class}"
		puts "Hit Points: #{@currentHP}/#{@maxHP}"
		puts "Magic Points: #{@currentMP}/#{@maxMP}"
		puts "Attack: #{@attackPoints}"
		puts "Defense: #{@defensePoints}"
	end
	
	def attack(target)
		if target.alive
			puts self.name + ' attacks ' + target.name + '.'
			if rand(target.defensePoints) == 0		
				puts target.name + " takes #{self.attackPoints} damage!"
				target.hpChange(-(self.attackPoints))
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
		unless @npc 
			puts self.name + ' gains ' + amount + ' experience.'
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
		while @level < (@charExp/10)
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
		hpMaxChange(2)
		mpMaxChange(2)
		attackChange(1)
		defenseChange(1)
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
		hpMaxChange(5)
		hpChange(@maxHP)
		mpMaxChange(-5)
		mpChange(@maxMP)
		attackChange(1)
		defenseChange(1)
	end

	def statsUp
		hpMaxChange(3)
		mpMaxChange(1)
		attackChange(2)
		defenseChange(2)
	end
	
end

class Mage < Character
	
	def initialize inName, npcFlag
		super
		hpMaxChange(-2)
		hpChange(@maxHP)
		mpMaxChange(8)
		mpChange(@maxMP)
	end
	
	def statsUp
		hpMaxChange(1)
		mpMaxChange(3)
		attackChange(1)
		defenseChange(1)
	end
	
end

#--------------------

module Magic

fireBall = Proc.new do |target|
		self.mpChange(-4)
		target.hpChange(4 + (self.level))
		return 'fireball'
	end
	
	def heal target
		self.mpChange(-2)
		target.hpChange(2 + (self.level))
		return 'heal'
	end

end
	

puts 'Please enter a name for a new fighter.'	
playerChar = Fighter.new((gets.chomp.downcase.capitalize), 0)
puts "Name: #{playerChar.name}"
puts "MP: #{playerChar.currentMP}"

playerChar.hpChange(-5)
puts "Ouch. HP now: #{playerChar.currentHP}"

playerChar.hpChange(10)
puts "Much better. HP now: #{playerChar.currentHP}"

playerChar.hpChange(-11)
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
puts computerChar.statusCheck

playerChar.gainExp(20)
puts playerChar.statusCheck