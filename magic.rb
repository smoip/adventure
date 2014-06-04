module Magic

	def spells
		spell_book = {'fireball' => {'target_hp' => -4, 'mp' => 4}, 'heal' => {'target_hp' => 4, 'mp' => 4}, 'lightning' => {'target_hp' => 10, 'mp' => 10}, 'cure' => {'target_hp' => 10, 'mp' => 10}}
	end
	
	def potions
		potion_table = {'healing potion' => {'hp' => 4, 'mp' => 0}, 'magic potion' => {'hp' => 0, 'mp' => 4}}
	end

end