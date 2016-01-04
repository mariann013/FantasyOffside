module ApplicationHelper

  def self.getPlayerIn(squadArray, playerOut)

    numToSkip = rand(Player.count)
    playerIn = Player.offset(numToSkip).first
    while ((squadArray.include? playerIn.id) || (playerIn.position != playerOut.position))
      numToSkip = rand(Player.count)
      playerIn = Player.offset(numToSkip).first
    end

    return playerIn

  end
end
