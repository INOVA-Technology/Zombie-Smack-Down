require 'minitest/autorun'
require 'yaml'
require './require/colors'
require './require/player'
require './require/zombie'
require './require/combo'
require './require/other'
require 'readline'
$rpath = "."

describe Player do

	before do
		@player = Player.new
	end

	describe "new game started" do
		it "must be a new game" do 
			@player.save[:newGame].must_equal false
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
	end

end