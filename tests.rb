#!/usr/bin/env ruby

require 'minitest/autorun'
$rpath = "."
require './require/other'

def exit *args
	"exited"
end

describe Player do

	before do
		@player = Player.new
	end

	describe "new game started" do
		it "must not longer be a new game" do 
			@player.save[:newGame].must_equal false
		end
	end

	describe "player is killed" do
		before do
			def @player.prompt *args
				"test"
			end
		end

		it "must die" do
			@player.save[:health] = 0
			@player.checkDead.must_equal "exited"
		end

		it "must reset game" do
			expected = { :health => 25,
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
			@player.save[:health] = 14
			@player.die
			YAML.load_file("#{$rpath}/require/player.yml").must_equal expected
		end

		it "must save score if score is a highscore" do
			scores_file = "#{$rpath}/scores.yml"
			backup = YAML.load_file(scores_file)
			@player.save[:zombiesKilled] = backup.last[0] + 1
			@player.saveScore
			YAML.load_file(scores_file).must_equal(
				[[33, "Addison"], [32, "Chase"], [1, "test"],
				[0, "nobody"], [0, "nobody"]])
			File.open(scores_file, "w") { |file| 
				YAML.dump(backup, file)
			}
			# if this test fails, the scores.yml file will have to be reset
		end

		it "wont save score if score isnt a highscore" do
			scores_file = "#{$rpath}/scores.yml"
			backup = YAML.load_file(scores_file)
			@player.save[:zombiesKilled] = backup.last[0] - 1
			@player.saveScore
			YAML.load_file(scores_file).must_equal backup
			# if this test fails, the scores.yml file will have to be reset
		end
	end

end

describe Cli do

	before do
		@cli = Cli.new
		@cli.spawn_zombie
	end

	describe "kick" do
		it "must damage zombie" do
			health = @cli.zombie.health
			@cli.kick
			@cli.zombie.health.must_be :<, health
		end

		it "must have zombie attack player" do
			health = @cli.player.save[:health]
			@cli.kick
			@cli.player.save[:health].must_be :<, health
		end
	end

	describe "punch" do
		it "must damage zombie" do
			health = @cli.zombie.health
			@cli.punch
			@cli.zombie.health.must_be :<, health
		end

		it "must have zombie attack player" do
			health = @cli.player.save[:health]
			@cli.punch
			@cli.player.save[:health].must_be :<, health
		end
	end

	describe "combo" do
		before do
			def @cli.prompt *args
				"kick punch"
			end
		end

		it "must damage zombie" do
			health = @cli.zombie.health
			@cli.combo
			@cli.zombie.health.must_be :<, health
		end

		it "must have zombie attack player" do
			health = @cli.player.save[:health]
			@cli.combo
			@cli.player.save[:health].must_be :<, health
		end

		it "requires correct amount of xp" do
			z_health = @cli.zombie.health
			p_health = @cli.player.save[:health]
			@cli.player.save[:xp] = 1
			@cli.player.save[:xp].must_equal 1
			z_health.must_equal @cli.zombie.health
			p_health.must_equal @cli.player.save[:health]
		end
	end

	describe "combolist" do
		it "must list correct amount or combos" do
			@cli.player.save[:rank] = 3

			expected = capture_io do
				puts ["Unlocked Combos:",
					"Kick Punch: -2 xp",
					"Trip Stomp: -3 xp",
					"Punch Punch Kick: -4 xp"].map(&:magenta).join("\n")
			end

			message = capture_io do
				@cli.combolist
			end
			assert_equal expected, message
		end
	end

	describe "taunt" do
		it "must require correct amount of xp" do

			expected_xp = @cli.player.save[:xp] = 1
			@cli.taunt
			@cli.player.save[:xp].must_equal expected_xp
			# check io
		end

		it "wont work if no taunts are left" do
			expected_xp = @cli.player.save[:xp]
			@cli.player.save[:tauntsAvailable] = 0
			@cli.taunt
			@cli.player.save[:xp].must_equal expected_xp
			# check io
		end
	end

	describe "info" do
		it "must print correct player info" do
			new_save = { :health => 48,
						 :xp => 27,
						 :rank => 2,
						 :wave => 2,
						 :zombiesKilled => 6,
						 :totalKills => 37,
						 :kickUpgrade => 4,
						 :punchUpgrade => 3,
						 :tauntsAvailable => 2 }
			@cli.player.save.merge! new_save

			actual = capture_io do
				@cli.player.info
			end

			expected = capture_io do
				puts "Health: 48".magenta
				puts "XP: 27".magenta
				puts "Rank: 2".magenta
				puts "Wave: 2".magenta
				puts "Zombies Killed: 6".magenta
				puts "Total Kills: 37".magenta
				puts "Kick Upgrade: 4".magenta
				puts "Punch Upgrade: 3".magenta
				puts "Taunts Available: 2".magenta
			end
			assert_equal expected, actual
		end

		it "must print correct zombie info" do
			@cli.zombie = DaddyZombie.new
			@cli.zombie.health = 2
			actual = capture_io do
				@cli.zombie.info
			end

			expected = capture_io do
				puts "Daddy Zombie health: 2".magenta
				puts "Attack Strength: 4 to 10".magenta
			end
			assert_equal expected, actual
		end
	end

end
