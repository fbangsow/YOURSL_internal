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

	instance.getProjectStaffing = function (projectIds, startMonth) {
		var deferred = $q.defer();

		Visualforce.remoting.Manager.invokeAction('PsoTable2Controller.getProjectStaffing', projectIds, startMonth.toUTCString(), function (result, event) {
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

	return instance;
}]);

PsoTable2.ng.controller('PsoTable2', ['$scope', '$rootScope', 'PsoTable2Endpoint', function ($scope, $rootScope, sfEndpoint) {
	$scope.status = {
		loading: true,
		isAllowedToRunScheduler: false,
		error: null
	};

	$scope.viewState = {
		selectedOpportunities: [],
		selectedOpportunitiesSize: 2,
		opportunitiesFilterText: ''
	};

	$scope.opportunitiesFilter = {
		events: {},
		filters: {}
	};

	/* functions for the opportunity filter */
	$scope.opportunitiesFilter.events.accountClicked = function (customer, event) {
		if (event.target !== event.currentTarget) {
			/* this event came bubbling through by clicking an option */
			return;
		}

		$scope.opportunitiesFilter.selectAccountOpportunities(customer, event.metaKey || event.ctrlKey || event.shiftKey);
	};

	$scope.opportunitiesFilter.selectAccountOpportunities = function (customer, toggle) {
		if (!toggle) {
			/* when not toggling we behave like a default option click and unselect all other options */
			$scope.opportunitiesFilter.clearSelectedOpportunities();
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

	$scope.opportunitiesFilter.customerMatchesFilter = function (customer) {
		if (!$scope.viewState.opportunitiesFilterText) {
			return true;
		}

		var regex = new RegExp('^.*' + $scope.viewState.opportunitiesFilterText.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&") + '.*$', 'i');

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

	$scope.opportunitiesFilter.projectMatchesFilter = function (project) {
		if (!$scope.viewState.opportunitiesFilterText) {
			return true;
		}

		var regex = new RegExp('^.*' + $scope.viewState.opportunitiesFilterText.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&") + '.*$', 'i');

		if (regex.test(project.AccountName) || regex.test(project.OpportunityName)) {
			return true;
		}

		return false;
	};

	$scope.opportunitiesFilter.clearSelectedOpportunities = function () {
		$scope.viewState.selectedOpportunities.splice(0, $scope.viewState.selectedOpportunities.length);
	};

	$scope.opportunitiesFilter.selectAllOpportunities = function () {
		/* add all currently visible projects to the selection */
		for (var c = 0; c < $scope.opportunitiesFilter.Customers.length; c++) {
			for (var p = 0; p < $scope.opportunitiesFilter.Customers[c].Projects.length; p++) {
				var currentIndex = $scope.viewState.selectedOpportunities.indexOf($scope.opportunitiesFilter.Customers[c].Projects[p].OpportunityId);

				if (currentIndex === -1 && $scope.opportunitiesFilter.projectMatchesFilter($scope.opportunitiesFilter.Customers[c].Projects[p])) {
					$scope.viewState.selectedOpportunities.push($scope.opportunitiesFilter.Customers[c].Projects[p].OpportunityId);
				}
			}
		}
	};

	$scope.opportunitiesFilter.removeFilteredOpportunitiesFromSelection = function () {
		/* check all projects of all customers if they match the filter and remove from selection, if not */
		for (var c = 0; c < $scope.opportunitiesFilter.Customers.length; c++) {
			for (var p = 0; p < $scope.opportunitiesFilter.Customers[c].Projects.length; p++) {
				var currentIndex = $scope.viewState.selectedOpportunities.indexOf($scope.opportunitiesFilter.Customers[c].Projects[p].OpportunityId);

				if (currentIndex > -1 && !$scope.opportunitiesFilter.projectMatchesFilter($scope.opportunitiesFilter.Customers[c].Projects[p])) {
					$scope.viewState.selectedOpportunities.splice(currentIndex, 1);
				}
			}
		}
	};

	/* functions for the staffing table */
	$scope.opportunitiesFilter.events.updateStaffingClicked = function (event) {
		event.preventDefault();

		if (!$scope.viewState.selectedOpportunities.length) {
			$scope.opportunitiesFilter.selectAllOpportunities();
		}

		$scope.$broadcast('updateStaffing', $scope.viewState.selectedOpportunities);
	};

	/* initialize data */
	sfEndpoint.getFilterOptions().then(function (data) {
		$scope.status.loading = false;
		$scope.status.isAllowedToRunScheduler = !!data.IsAllowedToRunScript;
		$scope.opportunitiesFilter.Customers = data.Customers;

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
		console.log(response);
	});
}]);

PsoTable2.ng.controller('PsoTable2Staffing', ['$scope', 'PsoTable2Endpoint', 'jQuery.ui.datepicker', function ($scope, sfEndpoint, datepicker) {
	console.log('init staffing controller');

	$scope.status = {
		loaded: false,
		loading: false
	};

	$scope.viewState = {
		staffingColumns: 0,
		staticStaffingColumns: 0,
		staffingDayColumns: 0,
		staffingMonths: [],
		staffingWeeks: [],
		staffingDays: []
	};

	$scope.staffing = {};

	/* functions for the staffing table */
	$scope.$on('updateStaffing', function (event, selectedOpportunities) {
		$scope.status.loading = true;
		$scope.status.loaded = false;

		sfEndpoint.getProjectStaffing(selectedOpportunities, new Date()).then(function (data) {
			console.log(data);

			var startDate = new Date(data.StartDate);
			var endDate = new Date(data.EndDate);

			$scope.viewState.staffingMonths.splice(0, $scope.viewState.staffingMonths.length);
			$scope.viewState.staffingWeeks.splice(0, $scope.viewState.staffingWeeks.length);
			$scope.viewState.staffingDays.splice(0, $scope.viewState.staffingDays.length);

			var lastMonth = null;
			var lastWeek = null;
			var dayCount = 0;

			/* iterate all days and build an array with all months, weeks and days to be able to build the html table */
			for (var currentDate = startDate; currentDate < endDate; currentDate.setDate(currentDate.getDate() + 1)) {
				dayCount++;

				var dateInfo = {
					date: new Date(currentDate.valueOf()),
					day: currentDate.getDate(),
					isWeekEnd: !(currentDate.getDay() % 6)
					weekDay: datepicker.formatDate('D', currentDate),
					week: datepicker.iso8601Week(currentDate),
					month: datepicker.formatDate('M', currentDate),
					dateString: datepicker.formatDate('yy-mm-dd', currentDate)
				};

				if (!lastMonth || lastMonth.caption !== dateInfo.month) {
					lastMonth = {
						caption: dateInfo.month,
						weeks: [],
						weekCount: 0,
						dayCount: 0
					};

					lastWeek = null;

					$scope.viewState.staffingMonths.push(lastMonth);
				}

				if (!lastWeek || lastWeek.number !== dateInfo.week) {
					lastWeek = {
						number: dateInfo.week,
						days: [],
						dayCount: 0
					};

					lastMonth.weeks.push(lastWeek);
					lastMonth.weekCount++;

					$scope.viewState.staffingWeeks.push(lastWeek);
				}

				lastWeek.days.push(dateInfo);
				lastMonth.dayCount++;
				lastWeek.dayCount++;

				$scope.viewState.staffingDays.push(dateInfo);
			}

			for (var c = 0; c < data.Customers.length; c++) {
				var customer = data.Customers[c];
				for (var p = 0; p < customer.Projects.length; p++) {
					var project = customer.Projects[p];
					for (var r = 0; r < project.Resources.length; r++) {
						var resource = project.Resources[r];

						resource.StaffingByDay = {};

						for (var s = 0; s < resource.Staffing.length; s++) {
							var staffing = resource.Staffing[s];
							resource.StaffingByDay[staffing.Day] = staffing;
						}
					}
				}
			}

			$scope.staffing.Customers = data.Customers;

			$scope.viewState.staffingDayColumns = dayCount;
			$scope.viewState.staffingColumns = $scope.viewState.staticStaffingColumns + dayCount;

			$scope.status.loading = false;
			$scope.status.loaded = true;
		}, function (response) {
			$scope.status.error = response;
			console.log(response);
		});
	});
}]);