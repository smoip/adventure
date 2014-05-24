# an arena for testing character interactions directly
# doesn't need to go through 'adventure'

$LOAD_PATH.insert(0, "/users/laevsky/documents/learning ruby/adventure")
require "character.rb"
require "dm.rb"
require "map.rb"
require "magic.rb"
require "items.rb"

# basic character interactions

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