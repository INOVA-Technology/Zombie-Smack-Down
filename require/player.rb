class Player

	# try to put methods in alphebetical order, except init

	attr_accessor :save, :phrases

	def initialize
		@save = YAML.load_file("#{$rpath}/require/player.yml")
		@save_original = { :health => 25,
						   :xp => 15,
						   :rank => 1,
						   :wave => 1,
						   :zombies_killed => 0,
						   :total_kills => 0,
						   :kick_upgrade => 0,
						   :punch_upgrade => 0,
						   :taunts_available => 3,
						   :egg_used => false,
						   :new_game => true }
		if @save[:new_game]
			self.give_xp((@save[:rank] - 1) * 2)
			@save[:new_game] = false
		end

		@phrases = ["You smacked down the", "You hit the", "Whose your daddy", "You just powned the"]

	end

	def add_kill
		@save[:total_kills] += 1
		@save[:zombies_killed] += 1
		self.next_wave if @save[:zombies_killed] % 3 == 0
		self.rank_up if @save[:total_kills] % 15 == 0
	end

	def check_dead
		self.die if @save[:health] <= 0
	end

	def die
		self.reset
		p_warn "You died!!!"
		p_warn "You killed #{@save[:zombies_killed]} zombies."
		self.save_score
		exit
	end

	def give_xp amount
		@save[:xp] += amount
	end

	def heal amount
		if @save[:xp] >= amount
			@save[:health] += amount
			self.give_xp -amount
			p_level_up "+#{amount} health!"
		else
			p_warn "You do not have enough xp!"
		end
	end

	def info
		p_info "Health: #{@save[:health]}"
		p_info "XP: #{@save[:xp]}"
		p_info "Rank: #{@save[:rank]}"
		p_info "Wave: #{@save[:wave]}"
		p_info "Zombies Killed: #{@save[:zombies_killed]}"
		p_info "Total Kills: #{@save[:total_kills]}"
		p_info "Kick Upgrade: #{@save[:kick_upgrade]}"
		p_info "Punch Upgrade: #{@save[:punch_upgrade]}"
		p_info "Taunts Available: #{@save[:taunts_available]}"
	end

	def kick
		(3..7).to_a.rand_choice + @save[:kick_upgrade]
	end

	def next_wave
		@save[:wave] += 1
		xp = @save[:wave] + 2
		self.give_xp xp
		p_level_up "Wave #{@save[:wave]}, +#{xp} xp"
	end

	def punch
		(4..6).to_a.rand_choice + @save[:punch_upgrade]
	end

	def rank_up
		@save[:rank] += 1
		p_level_up "Rank Up! You are now rank #{@save[:rank]}. You unlocked a new combo."
		self.upgrade
	end

	def reset
		@save_original[:rank] = @save[:rank]
		@save_original[:total_kills] = @save[:total_kills]
		@save_original[:kick_upgrade] = @save[:kick_upgrade]
		@save_original[:punch_upgrade] = @save[:punch_upgrade]
		File.open("#{$rpath}/require/player.yml", 'w') { |out|
		   YAML.dump(@save_original, out)
		}
	end

	def save_game
		File.open("#{$rpath}/require/player.yml", 'w') { |out|
		   YAML.dump(@save, out)
		}
	end

	def save_score
		score = @save[:zombies_killed]
		scores = YAML.load_file("#{$rpath}/scores.yml")
		if score > scores.last[0]
			p_level_up "High Score! What is your name?"
			name = prompt
			scores = scores.push([score, name]).sort_by { |i| -i[0]}
			scores.pop
			File.open("#{$rpath}/scores.yml", "w") { |out| 
				YAML.dump(scores, out)
			}
		end
	end

	def take_damage damage
		@save[:health] -= damage
	end

	def taunt
		taunt = ["HEY ZOMBIE! UR FACE!", "DIRT BAG", "UR MOM", "POOP FACE", "GET OWNED BUDDY BOY", ":p", "EAT MY FIST", "be nice", "You stink", "YO MAMA"].rand_choice
		if @save[:xp] >= 2
			xp = (-12..12).to_a.rand_choice
			self.give_xp xp
			p_pain "#{taunt} #{(xp >= 0 ? "+" : "-")}#{xp.abs} xp"
			@save[:taunts_available] -= 1
		else
			p_warn "You are missing the necessary xp to taunt (2)"
		end
	end

	def upgrade
		max_level = 6
		if @save[:kick_upgrade] >= max_level && @save[:punch_upgrade] >= max_level
			return
		else
			p_level_up "What do you want to upgrade? (kick or punch)"
			skill = prompt
			while !(["kick", "punch"].include? skill)
				p_warn "Please answer with kick or punch. What would you like to upgrade?"
				skill = prompt
			end
			max_level_message = "#{skill} is at the max level (6)"
			plus_1 = "#{skill} +1"
			case skill
			when "kick"
				if @save[:kick_upgrade] < max_level
					@save[:kick_upgrade] += 1
					p_level_up plus_1
				else 
					p_warn max_level_message
					upgrade
				end
			when "punch"
				if @save[:punch_upgrade] < max_level
					@save[:punch_upgrade] += 1
					p_level_up plus_1
				else 
					p_warn max_level_message
					upgrade
				end
			end
		end

	end

end