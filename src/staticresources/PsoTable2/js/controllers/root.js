PsoTable2.ng.controller('PsoTable2', ['$scope', '$rootScope', 'PsoTable2Endpoint', function ($scope, $rootScope, sfEndpoint) {
	$scope.status = {
		loading: true,
		isAllowedToRunScheduler: false,
		error: null
	};

	$scope.viewState = {
		startMonth: new Date(),

		selectedOpportunities: [],
		selectedOpportunitiesSize: 2,
		opportunitiesFilterText: '',

		selectedResources: [],
		selectedResourcesSize: 2,
		resourcesFilterText: ''
	};

	$scope.filter = {
		events: {},
		opportunities: {
			events: {}
		},
		resources: {
			events: {}
		}
	};

	$scope.data = {};

	$scope.filter.events.showStartMonthPickerClicked = function (event) {
		var target = $(event.target);
		var targetPosition = target.offset();

		target.datepicker('dialog', $scope.viewState.startMonth, function (dateString, datepicker) {
			/* nothing to do here, we'll not select a day, but only change the month */
		}, {
			firstDay: 1,
			showWeek: true,
			changeMonth: true,
			changeYear: true,
			showButtonPanel: true,
			minDate: -720,
			maxDate: 900,
			onChangeMonthYear: function (year, month, datepicker) {
				$scope.$apply(function () {
					$scope.filter.setStartDate(new Date(year, month - 1, 1));
				});
			}
		}, [
			targetPosition.left,
			targetPosition.top + target.height() + 5
		]);
	};

	$scope.filter.setStartDate = function (newStartDate) {
		$scope.viewState.startMonth = newStartDate;
	};

	/* functions for the opportunity filter */
	$scope.filter.opportunities.events.accountClicked = function (customer, event) {
		if (event.target !== event.currentTarget) {
			/* this event came bubbling through by clicking an option */
			return;
		}

		$scope.filter.opportunities.selectAccountOpportunities(customer, event.metaKey || event.ctrlKey || event.shiftKey);
	};

	$scope.filter.opportunities.selectAccountOpportunities = function (customer, toggle) {
		if (!toggle) {
			/* when not toggling we behave like a default option click and unselect all other options */
			$scope.filter.opportunities.clearSelectedOpportunities();
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

	$scope.filter.opportunities.customerMatchesFilter = function (customer) {
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

	$scope.filter.opportunities.projectMatchesFilter = function (project) {
		if (!$scope.viewState.opportunitiesFilterText) {
			return true;
		}

		var regex = new RegExp('^.*' + $scope.viewState.opportunitiesFilterText.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&") + '.*$', 'i');

		if (regex.test(project.AccountName) || regex.test(project.OpportunityName)) {
			return true;
		}

		return false;
	};

	$scope.filter.opportunities.clearSelectedOpportunities = function () {
		$scope.viewState.selectedOpportunities.splice(0, $scope.viewState.selectedOpportunities.length);
	};

	$scope.filter.opportunities.selectAllOpportunities = function () {
		/* add all currently visible projects to the selection */
		for (var c = 0; c < $scope.data.Customers.length; c++) {
			for (var p = 0; p < $scope.data.Customers[c].Projects.length; p++) {
				var currentIndex = $scope.viewState.selectedOpportunities.indexOf($scope.data.Customers[c].Projects[p].OpportunityId);

				if (currentIndex === -1 && $scope.filter.opportunities.projectMatchesFilter($scope.data.Customers[c].Projects[p])) {
					$scope.viewState.selectedOpportunities.push($scope.data.Customers[c].Projects[p].OpportunityId);
				}
			}
		}
	};

	$scope.filter.opportunities.removeFilteredOpportunitiesFromSelection = function () {
		/* check all projects of all customers if they match the filter and remove from selection, if not */
		for (var c = 0; c < $scope.data.Customers.length; c++) {
			for (var p = 0; p < $scope.data.Customers[c].Projects.length; p++) {
				var currentIndex = $scope.viewState.selectedOpportunities.indexOf($scope.data.Customers[c].Projects[p].OpportunityId);

				if (currentIndex > -1 && !$scope.filter.opportunities.projectMatchesFilter($scope.data.Customers[c].Projects[p])) {
					$scope.viewState.selectedOpportunities.splice(currentIndex, 1);
				}
			}
		}
	};

	$scope.filter.resources.resourceMatchesFilter = function (resource) {
		if (!$scope.viewState.resourcesFilterText) {
			return true;
		}

		var regex = new RegExp('^.*' + $scope.viewState.resourcesFilterText.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&") + '.*$', 'i');

		if (regex.test(resource.ResourceName)) {
			return true;
		}

		return false;
	};

	$scope.filter.resources.clearSelectedResources = function () {
		$scope.viewState.selectedResources.splice(0, $scope.viewState.selectedResources.length);
	};

	$scope.filter.resources.selectAllResources = function () {
		/* add all currently visible resources to the selection */
		for (var r = 0; r < $scope.data.Resources.length; r++) {
			var currentIndex = $scope.viewState.selectedResources.indexOf($scope.data.Resources[r].ContactId);

			if (currentIndex === -1 && $scope.filter.resources.resourceMatchesFilter($scope.data.Resources[r])) {
				$scope.viewState.selectedResources.push($scope.data.Resources[r].ContactId);
			}
		}
	};

	$scope.filter.resources.removeFilteredResourcesFromSelection = function () {
		/* check all resources if they match the filter and remove from selection, if not */
		for (var c = 0; c < $scope.data.Resources.length; c++) {
			var currentIndex = $scope.viewState.selectedResources.indexOf($scope.data.Resources[r].ContactId);

			if (currentIndex > -1 && !$scope.filter.resources.resourceMatchesFilter($scope.data.Resources[r])) {
				$scope.viewState.selectedResources.splice(currentIndex, 1);
			}
		}
	};

	/* functions for the staffing table */
	$scope.filter.events.updateStaffingClicked = function (event) {
		event.preventDefault();

		$scope.$broadcast('updateStaffing', $scope.viewState.selectedOpportunities, $scope.viewState.selectedResources, $scope.viewState.startMonth);
	};

	/* initialize data */
	sfEndpoint.getFilterOptions().then(function (data) {
		$scope.status.loading = false;
		$scope.status.isAllowedToRunScheduler = !!data.IsAllowedToRunScript;

		$scope.data.Customers = data.Customers;
		$scope.data.Resources = data.Resources;

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
		$scope.viewState.selectedResourcesSize = Math.min(10, data.Resources.length);

		console.log('received filter data', data);
	}, function (response) {
		$scope.status.error = response;
		console.log('error while receiving filter data', response);
	});
}]);