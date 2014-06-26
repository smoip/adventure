require_relative '../adventure'
require_relative '../art'
require_relative '../character'
require_relative '../dm'
require_relative '../items'
require_relative '../magic'
require_relative '../map'
require_relative '../qwertyio'

def random_name
	('a'..'z').to_a.sample(8).join.capitalize
end

def random_number
	random(10)
end