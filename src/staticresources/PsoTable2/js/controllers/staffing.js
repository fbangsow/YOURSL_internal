PsoTable2.ng.controller('PsoTable2Staffing', ['$scope', 'PsoTable2Endpoint', 'jQuery.ui.datepicker', 'alert', function ($scope, sfEndpoint, datepicker, alert) {
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

	$scope.data = {};

	var normalizeStaffing = function (staffing) {
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

		/*
		 * When hoursOff are set, they are also included in the Staff attribute.
		 * We remove them from the Staff to be able to later differentiate between both values.
		 */
		staffing.HoursOff = staffing.HoursOff || 0;
		staffing.Staff = (staffing.Staff || 0) - staffing.HoursOff;

		staffing.total = staffing.Staff + staffing.HoursOff;

		staffing.month = datepicker.formatDate('m', staffing.date);
		staffing.currentBooking = staffing.Staff;

		/* fully booked means 80% of 8 hours */
		var hoursPerDay = 8;
		var fullyBookedTreshold = hoursPerDay * 0.8;

		/*
		 * We calculate the booking state with both project allocation and holidays.
		 * Default project allocations do not have holidays (total == Staff) and availability infos
		 * should check both (Staff and HoursOff) for this. In both cases total is the number we that
		 * provides the proper info.
		 */
		staffing.hasBooking = staffing.total > 0;
		staffing.isPartlyBooked = staffing.hasBooking && staffing.total < fullyBookedTreshold;
		staffing.isFullyBooked = staffing.total >= fullyBookedTreshold && staffing.total <= hoursPerDay;
		staffing.isOverBooked = staffing.total > hoursPerDay;

		staffing.hasHoliday = staffing.HoursOff > 0;
		staffing.isPartlyHoliday = staffing.hasHoliday && staffing.HoursOff < fullyBookedTreshold;
		staffing.isFullHoliday = staffing.HoursOff >= fullyBookedTreshold;
	};

	var normalizeResourceStaffing = function (resource, project) {
		resource.StaffingByDay = {};
		resource.MonthSaldos = {};

		if (resource.MonthToLimitMap) {
			/* initialize the month saldo to the complete budget, we'll reduce by the planned hours later */
			for (monthKey in resource.MonthToLimitMap) {
				if (resource.MonthToLimitMap.hasOwnProperty(monthKey)) {
					var budgetForMonth = parseFloat(resource.MonthToLimitMap[monthKey]) * 8;

					resource.MonthSaldos['budget-' + monthKey] = budgetForMonth;
					resource.MonthSaldos['saldo-' + monthKey] = budgetForMonth;
					resource.MonthSaldos['utilization-' + monthKey] = 0;
					resource.MonthSaldos['booked-' + monthKey] = 0;
					resource.MonthSaldos['holiday-' + monthKey] = 0;

					if (project) {
						if (!project.MonthSaldos['budget-' + monthKey]) {
							project.MonthSaldos['budget-' + monthKey] = 0;
						}

						if (!project.MonthSaldos['saldo-' + monthKey]) {
							project.MonthSaldos['saldo-' + monthKey] = 0;
						}

						project.MonthSaldos['budget-' + monthKey] += budgetForMonth;
						project.MonthSaldos['saldo-' + monthKey] += budgetForMonth;
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

		var saldos = resource.MonthSaldos;
		var projectSaldos = project ? project.MonthSaldos : null;

		for (var s = 0; s < resource.Staffing.length; s++) {
			var staffing = resource.Staffing[s];

			normalizeStaffing(staffing);

			resource.StaffingByDay[staffing.Day] = staffing;

			['budget', 'saldo', 'utilization', 'booked', 'holiday'].forEach(function (saldoType) {
				var key = saldoType + '-' + staffing.month;
				if (!saldos[key]) {
					saldos[key] = 0;
				}
			});

			saldos['saldo-' + staffing.month] -= staffing.total;
			saldos['booked-' + staffing.month] += staffing.Staff;
			saldos['holiday-' + staffing.month] += staffing.HoursOff;

			var utilizationBudget = saldos['budget-' + staffing.month] - saldos['holiday-' + staffing.month];

			if (utilizationBudget) {
				saldos['utilization-' + staffing.month] = saldos['booked-' + staffing.month] / utilizationBudget;
			} else {
				saldos['utilization-' + staffing.month] = 0;
			}

			if (project) {
				if (!project.BookedHoursByDay[staffing.Day]) {
					project.BookedHoursByDay[staffing.Day] = 0;
				}

				project.BookedHoursByDay[staffing.Day] = staffing.Staff;

				['budget', 'saldo', 'utilization', 'booked', 'holiday'].forEach(function (saldoType) {
					var key = saldoType + '-' + staffing.month;
					if (!projectSaldos[key]) {
						projectSaldos[key] = 0;
					}
				});

				projectSaldos['saldo-' + staffing.month] -= staffing.total;
				projectSaldos['booked-' + staffing.month] += staffing.Staff;
				projectSaldos['holiday-' + staffing.month] += staffing.HoursOff;

				var utilizationBudget = projectSaldos['budget-' + staffing.month] - projectSaldos['holiday-' + staffing.month];

				if (utilizationBudget) {
					projectSaldos['utilization-' + staffing.month] = projectSaldos['booked-' + staffing.month] / utilizationBudget;
				} else {
					projectSaldos['utilization-' + staffing.month] = 0;
				}
			}
		}

		for (var s = 0; s < resource.Statistics.length; s++) {
			var stat = resource.Statistics[s];

			var startDate = new Date(stat.StartDate);
			var endDate = new Date(stat.EndDate);

			var startWeek = datepicker.iso8601Week(startDate);
			var endWeek = datepicker.iso8601Week(endDate);

			var saldoKey = 'week-stats-' + endWeek;

			if (startWeek !== endWeek) {
				/* monthly stats */
				saldoKey = 'month-stats-' + datepicker.formatDate('m', endDate);
			}

			if (!saldos[saldoKey]) {
				saldos[saldoKey] = {
					'planned': 0,
					'actual': 0
				};
			}

			saldos[saldoKey].planned += stat.PlannedDays;
			saldos[saldoKey].actual += stat.ActualDays;

			if (projectSaldos) {
				if (!projectSaldos[saldoKey]) {
					projectSaldos[saldoKey] = {
						'planned': 0,
						'actual': 0
					};
				}

				projectSaldos[saldoKey].planned += stat.PlannedDays;
				projectSaldos[saldoKey].actual += stat.ActualDays;
			}
		}
	};

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

		if (!leaveCurrentValues || !context.MonthSaldos) {
			context.MonthSaldos = {};
		}
	};

	/* restructure the staffings for each resource to be accessible by date */
	var normalizeProjectHours = function (project) {
		console.log('normalize project hours', project);

		initializeResourceContext(project);

		for (var r = 0; r < project.Resources.length; r++) {
			normalizeResourceStaffing(project.Resources[r], project);
		}
	};

	$scope.staffing = {};

	$scope.staffing.updateAllocation = function (project, resource, allocationDate, allocation) {
		allocation = allocation || {};

		var isNewAllocation = !allocation.Day;
		var dateString = datepicker.formatDate('yy-mm-dd', allocationDate);
		var requestedHours = parseFloat(allocation.currentBooking) || 0.0;
		var oldHours = !isNewAllocation ? allocation.Staff : 0.0;

		var totalResourceInfo = $scope.data.ResourcesByContactId[resource.ContactId];
		var totalDayInfo = totalResourceInfo ? totalResourceInfo.StaffingByDay[dateString] : null;
		var hoursOff = totalDayInfo ? totalDayInfo.HoursOff : 0.0;
		var currentTotalExcludingCurrentHours = (totalDayInfo ? totalDayInfo.Staff : 0.0) + hoursOff - oldHours;

		if (oldHours === requestedHours) {
			return;
		}

		console.log('checking allocation data for update');
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

		delta = requestedHours - oldHours;

		if (currentTotalExcludingCurrentHours + requestedHours > 8) {
			if (currentTotalExcludingCurrentHours + requestedHours > 12) {
				allocation.currentBooking = oldHours;

				if (hoursOff) {
					alert('This allocation will exceed the maximum allowed 12 hours per day for a resource. Please be aware of the existing PTO hours.');
				} else {
					alert('This allocation will exceed the maximum allowed 12 hours per day for a resource.')
				}

				return;
			}

			var remainingHours = Math.max(8 - currentTotalExcludingCurrentHours, 0);

			if (currentTotalExcludingCurrentHours + oldHours <= 8) {
				alert('This allocation will exceed 8 hours per day for this resource. You can allocate ' + remainingHours + ' hours for this project without exceeding 8 hours.');
			} else {
				alert('This allocation stills exceeds 8 hours per day for this resource. You can allocate ' + remainingHours + ' hours for this project without exceeding 8 hours.');
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

			alert('The allocation of additional ' + requestedHours + ' hours for ' + resource.ResourceName + ' exceeds the month limit of ' + resource.MonthToLimitMap[monthKey] + ' hours. The resource has ' + availableHours + ' hours left for this month.');
			return;
		}

		console.log('allocation is fine, persist.');

		/* after validating we associate the hours and recalculate the sums */
		if (isNewAllocation) {
			/* populate the new allocation to contain the required data */
			allocation.Day = dateString;
			allocation.HoursOff = 0.0;

			resource.Staffing.push(allocation);
		}

		if (totalDayInfo) {
			totalDayInfo.Staff += delta;
			totalDayInfo.total += delta;

			totalResourceInfo.MonthSaldos['saldo-' + monthKey] -= delta;
		}

		allocation.Staff = requestedHours;
		allocation.total += requestedHours;
		resource.PlannedDays += delta;

		normalizeProjectHours(project);

		sfEndpoint.updateAllocation(resource.MonthToOppLineItemIdMap[monthKey], allocationDate, requestedHours).then(function (result) {
			/* nothing to do, the interface is already updated */
		}, function (response) {
			console.log('error during allocation update:', response);
		});
	};

	$scope.buildResourceAllocationCellClasses = function (resource, day, allocation) {
		var classes = {};

		if (day) {
			classes.weekend = !!day.isWeekEnd;
			classes.past = !!day.isPast;
			classes.today = !!day.isToday;
			classes.future = !!day.isFuture;

			if (day.isSaldo) {
				classes['saldo'] = true;

				if (day.isStatisticSaldo) {
					/* the stats may not be generated, we need to check */
					if (resource.MonthSaldos[day.dateString]) {
						var stats = resource.MonthSaldos[day.dateString];

						classes['negative-saldo'] = stats.actual < stats.planned;
						classes['positive-saldo'] = stats.actual > stats.planned;
						classes['neutral-saldo'] = stats.actual === stats.planned;
					} else {
						classes['no-data'] = true;
					}
				} else {
					classes['negative-saldo'] = resource.MonthSaldos[day.dateString] && resource.MonthSaldos[day.dateString] < 0;
					classes['positive-saldo'] = resource.MonthSaldos[day.dateString] && resource.MonthSaldos[day.dateString] > 0;
					classes['neutral-saldo'] = !resource.MonthSaldos[day.dateString];
				}
			}
		}

		if (allocation) {
			classes['has-booking'] = !!allocation.hasBooking;
			classes['partly-booked'] = !!allocation.isPartlyBooked;
			classes['fully-booked'] = !!allocation.isFullyBooked;
			classes['overbooked'] = !!allocation.isOverBooked;
		}

		if ($scope.data.ResourcesByContactId[resource.ContactId]) {
			var holidayAllocation = $scope.data.ResourcesByContactId[resource.ContactId].StaffingByDay[day.dateString];

			if (holidayAllocation) {
				classes['has-holiday'] = !!holidayAllocation.hasHoliday;
				classes['full-holiday'] = !!holidayAllocation.isFullHoliday;
				classes['part-holiday'] = !!holidayAllocation.isPartlyHoliday;
			}
		}

		return classes;
	};

	$scope.buildProjectDayCellClasses = function (project, day) {
		var classes = $scope.buildDayHeaderClasses(day);

		if (project && day && day.isSaldo) {
			if (!day.isStatisticSaldo) {
				classes['negative-saldo'] = project.MonthSaldos[day.dateString] && project.MonthSaldos[day.dateString] < 0;
				classes['positive-saldo'] = project.MonthSaldos[day.dateString] && project.MonthSaldos[day.dateString] > 0;
				classes['neutral-saldo'] = !project.MonthSaldos[day.dateString];
			}
		}

		return classes;
	};

	$scope.buildDayHeaderClasses = function (day) {
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

	$scope.buildResourceRowClasses = function (resource) {
		var classes = {};

		classes.yourslEmployee = resource.AccountName === 'YOUR SL GmbH';
		classes.billable = resource.SalesPrice > 0;

		if (!resource.SalesPrice && typeof resource.SalesPrice !== 'undefined') {
			classes.unbillable = !resource.SalesPrice;
		}

		return classes;
	};

	$scope.updateProjectStatus = function (project) {
		sfEndpoint.updateProjectStatus(project.OpportunityId, project.ProjectStatus);
	};

	var normalizeTime = function (d) {
		d.setHours(0);
		d.setMinutes(0);
		d.setSeconds(0);
		d.setMilliseconds(0);
	};

	/* functions for the staffing table */
	$scope.$on('updateStaffing', function (event, selectedOpportunities, selectedResources, startMonth) {
		if ($scope.$parent.status) {
			$scope.$parent.status.loading = true;
			$scope.$parent.status.loaded = false;
		}

		sfEndpoint.getProjectStaffing(selectedOpportunities, selectedResources, startMonth).then(function (data) {
			console.log('received data for project staffing:', data);

			/* we need to equalize the time to be able to detect today */
			$scope.viewState.startDate = new Date(data.StartDate);
			normalizeTime($scope.viewState.startDate);

			$scope.viewState.endDate = new Date(data.EndDate);
			normalizeTime($scope.viewState.endDate);

			var today = new Date();
			normalizeTime(today);

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
					dateString: 'week-stats-' + week.number,
					weekDay: 'Dw',
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
					isSaldo: true,
					isStatisticSaldo: true
				});

				$scope.viewState.staffingDays.push({
					dateString: 'saldo-' + month.number,
					weekDay: 'Month saldo',
					isSaldo: true,
					isMonthSaldo: true
				});

				$scope.viewState.staffingDays.push({
					dateString: 'utilization-' + month.number,
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

			if (data.Resources) {
				for (var r = 0; r < data.Resources.length; r++) {
					var resource = data.Resources[r];

					resource.MonthToLimitMap = {};

					for (var m = 0; m < $scope.viewState.staffingMonths.length; m++) {
						var month = $scope.viewState.staffingMonths[m];
						resource.MonthToLimitMap[month.number] = month.workDayCount;
					}

					normalizeResourceStaffing(resource);

					$scope.data.ResourcesByContactId[data.Resources[r].ContactId] = data.Resources[r];
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

			console.log('finished data update');
		}, function (response) {
			$scope.status.error = response;
			console.log('error while retrieving project staffing data:', response);
		});
	});

	/* initialize data */
	sfEndpoint.getProjectHealthReasons().then(function (reasons) {
		console.log('received project health reasons', reasons);
		$scope.viewState.projectHealthReasons = reasons;
	})
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

				if (arrowKey === -1) {
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