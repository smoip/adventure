require 'spec_helper'

class TestClass
	
	include QwertyIO
		
end

describe TestClass do

	before :each do
		@tc = TestClass.new
	end

	describe '#manage_input' do
		it 'should return an array where input[0] matches a possible answer' do
			allow(@tc).to receive(:take_input).and_return('attack wall')
			expect(@tc.manage_input( [ 'lounge','attack' ] )).to eql [ 'attack','wall' ]
		end
		it 'should ask for a valid input where input[0] does not match a possible answer' do
			allow(@tc).to receive(:take_input).and_return('attack wall', 'obfuscate')
			expect(@tc.manage_input( [ 'lounge','obfuscate' ] )).to eql [ 'obfuscate' ]
		end
	end
	
	describe '#split_words' do
		it 'should split words by space' do
			expect(@tc.split_words('eat all the food')).to eql ['eat','all','the','food']
		end
		it 'should put single words in a one slot array' do
			name = random_name
			expect(@tc.split_words(name)).to eql [name]
		end
	end
	
	describe '#manage_output' do
	end
	
	describe '#format_output' do
		it 'should return incoming arrays as comma and space delineated strings' do
			expect(@tc.format_output(['get','you','some','peanuts'])).to eql 'get, you, some, peanuts'
		end
		it 'should return a two slot array properly' do
			expect(@tc.format_output(['spell','fireball'])).to eql 'spell, fireball'
		end
		it 'should return strings unchanged' do
			name = random_name
			expect(@tc.format_output(name)). to eql name
		end
		it 'should not break when passed a single index array' do
			expect(@tc.format_output(['dingle'])).to eql 'dingle'
		end
	end

end