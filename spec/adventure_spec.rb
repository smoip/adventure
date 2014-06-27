require 'spec_helper'

describe Game do
	
	before :each do
		@game = Game.new
		@dm = DungeonMaster.new
		@name = random_name
		@test_char = Character.new(@name, 0)
	end

	describe '#player_action' do
		context 'multi word command is entered' do
			it 'should parse actions properly' do
				allow(@game).to receive(:ask_player).and_return (nil)
				allow(@game).to receive(:take_input).and_return('m n')
				@game.player_action(@dm, @test_char)
				# spec no likey
			end
		end
	end

end