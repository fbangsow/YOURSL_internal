PsoTable2.ng.controller('PsoTable2Staffing', ['$scope', 'PsoTable2Endpoint', 'jQuery.ui.datepicker', 'alert', function ($scope, sfEndpoint, datepicker, alert) {
	console.log('init staffing controller');

	$scope.status = {
		loaded: false,
		loading: false
	};

	$scope.viewState = {
		startDate: null,
		endDate: null,
		staffingColumns: 0,
		staticStaffingColumns: 0,
		staffingDayColumns: 0,
		staffingMonths: [],
		staffingWeeks: [],
		staffingDays: []
	};

	/* restructure the staffings for each resource to be accessible by date */
	var normalizeProjectHours = function (project) {
		console.log('normalize project hours', project);
		project.SoldDays = 0;
		project.PlannedDays = 0;
		project.BookedHoursByDay = {};
		project.MonthSaldos = {};

		for (var r = 0; r < project.Resources.length; r++) {
			var resource = project.Resources[r];

			resource.StaffingByDay = {};
			resource.MonthSaldos = {};

			if (resource.MonthToLimitMap) {
				/* initialize the month saldo to the complete budget, we'll reduce by the planned hours later */
				for (monthKey in resource.MonthToLimitMap) {
					if (resource.MonthToLimitMap.hasOwnProperty(monthKey)) {
						var budgetForMonth = parseFloat(resource.MonthToLimitMap[monthKey]) * 8;

						resource.MonthSaldos['monthSaldo-' + monthKey] = budgetForMonth;

						if (!project.MonthSaldos['monthSaldo-' + monthKey]) {
							project.MonthSaldos['monthSaldo-' + monthKey] = 0;
						}

						project.MonthSaldos['monthSaldo-' + monthKey] += budgetForMonth;
					}
				}
			}

			/* float values including decimals are not converted to float, but string */
			resource.SoldDays = parseFloat((resource.SoldDays + "").replace(',', '.'));
			resource.PlannedDays = parseFloat((resource.PlannedDays + "").replace(',', '.'));

			project.SoldDays += resource.SoldDays;
			project.PlannedDays += resource.PlannedDays;

			/*
				Resort, we need the Staffing to be ordered by ascending date.
				Additionally we add a date field containing a JS Date object constructed from the Day string.
			*/
			resource.Staffing.sort(function (left, right) {
				if (!left.date) {
					left.date = new Date(left.Day);
				}

				if (!right.date) {
					right.date = new Date(right.Day);
				}

				return left.date.getTime() - right.date.getTime();
			});

			for (var s = 0; s < resource.Staffing.length; s++) {
				var staffing = resource.Staffing[s];

				/**
				 * {
					Day: '2016-01-28',
					Staff: 4.25,
					HoursOff: 0.75
				 }
				 */
				if (!staffing.date) {
					staffing.date = new Date(staffing.Day);
				}

				staffing.month = datepicker.formatDate('m', staffing.date);
				staffing.currentBooking = staffing.Staff || 0;

				/* fully booked means 80% of 8 hours */
				var hoursPerDay = 8;
				var fullyBookedTreshold = hoursPerDay * 0.8;

				/* booking means an allocation to a project, not holidays */
				staffing.hasBooking = staffing.Staff > 0;
				staffing.isPartlyBooked = staffing.hasBooking && staffing.Staff < fullyBookedTreshold;
				staffing.isFullyBooked = staffing.Staff >= fullyBookedTreshold && staffing.Staff <= hoursPerDay;
				staffing.isOverBooked = staffing.Staff > hoursPerDay;

				staffing.hasHoliday = staffing.HoursOff > 0;
				staffing.isPartlyHoliday = staffing.hasHoliday && staffing.HoursOff < fullyBookedTreshold;
				staffing.isFullHoliday = staffing.HoursOff >= fullyBookedTreshold;

				resource.StaffingByDay[staffing.Day] = staffing;

				if (!project.BookedHoursByDay[staffing.Day]) {
					project.BookedHoursByDay[staffing.Day] = 0;
				}

				project.BookedHoursByDay[staffing.Day] = staffing.Staff;

				[resource, project].forEach(function (context) {
					if (!context.MonthSaldos['monthSaldo-' + staffing.month]) {
						context.MonthSaldos['monthSaldo-' + staffing.month] = 0;
					}

					context.MonthSaldos['monthSaldo-' + staffing.month] -= staffing.currentBooking;
				});
			}
		}
	};

	$scope.staffing = {};

	$scope.staffing.updateAllocation = function (project, resource, allocationDate, allocation) {
		allocation = allocation || {};

		var isNewAllocation = !allocation.Day;
		var dateString = datepicker.formatDate('yy-mm-dd', allocationDate);
		var requestedHours = parseFloat(allocation.currentBooking) || 0.0;
		var oldHours = !isNewAllocation ? allocation.Staff : 0.0;
		var hoursOff = !isNewAllocation ? allocation.HoursOff : 0.0;

		if (oldHours === requestedHours) {
			return;
		}

		console.log(project);
		console.log(resource);
		console.log(allocationDate);
		console.log(allocation);

		var rh4 = requestedHours * 4;
		if (rh4 - parseInt(rh4, 10)) {
			allocation.currentBooking = oldHours;

			alert('Hour entries must be divisible by a quarter hour. The minimum are 15 minutes (0.25 hours).');
			return;
		}

		if (requestedHours < 0) {
			allocation.currentBooking = oldHours;

			alert('Please enter a positive number or 0 to remove the allocation.');
			return;
		}

		if (hoursOff + requestedHours > 8) {
			if (hoursOff + requestedHours > 12) {
				allocation.currentBooking = oldHours;
				if (hoursOff) {
					alert('This allocation will exceed the maximum allowed 12 hours per day for a resource. Please be aware of the existing PTO hours.');
				} else {
					alert('This allocation will exceed the maximum allowed 12 hours per day for a resource.')
				}

				return;
			}

			alert('This allocation will exceed 8 hours per day for this resource.');
			/* do not return here, exceeding 8 hours is allowed. */
		}

		var monthKey = datepicker.formatDate('m', allocationDate);

		if (!resource.MonthToLimitMap || !resource.MonthToLimitMap[monthKey]) {
			allocation.currentBooking = oldHours;

			alert('No contingent available for ' + resource.ResourceName + ' in this month. Please check with Sales Operations Team for adjustments.');
			return;
		}

		/* the currentMonthHours will containing a project bookings without the currently affected day */
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

			alert('The allocation of additional ' + requestedHours + ' hours for ' + resource.ResourceName + ' exceeds the month limit of ' + resource.MonthToLimitMap[monthKey] + ' hours. The resource has ' + availableHours + ' hours left for this month.');
			return;
		}

		console.log('allocation is fine, persist.');

		delta = requestedHours - oldHours;

		/* after validating we associate the hours and recalculate the sums */
		if (isNewAllocation) {
			/* populate the new allocation to contain the required data */
			allocation.Day = dateString;
			allocation.HoursOff = 0.0;

			resource.Staffing.push(allocation);
		}

		allocation.Staff = requestedHours;
		resource.PlannedDays += delta;

		normalizeProjectHours(project);

		sfEndpoint.updateAllocation(resource.MonthToOppLineItemIdMap[monthKey], allocationDate, requestedHours).then(function (result) {
			/* nothing to do, the interface is already updated */
		}, function (response) {
			console.log(response);
		});
	};

	$scope.buildResourceAllocationCellClasses = function (resource, day, allocation) {
		var classes = {};

		if (day) {
			classes.weekend = !!day.isWeekEnd;
			classes.past = !!day.isPast;
			classes.today = !!day.isToday;
			classes.future = !!day.isFuture;

			if (day.isMonthSaldo) {
				classes['month-saldo'] = true;
				classes['negative-saldo'] = resource.MonthSaldos[day.dateString] && resource.MonthSaldos[day.dateString] < 0;
				classes['positive-saldo'] = resource.MonthSaldos[day.dateString] && resource.MonthSaldos[day.dateString] > 0;
				classes['neutral-saldo'] = !resource.MonthSaldos[day.dateString];
			}
		}

		if (allocation) {
			classes['has-booking'] = !!allocation.hasBooking;
			classes['partly-booked'] = !!allocation.isPartlyBooked;
			classes['fully-booked'] = !!allocation.isFullyBooked;
			classes['overbooked'] = !!allocation.isOverbooked;
			classes['has-holiday'] = !!allocation.hasHoliday;
			classes['full-holiday'] = !!allocation.isFullHoliday;
			classes['part-holiday'] = !!allocation.isPartlyHoliday;
		}

		return classes;
	};

	$scope.buildProjectDayCellClasses = function (project, day) {
		var classes = {};

		if (day) {
			classes.weekend = !!day.isWeekEnd;
			classes.past = !!day.isPast;
			classes.today = !!day.isToday;
			classes.future = !!day.isFuture;

			if (day.isMonthSaldo) {
				classes['month-saldo'] = true;
				classes['negative-saldo'] = project.MonthSaldos[day.dateString] && project.MonthSaldos[day.dateString] < 0;
				classes['positive-saldo'] = project.MonthSaldos[day.dateString] && project.MonthSaldos[day.dateString] > 0;
				classes['neutral-saldo'] = !project.MonthSaldos[day.dateString];
			}
		}

		return classes;
	};

	/* functions for the staffing table */
	$scope.$on('updateStaffing', function (event, selectedOpportunities, startMonth) {
		$scope.status.loading = true;
		$scope.status.loaded = false;

		sfEndpoint.getProjectStaffing(selectedOpportunities, startMonth).then(function (data) {
			console.log(data);

			/* we need to equalize the time to be able to detect today */
			$scope.viewState.startDate = new Date(data.StartDate);
			$scope.viewState.startDate.setHours(0);
			$scope.viewState.startDate.setMinutes(0);
			$scope.viewState.startDate.setSeconds(0);
			$scope.viewState.startDate.setMilliseconds(0);

			$scope.viewState.endDate = new Date(data.EndDate);
			$scope.viewState.endDate.setHours(0);
			$scope.viewState.endDate.setMinutes(0);
			$scope.viewState.endDate.setSeconds(0);
			$scope.viewState.endDate.setMilliseconds(0);

			var today = new Date();
			today.setHours(0);
			today.setMinutes(0);
			today.setSeconds(0);
			today.setMilliseconds(0);

			$scope.viewState.staffingMonths.splice(0, $scope.viewState.staffingMonths.length);
			$scope.viewState.staffingWeeks.splice(0, $scope.viewState.staffingWeeks.length);
			$scope.viewState.staffingDays.splice(0, $scope.viewState.staffingDays.length);

			var lastMonth = null;
			var lastWeek = null;
			var dayCount = 0;

			var createSaldoColumn = function (month) {
				month.dayCount++;
				month.weeks[month.weeks.length - 1].dayCount++;

				$scope.viewState.staffingDays.push({
					dateString: 'monthSaldo-' + month.number,
					isMonthSaldo: true
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

				if (!lastMonth || lastMonth.number !== dateInfo.month) {
					if (lastMonth) {
						/* make place for the saldo column */
						createSaldoColumn(lastMonth);
					}

					lastMonth = {
						caption: dateInfo.monthName,
						number: dateInfo.month,
						weeks: [],
						weekCount: 0,
						dayCount: 0
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

			createSaldoColumn(lastMonth);

			for (var c = 0; c < data.Customers.length; c++) {
				var customer = data.Customers[c];
				for (var p = 0; p < customer.Projects.length; p++) {
					normalizeProjectHours(customer.Projects[p]);
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