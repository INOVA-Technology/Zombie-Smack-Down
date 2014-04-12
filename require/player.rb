class Player

	# try to put methods in alphebetical order, except init

	attr_accessor :save, :phrases

	def initialize
		@save = YAML.load_file("#{$rpath}/require/player.yml")
		@saveOriginal = { :health => 25,
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
			self.giveXP((@save[:rank] - 1) * 2)
			@save[:new_game] = false
		end

		@phrases = ["You smacked down the", "You hit the", "Whose your daddy", "You just powned the"]

	end

	def addKill
		@save[:total_kills] += 1
		@save[:zombies_killed] += 1
		self.nextWave if @save[:zombies_killed] % 3 == 0
		self.rankUp if @save[:total_kills] % 15 == 0
	end

	def checkDead
		self.die if @save[:health] <= 0
	end

	def die
		self.reset
		puts(pWarn "You died!!!")
		puts(pWarn "You killed #{@save[:zombies_killed]} zombies.")
		self.saveScore
		exit
	end

	def giveXP amount
		@save[:xp] += amount
	end

	def heal amount
		if @save[:xp] >= amount
			@save[:health] += amount
			self.giveXP -amount
			puts(pLevelUp "+#{amount} health!")
		else
			puts(pWarn "You do not have enough xp!")
		end
	end

	def info
		puts(pInfo "Health: #{@save[:health]}")
		puts(pInfo "XP: #{@save[:xp]}")
		puts(pInfo "Rank: #{@save[:rank]}")
		puts(pInfo "Wave: #{@save[:wave]}")
		puts(pInfo "Zombies Killed: #{@save[:zombies_killed]}")
		puts(pInfo "Total Kills: #{@save[:total_kills]}")
		puts(pInfo "Kick Upgrade: #{@save[:kick_upgrade]}")
		puts(pInfo "Punch Upgrade: #{@save[:punch_upgrade]}")
		puts(pInfo "Taunts Available: #{@save[:taunts_available]}")
	end

	def kick
		(3..7).to_a.rand_choice + @save[:kick_upgrade]
	end

	def nextWave
		@save[:wave] += 1
		xp = @save[:wave] + 2
		self.giveXP xp
		puts(pLevelUp "Wave #{@save[:wave]}, +#{xp} xp")
	end

	def punch
		(4..6).to_a.rand_choice + @save[:punch_upgrade]
	end

	def rankUp
		@save[:rank] += 1
		puts(pLevelUp "Rank Up! You are now rank #{@save[:rank]}. You unlocked a new combo.")
		self.upgrade
	end

	def reset
		@saveOriginal[:rank] = @save[:rank]
		@saveOriginal[:total_kills] = @save[:total_kills]
		@saveOriginal[:kick_upgrade] = @save[:kick_upgrade]
		@saveOriginal[:punch_upgrade] = @save[:punch_upgrade]
		File.open("#{$rpath}/require/player.yml", 'w') { |out|
		   YAML.dump(@saveOriginal, out)
		}
	end

	def saveGame
		File.open("#{$rpath}/require/player.yml", 'w') { |out|
		   YAML.dump(@save, out)
		}
	end

	def saveScore
		score = @save[:zombies_killed]
		scores = YAML.load_file("#{$rpath}/scores.yml")
		if score > scores.last[0]
			puts pLevelUp "High Score! What is your name?"
			name = prompt
			scores = scores.push([score, name]).sort_by { |i| -i[0]}
			scores.pop
			File.open("#{$rpath}/scores.yml", "w") { |out| 
				YAML.dump(scores, out)
			}
		end
	end

	def takeDamage damage
		@save[:health] -= damage
	end

	def taunt
		taunt = ["HEY ZOMBIE! UR FACE!", "DIRT BAG", "UR MOM", "POOP FACE", "GET OWNED BUDDY BOY", ":p", "EAT MY FIST", "be nice", "You stink", "YO MAMA"].rand_choice
		if @save[:xp] >= 2
			xp = (-12..12).to_a.rand_choice
			self.giveXP xp
			puts pPain "#{taunt} #{(xp >= 0 ? "+" : "-")}#{xp.abs} xp"
			@save[:taunts_available] -= 1
		else
			puts(pWarn "You are missing the necessary xp to taunt (2)")
		end
	end

	def upgrade
		max_level = 6
		if @save[:kick_upgrade] >= max_level && @save[:punch_upgrade] >= max_level
			return
		else
			puts(pLevelUp "What do you want to upgrade? (kick or punch)")
			skill = prompt
			while !(["kick", "punch"].include? skill)
				puts(pWarn "Please answer with kick or punch. What would you like to upgrade?")
				skill = prompt
			end
			max_level_message = pWarn "#{skill} is at the max level (6)"
			plus_1 = pLevelUp "#{skill} +1"
			case skill
			when "kick"
				if @save[:kick_upgrade] < max_level
					@save[:kick_upgrade] += 1
					puts plus_1
				else 
					puts max_level_message
					upgrade
				end
			when "punch"
				if @save[:punch_upgrade] < max_level
					@save[:punch_upgrade] += 1
					puts plus_1
				else 
					puts max_level_message
					upgrade
				end
			end
		end

	end

end