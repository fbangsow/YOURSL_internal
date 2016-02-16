window.PsoTable2 = window.PsoTable2 || {};

PsoTable2.ng = angular.module('PsoTable2', []);

PsoTable2.ng.factory('datepicker', function () {
	return $.datepicker;
});

PsoTable2.ng.factory('clientCache', ['$window', function ($window) {
	if (!$window.sessionStorage) {
		alert('Your browser does not support sessionStorage. Unable to store the selected filter in the session.');
	}

	return $window.sessionStorage;
}]);

PsoTable2.ng.factory('cometd', function () {
	return $.cometd;
});

PsoTable2.ng.factory('PsoTable2Endpoint', ['$q', 'cometd', 'alert', function ($q, cometd, alert) {
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
	instance.getFilterOptions = function (startMonth) {
		var deferred = $q.defer();

		Visualforce.remoting.Manager.invokeAction('PsoTable2Controller.getFilterOptions', startMonth.toUTCString(), function (result, event) {
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

	instance.getProjectHealthReasons = function () {
		var deferred = $q.defer();

		Visualforce.remoting.Manager.invokeAction('PsoTable2Controller.getProjectHealthReasons', function (result, event) {
			if (!event || !event.status) {
				deferred.reject(event);
				return
			}

			result = JSON.parse(htmlDecode(result));

			if (!result || !result.ReasonsLabelToValue) {
				deferred.reject(event);
			}

			deferred.resolve(result.ReasonsLabelToValue);
		}, {
			buffer: true,
			escape: true,
			timeout: 30000
		});

		return deferred.promise;
	};

	instance.updateProjectStatus = function (projectId, status) {
		var deferred = $q.defer();

		Visualforce.remoting.Manager.invokeAction('PsoTable2Controller.updateProjectStatus', projectId, status, function (result, event) {
			if (!event || !event.status) {
				deferred.reject(event);
				return
			}

			deferred.resolve();
		}, {
			buffer: true,
			escape: true,
			timeout: 30000
		});

		return deferred.promise;
	};

	instance.prepareSchedulerRun = function (date) {
		var deferred = $q.defer();

		Visualforce.remoting.Manager.invokeAction('PsoTable2Controller.prepareSchedulerRun', date.toUTCString(), function (result, event) {
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

	instance.runScheduler = function (date) {
		var deferred = $q.defer();

		Visualforce.remoting.Manager.invokeAction('PsoTable2Controller.runScheduler', date.toUTCString(), function (result, event) {
			if (!event || !event.status) {
				deferred.reject(event);
				return
			}

			deferred.resolve();
		}, {
			buffer: true,
			escape: true,
			timeout: 30000
		});

		return deferred.promise;
	};

	var broadcastSessionId = null;
	var broadcastListeners = [];
	var metaListener = null;

	var initialize = function () {
		if (metaListener) {
			cometd.removeListener(metaListener);
			metaListener = null;
		}

		if (broadcastListeners.length) {
			broadcastListeners.forEach(function (subscription) {
				if (subscription.subscription) {
					cometd.unsubscribe(subscription.subscription);
					subscription.subscription = null;
				}
			});
		}

		console.log('initialize cometd connection');

		cometd.init({
			'url': '/cometd/29.0/',
			'appendMessageTypeToURL': false,
			'requestHeaders': {
				'Authorization': 'OAuth ' + broadcastSessionId
			}
		});

		metaListener = cometd.addListener('/meta/unsuccessful', function (failureInfo) {
			console.log('cometd connection failure', failureInfo);
			alert('Resource availability is not being synced with latest changes automatically any more. Please refresh the page to get the latest data.');
		});

		if (broadcastListeners.length) {
			broadcastListeners.forEach(function (subscription) {
				if (!subscription.subscription) {
					subscription.subscription = cometd.uubscribe(subscription.listener);
				}
			});
		}
	};

	instance.initializeBroadcastSession = function (sessionId) {
		broadcastSessionId = sessionId;
		initialize();
	};

	instance.onResourceChange = function (listener) {
		if (typeof listener !== 'function') {
			return;
		}

		if (!broadcastSessionId) {
			return;
		}

		var subscription = null;

		if (broadcastSessionId) {
			subscription = cometd.subscribe('/topic/ResourceChanges', listener);
		}

		broadcastListeners.push({
			'subscription': subscription,
			'listener': listener
		});

		return subscription;
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