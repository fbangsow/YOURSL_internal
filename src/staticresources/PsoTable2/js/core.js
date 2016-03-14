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

PsoTable2.ng.factory('PsoTable2Endpoint', ['$q', '$timeout', 'cometd', 'alert', function ($q, $timeout, cometd, alert) {
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

			if (!result || !result.IsSuccess) {
				if (result && !result.message) {
					result.message = result.ErrorMessage;

					if (/INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY/i.test(result.message)) {
						result.message = 'You don\'t have proper access to this opportunity. Please ask your management for help.';
					}
				}

				deferred.reject(result);
				return;
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
	var metaListeners = [];

	var shutDown = function () {
		if (cometd.isDisconnected()) {
			return;
		}

		console.log('shut down cometd connection');

		/* shutdown connection */
		if (broadcastListeners.length) {
			broadcastListeners.forEach(function (subscription) {
				if (subscription.subscription) {
					try {
						cometd.unsubscribe(subscription.subscription);
					} catch (e) {
						console.error('failed unsubscribing topic listener', e);
					}

					subscription.subscription = null;
				}
			});
		}

		if (metaListeners.length) {
			metaListeners.forEach(function (subscription) {
				try {
					cometd.removeListener(subscription);
				} catch (e) {
					console.error('failed removing topic listener', e);
				}
			});

			metaListeners = [];
		}

		try {
			cometd.disconnect(true);
		} catch (e) {
			console.error('failed disconnecting from the topic streaming server', e);
		}
	};

	var initialize = function () {
		shutDown();

		var timers = {
			'running': {},
			'start': function (timer, callback, timeout) {
				if (timers.running[timer]) {
					return;
				}

				timers.running[timer] = $timeout(callback, timeout);
				timers.running[timer].then(function () {
					delete timers.running[timer];
				}, function () {
					delete timers.running[timer];
				});
			},
			'cancel': function (timer) {
				if (!timer) {
					for (var timer in timers.running) {
						if (timers.running.hasOwnProperty(timer)) {
							timers.cancel(timer);
						}
					}
					return;
				}

				if (timers.running[timer]) {
					$timeout.cancel(timers.running[timer]);
					delete timers.running[timer];
				}
			}
		};

		console.log('initialize cometd connection');

		try {
			cometd.init({
				'url': '/cometd/29.0/',
				'logLevel': 'info',
				'appendMessageTypeToURL': false,
				'requestHeaders': {
					'Authorization': 'OAuth ' + broadcastSessionId
				}
			});
		} catch (e) {
			console.error('failed initialize topic listener', e);
		}

		var successMessageSent = false;
		metaListeners.push(cometd.addListener('/meta/connect', function (connectInfo) {
			if (connectInfo.successful) {
				if (!successMessageSent) {
					console.log('cometd connect successful');
					successMessageSent = true;
				}

				timers.cancel();
				return;
			}

			var advice = connectInfo.advice;

			console.log('cometd connect failure', connectInfo, advice);

			timers.start('warn', function () {
				alert('Resource availability is not being synced with latest changes automatically any more. Please refresh the page to get the latest data.');
			}, 3000);

			if (advice && advice.reconnect && advice.reconnect !== 'none') {
				timers.start('reinit', initialize, advice.timeout || 250);
			}
		}));

		if (broadcastListeners.length) {
			broadcastListeners.forEach(function (subscription) {
				if (!subscription.subscription) {
					try {
						subscription.subscription = cometd.subscribe(subscription.channel, subscription.listener);
					} catch (e) {
						console.error('failed subscribing to topic channel ' + subscription.channel, e);
					}
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

		var subscription = null;

		if (broadcastSessionId) {
			subscription = cometd.subscribe('/topic/ResourceChanges', listener);
		}

		broadcastListeners.push({
			'subscription': subscription,
			'listener': listener,
			'channel': '/topic/ResourceChanges'
		});

		return subscription;
	};

	instance.isBroadcastConnected = function () {
		return ['connected', 'connecting'].indexOf(cometd.getStatus()) > -1;
	};

	return instance;
}]);

PsoTable2.ng.factory('alert', ['$rootScope', '$q', function ($rootScope, $q) {
	return function (message) {
		var deferred = $q.defer();

		$rootScope.$emit('alertMessage', message, {
			buttons: {
				'OK': function () {
					deferred.resolve('OK');
				}
			}
		});

		return deferred.promise;
	};
}]);

PsoTable2.ng.factory('confirm', ['$rootScope', '$q', function($rootScope, $q) {
	var makeButtonFunction = function (caption, resolveOrReject, promise) {
		var resolveMethod = resolveOrReject ? 'resolve' : 'reject';
		var resolveArgument = caption;

		return function () {
			promise[resolveMethod](resolveArgument);
		}
	};

	return function (message, buttons) {
		var deferred = $q.defer();

		if (!buttons) {
			buttons = {
				'Confirm': function () {
					deferred.resolve('Confirm');
				},
				'Cancel': function () {
					deferred.reject('Cancel');
				}
			};
		} else {
			for (b in buttons) {
				if (buttons.hasOwnProperty(b) && typeof buttons[b] !== 'function') {
					buttons[b] = makeButtonFunction(b, buttons[b], deferred);
				}
			}
		}

		$rootScope.$emit('alertMessage', message, {
			buttons: buttons
		});

		return deferred.promise;
	};
}]);

PsoTable2.ng.directive('alertDialog', ['$rootScope', function ($rootScope) {
	var makeDialogButtonFunction = function (callback) {
		var doCallback = callback;

		return function () {
			$( this ).dialog('close');

			if (typeof doCallback === 'function') {
				doCallback();
			}
		}
	};

	return {
		restrict: 'C',
		link: function (scope, el, attributes) {
			var defaultDialogOptions = {
				buttons: {
					OK: true
				}
			};

			var mandatoryOptions = {
				autoOpen: false,
				resizable: false,
				modal: true
			};

			$rootScope.$on('alertMessage', function (event, message, dialogOptions) {
				scope.alertMessage = message;

				dialogOptions = dialogOptions || {};

				var finalOptions = $.extend({}, defaultDialogOptions, dialogOptions, mandatoryOptions);

				if (finalOptions.buttons) {
					for (b in finalOptions.buttons) {
						if (finalOptions.buttons.hasOwnProperty(b)) {
							finalOptions.buttons[b] = makeDialogButtonFunction(finalOptions.buttons[b]);
						}
					}
				}

				el.dialog(finalOptions);
				el.dialog('open');
			});

			/* initialize once to update the html */
			el.dialog({
				autoOpen: false,
				resizable: false,
				modal: true
			});
		}
	};
}]);