fOffside.controller('FOffsideController', ['$http', function($http) {

  var self = this;

  self.init = function() {
    self.showForm = true;
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
    });
  };

  self.init();

}]);
