fOffside.controller('FOffsideController', ['$http', function($http) {

  var self = this;

  self.init = function() {
    self.showForm = true;
    self.showTable = false;
    self.showOptimiseButton = false;
  };


  self.getSquad = function() {
    $http({
      url: '/getsquad',
      method: 'GET',
      params: {fplid: self.inputId}
    }).then(function(res) {
      self.goalkeeper = res.data.squad.goalkeeper;
      self.defenders = res.data.squad.defenders;
      self.midfielders = res.data.squad.midfielders;
      self.forwards = res.data.squad.forwards;
      self.substitutes = res.data.squad.substitutes;
      self.showForm = false;
      self.showTable = true;
      console.log(res.data.playerids);
      self.playerIds = res.data.playerids;
      self.cash = res.data.cash;
      self.showOptimiseButton = true;
    });
  };

  self.optimiseSquad = function() {
    $http({
      url: '/optimiseSquad',
      method: 'GET',
      params: {squad: JSON.stringify(self.playerIds), cash: self.cash }
    }).then(function(res) {
      self.goalkeeper = res.data.squad.goalkeeper;
      self.defenders = res.data.squad.defenders;
      self.midfielders = res.data.squad.midfielders;
      self.forwards = res.data.squad.forwards;
      self.substitutes = res.data.squad.substitutes;
      self.cash = res.data.cash;
      self.showOptimiseButton = false;
    });
  };

  self.init();

}]);
