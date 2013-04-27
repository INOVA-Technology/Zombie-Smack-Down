#!/usr/bin/env ruby

# for color referances go to:
# http://pueblo.sourceforge.net/doc/manual/ansi_color_codes.html

module Stuff

  class Game
  	attr_accessor :prefs, :r
    require 'yaml'
    
    def initialize
      prefs_file = File.open 'prefs.yaml', 'r'
      @prefs = YAML.load prefs_file.read
      prefs_file.close
      @default = { xp: 10, kills: 0, health: 20}
      @r = 0;
      @prefs[:xp] += @prefs[:rank] * 5
      @combos = ["kick punch", "punch punch kick", "elbow fist knee fist knee body slam", "heal fury", "trip stomp", "knee punch face slap", "kick kick kick kick kick kick kick kick kick kick kick kick kick kick kick", "chase punch of fire", "addison kick of cold hard music", "ultimate destruction kick punch", "chuck norris stomp of mayhem", "coolest combo ever"]
    end

    def give_xp amount
      @prefs[:xp] += amount
      @prefs[:xp] = 0 if @prefs[:xp] < 0
    end	

    def die
      death = ["Your dead ", "Too bad", "The zombie ate ur brainz", "So sad", "Game over looser", "You must really fail at life"].sample
      introPhrase = ["You have killed", "You have viciously slapped", "You have beaten the crud out of"].sample
      endPhrase = ["zombies", "innocent zombies", "vicious zombies", "ruthless zombies", "walkers"].sample

      prefs_file = File.open 'prefs.yaml', 'w'
      prefs_file.puts @default.to_yaml + ":totalKills: " + @prefs[:totalKills].to_s + "\n:rank: " + @prefs[:rank].to_s
      prefs_file.close

      puts "\e[31m" + death + "\e[39m (enter to continue)"
      gets.chomp
      puts "\e[31m" + introPhrase + " " + @prefs[:kills].to_s + " " + endPhrase + "\e[39m (enter to exit)"
      gets.chomp
      exit
    end

    def win
      puts "You win!!"
      prefs_file = File.open 'prefs.yaml', 'w'
      prefs_file.puts @default.to_yaml + ":totalKills: " + @prefs[:totalKills].to_s + "\n:rank: " + @prefs[:rank].to_s
      prefs_file.close
    end

    def not_enough_xp
      puts
      puts "\e[33mNot enough xp...\e[39m"
      @r = 0
    end

    def punch
      @r = Random::rand(4..7)
    end

    def kick
      @r = Random::rand(3..8)
    end

    def combo com
      case com
      when "kick punch"
        if @prefs[:xp] >= 2
          @r = Random::rand(3..9)
          self.give_xp -2
        else
          self.not_enough_xp
        end
      when "punch punch kick"
        if @prefs[:xp] >= 4 
          @r = Random::rand(2..12)
          self.give_xp -4
        else
          self.not_enough_xp
        end
      when "elbow fist knee fist knee body slam" 
        if @prefs[:xp] >= 6
          @r = Random::rand(3..18)
          self.give_xp -6
        else
          self.not_enough_xp
        end
      when "trip stomp" 
        if @prefs[:xp] >= 3
          @r = Random::rand(4..10)
          self.give_xp -3
        else
          self.not_enough_xp
        end
      when "knee punch face slap" 
        if @prefs[:xp] >= 4
          @r = Random::rand(6..12)
          self.give_xp -4
        else
          self.not_enough_xp
        end
      when "kick kick kick kick kick kick kick kick kick kick kick kick kick kick kick" 
        if @prefs[:xp] >= 7
          @r = Random::rand(9..17)
          self.give_xp -7
        else
          self.not_enough_xp
        end
      when "chase punch of fire" 
        if @prefs[:xp] >= 20
          @r = Random::rand(20..40)
          self.give_xp -20
        else
          self.not_enough_xp
        end
      when "addison kick of cold hard music" 
        if @prefs[:xp] >= 20
          @r = Random::rand(20..40)
          self.give_xp -20
        else
          self.not_enough_xp
        end
      when "ultimate destruction kick punch" 
        if @prefs[:xp] >= 30
          @r = Random::rand(1..50)
          self.give_xp -30
        else
          self.not_enough_xp
        end
      when "chuck norris stomp of mayhem" 
        if @prefs[:xp] >= 1000
          @r = Random::rand(1..2000000)
          self.give_xp -1000
        else
          self.not_enough_xp
        end
      when "coolest combo ever" 
        if @prefs[:xp] >= 15
          @r = Random::rand(10..25)
          self.give_xp -15
        else
          self.not_enough_xp
        end
      when "heal fury"
        if @prefs[:xp] >= 5
          @r = Random::rand(4..10)
          self.damage(Random::rand(2..4) * -1)
          self.give_xp -5
        else
          self.not_enough_xp
        end
      end
    end

    def attack enemy, weapon = "punch"
      pass = 1
      phrase = ["You smacked down the", "You hit the", "Whose your daddy", "You just powned the"].sample
      while pass != 0
      	pass = 0
	      case weapon
	      when "punch"
	        self.punch
	      when "kick"
	      	self.kick
	      when "combo"
	      	puts "Which combo?"
	      	c = gets.chomp.downcase
	      	if @combos.include? c
            self.combo c
		      else
  	      	puts "Invalid combo..."
            @r = 0
	      	end
	      end
        
	    end
      enemy.damage @r
      
      puts "\e[1;31m"
      puts phrase + " " + enemy.name + " -" + @r.to_s
      puts "\e[22;39m"
    end

    def damage amount
      @prefs[:health] -= amount
      self.die if @prefs[:health] <= 0
    end	

    def info
      puts "\e[35m"
      @prefs.each{ |key, value|
        puts key.to_s + ": " + value.to_s
      }
      print "\e[39m"
    end

    def pwn
    	puts
      puts "\e[31;1mKO! \e[39;22m"
      @prefs[:kills] += 1
      @prefs[:totalKills] += 1
      self.rankup if @prefs[:totalKills] % 15 == 0
    end

    def rankup
      @prefs[:rank] += 1
      give_xp 10
      if (@combos[@prefs[:rank] - 1]) 
        puts "\e[35mNew combo unlocked!" + @combos[@prefs[:rank - 1]]
      else
        puts "\e[35mYour doing pretty good!\e[39m"
      end
    end

    def comboList
      puts
      puts "\e[35mCombos:"
      i = 0
      @combos.each { |c|
        break if i == @prefs[:rank]
        puts c
        i += 1
      }
      puts "\e[39m"
    end

    def quit
      puts "Wanna save yo game? yes or no"
      save = gets.chomp.downcase
        if save == "yes"
          prefs_file = File.open 'prefs.yaml', 'w'
          prefs_file.puts @prefs.to_yaml
          prefs_file.close
          exit
        else
        	exit
        end
    end

    def heal
      puts
      puts "\e[36mHow much health do u want? (1 xp for 1 health)"
      howMuch = gets.chomp.to_i
      if howMuch == 0
        puts "Nothing given"
      elsif howMuch <= @prefs[:xp] 
        howMuch *= -1
	      self.damage howMuch
        self.give_xp howMuch
	      puts "you have been healed +" + (howMuch * -1).to_s
	      puts "\e[39m"
	    else
	    	puts "\e[33mNOT ENOUGH XP!!! >:D\e[39m"
			end
    end

    def rankup
      give_xp 10
      puts "\e[39mRanked up!"
      begin
				puts "New combo unlocked: " + @combos[@prefs[:rank] - 1] 
	  	rescue
				puts "Your doing pretty good!"
	    end
      print "\e[39m"
    end

    def taunt
      taunt = ["HEY ZOMBIE! UR FACE!", "DIRT BAG", "UR MOM", "POOP FACE", "GET OWNED BUDDY BOY", ":p", "EAT MY FIST", "mbe nice"].sample
      
      if @prefs[:xp] >= 2
        r = Random::rand(-10..10)
        self.give_xp r
        puts
        puts "\e[31m" + taunt + " " + r.to_s + "\e[39m"
        puts
      else
        puts
        puts "\e[33mNOT ENOUGH XP >:p\e[39m"
        puts
      end

    end

  # end of Game class
  end

  ############### ZOMBIEZ!! ###############

  class Zombie
    
    attr_accessor :is_alive

    def initialize hero
      @is_alive = true;
      @hero = hero
      self.setXpPainHealth
    end

    def setXpPainHealth
      @xp = 2
      @pain = [4, 6]
      @health = 10
      @name = "Zombie"
      @phrases = ["hit ur face", "punched the heck out of you", "beat the heck out of you", "bruised ur face"].sample
    end
    
    def name
      @name
    end

    def attack
      if @is_alive
        r = Random::rand(@pain[0]..@pain[1])
        @hero.damage r
      	print "\e[31;1m"
        puts self.name + ' ' + @phrases + " -" + r.to_s
        puts "\e[39;22m"
      end
    end

    def die 
      @hero.give_xp @xp
      @is_alive = false
      @hero.pwn
    end

    def damage amount
      @health -= amount
      self.die if @health <= 0
    end

    def info
      puts "\e[35m"
      puts self.name + " health: " + @health.to_s
      print "\e[39m"

    end
  # end Zombie class
  end

  ### MORE ZOMBIEZ! ###

  class BigZombie < Zombie
    def setXpPainHealth
      @xp = 4
      @pain = [6, 8]
      @health = 15
      @name = "Big Zombie"
      @phrases = ["hit ur face", "punched the heck out of you", "beat the heck out of you", "bruised ur face"].sample
    end
  end

  class DaddyZombie < Zombie
    def setXpPainHealth
      @xp = 10
      @pain = [3, 12]
      @health = 20
      @name = "Daddy Zombie"
      @phrases = ["IS your daddy", "punched the heck out of you", "beat the heck out of you", "ain't your mom"].sample
    end
  end

  class GunZombie < Zombie
    def setXpPainHealth
      @xp = 15
      @pain = [2, 15]
      @health = 20
      @name = "Gun Zombie"
      @phrases = ["shot yo face", "shot the heck out of you", "beat the heck out of you", "made you eat bullets"].sample
    end
  end

  class NinjaZombie < Zombie
    def setXpPainHealth
      @xp = 20
      @pain = [7, 20]
      @health = 20
      @name = "Ninja Zombie"
      @phrases = ["was to ninja for you", "threw a ninja star at your face", "is a blur", "sent you flying"].sample
    end
  end

  class IdiotZombie < Zombie
    def setXpPainHealth
      @xp = 5
      @pain = [7, 20]
      @health = 2
      @name = "Idiot Zombie"
      @phrases = ["was to ninja for you", "threw a ninja star at your face", "is a blur", "sent you flying"].sample
    end
  end

  class BlindZombie < Zombie
    def setXpPainHealth
      @xp = 25
      @pain = [0, 25]
      @health = 24
      @name = "Blind Zombie"
      @phrases = ["was to ninja for you", "threw a ninja star at your face", "is a blur", "sent you flying"].sample
    end
  end

#end Stuff module
end