class Zombie 

	attr_accessor :isAlive, :name, :power, :xp, :phrases, :health
	
	def initialize
		@isAlive = true
		self.setInfo
	end

	def setInfo
		@name = "Zombie"
		@power = (4..6)
		@health = 10
		@xp = 2
		@phrases = ["hit ur face", "punched the heck out of you", "beat the heck out of you", "bruised ur face"]
	end

	def info
		_power = @power.to_a
		puts(pInfo "#{@name} health: #{@health}")
		puts(pInfo "Attack Strength: #{_power[0]} to #{_power[-1]}")
	end

	def attack
		@power.to_a.rand_choice
	end

	def takeDamage amount
		@health -= amount
	end

	def checkDead
		self.die if @health <= 0
	end

	def die
		puts(pPain "KO! You killed the #{@name}")
		@isAlive = false
	end

end

# start extra zombies

class BigZombie < Zombie
	def setInfo
		@name = "Big Zombie"
		@power = (6..8)
		@health = 15
		@xp = 4
		@phrases = ["hit ur face", "punched the heck out of you", "beat the heck out of you", "bruised ur face"]
	end
end

class DaddyZombie < Zombie
	def setInfo
		@name = "Daddy Zombie"
		@power = (4..10)
		@health = 20
		@xp = 9
		@phrases = ["IS your daddy", "punched the heck out of you", "beat the heck out of you", "ain't your mom", "told you to go to bed"]
	end
end

class GunZombie < Zombie
	def setInfo
		@name = "Gun Zombie"
		@power = (3..15)
		@health = 20
		@xp = 15		
		@phrases = ["shot yo face", "shot the heck out of you", "beat the heck out of you", "made you eat bullets", "showed you his ak-47"]
	end
end

class NinjaZombie < Zombie
	def setInfo
		@name = "Ninja Zombie"
		@power = (7..20)
		@health = 20
		@xp = 18
		@phrases = ["was to ninja for you", "threw a ninja star at your face", "is a blur", "sent you flying", "has a black belt"]
	end
end

class IdiotZombie < Zombie
	def setInfo
		@name = "Idiot Zombie"
		@power = (7..20)
		@health = 2
		@xp = 5
		@phrases = ["is an idiot but still pwn-ed u", "fell down from stupidness but somehow landed on you", "beat ur face's face", "is somehow beating you"]
	end
end

class BlindZombie < Zombie
	def setInfo
		@name = "Blind Zombie"
		@power = (1..25)
		@health = 24
		@xp = 20
		@phrases = ["tried to hit you", "cant see ur face", "cant touch this", "cant see you but hurt you anyway"]
	end
end

class StrongZombie < Zombie
	def setInfo
		@name = "Strong Zombie"
		@power = (15..21)
		@health = 30
		@xp = 30
		@phrases = ["destroyed you", "may have murdered you", "is strong", "is VERY strong", "works out"]
	end
end

class BasicallyDeadZombie < Zombie
	def setInfo
		@name = "Basically Dead Zombie"
		@power = (50..75)
		@health = (2..5).to_a.rand_choice
		@xp = (2..5).to_a.rand_choice
		@phrases = ["totally pwn-ed you!", "hurt you pretty bad", "obliterated you", "probably killed you", "is not dead"]
	end
end

class SuperZombie < Zombie
	def setInfo
		@name = "Super Zombie"
		@power = (35..56)
		@health = 65
		@xp = 38
		@phrases = ["is up up and away!", "just chucked kryptonite at ur face", "has super strength", "is the ultimate super villain", "just mad you cry"]
	end
end

class BossZombie < Zombie
	def setInfo
		@name = "Boss Zombie"
		@power = (60..90)
		@health = (95..105).to_a.rand_choice
		@xp = (65..80).to_a.rand_choice
		@phrases = ["sent you to work!", "is not giving you a raise", "is a boss!", "just fired you", "just demoted you"]
	end
end

class UltimateZombie < Zombie
	def setInfo
		@name = "Ultimate Zombie"
		@power = (75..115)
		@health = 100
		@xp = 115
		@phrases = ["is to ultimate", "is really scary", "just gave you a nice punch to the face", "is more ultimate than you", "makes you look... un-ultimate"]
	end
end