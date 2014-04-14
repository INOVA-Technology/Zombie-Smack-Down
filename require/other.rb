require "readline"
require "yaml"
require "#{$rpath}/require/zombie"
require "#{$rpath}/require/colors"
require "#{$rpath}/require/combo"
require "#{$rpath}/require/player"

class Cli

	attr_accessor :player, :zombie, :commands

	def initialize 
		@player = Player.new
		@commands = %w[ kick punch combo combolist taunt info scores quit help heal easter ]
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
		@zombie.take_damage damage
		@zombie.check_dead
		if @zombie.is_alive
			z_damage = @zombie.attack
		end
		@player.take_damage z_damage if @zombie.is_alive
		p_pain("#{@player.phrases.rand_choice} #{@zombie.name}! -#{damage}")
		p_pain("#{@zombie.name} #{@zombie.phrases.rand_choice}! -#{z_damage}")
		
		@zombie.check_dead
		@player.check_dead
		@player.add_kill if !@zombie.is_alive
		@player.give_xp @zombie.xp if !@zombie.is_alive
	end

	def do_combo
		# keep combos in order of xp cost
		# and keep keys lowercase

		if @combos.has_key? c = prompt("Which combo? ")
			used_combo = @combos[c]
			if @player.save[:xp] >= used_combo.price
				damage = used_combo.use
				@player.give_xp -used_combo.price
				return true, damage
			else
				p_warn("You don't have enough xp loser.")
				return false
			end
		else 
			p_warn("That is not a combo.")
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
		success, damage = do_combo
		attack damage if success
	end

	def combolist *args
		amount = @player.save[:rank]
		p_info "Unlocked Combos:" 
		combos = @combos.sort_by { |k, v| v.price }
		amount.times { |i|
			p_info "#{combos[i][1].name}: -#{combos[i][1].price} xp"
		}
	end

	def scores *args
		scores = YAML.load_file("#{$rpath}/scores.yml")
		p_info "High Scores:"
		scores.each { |s|
			p_info "#{s[1]}: #{s[0]}"
		}
	end

	def quit *args
		p_warn "Wanna save yo game? yes or no"
		answer = prompt
		while !(["yes", "y", "no", "n"].include? answer)
			p_warn "I didn't catch that. Yes or No?"
			answer = prompt
		end
		save_game = (answer == "yes" ? true : false)
		@player.save_game if save_game
		exit
	end

	def help *args
		p_info "Available commands:"
 		puts(@commands.join(" "))
  	end

	def taunt *args
		if @player.save[:taunts_available] > 0
			@player.taunt
		else
			p_warn "You have no more taunts."
		end
	end

	def heal *args
		amount = args[0].to_i
		if amount > 0
			@player.heal amount
		else
			p_warn "Please specify a number greater than 0. Example: heal 5"
		end
	end

	def info *args
		@player.info
		puts
		@zombie.info
	end

	def easter *args
		if args[0] == "egg"
			unless @player.save[:egg_used]
				xp = (-50..75).to_a.rand_choice
				@player.give_xp xp
				p_level_up "#{(xp >= 0 ? "+" : "-") + xp.abs.to_s} xp"
				@player.save[:egg_used] = true
			else
				p_warn "You used your easter egg this game you cheater :/"
			end
		else
			p_warn "Unknown Command."
		end
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
    player.save_game
    puts("^C")
    p_level_up "Game saved."
    exit
  }
end

def prompt _prompt="", newline=false
	_prompt += "\n" if newline
	inText = Readline.readline(_prompt, true).squeeze(" ").strip.downcase
	inText
end
