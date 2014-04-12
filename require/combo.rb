class Combo

	attr_accessor :name, :price

	def initialize player=nil
		@player = player
		self.setInfo
	end

	def use
		self.extra
		@damage.to_a.rand_choice
	end

	def extra
		
	end

end

# try to keep combos in order of xp cost
# also add new combos to combos variable in the start function in the zsd file
class KickPunch < Combo
	def setInfo
		@name = "Kick Punch"
		@price = 2
		@damage = (3..9)
	end
end

class TripStomp < Combo
	def setInfo
		@name = "Trip Stomp"
		@price = 3
		@damage = (4..10)
	end
end

class PunchPunchKick < Combo
	def setInfo
		@name = "Punch Punch Kick"
		@price = 4
		@damage = (4..12)
	end
end

class KneePunchFaceSlap < Combo
	def setInfo
		@name = "Knee Punch Face Slap"
		@price = 4
		@damage = (2..12)
	end
end

class HealFury < Combo
	def setInfo
		@name = "Heal Fury"
		@price = 5
		@damage = (5..10)
	end

	def extra
		health = -((3..7).to_a.rand_choice)
		@player.take_damage health
	end
end

class ElbowFistKneeFistKneeBodySlam < Combo
	def setInfo
		@name = "Elbow Fist Knee Fist Knee Body Slam"
		@price = 6
		@damage = (3..18)
	end
end

class KickKickKickKickKickKickKickKickKickKickKickKickKickKickKick < Combo
	def setInfo
		@name = "Kick Kick Kick Kick Kick Kick Kick Kick Kick Kick Kick Kick Kick Kick Kick"
		@price = 7
		@damage = (9..17)
	end
end

class ComboOfPossibleDeath < Combo
	def setInfo
		@name = "Combo of Possible Death"
		@price = 9
		@damage = (5..25)
	end
end

class ComboOfDeath < Combo
	def setInfo
		@name = "Combo of Death"
		@price = 12
		@damage = (14..30)
	end
end

class CoolestComboEver < Combo
	def setInfo
		@name = "Coolest Combo Ever"
		@price = 15
		@damage = (10..25)
	end
end

class ChasePunchOfFire < Combo
	def setInfo
		@name = "Chase Punch of Fire"
		@price = 20
		@damage = (20..40)
	end
end

class AddisonKickOfColdHardMusic < Combo
	def setInfo
		@name = "Addison Kick of Cold Hard Music"
		@price = 20
		@damage = (20..40)
	end
end

class NotACombo < Combo
	def setInfo
		@name = "Not A Combo"
		@price = 20
		@damage = (25..45)
	end
end

class PainWithASideOfBlood < Combo
	def setInfo
		@name = "Pain With a Side of Blood"
		@price = 25
		@damage = (35..50)
	end
end

class TheCombo < Combo
	def setInfo
		@name = "The Combo"
		@price = 25
		@damage = (1..100)
	end
end

class The2ndCombo < Combo
	def setInfo
		@name = "The 2nd Combo"
		@price = 30
		@damage = (20..100)
	end
end

class UltimateDestructionKickPunch < Combo
	def setInfo
		@name = "Ultimate Destruction Kick Punch"
		@price = 30
		@damage = (40..75)
	end
end

class The3rdCombo < Combo
	def setInfo
		@name = "The 3rd Combo"
		@price = 35
		@damage = (50..85)
	end
end

class PrettyGoodCombo < Combo
	def setInfo
		@name = "Pretty Good Combo"
		@price = 50
		@damage = (45..111)
	end
end

class ChuckNorrisStompOfMayhem < Combo
	def setInfo
		@name = "Chuck Norris Stomp of Mayhem"
		@price = 1000
		@damage = (1..2_000_000)
	end
end