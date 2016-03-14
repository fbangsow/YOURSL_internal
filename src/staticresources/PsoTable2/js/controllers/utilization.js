PsoTable2.ng.controller('PsoTable2Utilization', ['$scope', '$interval', 'PsoTable2Endpoint', 'PsoTable2StaffingHelper', 'datepicker', 'alert', function ($scope, $interval, sfEndpoint, staffingHelper, datepicker, alert) {
	console.log('init utilization controller');

	$scope.viewState = {
		startDate: null,
		endDate: null,
		staffingColumns: 0,
		staticStaffingColumns: 0,
		staffingDayColumns: 0,
		staffingMonths: [],
		staffingWeeks: [],
		staffingDays: [],
		projectHealthReasons: {},
		orderResources: 'ResourceName',
		orderResourcesDescending: false
	};

	$scope.data = {};

	/* restructure the staffings for each resource to be accessible by date */
	$scope.utilization = {};

	$scope.buildResourceAllocationCellClasses = function (resource, day, stats, type) {
		var classes = {};

		stats = stats || 0.0;

		if (!type && day && day.isSaldo) {
			type = 'saldo';

			if (day.isStatisticSaldo) {
				type = 'statistic';
			} else if (day.isUtilization) {
				type = 'utilization'
			}
		}

		if (day) {
			classes.weekend = !!day.isWeekEnd;
			classes.past = !!day.isPast;
			classes.today = !!day.isToday;
			classes.future = !!day.isFuture;

			if (day.isSaldo) {
				classes['saldo'] = true;

				switch (type) {
					case 'statistic':
						/* the stats may not be generated, we need to check */
						if (stats) {
							classes['negative-saldo'] = stats.actual < stats.planned;
							classes['positive-saldo'] = stats.actual > stats.planned;
							classes['neutral-saldo'] = stats.actual === stats.planned;
						} else {
							classes['no-data'] = true;
						}
					break;
					case 'utilization':
						var statsValue = stats ? stats.value : 0;

						classes['very-low-utilization'] = statsValue <= 0.4;
						classes['low-utilization'] = statsValue > 0.4 && statsValue < 0.6;
						classes['neutral-utilization'] = statsValue >= 0.6 && statsValue < 0.8;
						classes['high-utilization'] = statsValue >= 0.8;
					break;
					case 'saldo':
						classes['negative-saldo'] = stats && stats < 0;
						classes['positive-saldo'] = stats && stats > 0;
						classes['neutral-saldo'] = !stats;
					break;
				}
			}
		}

		return classes;
	};

	$scope.buildDayHeaderClasses = staffingHelper.buildDayHeaderClasses;
	$scope.buildResourceRowClasses = staffingHelper.buildResourceRowClasses;

	$scope.orderResourcesBy = function (column) {
		if ($scope.viewState.orderResources === column) {
			$scope.viewState.orderResourcesDescending = !$scope.viewState.orderResourcesDescending;
		} else {
			$scope.viewState.orderResources = column;
			$scope.viewState.orderResourcesDescending = false;
		}
	};

	$scope.getResourceOrderPredicate = function (resource) {
		var column = $scope.viewState.orderResources;

		if (resource[column]) {
			return resource[column];
		}

		if (/-saldo-/.test(column)) {
			return resource.Saldos[column] || 0;
		}

		if (/-utilization-/.test(column)) {
			return (resource.Saldos[column] || {value:0}).value || 0;
		}

		return 0;
	};

	/* functions for the staffing table */
	$scope.$on('updateStaffing', function (event, filter) {
		if ($scope.$parent.status) {
			$scope.$parent.status.loading = true;
			$scope.$parent.status.loaded = false;
		}

		filter.opportunities = ['__related'];

		var selectedOpportunities = filter.opportunities || [];
		var selectedResources = filter.resources || [];
		var startMonth = filter.startMonth || new Date();

		sfEndpoint.getProjectStaffing(selectedOpportunities, selectedResources, startMonth).then(function (data) {
			console.log('received data for project utilization:', data);

			$scope.$emit('receivedStaffingData', data, selectedOpportunities, selectedResources, startMonth);

			/* we need to equalize the time to be able to detect today */
			$scope.viewState.startDate = new Date(data.StartDate);
			staffingHelper.normalizeTime($scope.viewState.startDate);

			$scope.viewState.endDate = new Date(data.EndDate);
			staffingHelper.normalizeTime($scope.viewState.endDate);

			var today = new Date();
			staffingHelper.normalizeTime(today);

			var todayWeek = datepicker.iso8601Week(today);
			var todayMonth = datepicker.formatDate('m', today);

			$scope.viewState.staffingMonths.splice(0, $scope.viewState.staffingMonths.length);
			$scope.viewState.staffingWeeks.splice(0, $scope.viewState.staffingWeeks.length);
			$scope.viewState.staffingDays.splice(0, $scope.viewState.staffingDays.length);

			var lastMonth = null;
			var lastWeek = null;
			var dayCount = 0;

			var createWeekStatsColumn = function(month, week) {
				dayCount += 1;

				month.dayCount += 1;
				week.dayCount += 1;

				$scope.viewState.staffingDays.push({
					dateString: 'week-utilization-' + month.number + '-' + week.number,
					weekDay: 'Uw',
					isSaldo: true,
					isUtilization: true
				});

				week.caption = week.days[0].day + '. - ' + week.days[week.days.length - 1].day + '.';
			};

			var createSaldoColumns = function (month) {
				dayCount += 2;

				month.dayCount += 2;

				createWeekStatsColumn(month, month.weeks[month.weeks.length - 1]);

				$scope.viewState.staffingWeeks.push({
					dateString: 'month-utilization-' + month.number,
					dayCount: 1,
					caption: 'Total',
					isSaldo: true
				});

				$scope.viewState.staffingWeeks.push({
					dateString: 'month-saldo-' + month.number,
					dayCount: 1,
					caption: 'Remaining',
					isSaldo: true
				});

				$scope.viewState.staffingDays.push({
					dateString: 'month-utilization-' + month.number,
					weekDay: 'Total',
					isSaldo: true,
					isUtilization: true
				});

				$scope.viewState.staffingDays.push({
					dateString: 'month-saldo-' + month.number,
					weekDay: 'Remaining',
					isSaldo: true,
					isMonthSaldo: true
				});
			};

			/* iterate all days and build an array with all months, weeks and days to be able to build the html table */
			for (var currentDate = new Date($scope.viewState.startDate.getTime()); currentDate <= $scope.viewState.endDate; currentDate.setDate(currentDate.getDate() + 1)) {
				var dateInfo = {
					date: new Date(currentDate.valueOf()),
					day: currentDate.getDate(),
					isWeekEnd: !(currentDate.getDay() % 6),
					isPast: currentDate < today,
					isToday: currentDate.getTime() === today.getTime(),
					isFuture: currentDate > today,
					weekDay: datepicker.formatDate('D', currentDate),
					week: datepicker.iso8601Week(currentDate),
					monthName: datepicker.formatDate('M', currentDate),
					month: datepicker.formatDate('m', currentDate),
					dateString: datepicker.formatDate('yy-mm-dd', currentDate)
				};

				if (dateInfo.isToday || dateInfo.isFuture || (dateInfo.week === todayWeek && dateInfo.month === todayMonth)) {
					dateInfo.isAllocatable = true;
				}

				if (!lastMonth || lastMonth.number !== dateInfo.month) {
					if (lastMonth) {
						/* make place for the saldo column */
						createSaldoColumns(lastMonth);
					}

					lastMonth = {
						caption: dateInfo.monthName,
						number: dateInfo.month,
						weeks: [],
						weekCount: 0,
						dayCount: 0,
						workDayCount: 0
					};

					/* month change with forthgoing week, start a new week */
					if (lastWeek && lastWeek.number === dateInfo.week) {
						lastWeek = null;
					}

					$scope.viewState.staffingMonths.push(lastMonth);
				}

				if (!lastWeek || lastWeek.number !== dateInfo.week) {
					lastWeek = {
						dateString: 'week-utilization-' + dateInfo.month + '-' + dateInfo.week,
						number: dateInfo.week,
						month: dateInfo.month,
						days: [],
						dayCount: 0,
						workDayCount: 0
					};

					if (lastMonth.weeks.length > 0) {
						createWeekStatsColumn(lastMonth, lastMonth.weeks[lastMonth.weeks.length-1]);
					}

					lastMonth.weeks.push(lastWeek);
					lastMonth.weekCount++;

					$scope.viewState.staffingWeeks.push(lastWeek);
				}

				lastWeek.days.push(dateInfo);

				lastWeek.workDayCount += dateInfo.isWeekEnd ? 0 : 1;
				lastMonth.workDayCount += dateInfo.isWeekEnd ? 0 : 1;
			}

			createSaldoColumns(lastMonth);

			$scope.data.Resources = [];
			$scope.data.ResourcesByContactId = {};

			if (data.Resources) {
				for (var r = 0; r < data.Resources.length; r++) {
					var resource = data.Resources[r];

					resource.MonthToLimitMap = {};
					resource.WeekToLimitMap = {};

					for (var m = 0; m < $scope.viewState.staffingMonths.length; m++) {
						var month = $scope.viewState.staffingMonths[m];
						resource.MonthToLimitMap[month.number] = month.workDayCount;
					}

					for (var w = 0; w < $scope.viewState.staffingWeeks.length; w++) {
						var week = $scope.viewState.staffingWeeks[w];

						if (week.isSaldo) {
							continue;
						}

						resource.WeekToLimitMap[week.month + '-' + week.number] = week.workDayCount;
					}

					staffingHelper.normalizeResourceStaffing(resource);

					$scope.data.ResourcesByContactId[resource.ContactId] = resource;
				}

				$scope.data.Resources = data.Resources;
			}

			if (data.Customers) {
				for (var c = 0; c < data.Customers.length; c++) {
					var customer = data.Customers[c];
					for (var p = 0; p < customer.Projects.length; p++) {
						var project = customer.Projects[p];

						for (var r = 0; r < project.Resources.length; r++) {
							var resource = project.Resources[r];

							if (!resource.ContactId) {
								continue;
							}

							if (!$scope.data.ResourcesByContactId[resource.ContactId].Projects) {
								$scope.data.ResourcesByContactId[resource.ContactId].Projects = {};
							}

							var resourceProject = {
								AccountName: customer.AccountName,
								OpportunityName: project.OpportunityName,
								StaffingByDay: {}
							};

							if (!$scope.data.ResourcesByContactId[resource.ContactId].Projects[project.OpportunityId]) {
								$scope.data.ResourcesByContactId[resource.ContactId].Projects[project.OpportunityId] = resourceProject;
							}

							for (var s = 0; s < resource.Staffing.length; s++) {
								var staffing = resource.Staffing[s];
								var staffingDate = new Date(staffing.Day);

								var staffingWeek = datepicker.iso8601Week(staffingDate);
								var staffingMonth = datepicker.formatDate('m', staffingDate);

								var contexts = {
									month: staffingMonth,
									week: staffingMonth + '-' + staffingWeek
								};

								for (var contextType in contexts) {
									if (contexts.hasOwnProperty(contextType)) {
										var context = contexts[contextType];
										var utilizationDateString = contextType + '-utilization-' + context;

										if (!resourceProject.StaffingByDay[utilizationDateString]) {
											resourceProject.StaffingByDay[utilizationDateString] = 0;
										}

										resourceProject.StaffingByDay[utilizationDateString] += staffing.Staff;
									}
								}
							}

							if (resource.MonthToLimitMap) {
								for (monthKey in resource.MonthToLimitMap) {
									if (resource.MonthToLimitMap.hasOwnProperty(monthKey)) {
										var budgetForMonth = parseFloat(resource.MonthToLimitMap[monthKey]) * 8;
										var scheduledForMonth = resourceProject.StaffingByDay['month-utilization-' + monthKey] || 0;

										resourceProject.StaffingByDay['month-saldo-' + monthKey] = budgetForMonth - scheduledForMonth;
									}
								}
							}
						}
					}
				}
			}

			$scope.viewState.staffingDayColumns = dayCount;
			$scope.viewState.staffingColumns = $scope.viewState.staticStaffingColumns + dayCount;

			if ($scope.$parent.status) {
				$scope.$parent.status.loading = false;
				$scope.$parent.status.loaded = true;
			}

			$scope.$emit('updatedStaffingData', data, selectedOpportunities, selectedResources, startMonth);

			console.log('finished data update');
		}, function (response) {
			$scope.status.error = response;
			console.log('error while retrieving project utilization data:', response);
		});
	});

	sfEndpoint.onResourceChange(function (message) {
		console.log('received resource change info', message);

		var data = message.data.sobject;
		var resource = $scope.data.ResourcesByContactId[data.ContactId__c];

		if (!resource) {
			/* we don't currently see this resource */
			console.log('Affected resource is currently not displayed.');
			return;
		}

		var forDate = new Date(data.Scheduled_Date__c);
		var forDateString = datepicker.formatDate('yy-mm-dd', forDate);
		var newBookingValue = parseFloat(data.New_value__c) * 8;
		var oldBookingValue = parseFloat(data.Old_value__c) * 8;
		var delta = newBookingValue - oldBookingValue;

		$scope.$apply(function () {
			var staffing = resource.StaffingByDay[forDateString];

			if (!staffing) {
				staffing = {
					date: forDate,
					Day: forDateString,
					Staff: newBookingValue
				};
				resource.Staffing.push(staffing);
				resource.StaffingByDay[forDateString] = staffing;
			} else if (resource.Product) {
				staffing.Staff = newBookingValue;
			} else if (resource.Title) {
				staffing.Staff += delta;
			}

			console.log('updated resource', resource, staffing);

			staffingHelper.normalizeResourceStaffing(resource);
		});
	});

	/* initialize data */
	var connectionCheck = $interval(function () {
		$scope.$parent.viewState.isConnected = sfEndpoint.isBroadcastConnected();
	}, 1000);

	$scope.$on('$destroy', function() {
		if (connectionCheck) {
			$interval.cancel(connectionCheck);
			connectionCheck = null;
		}
	});
}]);