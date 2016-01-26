public with sharing class PsoTable2Controller {
	@RemoteAction
	public static string getFilterOptions() {
		return PsoToolController.getInstance().getFilterValues().JSON();
	}
}