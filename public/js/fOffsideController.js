fOffside.controller('FOffsideController', ['$http', function($http) {

  var self = this;

  self.init = function() {
    self.showForm = true;
    self.displayingCurrentSquad = false;
    self.displayingOptimisedSquad = false;
  };


  self.getSquad = function() {
    $http({
      url: '/getsquad',
      method: 'GET',
      params: {fplid: self.inputId}
    }).then(function(res) {
      self.showForm = false;
      self.displayingCurrentSquad = true;
      self.parsePlayers(res.data);
      self.playerIds = res.data.playerids;
      self.cash = res.data.cash;
    });
  };

  self.optimiseSquad = function() {
    $http({
      url: '/optimiseSquad',
      method: 'GET',
      params: {squad: JSON.stringify(self.playerIds), cash: self.cash }
    }).then(function(res) {
      self.displayingCurrentSquad = false;
      self.displayingOptimisedSquad = true;
      self.parsePlayers(res.data);
    });
  };

  self.parsePlayers = function(data) {
    self.goalkeeper = data.squad.goalkeeper;
    self.defenders = data.squad.defenders;
    self.midfielders = data.squad.midfielders;
    self.forwards = data.squad.forwards;
    self.substitutes = data.squad.substitutes;
  };

  self.init();

}]);
