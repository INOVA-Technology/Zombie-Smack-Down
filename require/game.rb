#!/usr/bin/env ruby

# for color referances go to:
# http://pueblo.sourceforge.net/doc/manual/ansi_color_codes.html

# codes/usages for colors and styles:
  # Colors:
    # \e[31m is red, for pain/death things
    # \e[33m is yellow, for warnings and such like not enough xp
    # \e[35m is purple, for info like ranking up and the info command
    # \e[36m is blue for healing and extra power/leveling up

    # \e[39m gets rid of colors, goes back to default

  # Bold:
  # \e[1m is bold, just for attacking info
  # \e[22m gets rid of the bold

def prompt promptBegining="", hero=nil
  begin # the true parameter keeps a history of the previously entered commands
    inText = Readline.readline(promptBegining, true).squeeze(" ").strip.downcase
    inText
  rescue Interrupt # this is run if the script is stopped with ctrl+c or ctrl+d
    unless hero.nil?
      hero.save
    end
    puts
    exit
  end
end

module Stuff

  class Game
  	attr_accessor :prefs, :disp, :new_game, :r # r is the damage done to the enemy
    require 'yaml'
    
    def initialize
      @new_game = true
      @prefs_file_path = ''
      if ARGV[0] == '-t' # uses local version of the prefs
        @prefs_file_path = './require/prefs.yaml'
        puts "TESTING"
      else # loads normal version of prefs
        @prefs_file_path = "#{Dir.home}/.zsd/require/prefs.yaml"
      end
      prefs_file = File.open @prefs_file_path, 'r'
      @prefs = YAML.load prefs_file.read
      prefs_file.close
      @r = 0; # damage done to enemy
      if @prefs[:xp] == 15
        @prefs[:xp] += (@prefs[:rank] - 1) * 4 # add 4 * their rank of xp at the beginning of they game
      end
      @disp = true # tells weather it should attack/tell the damage done
      @combos      = [ "kick punch",       "elbow fist knee fist knee body slam",      "trip stomp",      "punch punch kick",       "knee punch face slap",      "heal fury",      "kick kick kick kick kick kick kick kick kick kick kick kick kick kick kick",      "combo of possible death"       "combo of death"        "coolest combo ever",       "chase punch of fire",       "addison kick of cold hard music",       "pain with a side of blood",       "ultimate destruction kick punch",       "chuck norris stomp of mayhem",         "not a combo"]
      #combos with xp cost
      @comboValues = { "kick punch" => 2 , "elbow fist knee fist knee body slam" => 3, "trip stomp" => 3, "punch punch kick" => 4 , "knee punch face slap" => 4, "heal fury" => 5, "kick kick kick kick kick kick kick kick kick kick kick kick kick kick kick" => 7, "combo of possible death" => 9, "combo of death" => 12, "coolest combo ever" => 15, "chase punch of fire" => 20, "addison kick of cold hard music" => 20, "pain with a side of blood" => 25, "ultimate destruction kick punch" => 30, "chuck norris stomp of mayhem" => 1000, "not a combo" => 20}
    end

    def give_xp amount
        @prefs[:xp] += amount
    end	

    def die
      death = ["Your dead ", "Too bad", "The zombie ate ur brainz", "So sad", "Game over looser", "You must really fail at life"].sample
      introPhrase = ["You have killed", "You have viciously slapped", "You have beaten the crud out of"].sample
      endPhrase = ["zombies", "innocent zombies", "vicious zombies", "ruthless zombies", "walkers"].sample

      puts "\e[31m" + death + "\e[39m (enter to continue)"
      prompt
      puts "\e[31m" + introPhrase + " " + @prefs[:kills].to_s + " " + endPhrase + "\e[39m (enter to exit)"
      prompt

      unless ARGV[0] == '-n' || ARGV[1] == '-n'
        unless File.exists? "#{Dir.home}/.zsd/scores"
          system "touch ~/.zsd/scores"
          name = prompt "New Highscore! Enter Your name: "
          highscore_list = ["addison 27", "chase 10", "#{name} #{@prefs[:kills]}"]
          highscore_file = File.open("#{Dir.home}/.zsd/scores", "w")
          highscore_list.sort! { |s1, s2| 
            s2.split(" ").last.to_i <=> s1.split(" ").last.to_i
          }
          highscore_file.puts highscore_list.to_yaml
          highscore_file.close
          puts
        else
          highscore_file = File.open("#{Dir.home}/.zsd/scores", "r")
          highscore_list = YAML.load highscore_file.read
          highscore_file.close
          highscore_list.sort! { |s1, s2| 
            s2.split(" ").last.to_i <=> s1.split(" ").last.to_i
          }
          if highscore_list.length < 5 || highscore_list.last.split(" ").last.to_i < @prefs[:kills]
            highscore_file = File.open("#{Dir.home}/.zsd/scores", "w")
            if highscore_list.last.split(" ").last.to_i < @prefs[:kills] && highscore_list.length == 5
              highscore_list.pop
            end
            name = prompt "New Highscore! Enter Your name: "
            highscore_list << "#{name} #{@prefs[:kills]}"
            highscore_list.sort! { |s1, s2| 
              s2.split(" ").last.to_i <=> s1.split(" ").last.to_i
            }
            highscore_file.puts highscore_list.to_yaml
            puts
            highscore_file.close
          end
        end
      end

      # defualts
      @prefs[:xp] = 15
      @prefs[:kills] = 0
      @prefs[:health] = 25

      prefs_file = File.open @prefs_file_path, 'w'
      prefs_file.puts @prefs.to_yaml
      prefs_file.close

      exit
    end

    def win
      puts "You win!!"
      prefs_file = File.open @prefs_file_path, 'w'
      prefs_file.puts @default.to_yaml + ":totalKills: " + @prefs[:totalKills].to_s + "\n:rank: " + @prefs[:rank].to_s
      prefs_file.close
    end

    def not_enough_xp
      puts
      puts "\e[33mNot enough xp...\e[39m"
      @r = 0
      @disp = false
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
      when "combo of possible death"
        if @prefs[:xp] >= 9
          @r = Random::rand(5..25)
          self.give_xp -9
        else
          self.not_enough_xp
        end
      when "combo of death"
        if @prefs[:xp] >= 12
          @r = Random::rand(12..30)
          self.give_xp -12
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
          self.damage(Random::rand(2..5) * -1)
          self.give_xp -5
        else
          self.not_enough_xp
        end
      when "not a combo"
        if @prefs[:xp] >= 20
          @r = Random::rand(25..45)
          self.give_xp -5
        else
          self.not_enough_xp
        end
      when "pain with a side of blood"
        if @prefs[:xp] >= 25
          @r = Random::rand(35..50)
          self.give_xp -25
        else
          self.not_enough_xp
        end
      else
        print "\e[33m"        
        puts "Invalid combo..."
        print "\e[1m"
        puts "No damage done!!"
        puts "\e[22;39m"

        @disp = false
        @r = 0
      end
    end

    def attack enemy, weapon = "punch"
      @disp = true # tells weather it should attack/tell the damage done
      pass = 1
      phrase = ["You smacked down the", "You hit the", "Whose your daddy", "You just powned the"].sample
      while pass != 0
      	pass = 0
	      case weapon
	      when "punch"
	        @r = Random::rand(4..7) + @prefs[:punch]
	      when "kick"
	      	@r = Random::rand(3..8) + @prefs[:kick]
	      when "combo"
	      	puts "Which combo?"
	      	c = prompt
          self.combo c
	      end
        
	    end

      if @disp # only display damage done if they attacked
        @new_game = false
        enemy.damage @r

        puts "\e[1;31m"
        puts phrase + " " + enemy.name + " -" + @r.to_s
        puts "\e[22;39m"
      end
    end

    def damage amount
      @prefs[:health] -= amount
      self.die if @prefs[:health] <= 0
    end	

    def info
      puts "\e[35m"
      @prefs.each{ |key, value|
        case key
        when :kick
          puts "Kick upgrade: #{@prefs[:kick].to_s}"
        when :punch
          puts "Punch upgrade: #{@prefs[:punch].to_s}"
        when :block
          puts "Block upgrade: #{@prefs[:block].to_s}"
        when :totalKills
          puts "Total Kills: #{@prefs[:totalKills].to_s}"
        else
          puts key.to_s + ": " + value.to_s
        end
      }
      print "\e[39m"
    end

    def pwn
    	puts
      puts "\e[31;1mKO! \e[39;22m"
      @prefs[:kills] += 1
      @prefs[:totalKills] += 1
      self.rankup if @prefs[:totalKills] % 15 == 0 # rankup every 15 kills
    end

    def comboList
      puts
      puts "\e[35mCombos:"
      i = 0
      @comboValues.each { |c, xp|
        break if i == @prefs[:rank] # break if i equals their rank
        puts "#{c} -#{xp} xp" # outputs something like:  kick punch -2 xp
        i += 1
      }
      puts "\e[39m"
    end

    def save
      prefs_file = File.open @prefs_file_path, 'w'
      prefs_file.puts @prefs.to_yaml
      prefs_file.close
      puts "\e[36mGave saved!\e[39m"
    end

    def quit
      puts "Wanna save yo game? yes or no"
      save_game = prompt
      self.save unless save_game == "no"
    	exit
    end

    def heal
      puts
      puts "\e[36mHow much health do u want? (1 xp for 1 health)"
      howMuch = prompt.to_i
      if howMuch == 0
        puts "Nothing given"
        puts "\e[39m"
      elsif howMuch <= @prefs[:xp] 
        howMuch *= -1
	      self.damage howMuch
        self.give_xp howMuch
	      puts "you have been healed +" + (howMuch * -1).to_s
	      puts "\e[39m"
	    else
	    	puts "\e[33mNOT ENOUGH XP!!! >:D\e[39m"
        puts
			end
    end

    def rankup
      @prefs[:rank] += 1
      give_xp 10
      puts "\e[35mRanked up!"
      begin
				puts "New combo unlocked: " + @combos[@prefs[:rank] - 1] 
	  	rescue
				puts "Your doing pretty good!"
	    end
      print "\e[36m"
      puts "New upgrade available!"
      self.upgrade
      print "\e[39m"
    end

    def taunt
      taunt = ["HEY ZOMBIE! UR FACE!", "DIRT BAG", "UR MOM", "POOP FACE", "GET OWNED BUDDY BOY", ":p", "EAT MY FIST", "be nice", "You stink", "YO MAMA"].sample
      
      if @prefs[:xp] >= 2
        r = Random::rand(-10..10)
        self.give_xp r
        puts
        puts "\e[31m" + taunt + " " + r.to_s + "\e[39m"
        puts
      else
        self.not_enough_xp
      end

    end

    def upgrade
      if @prefs[:block] >= 7 && @prefs[:punch] >= 7 && @prefs[:kick] >= 7
        puts "\e[33All skills are fully upgraded.\e[39m"
        return
      end
      puts "What do you want to upgrade? (kick, punch, or block)"
      skill = prompt.to_sym
      if [:kick, :punch, :block].include? skill
        if @prefs[skill] < 7
          @prefs[skill] += 1
          print "\e[36m"
          puts "successfully upgraded"
          print "\e[39m"
        else
          puts "\e[33m#{skill.to_s} is at the maximum level (7)\e[33m"
          self.upgrade
        end
      else
        print "\e[33m"
        puts "Invalid upgrade"
        print "\e[36m"
        self.upgrade
      end
    end

    def block
       health = 1 + (@prefs[:block] * 1.5).ceil
       self.give_xp 1 + @prefs[:block]
       @prefs[:health] += 1 + health
       puts "\e[36m#{@prefs[:block]} xp added and #{health} health added\e[39m"
       puts
    end

  # end of Game class
  end

  ############### ZOMBIEZ!! ###############

  class Zombie
    
    attr_accessor :is_alive

    def initialize hero
      @is_alive = true;
      @hero = hero
      self.setPower
    end

    def setPower
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
      puts "Attack strength: #{@pain[0]} to #{@pain[1]}"
      puts
      print "\e[39m"
    end
  # end Zombie class
  end

  ### MORE ZOMBIEZ! ###

  class BigZombie < Zombie
    def setPower
      @xp = 5
      @pain = [6, 8]
      @health = 15
      @name = "Big Zombie"
      @phrases = ["hit ur face", "punched the heck out of you", "beat the heck out of you", "bruised ur face"].sample
    end
  end

  class DaddyZombie < Zombie
    def setPower
      @xp = 10
      @pain = [4, 10]
      @health = 20
      @name = "Daddy Zombie"
      @phrases = ["IS your daddy", "punched the heck out of you", "beat the heck out of you", "ain't your mom", "told you to go to bed"].sample
    end
  end

  class GunZombie < Zombie
    def setPower
      @xp = 15
      @pain = [3, 15]
      @health = 20
      @name = "Gun Zombie"
      @phrases = ["shot yo face", "shot the heck out of you", "beat the heck out of you", "made you eat bullets", "showed you his ak-47"].sample
    end
  end

  class NinjaZombie < Zombie
    def setPower
      @xp = 18
      @pain = [7, 20]
      @health = 20
      @name = "Ninja Zombie"
      @phrases = ["was to ninja for you", "threw a ninja star at your face", "is a blur", "sent you flying", "has a black belt"].sample
    end
  end

  class IdiotZombie < Zombie
    def setPower
      @xp = 5
      @pain = [7, 20]
      @health = 2
      @name = "Idiot Zombie"
      @phrases = ["is an idiot but still pwn-ed u", "fell down from stupidness but somehow landed on you", "beat ur face's face", "is somehow beating you"].sample
    end
  end

  class BlindZombie < Zombie
    def setPower
      @xp = 20
      @pain = [0, 25]
      @health = 24
      @name = "Blind Zombie"
      @phrases = ["tried to hit you", "cant see ur face", "cant touch this", "cant see you but hurt you anyway"].sample
    end
  end

  class StrongZombie < Zombie
    def setPower
      @xp = 30
      @pain = [15, 21]
      @health = 30
      @name = "Strong Zombie"
      @phrases = ["destroyed you", "may have murdered you", "is strong", "is VERY strong", "works out"].sample
    end
  end

  class BasicallyDeadZombie < Zombie
    def setPower
      @xp = 2
      @pain = [50, 75]
      @health = 1
      @name = "Basically Dead Zombie"
      @phrases = ["totally pwn-ed you!", "hurt you pretty bad", "obliterated you", "probably killed you", "is not dead"].sample
    end
  end

  class SuperZombie < Zombie
    def setPower
      @xp = 37
      @pain = [35, 56]
      @health = 65
      @name = "Super Zombie"
      @phrases = ["is up up and away!", "just chucked kryptonite at ur face", "has super strength", "is the ultimate super villain", "just mad you cry"].sample
    end
  end

  class BossZombie < Zombie
    def setPower
      @xp = 65
      @pain = [60, 90]
      @health = 100
      @name = "Boss Zombie"
      @phrases = ["sent you to work!", "is not giving you a raise", "is a boss!", "just fired you", "just demoted you"].sample
    end
  end

#end Stuff module
end
