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
		context 'when hp above zero' do
			it 'should return \'true\'' do
				expect(@test_char.alive?).to be true
			end
		end
		context 'when hp not above zero' do
			it 'should return \'false\'' do
				@test_char.instance_variable_set("@currentHP", 0)
				expect(@test_char.alive?).to be false
			end
		end
	end
	
	describe '#hp=' do
		it 'should change hp' do
			@test_char.hp=(-1)
			expect(@test_char.currentHP).to eql 9
		end
		context 'when hp change exceeds maxHP' do
			it 'should return maxHP' do
				@test_char.hp=(10)
				expect(@test_char.currentHP).to eql 10
			end
		end
		context 'when negative hp change is less than zero' do
			it 'should return zero' do
				@test_char.hp=(-25)
				expect(@test_char.currentHP).to eql 0
			end
		end
	end
	
	describe '#mp=' do
		it 'should change mp' do
			@test_char.mp=(-1)
			expect(@test_char.currentMP).to eql 9
		end
		context 'when mp change exceeds maxMP' do
			it 'should return maxHP' do
				@test_char.mp=(10)
				expect(@test_char.currentMP).to eql 10
			end
		end
		context 'when negative mp change is less than zero' do
			it 'should return zero' do
				@test_char.mp=(-25)
				expect(@test_char.currentMP).to eql 0
			end
		end
	end
	
	describe '#status_check' do
		it 'should return stats' do
			expect(@test_char.status_check[0]).to eql "Name: #{@name}"
		end
		context 'if player knows spells' do
			it 'should return spell_list' do
				@test_char.instance_variable_set("@spell_list", ['spell'])
				expect(@test_char.status_check[10]).not_to eql nil
			end
		end
	end
	
	describe '#learn_spell' do
		it 'should add spells to spell_list' do
			spell = random_name
			@test_char.learn_spell(spell)
			expect(@test_char.spell_list[0]).to eql spell
		end
	end

end