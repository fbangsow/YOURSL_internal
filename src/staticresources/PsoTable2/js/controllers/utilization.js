PsoTable2.ng.controller('PsoTable2Utilization', ['$scope', '$interval', 'PsoTable2Endpoint', 'datepicker', 'alert', function ($scope, $interval, sfEndpoint, datepicker, alert) {
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

	var normalizeResourceStaffing = function (resource) {
		console.log('normalize resource staffing for resource', resource);

		resource.StaffingByDay = {};
		resource.MonthSaldos = {};

		if (resource.MonthToLimitMap) {
			/* initialize the month saldo to the complete budget, we'll reduce by the planned hours later */
			for (monthKey in resource.MonthToLimitMap) {
				if (resource.MonthToLimitMap.hasOwnProperty(monthKey)) {
					var budgetForMonth = parseFloat(resource.MonthToLimitMap[monthKey]) * 8;

					resource.MonthSaldos['month-budget-' + monthKey] = budgetForMonth;
					resource.MonthSaldos['month-saldo-' + monthKey] = budgetForMonth;
					resource.MonthSaldos['month-utilization-' + monthKey] = 0;
					resource.MonthSaldos['month-booked-' + monthKey] = 0;
					resource.MonthSaldos['month-holiday-' + monthKey] = 0;
				}
			}
		}

		if (resource.WeekToLimitMap) {
			/* initialize the week saldo to the complete budget, we'll reduce by the planned hours later */
			for (weekNumber in resource.WeekToLimitMap) {
				if (resource.WeekToLimitMap.hasOwnProperty(weekNumber)) {
					var budgetForWeek = parseFloat(resource.WeekToLimitMap[weekNumber]) * 8;

					resource.MonthSaldos['week-budget-' + weekNumber] = budgetForWeek;
					resource.MonthSaldos['week-saldo-' + weekNumber] = budgetForWeek;
					resource.MonthSaldos['week-utilization-' + weekNumber] = 0;
					resource.MonthSaldos['week-booked-' + weekNumber] = 0;
					resource.MonthSaldos['week-holiday-' + weekNumber] = 0;
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

		for (var s = 0; s < resource.Staffing.length; s++) {
			var staffing = resource.Staffing[s];

			normalizeStaffing(staffing);

			resource.StaffingByDay[staffing.Day] = staffing;

			var contexts = {
				month: staffing.month,
				week: staffing.month + '-' + staffing.week
			};

			for (var contextType in contexts) {
				if (contexts.hasOwnProperty(contextType)) {
					var context = contexts[contextType];

					[contextType + '-budget', contextType + '-saldo', contextType + '-utilization', contextType + '-booked', contextType + '-holiday'].forEach(function (saldoType) {
						var key = saldoType + '-' + context;
						if (!saldos[key]) {
							saldos[key] = 0;
						}
					});

					saldos[contextType + '-saldo-' + context] -= staffing.total;
					saldos[contextType + '-booked-' + context] += staffing.Staff;
					saldos[contextType + '-holiday-' + context] += staffing.HoursOff;

					var utilizationBudget = saldos[contextType + '-budget-' + context] - saldos[contextType + '-holiday-' + context];

					if (utilizationBudget) {
						saldos[contextType + '-utilization-' + context] = saldos[contextType + '-booked-' + context] / utilizationBudget;
					} else {
						saldos[contextType + '-utilization-' + context] = 0;
					}

				}
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
			classes.isAllocatable = !!day.isAllocatable;
			classes.isNotAllocatable = !day.isAllocatable;

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
						classes['very-low-utilization'] = stats <= 0.4;
						classes['low-utilization'] = stats > 0.4 && stats < 0.6;
						classes['neutral-utilization'] = stats >= 0.6 && stats < 0.8;
						classes['high-utilization'] = stats >= 0.8;
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

		selectedOpportunities = ['__related'];

		$scope.$emit('loadStaffingData', selectedOpportunities, selectedResources, startMonth);

		sfEndpoint.getProjectStaffing(selectedOpportunities, selectedResources, startMonth).then(function (data) {
			console.log('received data for project utilization:', data);

			$scope.$emit('receivedStaffingData', data, selectedOpportunities, selectedResources, startMonth);

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
					dayCount: 1,
					caption: 'Total'
				});

				$scope.viewState.staffingWeeks.push({
					dayCount: 1,
					caption: 'Remaining'
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
						number: dateInfo.week,
						month: lastMonth.number,
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
						resource.WeekToLimitMap[week.month + '-' + week.number] = week.workDayCount;
					}

					normalizeResourceStaffing(resource);

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
											resourceProject.StaffingByDay[utilizationDateString] = 0
										}

										resourceProject.StaffingByDay[utilizationDateString] += staffing.Staff;
									}
								}
							}

							if (resource.MonthToLimitMap) {
								for (monthKey in resource.MonthToLimitMap) {
									if (resource.MonthToLimitMap.hasOwnProperty(monthKey)) {
										var budgetForMonth = parseFloat(resource.MonthToLimitMap[monthKey]) * 8;

										resourceProject.StaffingByDay['month-saldo-' + monthKey] = budgetForMonth - resourceProject.StaffingByDay['month-utilization-' + monthKey];
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

			normalizeResourceStaffing(resource);
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