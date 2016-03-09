PsoTable2.ng.factory('PsoTable2StaffingHelper', ['datepicker', function (datepicker) {
	var helper = {};

	var hoursPerDay = 8;
	var fullyBookedTreshold = hoursPerDay * 1;

	helper.normalizeStaffing = function (staffing) {
		/**
		 * {
			Day: '2016-01-28',
			Staff: 4.25,
			HoursOff: 0.75
		 }
		 */
		if (!staffing.__normalized) {
			staffing.__normalized = true;

			/* do some initial stuff here that we're allowed to do only once or at least don't need to do more often */

			if (!staffing.date) {
				staffing.date = new Date(staffing.Day);
			}

			staffing.month = datepicker.formatDate('m', staffing.date);
			staffing.week = datepicker.iso8601Week(staffing.date);

			staffing.HoursOff = staffing.HoursOff || 0;

			/*
			 * When hoursOff are set, they are also included in the Staff attribute.
			 * We remove them from the Staff to be able to later differentiate between both values.
			 */
			staffing.Staff = (staffing.Staff || 0) - staffing.HoursOff;
		}

		staffing.total = staffing.Staff + staffing.HoursOff;
		staffing.currentBooking = staffing.Staff;

		/*
		 * We calculate the booking state with both project allocation and holidays.
		 * Default project allocations do not have holidays (total == Staff) and availability infos
		 * should check both (Staff and HoursOff) for this. In both cases total is the number we that
		 * provides the proper info.
		 */
		staffing.hasStaffing = staffing.Staff > 0;
		staffing.isPartlyStaffed = staffing.hasBooking && staffing.Staff < fullyBookedTreshold;
		staffing.isFullyStaffed = staffing.Staff >= fullyBookedTreshold && staffing.Staff <= hoursPerDay;
		staffing.isOverStaffed = staffing.Staff > hoursPerDay;

		staffing.hasHoliday = staffing.HoursOff > 0;
		staffing.isPartlyHoliday = staffing.hasHoliday && staffing.HoursOff < fullyBookedTreshold;
		staffing.isFullHoliday = staffing.HoursOff >= fullyBookedTreshold;

		staffing.hasStaffingAndHoliday = staffing.Staff > 0 && staffing.HoursOff > 0;
		staffing.hasStaffingOrHoliday = staffing.total > 0;

		staffing.isPartlyStaffedOrHoliday = staffing.hasStaffingOrHoliday && staffing.total < fullyBookedTreshold;
		staffing.isFullyStaffedOrHoliday = staffing.total >= fullyBookedTreshold && staffing.total <= hoursPerDay;
		staffing.isOverStaffedOrHoliday = staffing.total > hoursPerDay;
	};

	helper.normalizeResourceStaffing = function (resource, resourceSummary, project) {
		/*console.log('normalize resource staffing for resource');
		console.log(resource);
		console.log(project);*/

		resource.StaffingByDay = {};
		resource.Saldos = {};

		if (!resource.AccountName && resourceSummary && resourceSummary.AccountName) {
			resource.AccountName = resourceSummary.AccountName;
		}

		if (resource.MonthToLimitMap) {
			/* initialize the month saldo to the complete budget, we'll reduce by the planned hours later */
			for (monthKey in resource.MonthToLimitMap) {
				if (resource.MonthToLimitMap.hasOwnProperty(monthKey)) {
					var budgetForMonth = parseFloat(resource.MonthToLimitMap[monthKey]) * 8;

					resource.Saldos['month-budget-' + monthKey] = budgetForMonth;
					resource.Saldos['month-saldo-' + monthKey] = budgetForMonth;

					resource.Saldos['month-utilization-' + monthKey] = {
						value: 0,
						booked: 0,
						budget: 0,
						holiday: 0
					};

					resource.Saldos['month-booked-' + monthKey] = 0;
					resource.Saldos['month-holiday-' + monthKey] = 0;

					if (project) {
						if (!project.Saldos['month-budget-' + monthKey]) {
							project.Saldos['month-budget-' + monthKey] = 0;
						}

						if (!project.Saldos['month-saldo-' + monthKey]) {
							project.Saldos['month-saldo-' + monthKey] = 0;
						}

						project.Saldos['month-budget-' + monthKey] += budgetForMonth;
						project.Saldos['month-saldo-' + monthKey] += budgetForMonth;
					}
				}
			}
		}

		if (resource.WeekToLimitMap) {
			/* initialize the week saldo to the complete budget, we'll reduce by the planned hours later */
			for (weekNumber in resource.WeekToLimitMap) {
				if (resource.WeekToLimitMap.hasOwnProperty(weekNumber)) {
					var budgetForWeek = parseFloat(resource.WeekToLimitMap[weekNumber]) * 8;

					resource.Saldos['week-budget-' + weekNumber] = budgetForWeek;
					resource.Saldos['week-saldo-' + weekNumber] = budgetForWeek;
					resource.Saldos['week-utilization-' + weekNumber] = {
						value: 0,
						booked: 0,
						budget: 0,
						holiday: 0
					};

					resource.Saldos['week-booked-' + weekNumber] = 0;
					resource.Saldos['week-holiday-' + weekNumber] = 0;

					if (project) {
						if (!project.Saldos['week-budget-' + weekNumber]) {
							project.Saldos['week-budget-' + weekNumber] = 0;
						}

						if (!project.Saldos['week-saldo-' + weekNumber]) {
							project.Saldos['week-saldo-' + weekNumber] = 0;
						}

						project.Saldos['week-budget-' + weekNumber] += budgetForWeek;
						project.Saldos['week-saldo-' + weekNumber] += budgetForWeek;
					}
				}
			}
		}

		/* float values including decimals are not converted to float, but string */
		if (resource.SoldDays) {
			resource.SoldDays = parseFloat((resource.SoldDays + "").replace(',', '.'));

			if (project) {
				project.SoldDays += resource.SoldDays;
			}
		}

		if (resource.PlannedDays) {
			resource.PlannedDays = parseFloat((resource.PlannedDays + "").replace(',', '.'));

			if (project) {
				project.PlannedDays += resource.PlannedDays;
			}
		}

		var saldoContexts = [resource.Saldos];

		if (project) {
			saldoContexts.push(project.Saldos);
		}

		for (var s = 0; s < resource.Staffing.length; s++) {
			var staffing = resource.Staffing[s];

			this.normalizeStaffing(staffing);

			resource.StaffingByDay[staffing.Day] = staffing;

			if (project) {
				if (!project.BookedHoursByDay[staffing.Day]) {
					project.BookedHoursByDay[staffing.Day] = 0;
				}

				project.BookedHoursByDay[staffing.Day] += staffing.Staff;
			}

			var timeRanges = {
				month: staffing.month,
				week: staffing.month + '-' + staffing.week
			};

			for (var timeContext in timeRanges) {
				if (!timeRanges.hasOwnProperty(timeContext)) {
					continue;
				}

				var timeRange = timeRanges[timeContext];

				for (var sc = 0; sc < saldoContexts.length; sc++) {
					var saldos = saldoContexts[sc];

					[timeContext + '-budget', timeContext + '-saldo', timeContext + '-booked', timeContext + '-holiday'].forEach(function (saldoType) {
						var key = saldoType + '-' + timeRange;

						if (!saldos[key]) {
							saldos[key] = 0;
						}
					});

					saldos[timeContext + '-saldo-' + timeRange] -= staffing.total;
					saldos[timeContext + '-booked-' + timeRange] += staffing.Staff;
					saldos[timeContext + '-holiday-' + timeRange] += staffing.HoursOff;

					if (!saldos[timeContext + '-utilization-' + timeRange]) {
						saldos[timeContext + '-utilization-' + timeRange] = {
							value: 0,
							booked: 0,
							budget: 0,
							holiday: 0
						};
					}

					var utilization = saldos[timeContext + '-utilization-' + timeRange];

					utilization.budget = saldos[timeContext + '-budget-' + timeRange];
					utilization.holiday = saldos[timeContext + '-holiday-' + timeRange];
					utilization.booked = saldos[timeContext + '-booked-' + timeRange];

					var utilizationBudget = utilization.budget - utilization.holiday;
					utilization.value = utilizationBudget ? (utilization.booked / utilizationBudget) : 0;
				}
			}
		}

		for (var s = 0; s < resource.Statistics.length; s++) {
			var stat = resource.Statistics[s];

			var startDate = new Date(stat.StartDate);
			var endDate = new Date(stat.EndDate);

			var month = datepicker.formatDate('m', endDate);
			var startWeek = datepicker.iso8601Week(startDate);
			var endWeek = datepicker.iso8601Week(endDate);

			var saldoKey = 'week-stats-' + month + '-' + endWeek;

			if (startWeek !== endWeek) {
				/* monthly stats */
				saldoKey = 'month-stats-' + month;
			}

			for (var sc = 0; sc < saldoContexts.length; sc++) {
				var saldos = saldoContexts[sc];

				if (!saldos[saldoKey]) {
					saldos[saldoKey] = {
						'planned': 0,
						'actual': 0
					};
				}

				saldos[saldoKey].planned += stat.PlannedDays;
				saldos[saldoKey].actual += stat.ActualDays;
			}
		}
	};

	helper.buildDayHeaderClasses = function (day) {
		var classes = {};

		if (day) {
			classes.weekend = !!day.isWeekEnd;
			classes.past = !!day.isPast;
			classes.today = !!day.isToday;
			classes.future = !!day.isFuture;

			if (day.isMonthSaldo) {
				classes['month-saldo'] = true;
			}

			if (day.isUtilization) {
				classes['utilization'] = true;
			}

			if (day.isStatisticSaldo) {
				classes['statistic'] = true;
			}
		}

		return classes;
	};

	helper.buildResourceRowClasses = function (resource) {
		var classes = {};

		classes.yourslEmployee = resource.AccountName === 'YOUR SL GmbH';
		classes.externalEmployee = !classes.yourslEmployee;

		classes.billable = resource.SalesPrice > 0;

		if (!resource.SalesPrice && typeof resource.SalesPrice !== 'undefined') {
			classes.unbillable = !resource.SalesPrice;
		}

		return classes;
	};

	helper.normalizeTime = function (d) {
		d.setHours(0);
		d.setMinutes(0);
		d.setSeconds(0);
		d.setMilliseconds(0);
	};

	return helper;
}]);

PsoTable2.ng.controller('PsoTable2Staffing', ['$scope', '$interval', '$timeout', 'PsoTable2Endpoint', 'PsoTable2StaffingHelper', 'datepicker', 'alert', function ($scope, $interval, $timeout, sfEndpoint, staffingHelper, datepicker, alert) {
	console.log('init staffing controller');

	$scope.viewState = {
		startDate: null,
		endDate: null,
		staffingColumns: 0,
		staticStaffingColumns: 0,
		staffingDayColumns: 0,
		staffingMonths: [],
		staffingWeeks: [],
		staffingDays: [],
		projectHealthReasons: {}
	};

	$scope.filter = {};
	$scope.data = {};

	var initializeResourceContext = function (context, leaveCurrentValues) {
		if (!leaveCurrentValues || !context.SoldDays) {
			context.SoldDays = 0;
		}

		if (!leaveCurrentValues || !context.PlannedDays) {
			context.PlannedDays = 0;
		}

		if (!leaveCurrentValues || !context.BookedHoursByDay) {
			context.BookedHoursByDay = {};
		}

		if (!leaveCurrentValues || !context.Saldos) {
			context.Saldos = {};
		}
	};

	/* restructure the staffings for each resource to be accessible by date */
	var normalizeProjectHours = function (project) {
		console.log('normalize project hours', project);

		initializeResourceContext(project);

		for (var r = 0; r < project.Resources.length; r++) {
			var resource = project.Resources[r];

			staffingHelper.normalizeResourceStaffing(resource, $scope.data.ResourcesByContactId[resource.ContactId], project);

			if (resource.MonthToOppLineItemIdMap) {
				for (month in resource.MonthToOppLineItemIdMap) {
					if (resource.MonthToOppLineItemIdMap.hasOwnProperty(month)) {
						$scope.data.ResourcesByScheduleId[resource.MonthToOppLineItemIdMap[month]] = resource;
					}
				}
			}
		}
	};

	$scope.staffing = {};

	var parseAllocationTime = function (allocationTime) {
		allocationTime = ((allocationTime || '0.0') + '').replace(',','.');

		var minuteFormat = /^(\d{0,2}):(\d{1,2})$/.exec(allocationTime);
		if (minuteFormat) {
			allocationTime = parseInt(minuteFormat[1] || '0', 10) + (parseInt(minuteFormat[2] || '0', 10) / 60);
		}

		if (/^\.\d{1,2}$/.test(allocationTime)) {
			allocationTime = '0' + allocationTime;
		}

		if (!/^\d{1,2}(?:\.\d{1,2})?$/.test(allocationTime)) {
			return 'no_number';
		}

		allocationTime = parseFloat(allocationTime);

		var at4 = allocationTime * 4;
		if (at4 - parseInt(at4, 10)) {
			return 'not_quarter_hour';
		}

		if (allocationTime < 0) {
			return 'negative_number';
		}

		return allocationTime;
	};

	var scheduledAllocationUpdate;
	$scope.staffing.scheduleAsyncAllocationUpdate = function (project, resource, allocationDate, allocation) {
		if (scheduledAllocationUpdate) {
			$timeout.cancel(scheduledAllocationUpdate);
			scheduledAllocationUpdate = null;
		}

		allocation = allocation || {};
		var parsedTime = parseAllocationTime(allocation.currentBooking);

		if (typeof parsedTime === 'string') {
			return;
		}

		/* ok, at least it's a valid number, schedule silent update */
		scheduledAllocationUpdate = $timeout(function () {
			$scope.$apply(function () {
				$scope.staffing.updateAllocation(project, resource, allocationDate, allocation, true);
			});
		}, 500);
	};

	$scope.staffing.clearAllocation = function (project, resource, allocationDate, allocation) {
		allocation = allocation || {};
		allocation.currentBooking = 0;

		$scope.staffing.updateAllocation(project, resource, allocationDate, allocation);
	};

	$scope.staffing.updateAllocation = function (project, resource, allocationDate, allocation, silent) {
		allocation = allocation || {};

		var isNewAllocation = !allocation.Day;
		var dateString = datepicker.formatDate('yy-mm-dd', allocationDate);

		var requestedHours = parseAllocationTime(allocation.currentBooking);

		var oldHours = !isNewAllocation ? allocation.Staff : 0.0;

		if (typeof requestedHours === 'string') {
			if (!silent) {
				allocation.currentBooking = oldHours;

				switch (requestedHours) {
					case 'no_number':
						alert('Hour entries must be divisible by a quarter hour. The minimum are 15 minutes (0.25 hours).');
						break;
					case 'not_quarter_hour':
						alert('Hour entries must be divisible by a quarter hour. The minimum are 15 minutes (0.25 hours).');
						break;
					case 'negative_number':
						alert('Please enter a positive number or 0 to remove the allocation.');
						break;
				}
			}

			return;
		}

		if (oldHours === requestedHours) {
			return;
		}

		var totalResourceInfo = $scope.data.ResourcesByContactId[resource.ContactId];
		var totalDayInfo = totalResourceInfo ? totalResourceInfo.StaffingByDay[dateString] : null;
		var hoursOff = totalDayInfo ? totalDayInfo.HoursOff : 0.0;
		var currentTotalExcludingCurrentHours = (totalDayInfo ? totalDayInfo.Staff : 0.0) + hoursOff - oldHours;

		console.log('checking allocation data for update');
		/*console.log(project);
		console.log(resource);
		console.log(allocationDate);
		console.log(allocation);*/

		delta = requestedHours - oldHours;

		if (currentTotalExcludingCurrentHours + requestedHours > 8) {
			if (currentTotalExcludingCurrentHours + requestedHours > 12) {
				if (!silent) {
					allocation.currentBooking = oldHours;

					if (hoursOff) {
						alert('This allocation will exceed the maximum allowed 12 hours per day for a resource. Please be aware of the existing PTO hours.');
					} else {
						alert('This allocation will exceed the maximum allowed 12 hours per day for a resource.')
					}
				}

				return;
			}

			if (!silent) {
				var remainingHours = Math.max(8 - currentTotalExcludingCurrentHours, 0);

				if (currentTotalExcludingCurrentHours + oldHours <= 8) {
					alert('This allocation will exceed 8 hours per day for this resource. You can allocate ' + remainingHours + ' hours for this project without exceeding 8 hours.');
				} else {
					alert('This allocation stills exceeds 8 hours per day for this resource. You can allocate ' + remainingHours + ' hours for this project without exceeding 8 hours.');
				}
			}

			/* do not return here, exceeding 8 hours is allowed. */
		}

		var monthKey = datepicker.formatDate('m', allocationDate);

		if (!resource.MonthToLimitMap || !resource.MonthToLimitMap[monthKey]) {
			allocation.currentBooking = oldHours;

			alert('No contingent available for ' + resource.ResourceName + ' in this month. Please check with Sales Operations Team for adjustments.');
			return;
		}

		/* the currentMonthHours will contain the project bookings without the currently affected day */
		var currentMonthHours = 0;
		for (var s = 0; s < resource.Staffing.length; s++) {
			var staffing = resource.Staffing[s];
			if (staffing !== allocation && staffing.month === monthKey) {
				currentMonthHours += staffing.Staff;
			}
		}

		var limit = parseFloat(resource.MonthToLimitMap[monthKey]) * 8;
		var availableHours = Math.round(Math.max(0, limit - currentMonthHours) * 100) / 100;

		if (currentMonthHours + requestedHours > limit) {
			allocation.currentBooking = oldHours;

			var displayLimit = limit > 16 ? limit / 8 : limit;
			var intLimit = parseInt(displayLimit, 10);

			if (!(displayLimit - intLimit)) {
				/* it's an integer, use the non- decimal version for display */
				displayLimit = intLimit;
			}

			displayLimit += ' ' + (limit > 16 ? 'days' : 'hours');

			alert('The allocation of additional ' + requestedHours + ' hours for ' + resource.ResourceName + ' exceeds the month limit of ' + displayLimit + '. The resource has ' + availableHours + ' hours left for this month.');
			return;
		}

		console.log('allocation is fine, persist.');
		allocation.currentBooking = requestedHours;

		/* after validating we associate the hours and recalculate the sums */
		if (isNewAllocation) {
			/* populate the new allocation to contain the required data */
			allocation.Day = dateString;
			allocation.HoursOff = 0.0;

			resource.Staffing.push(allocation);
		}

		if (totalResourceInfo) {
			totalResourceInfo.Saldos['month-saldo-' + monthKey] -= delta;
		}

		if (totalDayInfo) {
			totalDayInfo.Staff += delta;
			totalDayInfo.total += delta;
		} else if (totalResourceInfo) {
			totalDayInfo = {
				Day: dateString,
				Staff: requestedHours,
				total: requestedHours,
			};

			totalResourceInfo.Staffing.push(totalDayInfo);
		}

		staffingHelper.normalizeResourceStaffing(totalResourceInfo);

		allocation.Staff = requestedHours;
		allocation.total += requestedHours;
		resource.PlannedDays += delta;

		normalizeProjectHours(project);

		sfEndpoint.updateAllocation(resource.MonthToOppLineItemIdMap[monthKey], allocationDate, requestedHours).then(function (result) {
			/* nothing to do, the interface is already updated */
		}, function (response) {
			console.log('error during allocation update:', response);

			if (totalDayInfo) {
				totalDayInfo.Staff -= delta;
				totalDayInfo.total -= delta;

				staffingHelper.normalizeResourceStaffing(totalResourceInfo);
			}

			allocation.Staff = oldHours;
			allocation.total -= requestedHours;
			resource.PlannedDays -= delta;

			normalizeProjectHours(project);

			if (response.message) {
				alert('An error occured during the allocation update:' + "\n" + response.message + "\n" + "Your changes were rolled back. Please reload the page if the error remains.");
			}
		});
	};

	$scope.buildResourceAllocationCellClasses = function (resource, day, allocation) {
		var classes = {};

		if (day) {
			classes.weekend = !!day.isWeekEnd;
			classes.past = !!day.isPast;
			classes.today = !!day.isToday;
			classes.future = !!day.isFuture;

			classes.isAllocatable = day.isAllocatable && resource.MonthToLimitMap[day.month];
			classes.isNotAllocatable = !classes.isAllocatable;

			if (day.isSaldo) {
				classes['saldo'] = true;

				var stats = resource.Saldos[day.dateString] || 0.0;

				if (day.isStatisticSaldo) {
					/* the stats may not be generated, we need to check */
					if (stats) {
						classes['negative-saldo'] = stats.actual < stats.planned;
						classes['positive-saldo'] = stats.actual > stats.planned;
						classes['neutral-saldo'] = stats.actual === stats.planned;
					} else {
						classes['no-data'] = true;
					}
				} else if (day.isUtilization) {
					var statsValue = stats ? stats.value : 0;

					classes['very-low-utilization'] = statsValue <= 0.4;
					classes['low-utilization'] = statsValue > 0.4 && statsValue < 0.6;
					classes['neutral-utilization'] = statsValue >= 0.6 && statsValue < 0.8;
					classes['high-utilization'] = statsValue >= 0.8;
				} else {
					classes['negative-saldo'] = stats && stats < 0;
					classes['positive-saldo'] = stats && stats > 0;
					classes['neutral-saldo'] = !stats;
				}
			}
		}

		if (allocation) {
			classes['has-staffing'] = !!allocation.hasStaffing;
			classes['partly-staffed'] = !!allocation.isPartlyStaffed;
			classes['fully-staffed'] = !!allocation.isFullyStaffed;

			classes['has-staffing-and-holiday'] = !!allocation.hasStaffingAndHoliday;

			/* use the combination for the overstaffed as this will be the more common case when handling part time holiday */
			classes['overstaffed'] = !!allocation.isOverStaffedOrHoliday;
		}

		if ($scope.data.ResourcesByContactId[resource.ContactId]) {
			var holidayAllocation = $scope.data.ResourcesByContactId[resource.ContactId].StaffingByDay[day.dateString];

			if (holidayAllocation) {
				classes['has-holiday'] = !!holidayAllocation.hasHoliday;
				classes['full-holiday'] = !!holidayAllocation.isFullHoliday;

				if (classes['full-holiday'] && classes.isAllocatable) {
					classes.isAllocatable = false;
					classes.isNotAllocatable = true;
				}

				classes['part-holiday'] = !!holidayAllocation.isPartlyHoliday;
			}
		}

		return classes;
	};

	$scope.buildProjectDayCellClasses = function (project, day) {
		var classes = $scope.buildDayHeaderClasses(day);

		if (project && day && day.isSaldo) {
			classes['saldo'] = true;

			var stats = project.Saldos[day.dateString] || 0.0;

			if (day.isStatisticSaldo) {
				/* the stats may not be generated, we need to check */
				if (stats) {
					classes['negative-saldo'] = stats.actual < stats.planned;
					classes['positive-saldo'] = stats.actual > stats.planned;
					classes['neutral-saldo'] = stats.actual === stats.planned;
				} else {
					classes['no-data'] = true;
				}
			} else if (day.isUtilization) {
				var statsValue = stats ? stats.value : 0;

				classes['very-low-utilization'] = statsValue <= 0.4;
				classes['low-utilization'] = statsValue > 0.4 && statsValue < 0.6;
				classes['neutral-utilization'] = statsValue >= 0.6 && statsValue < 0.8;
				classes['high-utilization'] = statsValue >= 0.8;
			} else {
				classes['negative-saldo'] = stats && stats < 0;
				classes['positive-saldo'] = stats && stats > 0;
				classes['neutral-saldo'] = !stats;
			}
		}

		return classes;
	};

	$scope.buildDayHeaderClasses = staffingHelper.buildDayHeaderClasses;
	$scope.buildResourceRowClasses = staffingHelper.buildResourceRowClasses;

	$scope.updateProjectStatus = function (project) {
		sfEndpoint.updateProjectStatus(project.OpportunityId, project.ProjectStatus);
	};

	$scope.filter.customerHasResource = function (customer) {
		for (var p = 0; p < customer.Projects.length; p++) {
			if ($scope.filter.projectHasResource(customer.Projects[p])) {
				return true;
			}
		}

		return false;
	};

	$scope.filter.projectHasResource = function (project) {
		return project.Resources && !!project.Resources.length;
	};

	/* functions for the staffing table */
	$scope.$on('updateStaffing', function (event, selectedOpportunities, selectedResources, startMonth) {
		if ($scope.$parent.status) {
			$scope.$parent.status.loading = true;
			$scope.$parent.status.loaded = false;
		}

		$scope.$emit('loadStaffingData', selectedOpportunities, selectedResources, startMonth);

		sfEndpoint.getProjectStaffing(selectedOpportunities, selectedResources, startMonth).then(function (data) {
			console.log('received data for project staffing:', data);

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
					dateString: 'week-stats-' + month.number + '-' + week.number,
					weekDay: 'Dw',
					tooltip: 'Days of the week',
					isSaldo: true,
					isStatisticSaldo: true
				});
			};

			var createSaldoColumns = function (month) {
				dayCount += 3;

				month.dayCount += 3;
				month.weeks[month.weeks.length - 1].dayCount += 3;

				createWeekStatsColumn(month, month.weeks[month.weeks.length - 1]);

				$scope.viewState.staffingDays.push({
					dateString: 'month-stats-' + month.number,
					weekDay: 'Dm',
					tooltip: 'Days of the month',
					isSaldo: true,
					isStatisticSaldo: true
				});

				$scope.viewState.staffingDays.push({
					dateString: 'month-saldo-' + month.number,
					weekDay: 'Month saldo',
					isSaldo: true,
					isMonthSaldo: true
				});

				$scope.viewState.staffingDays.push({
					dateString: 'month-utilization-' + month.number,
					weekDay: 'Utilization',
					isSaldo: true,
					isUtilization: true
				});
			};

			/* iterate all days and build an array with all months, weeks and days to be able to build the html table */
			for (var currentDate = new Date($scope.viewState.startDate.getTime()); currentDate <= $scope.viewState.endDate; currentDate.setDate(currentDate.getDate() + 1)) {
				dayCount++;

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

					/* month change with forthgoing week */
					if (lastWeek && lastWeek.number === dateInfo.week) {
						lastMonth.weeks.push(lastWeek);
					}

					$scope.viewState.staffingMonths.push(lastMonth);
				}

				if (!lastWeek || lastWeek.number !== dateInfo.week) {
					lastWeek = {
						number: dateInfo.week,
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
				lastWeek.dayCount++;
				lastWeek.workDayCount += dateInfo.isWeekEnd ? 0 : 1;

				lastMonth.dayCount++;
				lastMonth.workDayCount += dateInfo.isWeekEnd ? 0 : 1;

				$scope.viewState.staffingDays.push(dateInfo);
			}

			createSaldoColumns(lastMonth);

			$scope.data.Customers = [];
			$scope.data.Resources = [];
			$scope.data.ResourcesByContactId = {};
			$scope.data.ResourcesByScheduleId = {};

			if (data.Resources) {
				for (var r = 0; r < data.Resources.length; r++) {
					var resource = data.Resources[r];

					resource.MonthToLimitMap = {};

					for (var m = 0; m < $scope.viewState.staffingMonths.length; m++) {
						var month = $scope.viewState.staffingMonths[m];
						resource.MonthToLimitMap[month.number] = month.workDayCount;
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
						normalizeProjectHours(customer.Projects[p]);
					}
				}

				$scope.data.Customers = data.Customers;
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
			console.log('error while retrieving project staffing data:', response);
		});
	});

	sfEndpoint.onResourceChange(function (message) {
		console.log('received resource change info', message);

		var data = message.data.sobject;
		var overallResource = $scope.data.ResourcesByContactId[data.ContactId__c];
		var projectResource = $scope.data.ResourcesByScheduleId[data.OpportunityLineItemId__c];

		if (!overallResource) {
			/* we don't currently see this resource */
			console.log('Affected resource is currently not displayed.');
			return;
		}

		var forDate = new Date(data.Scheduled_Date__c);
		var forDateString = datepicker.formatDate('yy-mm-dd', forDate);
		var newBookingValue = parseFloat(data.New_value__c) * 8;
		var oldBookingValue = parseFloat(data.Old_value__c) * 8;
		var delta = newBookingValue - oldBookingValue;

		if (projectResource) {
			var projectStaffing = projectResource.StaffingByDay[forDateString];

			if (projectStaffing && projectStaffing.Staff === newBookingValue) {
				/* we did the change, no need to update again */
				console.log('Affected project resource schedule is already up to date.');
				return;
			}

			/* update the delta to be based on our current value */
			delta = newBookingValue - projectStaffing.Staff;
		}

		$scope.$apply(function () {
			[overallResource, projectResource].forEach(function (resource) {
				if (!resource) {
					return;
				}

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
	});

	/* initialize data */
	sfEndpoint.getProjectHealthReasons().then(function (reasons) {
		console.log('received project health reasons', reasons);
		$scope.viewState.projectHealthReasons = reasons;
	});

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

/* interface extensions */
PsoTable2.ng.directive('navigateCellInputs', function () {
	/* up, right, down, left */
	var arrowKeys = [38,39,40,37];

	return {
		restrict: 'A',
		link: function (scope, el, attributes) {
			el.on('focus', 'input', function (e) {
				var target = $(e.target);

				var cell = target.closest('td');
				var row = target.closest('tr');
				var table = target.closest('table');

				$('td', table).removeClass('focus');
				$('tr', table).removeClass('focus');

				cell.addClass('focus');
				row.addClass('focus');
			});

			el.on('blur', 'input', function (e) {
				var target = $(e.target);
				var table = target.closest('table');

				$('td', table).removeClass('focus');
				$('tr', table).removeClass('focus');
			});

			el.on('keydown', 'input', function (e) {
				var arrowKey = arrowKeys.indexOf(e.which);

				if (e.shiftKey || arrowKey === -1) {
					return;
				}

				e.preventDefault();

				var target = $(e.target);

				var cell = target.closest('td');
				var row = target.closest('tr');
				var table = target.closest('table');

				var targetInput;

				switch (arrowKey) {
					case 0:
						/* up */
						var allCells = $('td', row);
						var allRows = $('tr', table);

						var cellIndex = allCells.index(cell);

						/* iterate over all previous rows until we find an input */
						for (var rowIndex = allRows.index(row); rowIndex > 0; rowIndex--) {
							var targetRow = allRows.get(rowIndex - 1);
							var targetCell = $('td', targetRow).get(cellIndex);

							if (targetCell) {
								targetInput = $('input', targetCell);

								if (targetInput && targetInput.length) {
									break;
								}
							}
						}
						break;
					case 1:
						/* right */
						/* try the next cell */
						targetInput = $('input', cell.next());

						if (!targetInput || !targetInput.length) {
							/* this did not work out, propably week end, try all following siblings */
							targetInput = $('input', cell.nextAll()).first();
						}
						break;
					case 2:
						/* down */
						var allCells = $('td', row);
						var allRows = $('tr', table);

						var cellIndex = allCells.index(cell);
						var rowIndex = allRows.index(row);

						/* iterate over all following rows until we find an input */
						for (var rowIndex = allRows.index(row); rowIndex < allRows.length - 1; rowIndex++) {
							var targetRow = allRows.get(rowIndex + 1);
							var targetCell = $('td', targetRow).get(cellIndex);

							if (targetCell) {
								targetInput = $('input', targetCell);

								if (targetInput && targetInput.length) {
									break;
								}
							}
						}
						break;
					case 3:
						/* left */
						/* try the previous cell */
						targetInput = $('input', cell.prev());

						if (!targetInput || !targetInput.length) {
							/* this did not work out, propably week start, try all previous siblings */
							targetInput = $('input', cell.prevAll()).last();
						}
						break;
				};

				if (targetInput && targetInput.length) {
					targetInput.focus();
				}
			});
		}
	};
});

PsoTable2.ng.directive('staffingCaptionsSpacing', ['$timeout', '$window', function ($timeout, $window) {
	return {
		'restrict': 'A',
		'link': function (scope, el, attributes) {
			var captionsContainer = $(attributes.staffingCaptionsSpacing);

			var updateMargin = function () {
				el.css('margin-left', captionsContainer.width());
			};

			/*
			 * Ok, this is a little bit tricky, the solution is copied from
			 * http://stackoverflow.com/questions/21138388/angular-js-identify-an-digest-complete-event-and-removing-from-url-in-angular
			 *
			 * First, we listen for the updatedStaffingData event, which tells us the PsoTable2Staffing controller updated the data
			 * (see above in the controller). Second, we register a $watch without an expression, meaning we'll get each $digest cycle end.
			 * As we only want to do this once, we immediately unregister the $watch after the first call. Lastly, we use $timeout to let the browser
			 * end this thread, render the dom and have the proper width of the target element at hand when being run asynchronously.
			 */
			scope.$on('updatedStaffingData', function () {
				var unregisterWatch = scope.$watch(function () {
					unregisterWatch();
					$timeout(updateMargin, 0, false);
				});
			});

			$($window).on('resize', function () {
				updateMargin();
			});

			updateMargin();
		}
	};
}]);