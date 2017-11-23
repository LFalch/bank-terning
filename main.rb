#!/usr/bin/env ruby

require 'gosu'
require_relative "turn"
require_relative "bot"

class GameWindow < Gosu::Window
  attr_reader :font
  def initialize
    super(1200, 900, false)
    @font = Gosu::Font.new(self, Gosu.default_font_name, 32)
    @dices = []
    1.upto(6) do |i|
      @dices << Gosu::Image.new("res/dice#{i}.png")
    end
    @rolls = []
    @playerBank = 0
    @botBank = 0
    @playerTurn = true
    @lastRoll = 0
    @curTurn = Turn.new
    @botTurnTimer = 120
    @lastEvent = ""
    @bot = RubberBandBot.new

    @winner = nil
  end

  def needs_cursor?
    true
  end

  def endTurn
    @rolls = []
    @lastEvent = "#{curName} ended their turn"
    if @lastRoll == 1
      @lastEvent += " because of a 1-roll"
    end
    if @playerTurn
      @playerBank += @curTurn.sum
      @bot.newTurn(@botBank, @playerBank)
    else
      @botBank += @curTurn.sum
    end
    @curTurn.reset
    @playerTurn = !@playerTurn
  end

  def update
    if @curTurn.dead
      endTurn
    end

    if @botBank >= 100
      @winner = "Bot"
      @playerTurn = false
      return
    elsif @playerBank >= 100
      @winner = "Player"
      return
    end

    # Bot logik:
    if !@playerTurn
      if @botTurnTimer <= 0
        if @bot.makeTurn
          roll
        else
          endTurn
        end
        @botTurnTimer = 120
      else
        @botTurnTimer -= 1
      end
    end
  end

  def draw
    @font.draw("Player bank: #{@playerBank}", 600, 20, 0)
    @font.draw("Bot's  bank: #{@botBank}", 600, 50, 0)

    if @winner != nil
      @font.draw("#{@winner} has won!", 500, 450, 0)
      return
    end

    @font.draw("#{curName}'s turn.", 20, 20, 0)
    @font.draw("Current sum: #{@curTurn.sum}", 20, 50, 0)
    @font.draw("Last roll  : #{@lastRoll}", 20, 80, 0)
    @font.draw(@lastEvent, 100, 600, 0)
    @rolls.each_index {|i|
      @dices[@rolls[i]-1].draw(20+64*i, 128, 0)
    }
  end

  def curName
    @playerTurn ? "Player" : "Bot"
  end

  def roll
    @lastRoll = @curTurn.do_roll
    @rolls << @lastRoll
    @lastEvent = "#{curName} rolled a #{@lastRoll}"
    if !@playerTurn
      @bot.addRoll(@lastRoll)
    end
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
    if @playerTurn
      if id == Gosu::KbR
        roll
      end
      if id == Gosu::KbE
        endTurn
      end
    end
  end
end

GameWindow.new.show
