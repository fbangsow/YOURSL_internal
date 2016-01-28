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
					isWeekEnd: !(currentDate.getDay() % 6),
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

			/* restructure the staffings for each resource to be accessible by date */
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