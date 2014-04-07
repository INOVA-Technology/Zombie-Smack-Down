#!/usr/bin/env ruby

require 'minitest/autorun'
$rpath = "."
require './require/other'

def exit
	"exited"
end

describe Player do

	before do
		@player = Player.new
	end

	describe "new game started" do
		it "must be a new game" do 
			@player.save[:newGame].must_equal false
		end
	end

	describe "player is killed" do
		before do
			def prompt
				"test"
			end
		end

		it "must die" do
			@player.save[:health] = 0
			@player.checkDead.must_equal "exited"
		end

		# it "must reset game" do
			
		# end

		# it "must save score if score is a highscore" do

		# end

		# it "wont save score if score isnt a highscore" do

		# end
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

end
