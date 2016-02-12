public with sharing class PsoTable2Controller {
	@RemoteAction
	public static String getFilterOptions(Datetime startMonth) {
		return PsoToolController.getInstance().setStartDate(startMonth.date()).getFilterValues().JSON();
	}

	@RemoteAction
	public static String getProjectStaffing(List<String> opportunityIds, List<String> resourceIds, Datetime startMonth) {
		PsoToolController instance = PsoToolController.getInstance();

		if (!opportunityIds.isEmpty() && opportunityIds[0] != '__none') {
			instance.setSelectedOpportunities(opportunityIds);
		}

		if (!resourceIds.isEmpty() && resourceIds[0] != '__none' && resourceIds[0] != '__related') {
			instance.setSelectedContacts(resourceIds);
		}

		instance.setStartDate(startMonth.date());

		PsoToolController.PsoToolDataSetWrapper data = instance.getDataSet();

		data.StartDate = formatDate(data.StartDate);
		data.EndDate = formatDate(data.EndDate);

		if (data.Customers != null) {
			for (PsoToolController.Customer customer : data.Customers) {
				for (PsoToolController.Project project : customer.Projects) {
					for (PsoToolController.Resource resource : project.Resources) {
						for (PsoToolController.Staffing staffing : resource.Staffing) {
							staffing.Day = formatDate(staffing.Day);
						}
						for (PsoToolController.Stats stat : resource.Statistics) {
							stat.StartDate = formatDate(stat.StartDate);
							stat.EndDate = formatDate(stat.EndDate);
						}
					}
				}
			}
		}

		if (data.Resources != null) {
			for (PsoToolController.ResourceInfo resource : data.Resources) {
				for (PsoToolController.Staffing staffing : resource.Staffing) {
					staffing.Day = formatDate(staffing.Day);
				}
				for (PsoToolController.Stats stat : resource.Statistics) {
					stat.StartDate = formatDate(stat.StartDate);
					stat.EndDate = formatDate(stat.EndDate);
				}
			}
		}

		return data.JSON();
	}

	@RemoteAction
	public static PsoToolController.Result updateAllocation(String allocationIdId, Datetime day, Decimal hours) {
		return PsoToolController.getInstance().allocateResource(allocationIdId, day.date(), hours / 8);
	}

	@RemoteAction
	public static String getProjectHealthReasons() {
		return PsoToolController.getInstance().getProjectHealthReasons().JSON();
	}

	@RemoteAction
	public static void updateProjectStatus(String opportunityId, String status) {
		PsoToolController.getInstance().setProjectHealthReason(opportunityId, status);
	}

	private static String formatDate(String localDateString) {
		if (String.isBlank(localDateString)) {
			return '';
		}

		Date dateObj = Date.parse(localDateString);
		String month = String.valueOf(dateObj.month());
		String day = String.valueOf(dateObj.day());

		if (month.length() < 2) {
			month = '0' + month;
		}

		if (day.length() < 2) {
			day = '0' + day;
		}

		return dateObj.year() + '-' + month + '-' + day;
	}
}