require './app/models/player.rb'
namespace :projections do

  desc "update player point projections"
  task :update_projections do
    Player.update_projections
  end
end
