window.PsoTable2 = window.PsoTable2 || {};

PsoTable2.ng = angular.module('PsoTable2', []);

PsoTable2.ng.factory('jQuery.ui.datepicker', function () {
	return $.datepicker;
});

PsoTable2.ng.factory('PsoTable2Endpoint', ['$q', function ($q) {
	console.log('init endpoint');

	var instance = {};

	/* check the remote endpoint */
	if (typeof PsoTable2Controller !== 'object') {
		throw 'Remote endpoint PsoTable2Controller is not initialized';
	}

	var expectedFunctions = ['getFilterOptions'];

	for (var i = 0; i < expectedFunctions.length; i++) {
		var funcName = expectedFunctions[i];
		if (typeof PsoTable2Controller[funcName] !== 'function') {
			throw 'Remote endpoint PsoTable2Controller does not provide the function ' + funcName;
		}
	}

	/* provide some helper functions */
	var htmlDecode = function (value) {
		if (value && typeof value === 'string') {
			return $('<div />').html(value).text();
		}

		return '';
	};

	/* initialize remote functions */
	instance.getFilterOptions = function () {
		var deferred = $q.defer();

		Visualforce.remoting.Manager.invokeAction('PsoTable2Controller.getFilterOptions', function (result, event) {
			if (!event || !event.status) {
				deferred.reject(event);
				return
			}

			result = JSON.parse(htmlDecode(result));
			deferred.resolve(result);
		}, {
			buffer: true,
			escape: true,
			timeout: 30000
		});

		return deferred.promise;
	}

	instance.getProjectStaffing = function (projectIds, resourceIds, startMonth) {
		var deferred = $q.defer();

		if (!projectIds.length) {
			projectIds = ['__none'];
		}

		if (!resourceIds.length) {
			resourceIds = ['__none'];
		}

		Visualforce.remoting.Manager.invokeAction('PsoTable2Controller.getProjectStaffing', projectIds, resourceIds, startMonth.toUTCString(), function (result, event) {
			if (!event || !event.status) {
				deferred.reject(event);
				return
			}

			result = JSON.parse(htmlDecode(result));
			deferred.resolve(result);
		}, {
			buffer: true,
			escape: true,
			timeout: 30000
		});

		return deferred.promise;
	};

	instance.updateAllocation = function (allocationId, day, hours) {
		var deferred = $q.defer();

		Visualforce.remoting.Manager.invokeAction('PsoTable2Controller.updateAllocation', allocationId, day.toUTCString(), hours, function (result, event) {
			if (!event || !event.status) {
				deferred.reject(event);
				return
			}

			deferred.resolve(result.ReturnedResult);
		}, {
			buffer: true,
			escape: true,
			timeout: 30000
		});

		return deferred.promise;
	};

	return instance;
}]);

PsoTable2.ng.factory('alert', ['$rootScope', function ($rootScope) {
	return function (message) {
		//alert(message);
		$rootScope.$emit('alertMessage', message);
	};
}]);

PsoTable2.ng.directive('alertDialog', ['$rootScope', function ($rootScope) {
	return {
		restrict: 'C',
		link: function (scope, el, attributes) {
			el.dialog({
				autoOpen: false,
				resizable: false,
				modal: true,
				buttons: {
					OK: function() {
						$( this ).dialog( "close" );
					}
				}
			});

			$rootScope.$on('alertMessage', function (event, message) {
				scope.alertMessage = message;
				el.dialog('open');
			});
		}
	};
}]);