class Player

	# try to put methods in alphebetical order, except init

	attr_accessor :save, :phrases

	def initialize
		@save = YAML.load_file("#{$rpath}/require/player.yml")
		@saveOriginal = { :health => 25,
						   :xp => 15,
						   :rank => 1,
						   :wave => 1,
						   :zombiesKilled => 0,
						   :totalKills => 0,
						   :kickUpgrade => 0,
						   :punchUpgrade => 0,
						   :tauntsAvailable => 3,
						   :eggUsed => false,
						   :newGame => true }
		if @save[:newGame]
			self.giveXP((@save[:rank] - 1) * 2)
			@save[:newGame] = false
		end

		@phrases = ["You smacked down the", "You hit the", "Whose your daddy", "You just powned the"]

	end

	def addKill
		@save[:totalKills] += 1
		@save[:zombiesKilled] += 1
		self.nextWave if @save[:zombiesKilled] % 3 == 0
		self.rankUp if @save[:totalKills] % 15 == 0
	end

	def die
		self.reset
		puts pWarn "You died!!!"
		puts pWarn "You killed #{@save[:zombiesKilled]} zombies."
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
			puts pLevelUp "+#{amount} health!"
		else
			puts pWarn "You do not have enough xp!"
		end
	end

	def info
		puts pInfo "Health: #{@save[:health]}"
		puts pInfo "XP: #{@save[:xp]}"
		puts pInfo "Rank: #{@save[:rank]}"
		puts pInfo "Wave: #{@save[:wave]}"
		puts pInfo "Zombies Killed: #{@save[:zombiesKilled]}"
		puts pInfo "Total Kills: #{@save[:totalKills]}"
		puts pInfo "Kick Upgrade: #{@save[:kickUpgrade]}"
		puts pInfo "Punch Upgrade: #{@save[:punchUpgrade]}"

	end

	def kick
		(3..7).to_a.rand_choice + @save[:kickUpgrade]
	end

	def nextWave
		@save[:wave] += 1
		xp = @save[:wave] + 2
		self.giveXP xp
		puts pLevelUp "Wave #{@save[:wave]}, +#{xp} xp"
	end

	def punch
		(4..6).to_a.rand_choice + @save[:punchUpgrade]
	end

	def rankUp
		@save[:rank] += 1
		puts pLevelUp "Rank Up! You are now rank #{@save[:rank]}. You unlocked a new combo."
		self.upgrade
	end

	def reset
		@saveOriginal[:rank] = @save[:rank]
		@saveOriginal[:totalKills] = @save[:totalKills]
		@saveOriginal[:kickUpgrade] = @save[:kickUpgrade]
		@saveOriginal[:punchUpgrade] = @save[:punchUpgrade]
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
		score = @save[:zombiesKilled]
		scores = YAML.load_file("#{$rpath}/scores.yml")
		if score > scores[-1][0]
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
		self.die if @save[:health] <= 0
	end

	def taunt
		taunt = ["HEY ZOMBIE! UR FACE!", "DIRT BAG", "UR MOM", "POOP FACE", "GET OWNED BUDDY BOY", ":p", "EAT MY FIST", "be nice", "You stink", "YO MAMA"].rand_choice
		if @save[:xp] >= 2
			xp = (-12..12).to_a.rand_choice
			self.giveXP xp
			puts pPain "#{taunt} #{(xp >= 0 ? "+" : "-")}#{xp.abs} xp"
			@save[:tauntsAvailable] -= 1
		else
			puts pWarn "You are missing the necessary xp to taunt (2)"
		end
	end

	def upgrade
		max_level = 6
		if @save[:kickUpgrade] >= max_level && @save[:punchUpgrade] >= max_level
			return
		else
			puts pLevelUp "What do you want to upgrade? (kick or punch)"
			skill = prompt
			while !(["kick", "punch"].include? skill)
				puts pWarn "Please answer with kick or punch. What would you like to upgrade?"
				skill = prompt
			end
			max_level_message = pWarn "#{skill} is at the max level (6)"
			plus_1 = pLevelUp "#{skill} +1"
			case skill
			when "kick"
				if @save[:kickUpgrade] < max_level
					@save[:kickUpgrade] += 1
					puts plus_1
				else 
					puts max_level_message
					upgrade
				end
			when "punch"
				if @save[:punchUpgrade] < max_level
					@save[:punchUpgrade] += 1
					puts plus_1
				else 
					puts max_level_message
					upgrade
				end
			end
		end

	end

end