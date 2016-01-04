module ApplicationHelper

  def self.getPlayerIn(squadArray)

    numToSkip = rand(Player.count)
    playerIn = Player.offset(numToSkip).first
    while (squadArray.include? playerIn.id)
      numToSkip = rand(Player.count)
      playerIn = Player.offset(numToSkip).first
    end

    return playerIn
    
  end
end
