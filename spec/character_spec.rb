require 'spec_helper'

describe Character do

	before :each do
		@name = random_name
		@test_char = Character.new(@name, 0)
		@target_name = random_name
		@target = Character.new(@target_name, 1)
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
	
	describe '#hit_ratio' do
		context 'active player\'s agility is higher than target\'s' do
			it 'should return hit ratio 1' do
				allow(@target).to receive(:real_agility_points).and_return(1)
				allow(@test_char).to receive(:real_agility_points).and_return (2)
				expect(@test_char.hit_ratio(@target)).to eql 1
			end
		end
		context 'target\'s agility is higher than active player\'s' do
			it 'should return hit ratio 2' do
				allow(@target).to receive(:real_agility_points).and_return(2)
				allow(@test_char).to receive(:real_agility_points).and_return (1)
				expect(@test_char.hit_ratio(@target)).to eql 2
			end
		end
	end
	
	describe '#damage_amount' do
		context 'player ap greater than target dp/2' do
			it 'should return damage of 4' do
				allow(@target).to receive(:real_defense_points).and_return(2)
				allow(@test_char).to receive(:real_attack_points).and_return (5)
				expect(@test_char.damage_amount(@target)).to eql 4	
			end
		end
		context 'player ap not greater than target dp/2' do
			it 'should return damage of 1' do
				allow(@target).to receive(:real_defense_points).and_return(4)
				allow(@test_char).to receive(:real_attack_points).and_return (1)
				expect(@test_char.damage_amount(@target)).to eql 1
			end
		end
	end
	
	describe '#hit_target?' do
		# untestable with current construction (rand is a singleton)
	end
	
	describe '#attack' do
		context 'target is already dead' do
			it 'should not change target hp' do
				allow(@target).to receive(:alive?).and_return(false)
				@test_char.attack(@target)
				expect(@target.currentHP).to eql @target.maxHP
			end
		end
		context 'target is not already dead' do
			context 'player misses' do
				it 'should not change target hp' do
					allow(@test_char).to receive(:hit_target?).and_return(false)
					@test_char.attack(@target)
					expect(@target.currentHP).to eql @target.maxHP
				end
			end
			context 'player hits' do
				it 'should decrease target hp' do
					allow(@test_char).to receive(:hit_target?).and_return(true)
					@test_char.attack(@target)
					expect(@target.currentHP).to be < @target.maxHP
				end
				context 'target is slain' do
					it 'should increase player exp' do
						@test_char.instance_variable_set("@attackPoints", 40)
						allow(@test_char).to receive(:hit_target?).and_return(true)
						@test_char.attack(@target)
						expect(@test_char.charExp).to be >= 1
					end
					it 'should increase player gold' do
						@test_char.instance_variable_set("@attackPoints", 40)
						allow(@test_char).to receive(:hit_target?).and_return(true)
						allow(@target).to receive(:gold_value).and_return(6)
						@test_char.attack(@target)
						expect(@test_char.gold).to be > 0
					end
				end
				context 'target is not slain' do
					it 'should not increase player exp' do
						allow(@test_char).to receive(:hit_target?).and_return(true)
						@test_char.attack(@target)
						expect(@test_char.charExp).to eql 0
					end
				end
			end
		end
	end
	
	describe '#gain_exp' do
		it 'should increase player exp' do
			@test_char.gain_exp(4)
			expect(@test_char.charExp).to be > 0
		end
	end

	describe '#gain_gold' do
		it 'should increase player gold' do
			@test_char.gain_gold(4)
			expect(@test_char.gold).to be > 0
		end
	end
	
	describe '#gold_value' do
		it 'should return a value greater than eight' do
			@test_char.instance_variable_set("@level", 8)
			expect(@test_char.gold_value).to be > 6
		end
	end
	
	describe '#level_up' do
		it 'should level up once' do
			@test_char.instance_variable_set("@charExp", 11)
			@test_char.level_up
			expect(@test_char.level).to eql 1
		end
		it 'should level up twice' do
			@test_char.instance_variable_set("@charExp", 33)
			@test_char.level_up
			expect(@test_char.level).to eql 2
		end
	end
	
	describe '#force_level_up' do
		it 'should level up once' do
			@test_char.force_level_up
			expect(@test_char.level).to eql 1
		end
	end

	describe '#real_attack_points' do
		context 'no modifier' do
			it 'should equal attackPoints' do
				expect(@test_char.real_attack_points).to eql @test_char.attackPoints
			end
		end
		context 'modifier' do
			it 'should not equal attackPoints' do
				@test_char.instance_variable_set("@ap_mod", 2)
				expect(@test_char.real_attack_points).to_not eql @test_char.attackPoints
			end
		end
	end
	
	describe '#real_defense_points' do
		context 'no modifier' do
			it 'should equal defensePoints' do
				expect(@test_char.real_defense_points).to eql @test_char.defensePoints
			end
		end
		context 'modifier' do
			it 'should not equal defensePoints' do
				@test_char.instance_variable_set("@dp_mod", 2)
				expect(@test_char.real_defense_points).to_not eql @test_char.defensePoints
			end
		end
	end
	
	describe '#real_agility_points' do
		context 'no modifier' do
			it 'should equal agility' do
				expect(@test_char.real_agility_points).to eql @test_char.agility
			end
		end
		context 'modifier' do
			it 'should not equal agility' do
				@test_char.instance_variable_set("@ag_mod", 2)
				expect(@test_char.real_agility_points).to_not eql @test_char.agility
			end
		end
	end
	
	describe '#cast_spell' do
		context 'not enough mp for spell' do
			it 'should not effect target hp' do
				@test_char.instance_variable_set("@currentMP", 0)
				@test_char.cast_spell('fireball', @target)
				expect(@target.currentHP).to eql @target.maxHP
			end
		end
		context 'enough mp for spell' do
			it 'should decrease player mp' do
				@test_char.cast_spell('fireball', @target)
				expect(@target.currentHP).to be < @target.maxHP
			end
		end
	end
	
	describe '#mod_spell_effect_hp' do
		it 'should return -4' do
			expect(@test_char.mod_spell_effect_hp({'target_hp' => -4, 'mp' => 4}, @target)).to eql -4
		end
	end
	
	
	
end