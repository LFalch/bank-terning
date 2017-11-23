class Bot
  def initialize(bank=0, otherBank=0)
    newTurn(bank, otherBank)
  end

  def newTurn(bank, otherBank)
    @rolls = []
    @sum = 0
    @otherBank = otherBank
    @bank = bank
  end

  def addRoll(roll)
    @rolls << roll
    @sum += roll
  end

  def makeTurn
    return true
  end
end

class TenBot < Bot
  def initialize(maxSum=10)
    super
    @max = maxSum
  end

  def makeTurn
    if @sum + @bank < 100 and @sum < 10
      return true
    else
      return false
    end
  end
end

class FourTurnBot < Bot
  def makeTurn
    if @sum + @bank < 100 and @rolls.length < 4
      return true
    else
      return false
    end
  end
end

class RubberBandBot < Bot
  def makeTurn
    if @rolls.length >= 5
      return false
    end
    @sum + @bank < [100, @otherBank].min or @rolls.length < 3
  end
end
