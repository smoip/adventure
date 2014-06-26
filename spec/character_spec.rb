require 'spec_helper'

describe Character do

	before :each do
		@name = random_name
		@test_char = Character.new(@name, 0)
	end
	
	describe '#initialize' do
		it 'should assign name' do
			expect(@test_char.name).to eql @name
		end
		it 'should assign npcFlag' do
			expect(@test_char.npc).to eql 0
		end
		it 'should assign maxHP' do
			expect(@test_char.maxHP).to eql 10
		end
		it 'should assign currentHP' do
			expect(@test_char.currentHP).to eql @test_char.maxHP
		end
		it 'should assign maxMP' do
			expect(@test_char.maxMP).to eql 10
		end
		it 'should assign currentMP' do
			expect(@test_char.currentMP).to eql @test_char.maxMP
		end
		it 'should assign attackPoints' do
			expect(@test_char.attackPoints).to eql 1
		end
		it 'should assign defensePoints' do
			expect(@test_char.defensePoints).to eql 1
		end
		it 'should assign agility' do
			expect(@test_char.agility).to eql 1
		end
		it 'should assign ap_mod' do
			expect(@test_char.ap_mod).to eql 0
		end
		it 'should assign dp_mod' do
			expect(@test_char.dp_mod).to eql 0
		end
		it 'should assign ag_mod' do
			expect(@test_char.ag_mod).to eql 0
		end
		it 'should assign level' do
			expect(@test_char.level).to eql 0
		end
		it 'should assign charExp' do
			expect(@test_char.charExp).to eql 0
		end
		it 'should assign exp_value' do
			expect(@test_char.exp_value).to eql 1
		end
		it 'should create inventory hash' do
			expect(@test_char.inventory).to be_truthy
		end
		it 'should create \'nothing\' objects in inventory slots' do
			expect(@test_char.inventory['potion'].name).to eql 'nothing'
		end
		it 'should assign gold' do
			expect(@test_char.gold).to eql 0
		end
		it 'should create empty spell_list' do
			expect(@test_char.spell_list).to eql []
		end
	end
	
	describe '#alive?' do
		it 'should return \'true\' when hp above zero' do
			expect(@test_char.alive?).to be true
		end
		it 'should return \'false\' when hp not above zero' do
			allow(@test_char).to receive(:currentHP).and_return( 0 )
			expect(@test_char.currentHP).to eql 0
			expect(@test_char.alive?).to be false
			# wuh-oh.  Doesn't work
		end
	end

end