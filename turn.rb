class Turn
  attr_reader :sum, :dead
  def initialize(sidesOnDie = 6)
    @d = sidesOnDie
    reset
  end

  def reset
    @sum = 0
    @dead = false
  end

  def do_roll
    if @dead
      return 0
    end
    # `rand(@d)` giver et heltal fra 0-5, vi lægger én til for at få det fra 1-6:
    roll = rand(@d) + 1
    if roll == 1 then
      @dead = true
      @sum = 0
    else
      @sum += roll
    end
    return roll
  end
end
