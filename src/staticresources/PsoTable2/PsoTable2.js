window.PsoTable2 = window.PsoTable2 || {};

PsoTable2.ng = angular.module('PsoTable2', []);

PsoTable2.ng.factory('PsoTable2Endpoint', ['$q', function ($q) {
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

	return instance;
}]);

PsoTable2.ng.controller('PsoTable2', ['$scope', 'PsoTable2Endpoint', function ($scope, sfEndpoint) {
	$scope.status = {
		loading: true,
		isAllowedToRunScheduler: false,
		error: null
	};

	$scope.viewState = {
		selectedOpportunities: [],
		selectedOpportunitiesSize: 2,
		opportunitiesFilter: ''
	};

	$scope.accountClicked = function (customer, event) {
		if (event.target !== event.currentTarget) {
			/* this event came bubbling through by clicking an option */
			return;
		}

		var toggle = event.metaKey || event.ctrlKey || event.shiftKey;

		if (!toggle) {
			/* when not toggling we behave like a default option click and unselect all other options */
			$scope.clearSelectedOpportunities();
		}

		var allActive = true;

		if (toggle) {
			/* when toggling we will select all, if not all were selected or unselect all, if all were */
			for (var i = 0; i < customer.Projects.length; i++) {
				var projectId = customer.Projects[i].OpportunityId;
				var currentIndex = $scope.viewState.selectedOpportunities.indexOf(projectId);

				allActive = allActive && (currentIndex !== -1);

				if (!allActive) {
					break;
				}
			}
		}

		for (var i = 0; i < customer.Projects.length; i++) {
			var projectId = customer.Projects[i].OpportunityId;
			var currentIndex = $scope.viewState.selectedOpportunities.indexOf(projectId);

			if (currentIndex === -1) {
				/* if it's not in yet, we want to add, whether toggling or not doesn't matter */
				$scope.viewState.selectedOpportunities.push(projectId);
			} else if (toggle && allActive) {
				$scope.viewState.selectedOpportunities.splice(currentIndex, 1);
			}
		}
	};

	$scope.customerMatchesFilter = function (customer) {
		if (!$scope.viewState.opportunitiesFilter) {
			return true;
		}

		var regex = new RegExp('^.*' + $scope.viewState.opportunitiesFilter.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&") + '.*$', 'i');

		if (regex.test(customer.AccountName)) {
			return true;
		}

		for (var p = 0; p < customer.Projects.length; p++) {
			if (regex.test(customer.Projects[p].OpportunityName)) {
				return true;
			}
		}

		return false;
	};

	$scope.projectMatchesFilter = function (project) {
		if (!$scope.viewState.opportunitiesFilter) {
			return true;
		}

		var regex = new RegExp('^.*' + $scope.viewState.opportunitiesFilter.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&") + '.*$', 'i');

		if (regex.test(project.AccountName) || regex.test(project.OpportunityName)) {
			return true;
		}

		return false;
	};

	$scope.clearSelectedOpportunities = function () {
		$scope.viewState.selectedOpportunities.splice(0, $scope.viewState.selectedOpportunities.length);
	};

	$scope.selectAllOpportunities = function () {
		/* add all currently visible projects to the selection */
		for (var c = 0; c < $scope.data.Customers.length; c++) {
			for (var p = 0; p < $scope.data.Customers[c].Projects.length; p++) {
				var currentIndex = $scope.viewState.selectedOpportunities.indexOf($scope.data.Customers[c].Projects[p].OpportunityId);

				if (currentIndex === -1 && $scope.projectMatchesFilter($scope.data.Customers[c].Projects[p])) {
					$scope.viewState.selectedOpportunities.push($scope.data.Customers[c].Projects[p].OpportunityId);
				}
			}
		}
	};

	$scope.removeFilteredOpportunitiesFromSelection = function () {
		/* check all projects of all customers if they match the filter and remove from selection, if not */
		for (var c = 0; c < $scope.data.Customers.length; c++) {
			for (var p = 0; p < $scope.data.Customers[c].Projects.length; p++) {
				var currentIndex = $scope.viewState.selectedOpportunities.indexOf($scope.data.Customers[c].Projects[p].OpportunityId);

				if (currentIndex > -1 && !$scope.projectMatchesFilter($scope.data.Customers[c].Projects[p])) {
					$scope.viewState.selectedOpportunities.splice(currentIndex, 1);
				}
			}
		}
	};

	$scope.$watch('viewState.selectedOpportunities', function (newValue, oldValue) {
		var oppNames = '';
		for (var i = 0; i < newValue.length; i++) {
			if (typeof newValue[i] === 'string') {
				oppNames += ', ' + newValue[i];
			} else {
				oppNames += ', ' + newValue[i].OpportunityName;
			}
		}

		console.log('selected opps changed:', oppNames.substr(2), newValue);
	});

	sfEndpoint.getFilterOptions().then(function (data) {
		$scope.status.loading = false;
		$scope.status.isAllowedToRunScheduler = !!data.IsAllowedToRunScript;
		$scope.data = data;

		var projectAndCustomerCount = data.Customers.length;

		for (var c = 0; c < data.Customers.length; c++) {
			projectAndCustomerCount += data.Customers[c].Projects.length;

			/* normalize the projects to contain the customer info */
			for (var p = 0; p < data.Customers[c].Projects.length; p++) {
				var project = data.Customers[c].Projects[p];

				project.AccountId = data.Customers[c].AccountId;
				project.AccountName = data.Customers[c].AccountName;
			}
		}

		$scope.viewState.selectedOpportunitiesSize = Math.min(10, projectAndCustomerCount);

		console.log(data);
	}, function (response) {
		$scope.status.error = response;
	});
}]);