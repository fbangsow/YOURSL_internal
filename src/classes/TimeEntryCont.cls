public class TimeEntryCont {
	
	string timeSheetIdField = 'CF00NL0000000KIkR_lkid'; //sb CF00NL0000000KIkR_lkid pro CF00NL0000000KIkR_lkid
	
	public Time_Entry__c timeEntry{get;set;}
	public Time_Bong__c WeeklyTimesheet{get;set;}
	public boolean isRendered{get;set;}
	public boolean isEdit{get;set;}
	
	public string OpportunityName{get; set;} 
	private List<SelectOption> OpportunityNamesP;
	public List<SelectOption> OpportunityNames {
    	get {
    		if(OpportunityNamesP == null) {
	    		OpportunityNamesP = new List<SelectOption>();
	    		list<Opportunity_Assignment__c> OAs = new list<Opportunity_Assignment__c>(
	    								[SELECT opportunity__c, opportunity__r.Name FROM Opportunity_Assignment__c
	    									WHERE Time_Entry_User__c =: timeEntryUserId]);
	    		for(Opportunity_Assignment__c OA : OAs) {
	    			OpportunityNamesP.add(new SelectOption(OA.opportunity__c, OA.opportunity__r.Name));
	    		}
    		} 
		    return OpportunityNamesP;
	    }
	    set;
	}
	
	public string ProductName{get; set;} 
	private List<SelectOption> ProductNamesP;
	public List<SelectOption> ProductNames {
    	get {
    		//ProduktRessourcenForecast
    		if(ProductNamesP == null) {
	    		ProductNamesP = new List<SelectOption>();
	    		list<Produkt_Ressourcen_Forecast__c> PRFs = new list<Produkt_Ressourcen_Forecast__c>(
	    								[SELECT Product__r.name, Product__c
	    									FROM Produkt_Ressourcen_Forecast__c
	    									WHERE Opportunity_TS_BETA__c =: OpportunityName
	    									AND Time_Entry_User__c =: timeEntryUserId]);
	    		for(Produkt_Ressourcen_Forecast__c PRF : PRFs) {
	    			ProductNamesP.add(new SelectOption(PRF.Product__c, PRF.Product__r.name));
	    		}
    		}
    		/*if(ProductNamesP == null) {
	    		ProductNamesP = new List<SelectOption>();
	    		list<OpportunityLineItem> OLIs = new list<OpportunityLineItem>(
	    								[SELECT PricebookEntry.Product2.name, PricebookEntry.Product2Id
	    									FROM OpportunityLineItem
	    									WHERE opportunityid =: OpportunityName
	    									AND contact__r.firstname =: System.Userinfo.getFirstName()
	    									AND  contact__r.lastname =: System.Userinfo.getLastName()]);
	    		for(OpportunityLineItem OLI : OLIs) {
	    			ProductNamesP.add(new SelectOption(OLI.PricebookEntry.Product2Id, OLI.PricebookEntry.Product2.name));
	    		}
    		}*/
		    return ProductNamesP;
	    }
	    set;
	}
	
	public string fromHour{get; set;} 
	public List<SelectOption> fromHours{get; set;}
	public string toHour{get; set;} 
	public List<SelectOption> toHours{get; set;}
	
	id userId;
	string userName;
	id timeEntryUserId;
	
	/** constructor **/
	public TimeEntryCont(ApexPages.StandardController stdController) {
		isRendered = true;
    	//timeEntry = new Time_Entry__c();
    	timeEntry = (Time_Entry__c)stdController.getRecord();
    	if(timeEntry.id != null) { //edit
    		isEdit = true;
    		timeEntry = (Time_Entry__c)stdController.getRecord();
    		timeEntry = [SELECT id, From__c, to__c, opportunity__c, Billable__c,
    						opportunity__r.name, product__r.name, product__c,
    						Time_Booking__c, Time_Booking__r.Calendar_Week__c, Work_Start__c, Description_of_work__c 
    						FROM Time_Entry__c
    						WHERE Id =: timeEntry.id];
    		WeeklyTimesheet = [SELECT id, Time_Entry_User__c FROM Time_Bong__c
    							WHERE id =: timeEntry.Time_Booking__c];
    		timeEntryUserId = WeeklyTimesheet.Time_Entry_User__c;
    		OpportunityNamesP = OpportunityNames;
	    	OpportunityName = timeEntry.opportunity__c;
	    	ProductNamesP = ProductNames;
	    	ProductName = timeEntry.product__c;
	    	List<Schema.PicklistEntry> hours = Time_Entry__c.From__c.getDescribe().getPicklistValues();
	    	List<SelectOption> toHours = new List<SelectOption>();
	    	List<SelectOption> fromHours = new List<SelectOption>();
			for(Schema.PicklistEntry hour : hours) {
	        	fromHours.add(new SelectOption(hour.getValue(), hour.getValue()));
	        	toHours.add(new SelectOption(hour.getValue(), hour.getValue()));
	    	}
	    	this.fromHours = fromHours;
	    	fromHour = timeEntry.from__c;
	    	this.toHours = toHours;
	    	toHour = timeEntry.to__c;
     	} else { //new
    		isEdit = false;
     		if(ApexPages.currentPage().getParameters().get('user') != null) { //came from the page WeeklyTimesheets
   				userId = id.valueof(ApexPages.currentPage().getParameters().get('user'));
   				try {
   					timeEntryUserId = [SELECT id FROM Time_Entry_User__c WHERE User__c =: userId].id;
   				} catch(QueryException e) {
   					User u = [select name from User where id=: userId];
   					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'No Time Entry User for ' + u.name));
	    			isRendered = false;
   				}
     		} else { //came from "new" on the related list of weekly time sheet
     			string wtsId = ApexPages.currentPage().getParameters().get(timeSheetIdField); //points to the timesheet
     			timeEntryUserId = [SELECT Time_Entry_User__c FROM Time_Bong__c WHERE Id =: wtsId].Time_Entry_User__c;
     		}
     		WeeklyTimesheet = new Time_Bong__c(Time_Entry_User__c = timeEntryUserId);
    		if(isRendered) {
	    		timeEntry.Work_Start__c = Date.Today();
		    	OpportunityNamesP = OpportunityNames;
		    	if(OpportunityNames.size() > 0) {
			    	OpportunityName = OpportunityNames[0].getValue();
			    	ProductNamesP = ProductNames;
		    	}
		    	List<Schema.PicklistEntry> hours = Time_Entry__c.From__c.getDescribe().getPicklistValues();
		    	List<SelectOption> toHours = new List<SelectOption>();
		    	List<SelectOption> fromHours = new List<SelectOption>();
				for(Schema.PicklistEntry hour : hours) {
		        	fromHours.add(new SelectOption(hour.getValue(), hour.getValue()));
		        	toHours.add(new SelectOption(hour.getValue(), hour.getValue()));
		    	}
		    	this.fromHours = fromHours;
		    	fromHour = '10:00';
		    	this.toHours = toHours;
		    	toHour = '18:00';
    		}
    	}
	}
	
	public void changeProdcuts() {
		ProductNamesP = null;
    	ProductNamesP = ProductNames;
	}
	
	public pageReference save() {
		string weekCalendar;
		Time_Bong__c dummyWTS;
		string url;
		boolean newWTS = false;
		OpportunityLineItem oppProd;
		
		dummyWTS = new Time_Bong__c(Start_Date__c = GPL.getMonday(timeEntry.Work_Start__c), Time_Entry_User__c = timeEntryUserId, end_date__c = GPL.getMonday(timeEntry.Work_Start__c).addDays(4));
		insert dummyWTS;
		weekCalendar = [SELECT Calendar_Week__c FROM Time_Bong__c WHERE Id =: dummyWTS.id].Calendar_Week__c;
		delete dummyWTS;
		
		if(timeEntry.id == null) { //new
			try {
				WeeklyTimesheet = [SELECT id, Time_Entry_User__c, name FROM Time_Bong__c WHERE Time_Entry_User__c =: timeEntryUserId AND Calendar_Week__c =: weekCalendar];
			} catch (QueryException e) {
				//couldn't find a weekly time sheet for this user and this calendar week, create it:
				WeeklyTimesheet = new Time_Bong__c(Time_Entry_User__c = timeEntryUserId, Start_Date__c = GPL.getMonday(timeEntry.Work_Start__c), end_date__c = GPL.getMonday(timeEntry.Work_Start__c).addDays(4));
				insert WeeklyTimesheet;
				newWTS = true;
			}
			timeEntry.From__c = fromHour;
			timeEntry.To__c = toHour;
			timeEntry.opportunity__c = opportunityName;
			timeEntry.product__c = productName;
			
			oppProd = [SELECT id, Mitarbeiter_Rolle__c 
						FROM OpportunityLineItem 
						WHERE PricebookEntry.Product2Id =: timeEntry.product__c
						AND OpportunityId =: timeEntry.opportunity__c
						limit 1];
			timeEntry.Employee_Role__c = oppProd.Mitarbeiter_Rolle__c;
			timeEntry.Time_Booking__c = WeeklyTimesheet.id;
			try {
				insert timeEntry;
				url = '/' + WeeklyTimesheet.id;
			} catch (DMLException e) {
				if(newWTS) {
					delete WeeklyTimesheet;
	    			WeeklyTimesheet = new Time_Bong__c(Time_Entry_User__c = timeEntryUserId);
				}
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getDmlMessage(0)));
				url = null;
			}
		} else { //edit
			timeEntry.From__c = fromHour;
			timeEntry.To__c = toHour;
			timeEntry.opportunity__c = opportunityName;
			timeEntry.product__c = productName;
			try {
				update timeEntry;
				url = '/' + WeeklyTimesheet.id;
			} catch (DMLException e) {
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getDmlMessage(0)));
				url = null;
			}
		}
		
		if(url!=null) {
			return new PageReference(url);	
		} else {
			return null;
		}
	}
	
	public void userChanged() {
		timeEntryUserId = WeeklyTimesheet.Time_Entry_User__c;
		WeeklyTimesheet = new Time_Bong__c(Time_Entry_User__c = timeEntryUserId);
		timeEntry.Work_Start__c = Date.Today();
    	OpportunityNamesP = null;
    	OpportunityNamesP = OpportunityNames;
    	if(OpportunityNames.size() > 0) {
	    	OpportunityName = OpportunityNames[0].getValue();
	    	ProductNamesP = null;
	    	ProductNamesP = ProductNames;
    	} else {
    		ProductNamesP = null;
	    	ProductNames = null;
    	}
    	List<Schema.PicklistEntry> hours = Time_Entry__c.From__c.getDescribe().getPicklistValues();
    	List<SelectOption> toHours = new List<SelectOption>();
    	List<SelectOption> fromHours = new List<SelectOption>();
		for(Schema.PicklistEntry hour : hours) {
        	fromHours.add(new SelectOption(hour.getValue(), hour.getValue()));
        	toHours.add(new SelectOption(hour.getValue(), hour.getValue()));
    	}
    	this.fromHours = fromHours;
    	fromHour = '10:00';
    	this.toHours = toHours;
    	toHour = '18:00';
	}	
}