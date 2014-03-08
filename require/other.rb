class Array
	def rand_choice
		if RUBY_VERSION.to_f > 1.8
			self.sample
		else
			self.choice
		end
	end
end

def prompt _prompt="", newline=false
	_prompt += "\n" if newline
	inText = Readline.readline(_prompt, true).squeeze(" ").strip.downcase
	inText
end

def attack attacker, victim, attack_method=nil
	if attacker.class == Player
		damage = case attack_method
				 when "kick"
				 	attacker.kick
				 when "punch"
				 	attacker.punch
				 end
		finish_attack attacker, damage, victim
	else
		damage = attacker.attack
		puts pPain "#{attacker.name} #{attacker.phrases.rand_choice} -#{damage}"
		victim.takeDamage damage
	end
end

def combo attacker, victim, c, combos

	if combos.has_key? c
		_combo = combos[c]
		if $player.save[:xp] >= _combo.price
			damage = _combo.use
			$player.save[:xp] -= _combo.price
			finish_attack attacker, damage, victim
			return true
		else
			puts pWarn "You don't have enough xp loser."
			return false
		end
	else 
		puts pWarn "That is not a combo."
		return false
	end
end

def finish_attack attacker, damage, victim
	victim.takeDamage damage
	puts pPain "#{attacker.phrases.rand_choice} #{victim.name}! -#{damage}"
	victim.checkDead
	attacker.addKill if !victim.isAlive
	attacker.giveXP victim.xp if !victim.isAlive
end

def combolist player, combos
	amount = player.save[:rank]
	i = 1
	puts pInfo "Unlocked Combos:"
	combos = combos.sort_by { |k, v| v.price }
	combos.each { |c|
		puts pInfo "#{c[1].name}: -#{c[1].price} xp"
		break if i >= amount
		i += 1
	}
end

def quit player
	puts pWarn "Wanna save yo game? yes or no"
	answer = prompt
	while !(["yes", "y", "no", "n"].include? answer)
		puts pWarn "I didn't catch that. Yes or No?"
		answer = prompt
	end
	save_game = (answer == "yes" ? true : false)
	player.saveGame if save_game
	exit
end

def help

	puts pInfo "BASICS:"
	puts
	puts "Kick: does between 3 and 8 damage"
	puts
	puts "Punch: does between 4 and 7 damage"
	puts
	puts "Info: shows status of zombie, player, and level"
	puts
	puts "Scores: Shows high score list"
	puts
	puts "Quit: quits the game and give option to save"
	puts
	puts pInfo "COMBOS:"
	puts
	puts "To start using combos, type #{pInfo 'combo'}"
	puts
	puts "Combos are displayed using the combolist command."
	puts
	puts pInfo "HEALTH:"
	puts
	puts "If you want more health, type #{pInfo 'heal'}."
	puts
	puts "Healing costs 1 xp per health point."
	puts
	puts pInfo "UPGRADING:"
	puts
	puts "Upgrading makes attacks more affective."
	puts
	puts "To upgrade type #{pInfo 'upgrade <attack>'} replacing #{pInfo '<attack>'} with kick or punch."
	puts
	puts "Upgrading costs more each time."
	puts
	puts pInfo "TAUNT:"
	puts
	puts "Taunting gives or takes away xp."
	puts
	puts "To taunt type #{pInfo 'taunt'}"
	puts
	puts "You cannot taunt with less than 2 xp."
	puts
	puts pInfo "BLOCK:"
	puts
	puts "Blocking gives xp and health."
	puts
	puts "To block type #{pInfo 'block'}"
	puts
	puts "Upgrade your block to increase health and xp added."
	puts

end