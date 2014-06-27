require 'spec_helper'

describe Room do
	
	before :each do
		dm = DungeonMaster.new
		@room = Room.new(dm)
	end
	
	describe '#initialize' do
		it 'should assign' do
		end
	end
	
	describe '#enter_description' do
		it 'should' do
		end
	end

	describe '#describe' do
		it 'should' do
		end
	end
	
	describe '#creature_inside' do
		context 'room type is entrance' do
			it 'should never return \'true\'' do
				@room.instance_variable_set("@type", 'entrance')
				10.times do
					expect(@room.creature_inside).to be false
				end
			end
		end
		context 'room type is not entrance' do
			it 'should return true' do
				allow(@room).to receive(:rand).and_return(0)
				expect(@room.creature_inside).to be true
			end
			it 'should return false' do
				allow(@room).to receive(:rand).and_return(1)
				expect(@room.creature_inside).to be false
			end
		end
	end
	
	describe '#treasure_inside' do
		it 'should return true' do
			allow(@room).to receive(:rand).and_return(0)
			expect(@room.treasure_inside).to be true
		end
		it 'should return false' do
			allow(@room).to receive(:rand).and_return(1)
			expect(@room.treasure_inside).to be false
		end
	end
end