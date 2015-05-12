public class WeeklyTimesheetsAdminCont {

	public list<Time_Bong__c> weeklyTimeSheets {get;set;}

	public opportunity oppStart{get;set;} //used because it has a date field
	public opportunity oppEnd{get;set;} //used because it has a date field
	
	public string user{get; set;} 
	public List<SelectOption> Users {
    	get {
    			/* problematic - there is no select distinct, will crush if there are too many Time_Bong__c
    			List<Time_Bong__c> WTSs = new List<Time_Bong__c>([SELECT user__c FROM Time_Bong__c]);
    			Set<id> userIDs = new Set<id>();
    			for(Time_Bong__c t : WTSs) {
    				userIDs.add(t.user__c);
    			}*/
    			list<Time_Entry_User__c> Users = new list<Time_Entry_User__c>([SELECT id, Name FROM Time_Entry_User__c]);
	    		List<SelectOption> UserNames = new List<SelectOption>();	
	    		UserNames.add(new SelectOption('All', 'All'));						
	    		for(Time_Entry_User__c u : Users) {
	    			UserNames.add(new SelectOption(u.id, u.Name));
	    		}
	    		return UserNames;
    	} 
	    set;
	}
	
	public WeeklyTimesheetsAdminCont() {
		oppStart = new Opportunity(CloseDate=GPL.getMonday(Date.Today()-63)); //ten weeks back
		oppEnd = new Opportunity(CloseDate=GPL.getMonday(Date.Today()));
		user = 'All';
		showTimeSheets();
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
		if(user == 'All') {
			query = 'SELECT Name, id, Start_Date__c, End_Date__c,' +
					' Total_hours_worked_billable__c, Total_hours_worked_non_billable__c,' + 
					' Days_overdue__c, approved__c' + 
					' FROM Time_Bong__c ' + 
		          	' WHERE Start_Date__c >= ' + startDateStr +
		          	' AND Start_Date__c <= ' + endDateStr; 
		} else {
			query = 'SELECT Name, id, Start_Date__c, End_Date__c,' +
					' Total_hours_worked_billable__c, Total_hours_worked_non_billable__c,' + 
					' Days_overdue__c, approved__c' + 
					' FROM Time_Bong__c ' + 
					' WHERE Time_Entry_User__c = \'' + user + '\'' +
		          	' AND Start_Date__c >= ' + startDateStr +
		          	' AND Start_Date__c <= ' + endDateStr; 
		}
		weeklyTimeSheets = Database.query(query);

	}

}