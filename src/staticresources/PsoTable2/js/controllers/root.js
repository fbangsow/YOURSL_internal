PsoTable2.ng.controller('PsoTable2', ['$location', '$window', '$scope', '$rootScope', 'alert', 'PsoTable2Endpoint', function ($location, $window, $scope, $rootScope, alert, sfEndpoint) {
	$scope.status = {
		loading: true,
		error: null,
		updatingLocation: false,
		updatingViewState: false
	};

	$scope.sfEndpoint = sfEndpoint;

	$scope.defaultFilter = {
		startMonth: new Date(),

		selectedOpportunities: [],
		selectRelatedOpportunities: false,
		opportunitiesFilterText: '',

		selectedResources: [],
		selectRelatedResources: true,
		resourcesFilterText: ''
	};

	$scope.viewState = $.extend({}, $scope.defaultFilter, {
		today: new Date(),
		minStartMonth: new Date(),
		maxStartMonth: new Date(),

		filterVisible: false,
		isAllowedToRunScheduler: false
	});

	var initializeViewStateFromLocation = function (forceFilterUpdate) {
		//console.log('initializeViewStateFromLocation');

		var arraysEqual = function (a1, a2) {
			if (!a1 || !a2) {
				return false;
			}

			var a1length = a1.length;

			if (a1length !== a2.length) {
				return false;
			}

			for (var i = a1length - 1; i >= 0; --i) {
				if (a2.indexOf(a1[i]) === -1) {
					return false;
				}
			}

			return true;
		};

		var currentSearch = $location.search();

		var hasLocationFilter = false;
		var hasChanges = false;

		var newFilter = $.extend({}, $scope.defaultFilter);

		if (currentSearch.d) {
			hasLocationFilter = true;
			newFilter.startMonth = new Date(currentSearch.d);
		}

		if (currentSearch.o && !currentSearch.sro) {
			hasLocationFilter = true;
			newFilter.selectedOpportunities = currentSearch.o.split(',');
		}

		if (currentSearch.r && !currentSearch.srr) {
			hasLocationFilter = true;
			newFilter.selectedResources = currentSearch.r.split(',');
		}

		if (currentSearch.of) {
			hasLocationFilter = true;
			newFilter.opportunitiesFilterText = currentSearch.of;
		}

		if (currentSearch.rf) {
			hasLocationFilter = true;
			newFilter.resourcesFilterText = currentSearch.rf;
		}

		if (currentSearch.sro) {
			hasLocationFilter = true;
			newFilter.selectRelatedOpportunities = true;
			newFilter.selectedOpportunities = [];
		}

		if (currentSearch.srr) {
			hasLocationFilter = true;
			newFilter.selectRelatedResources = true;
			newFilter.selectedResources = [];
		}

		var oldDate = $scope.viewState.startMonth;

		if (oldDate.getMonth() !== newFilter.startMonth.getMonth() || oldDate.getFullYear() !== newFilter.startMonth.getFullYear()) {
			hasChanges = true;

			oldDate.setMonth(newFilter.startMonth.getMonth());
			oldDate.setFullYear(newFilter.startMonth.getFullYear());
		}

		if (!arraysEqual(newFilter.selectedOpportunities, $scope.viewState.selectedOpportunities)) {
			//console.log('opps differ', newFilter.selectedOpportunities, $scope.viewState.selectedOpportunities);

			hasChanges = true;
			$scope.viewState.selectedOpportunities.splice(0, $scope.viewState.selectedOpportunities.length);

			/* add by hand, do not alter the array reference! */
			for (var i = 0; i < newFilter.selectedOpportunities.length; i++) {
				$scope.viewState.selectedOpportunities.push(newFilter.selectedOpportunities[i]);
			}
		}

		if (!arraysEqual(newFilter.selectedResources, $scope.viewState.selectedResources)) {
			//console.log('resources differ', newFilter.selectedResources, $scope.viewState.selectedResources);

			hasChanges = true;
			$scope.viewState.selectedResources.splice(0, $scope.viewState.selectedResources.length);

			/* add by hand, do not alter the array reference! */
			for (var i = 0; i < newFilter.selectedResources.length; i++) {
				$scope.viewState.selectedResources.push(newFilter.selectedResources[i]);
			}
		}

		if (newFilter.opportunitiesFilterText !== $scope.viewState.opportunitiesFilterText) {
			//console.log('of differs', newFilter.opportunitiesFilterText, $scope.viewState.opportunitiesFilterText);

			hasChanges = true;
			$scope.viewState.opportunitiesFilterText = newFilter.opportunitiesFilterText;
		}

		if (newFilter.resourcesFilterText !== $scope.viewState.resourcesFilterText) {
			//console.log('rf differs', newFilter.resourcesFilterText, $scope.viewState.resourcesFilterText);

			hasChanges = true;
			$scope.viewState.resourcesFilterText = newFilter.resourcesFilterText;
		}

		if (newFilter.selectRelatedOpportunities !== $scope.viewState.selectRelatedOpportunities) {
			//console.log('sro differs', newFilter.selectRelatedOpportunities, $scope.viewState.selectRelatedOpportunities);

			hasChanges = true;
			$scope.viewState.selectRelatedOpportunities = newFilter.selectRelatedOpportunities;
		}

		if (newFilter.selectRelatedResources !== $scope.viewState.selectRelatedResources) {
			//console.log('srr differs', newFilter.selectRelatedResources, $scope.viewState.selectRelatedResources);

			hasChanges = true;
			$scope.viewState.selectRelatedResources = newFilter.selectRelatedResources;
		}

		//console.log('hasChanges', hasChanges);
		//console.log('forceFilterUpdate', forceFilterUpdate);
		//console.log('hasLocationFilter', hasLocationFilter);

		$scope.status.loaded = false;
		$scope.viewState.filterVisible = !hasLocationFilter;
		$scope.filter.updateFilterData(hasLocationFilter);
	};

	[$scope.viewState.today, $scope.viewState.startMonth, $scope.viewState.minStartMonth, $scope.viewState.maxStartMonth].forEach(function (d, index) {
		if (index > 0) {
			d.setDate(1);
		}

		d.setHours(0);
		d.setMinutes(0);
		d.setSeconds(0);
		d.setMilliseconds(0);
	});

	/* set the proper min and max dates by subtracting 720 days and adding 900 */
	$scope.viewState.minStartMonth.setDate(-720);
	$scope.viewState.minStartMonth.setDate(1);

	$scope.viewState.maxStartMonth.setDate(900);
	/* set the tenth of the month to properly check selected < max */
	$scope.viewState.maxStartMonth.setDate(10);

	$scope.viewState.hasPreviousStartMonthYear = function () {
		return $scope.viewState.startMonth.getFullYear() > $scope.viewState.minStartMonth.getFullYear();
	};

	$scope.viewState.hasNextStartMonthYear = function () {
		return $scope.viewState.startMonth.getFullYear() < $scope.viewState.maxStartMonth.getFullYear();
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

	var getStartMonthNumber = function () {
		return $scope.viewState.startMonth.getFullYear() * 100 + $scope.viewState.startMonth.getMonth();
	};

	$scope.filter.validateStartMonthRange = function () {
		if ($scope.viewState.startMonth < $scope.viewState.minStartMonth) {
			$scope.viewState.startMonth.setFullYear($scope.viewState.minStartMonth.getFullYear(), $scope.viewState.minStartMonth.getMonth());
		} else if ($scope.viewState.startMonth > $scope.viewState.maxStartMonth) {
			$scope.viewState.startMonth.setFullYear($scope.viewState.maxStartMonth.getFullYear(), $scope.viewState.maxStartMonth.getMonth());
		}
	};

	$scope.filter.setStartMonthMonth = function (month) {
		var oldMonth = getStartMonthNumber();

		$scope.viewState.startMonth.setMonth(month - 1, 1);
		$scope.filter.validateStartMonthRange();

		if (getStartMonthNumber() !== oldMonth) {
			$scope.filter.updateFilterData();
		}
	};

	$scope.filter.increaseStartMonthYear = function () {
		if ($scope.viewState.startMonth.getFullYear() >= $scope.viewState.maxStartMonth.getFullYear()) {
			return;
		}

		var oldMonth = getStartMonthNumber();

		$scope.viewState.startMonth.setFullYear($scope.viewState.startMonth.getFullYear() + 1);
		$scope.filter.validateStartMonthRange();

		if (getStartMonthNumber() !== oldMonth) {
			$scope.filter.updateFilterData();
		}
	};

	$scope.filter.decreaseStartMonthYear = function () {
		if ($scope.viewState.startMonth.getFullYear() <= $scope.viewState.minStartMonth.getFullYear()) {
			return;
		}

		var oldMonth = getStartMonthNumber();

		$scope.viewState.startMonth.setFullYear($scope.viewState.startMonth.getFullYear() - 1);
		$scope.filter.validateStartMonthRange();

		if (getStartMonthNumber() !== oldMonth) {
			$scope.filter.updateFilterData();
		}
	};

	$scope.filter.resetStartMonth = function () {
		var oldMonth = getStartMonthNumber();

		$scope.viewState.startMonth.setFullYear($scope.viewState.today.getFullYear(), $scope.viewState.today.getMonth(), 1);

		if (getStartMonthNumber() !== oldMonth) {
			$scope.filter.updateFilterData();
		}
	};

	$scope.filter.getStartMonthClasses = function (month) {
		var target = new Date();
		target.setFullYear($scope.viewState.startMonth.getFullYear(), month - 1, 1);

		var classes = {};

		classes.active = $scope.viewState.startMonth.getMonth() === target.getMonth();
		classes.disabled = $scope.viewState.maxStartMonth < target || $scope.viewState.minStartMonth > target;

		return classes;
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
		$scope.viewState.selectRelatedOpportunities = false;

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

	$scope.filter.opportunities.selectRelatedOpportunities = function() {
		if ($scope.viewState.selectRelatedOpportunities) {
			$scope.filter.opportunities.clearSelectedOpportunities();
		}

		return $scope.viewState.selectRelatedOpportunities;
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

	$scope.filter.resources.events.roleClicked = function (role, event) {
		if (event.target !== event.currentTarget) {
			/* this event came bubbling through by clicking an option */
			return;
		}

		$scope.filter.resources.selectRoleResources(role, event.metaKey || event.ctrlKey || event.shiftKey);
	};

	$scope.filter.resources.selectRoleResources = function (role, toggle) {
		if (!toggle) {
			/* when not toggling we behave like a default option click and unselect all other options */
			$scope.filter.resources.clearSelectedResources();
		}

		var allActive = true;

		if (toggle) {
			/* when toggling we will select all, if not all were selected or unselect all, if all were */
			for (var i = 0; i < role.length; i++) {
				var resourceId = role[i].ContactId;
				var currentIndex = $scope.viewState.selectedResources.indexOf(resourceId);

				allActive = allActive && (currentIndex !== -1);

				if (!allActive) {
					break;
				}
			}
		}

		for (var i = 0; i < role.length; i++) {
			var resourceId = role[i].ContactId;
			var currentIndex = $scope.viewState.selectedResources.indexOf(resourceId);

			if (currentIndex === -1) {
				/* if it's not in yet, we want to add, whether toggling or not doesn't matter */
				$scope.viewState.selectedResources.push(resourceId);
			} else if (toggle && allActive) {
				$scope.viewState.selectedResources.splice(currentIndex, 1);
			}
		}
	};

	$scope.filter.resources.roleMatchesFilter = function (role) {
		if (!$scope.viewState.resourcesFilterText) {
			return true;
		}

		var regex = new RegExp('^.*' + $scope.viewState.resourcesFilterText.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&") + '.*$', 'i');

		if (regex.test(role.Role)) {
			return true;
		}

		for (var r = 0; r < role.length; r++) {
			if (regex.test(role[r].ResourceName)) {
				return true;
			}
		}

		return false;
	};

	$scope.filter.resources.resourceMatchesFilter = function (resource) {
		if (!$scope.viewState.resourcesFilterText) {
			return true;
		}

		var regex = new RegExp('^.*' + $scope.viewState.resourcesFilterText.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&") + '.*$', 'i');

		if (regex.test(resource.ResourceName) || regex.test(resource.Title)) {
			return true;
		}

		return false;
	};

	$scope.filter.resources.clearSelectedResources = function () {
		$scope.viewState.selectedResources.splice(0, $scope.viewState.selectedResources.length);
	};

	$scope.filter.resources.selectAllResources = function () {
		$scope.viewState.selectRelatedResources = false;

		/* add all currently visible resources to the selection */
		for (var c = 0; c < $scope.data.Resources.length; c++) {
			for (var r = 0; r < $scope.data.Resources[c].length; r++) {
				var currentIndex = $scope.viewState.selectedResources.indexOf($scope.data.Resources[c][r].ContactId);

				if (currentIndex === -1 && $scope.filter.resources.resourceMatchesFilter($scope.data.Resources[c][r])) {
					$scope.viewState.selectedResources.push($scope.data.Resources[c][r].ContactId);
				}
			}
		}
	};

	$scope.filter.resources.selectRelatedResources = function() {
		if ($scope.viewState.selectRelatedResources) {
			$scope.filter.resources.clearSelectedResources();
		}

		return $scope.viewState.selectRelatedResources;
	};

	$scope.filter.resources.removeFilteredResourcesFromSelection = function () {
		/* check all resources if they match the filter and remove from selection, if not */
		for (var c = 0; c < $scope.data.Resources.length; c++) {
			for (var r = 0; r < $scope.data.Resources[c].length; r++) {
				var currentIndex = $scope.viewState.selectedResources.indexOf($scope.data.Resources[c][r].ContactId);

				if (currentIndex > -1 && !$scope.filter.resources.resourceMatchesFilter($scope.data.Resources[c][r])) {
					$scope.viewState.selectedResources.splice(currentIndex, 1);
				}
			}
		}
	};

	/* functions for the staffing table */
	$scope.filter.events.updateStaffingClicked = function (event) {
		event.preventDefault();

		$scope.viewState.filterVisible = false;

		$scope.updateStaffing();
	};

	$scope.filter.updateFilterData = function (populateStaffing) {
		$scope.viewState.endMonth = new Date($scope.viewState.startMonth.getTime());
		$scope.viewState.endMonth.setMonth($scope.viewState.endMonth.getMonth() + 1);

		sfEndpoint.getFilterOptions($scope.viewState.startMonth).then(function (data) {
			$scope.status.loading = false;
			$scope.viewState.isAllowedToRunScheduler = !!data.IsAllowedToRunScript;

			$scope.data.Customers = data.Customers;
			$scope.data.Resources = [];

			var resourcesByRole = {
				/* preinitialize here to prevent it from being pushed to the data to early, it will be pushed later */
				'No role': []
			};

			var knownResourceIds = {};
			var knownOpportunityIds = {};

			resourcesByRole['No role'].Role = 'No role';

			for (var r = 0; r < data.Resources.length; r++) {
				var resource = data.Resources[r];

				knownResourceIds[resource.ContactId] = true;

				if (!resource.Title) {
					resource.Title = 'No role';
				}

				if (!resourcesByRole[resource.Title]) {
					resourcesByRole[resource.Title] = [];
					resourcesByRole[resource.Title].Role = resource.Title;
					$scope.data.Resources.push(resourcesByRole[resource.Title]);
				}

				resourcesByRole[resource.Title].push(resource);
			}

			if (resourcesByRole['No role'].length) {
				$scope.data.Resources.push(resourcesByRole['No role']);
			}

			var projectAndCustomerCount = data.Customers.length;

			for (var c = 0; c < data.Customers.length; c++) {
				projectAndCustomerCount += data.Customers[c].Projects.length;

				/* normalize the projects to contain the customer info */
				for (var p = 0; p < data.Customers[c].Projects.length; p++) {
					var project = data.Customers[c].Projects[p];

					knownOpportunityIds[project.OpportunityId] = true;

					project.AccountId = data.Customers[c].AccountId;
					project.AccountName = data.Customers[c].AccountName;
				}
			}

			$scope.viewState.selectedOpportunitiesSize = Math.min(10, projectAndCustomerCount);
			$scope.viewState.selectedResourcesSize = Math.min(10, data.Resources.length);

			var lostOpportunityIds = [];
			for (var o = 0; o < $scope.viewState.selectedOpportunities.length; o++) {
				var oppId = $scope.viewState.selectedOpportunities[o];

				if (!knownOpportunityIds[oppId]) {
					lostOpportunityIds.push(oppId);
				}
			}

			for (var o = 0; o < lostOpportunityIds.length; o++) {
				var index = $scope.viewState.selectedOpportunities.indexOf(lostOpportunityIds[o]);
				$scope.viewState.selectedOpportunities.splice(index, 1);
			}

			var lostResourceIds = [];
			for (var r = 0; r < $scope.viewState.selectedResources.length; r++) {
				var resourceId = $scope.viewState.selectedResources[r];

				if (!knownResourceIds[resourceId]) {
					lostResourceIds.push(resourceId);
				}
			}

			for (var r = 0; r < lostResourceIds.length; r++) {
				var index = $scope.viewState.selectedResources.indexOf(lostResourceIds[r]);
				$scope.viewState.selectedResources.splice(index, 1);
			}

			console.log('received filter data', data);

			if (populateStaffing) {
				console.log('directly populate staffing');
				$scope.updateStaffing();
			}
		}, function (response) {
			$scope.status.error = response;
			console.log('error while receiving filter data', response);
		});
	};

	$scope.updateStaffing = function () {
		var locationSearchParams = {
			d: JSON.stringify($scope.viewState.startMonth).replace(/^"(.*)"$/, '$1')
		}

		if ($scope.viewState.selectRelatedOpportunities) {
			locationSearchParams.sro = 1;
		} else {
			locationSearchParams.o = $scope.viewState.selectedOpportunities.join(',');
		}

		if ($scope.viewState.selectRelatedResources) {
			locationSearchParams.srr = 1;
		} else {
			locationSearchParams.r = $scope.viewState.selectedResources.join(',');
		}

		if ($scope.viewState.opportunitiesFilterText) {
			locationSearchParams.of = $scope.viewState.opportunitiesFilterText;
		}

		if ($scope.viewState.resourcesFilterText) {
			locationSearchParams.rf = $scope.viewState.resourcesFilterText;
		}

		//console.log('updating location to include current filter', !$scope.status.updatingViewState);

		/*
		 * use the negation of the updatingViewState, which means we were
		 * already triggered by the location change event and do not need to catch this
		 */
		$scope.status.updatingLocation = !$scope.status.updatingViewState;
		$scope.status.updatingViewState = false;

		$location.search(locationSearchParams);

		$scope.$broadcast(
			'updateStaffing',
			{
				'opportunities': $scope.viewState.selectRelatedOpportunities ? ['__related'] : $scope.viewState.selectedOpportunities,
				'resources': $scope.viewState.selectRelatedResources ? ['__related'] : $scope.viewState.selectedResources,
				'startMonth': $scope.viewState.startMonth,
				'options': {
					'selectRelatedResources' : $scope.viewState.selectRelatedResources,
					'selectRelatedOpportunities': $scope.viewState.selectRelatedOpportunities
				}
			}
		);
	};

	$scope.prepareSchedulerRun = function (date) {
		$scope.viewState.schedulerVisible = false;

		sfEndpoint.prepareSchedulerRun(date).then(function (result) {
			var message = 'Please confirm the following actions:';
			message += "\n" + '- planned statistics will be created from ' + result.PlannedWeekStart + ' to ' + result.PlannedWeekEnd;
			message += "\n" + '- planned schedules will be replaced with time entries from ' + result.ActualWeekStart + ' to ' + result.ActualWeekEnd;
			message += "\n" + '- actual statistics will be created from ' + result.ActualWeekStart + ' to ' + result.ActualWeekEnd;

			if (result.PlannedMonthEnd) {
				message += "\n" + 'planned statistics will be created from ' + result.PlannedMonthStart + ' to ' + result.PlannedMonthEnd;
				message += "\n" + 'actual statistics will be created from ' + result.ActualMonthStart + ' to ' + result.ActualMonthEnd;
			}

			if (confirm(message)) {
				console.log('run scheduler for time range', result);
				sfEndpoint.runScheduler(date).then(function () {
					alert('The job was successfully submitted, you\'ll see results in a few minutes.');
				});
			} else {
				console.log('scheduler run aborted');
			}
		});
	};

	/* initialize data */
	initializeViewStateFromLocation(true);

	var basePath = null;
	$scope.$on('$locationChangeSuccess', function (e, newUrl, oldUrl) {
		if (!basePath) {
			basePath = $location.path();
		}

		if ($scope.status.updatingLocation) {
			$scope.status.updatingLocation = false;
			return;
		}

		if (newUrl !== oldUrl) {
			if ($location.path() !== basePath) {
				$window.location.href = newUrl;
				return;
			}

			$scope.status.updatingViewState = true;
			initializeViewStateFromLocation();
		}
	});
}]);

PsoTable2.ng.directive('showWeekOrMonthPicker', ['$timeout', function ($timeout) {
	return {
		restrict: 'A',
		link: function (scope, el, attributes) {
			scope.$watch(attributes.showWeekOrMonthPicker, function (status) {
				if (status) {
					$timeout(function() {
						el.datepicker('show');
					}, 100);
				} else {
					el.datepicker('hide');
				}
			});

			var datepickerOptions = {
				showButtonPanel: false,
				dateFormat: 'yy-mm-dd',
				beforeShowDay: function (date) {
					var dayOfWeek = date.getDay();
					var dayOfMonth = date.getDate();

					if (dayOfWeek === 1 || dayOfMonth === 1) {
						return [true, ''];
					}

					return [false, ''];
				}
			};

			if (attributes.selectDate) {
				datepickerOptions.onSelect = function (selectedDate) {
					scope.$eval(attributes.selectDate, {
						'selectedDate': new Date(selectedDate)
					});
				}
			}

			el.datepicker(datepickerOptions);
		}
	};
}]);

PsoTable2.ng.directive('exportToExcel', ['$document', function ($document) {
	return {
		restrict: 'A',
		link: function (scope, el, attributes) {
			el.on('click', function () {
				var document = $document[0];

				var target = document.createElement('table');
				var rows = [];

				$(attributes.exportToExcelSource || 'table').each(function (index, table) {
					$('tr', table).each(function (rowIndex, row) {
						var targetRow;

						if (rowIndex >= rows.length) {
							targetRow = document.createElement('tr');
							rows.push(targetRow);
						} else {
							targetRow = rows[rowIndex];
						}

						$('th,td', row).each(function (cellIndex, cell) {
							var targetCell = document.createElement(cell.nodeName);

							targetCell.innerText = cell.innerText.trim();
							targetCell.rowSpan = cell.rowSpan;
							targetCell.colSpan = cell.colSpan;

							targetRow.appendChild(targetCell);
						});

						target.appendChild(targetRow);
					});
				});

				ExcellentExport.excel(el[0], target, attributes.exportToExcel);
			});
		}
	};
}]);