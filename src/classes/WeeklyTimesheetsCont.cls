public class WeeklyTimesheetsCont {

	public list<Time_Bong__c> weeklyTimeSheets {get;set;}

	public opportunity oppStart{get;set;} //used because it has a date field
	public opportunity oppEnd{get;set;} //used because it has a date field

	public WeeklyTimesheetsCont() {
		oppStart = new Opportunity(CloseDate=GPL.getMonday(Date.Today()-63)); //ten weeks back
		oppEnd = new Opportunity(CloseDate=GPL.getMonday(Date.Today()));
		showTimeSheets();
	}

	public pageReference newTimeEntry() {
		return new PageReference(Page.TimeEntry.getURL() + '?user=' + System.Userinfo.getuserid() + '&retURL=' + ApexPages.currentPage().getUrl());		
	}
	
	public void showTimeSheets() {
		Date startDate;
		Date endDate;
		string startDateStr;
		string endDateStr;
		string query;
		
		startDate = GPL.getMonday(oppStart.CloseDate);
		endDate = GPL.getMonday(oppEnd.CloseDate);
		if(endDate < startDate) {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Start date has to be earlier than end date!'));
			return;
		}
		startDateStr = string.valueof(startDate.year()) + '-' + GPL.padIntegerWithZero(startDate.month()) + '-' + GPL.padIntegerWithZero(startDate.day());
		endDateStr = string.valueof(endDate.year()) + '-' + GPL.padIntegerWithZero(endDate.month()) + '-' + GPL.padIntegerWithZero(endDate.day());
		query = 'SELECT Name, id, Start_Date__c, End_Date__c,' +
				' Total_hours_worked_billable__c, Total_hours_worked_non_billable__c,' + 
				' Days_overdue__c, approved__c' + 
				' FROM Time_Bong__c ' + 
				' WHERE Time_Entry_User__r.user__c = \'' + System.Userinfo.getuserid() + '\'' +
	          	' AND Start_Date__c >= ' + startDateStr +
	          	' AND Start_Date__c <= ' + endDateStr; 
		weeklyTimeSheets = Database.query(query);

	}
}