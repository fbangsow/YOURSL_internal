public with sharing class PsoTable2Controller {
	@RemoteAction
	public static String getFilterOptions() {
		return PsoToolController.getInstance().getFilterValues().JSON();
	}

	@RemoteAction
	public static String getProjectStaffing(List<String> opportunityIds, Datetime startMonth) {
		PsoToolController.PsoToolDataSetWrapper data = PsoToolController.getInstance().setSelectedOpportunities(opportunityIds).setStartDate(startMonth.date()).getDataSet();

		data.StartDate = formatDate(data.StartDate);
		data.EndDate = formatDate(data.EndDate);

		if (!data.Customers.isEmpty()) {
			for (PsoToolController.Customer customer : data.Customers) {
				if (!customer.Projects.isEmpty()) {
					for (PsoToolController.Project project : customer.Projects) {
						if (!project.Resources.isEmpty()) {
							for (PsoToolController.Resource resource : project.Resources) {
								if (!resource.Staffing.isEmpty()) {
									for (PsoToolController.Staffing staffing : resource.Staffing) {
										staffing.Day = formatDate(staffing.Day);
									}
								}
							}
						}
					}
				}
			}
		}

		return data.JSON();
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