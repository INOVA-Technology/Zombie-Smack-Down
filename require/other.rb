require "readline"
require "yaml"
require "#{$rpath}/require/zombie"
require "#{$rpath}/require/colors"
require "#{$rpath}/require/combo"
require "#{$rpath}/require/player"

class Cli

	attr_accessor :player, :zombie, :available_commands

	def initialize 
		@player = Player.new
		@available_commands = %w[ kick punch combo combolist taunt info scores quit help commands tutorial heal easter ]
		@combos = { "kick punch" => KickPunch.new,
				   "trip stomp" => TripStomp.new,
				   "punch punch kick" => PunchPunchKick.new,
				   "Knee Punch Face Slap" => KneePunchFaceSlap.new,
				   "heal fury" => HealFury.new(@player),
				   "elbow fist knee fist knee body slam" => ElbowFistKneeFistKneeBodySlam.new,
				   "kick kick kick kick kick kick kick kick kick kick kick kick kick kick kick" => KickKickKickKickKickKickKickKickKickKickKickKickKickKickKick.new,
				   "combo of possible death" => ComboOfPossibleDeath.new,
				   "combo of death" => ComboOfDeath.new,
				   "coolest combo ever" => CoolestComboEver.new,
				   "chase punch of fire" => ChasePunchOfFire.new,
				   "addison kick of cold hard music" => AddisonKickOfColdHardMusic.new,
				   "not a combo" => NotACombo.new,
				   "pain with a side of blood" => PainWithASideOfBlood.new,
				   "the combo" => TheCombo.new,
				   "the 2nd combo" => The2ndCombo.new,
				   "ultimate destruction kick punch" => UltimateDestructionKickPunch.new,
				   "the 3rd combo" => The3rdCombo.new,
				   "pretty good combo" => PrettyGoodCombo.new,
				   "chuck norris stomp of mayhem" => ChuckNorrisStompOfMayhem.new
		}
	end

	def spawn_zombie
		zombies = [ Zombie,
				BigZombie,
				DaddyZombie,
				GunZombie,
				NinjaZombie,
				IdiotZombie,
				BlindZombie,
				StrongZombie,
				BasicallyDeadZombie,
				SuperZombie,
				BossZombie,
				UltimateZombie ]

		@zombie = zombies[@player.save[:wave] - 1].new
	end

	def attack damage
		@zombie.takeDamage damage
		z_damage = @zombie.attack
		@player.takeDamage z_damage if @zombie.isAlive
		puts (pPain "#{@player.phrases.rand_choice} #{@zombie.name}! -#{damage}")
		puts (pPain "#{@zombie.name} #{@zombie.phrases.rand_choice}! -#{z_damage}")
		@zombie.checkDead
		@player.checkDead
		@player.addKill if !@zombie.isAlive
		@player.giveXP @zombie.xp if !@zombie.isAlive
	end

	def doCombo
		# keep combos in order of xp cost
		# and keep keys lowercase

		if @combos.has_key? c = prompt("Which combo? ")
			used_combo = @combos[c]
			if @player.save[:xp] >= used_combo.price
				damage = used_combo.use
				@player.giveXP -used_combo.price
				return true, damage
			else
				puts (pWarn "You don't have enough xp loser.")
				return false
			end
		else 
			puts pWarn "That is not a combo."
			return false
		end

	end

	# CLI METHODS BELOW

	def kick *args
		attack @player.kick
	end

	def punch *args
		attack @player.punch
	end

	def combo *args
		success, damage = doCombo
		attack damage if success
	end

	def combolist *args
		amount = @player.save[:rank]
		puts pInfo "Unlocked Combos:"
		combos = @combos.sort_by { |k, v| v.price }
		amount.times { |i|
			puts pInfo "#{combos[i][1].name}: -#{combos[i][1].price} xp"
		}
	end

	def scores *args
		scores = YAML.load_file("#{$rpath}/scores.yml")
		puts pInfo "High Scores:"
		scores.each { |s|
			puts pInfo "#{s[1]}: #{s[0]}"
		}
	end

	def quit *args
		puts pWarn "Wanna save yo game? yes or no"
		answer = prompt
		while !(["yes", "y", "no", "n"].include? answer)
			puts pWarn "I didn't catch that. Yes or No?"
			answer = prompt
		end
		save_game = (answer == "yes" ? true : false)
		@player.saveGame if save_game
		exit
	end

	def help *args
		puts pWarn "Type commands for a list of commands, and tutorial for more in depth info."
	end

	def commands *args
		puts "Avalible Commands:"
		puts "kick, punch, combo, combolist, taunt, heal, info, scores, help, commands, tutorial, save, quit"
	end

	def taunt *args
		if @player.save[:tauntsAvailable] > 0
			@player.taunt
		else
			puts pWarn "You have no more taunts."
		end
	end

	def heal *args
		amount = args[0].to_i
		if amount > 0
			@player.heal amount
		else
			puts (pWarn "Please specify a number greater than 0. Example: heal 5")
		end
	end

	def info *args
		@player.info
		puts
		@zombie.info
	end

	def easter *args
		if args[0] == "egg"
			unless @player.save[:eggUsed]
				xp = (-50..75).to_a.rand_choice
				@player.giveXP xp
				puts pLevelUp "#{(xp >= 0 ? "+" : "-") + xp.abs.to_s} xp"
				@player.save[:eggUsed] = true
			else
				puts pWarn "You used your easter egg this game you cheater :/"
			end
		else
			puts pWarn "Unknown Command."
		end
	end

	def tutorial *args
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

end

class Array
	def rand_choice
		if RUBY_VERSION.to_f > 1.8
			self.sample
		else
			self[rand(self.length)]
		end
	end
end

def exit_game player
  Thread.new {
    player.saveGame
    puts "^C"
    puts pLevelUp "Game saved."
    exit
  }
end

def prompt _prompt="", newline=false
	_prompt += "\n" if newline
	inText = Readline.readline(_prompt, true).squeeze(" ").strip.downcase
	inText
end
