@isTest 
private class test_timesheet {
	static testMethod void test_TimeEntryCont() {
		PageReference testedPage;
		ApexPages.StandardController controller;
    	TimeEntryCont testedPageController;
    	Time_Bong__c tb;
		Time_Entry__c te;
		user u;
		Time_Entry_User__c te_u;
		OpportunityLineItem oli;
		Opportunity_Assignment__c oa;
		Produkt_Ressourcen_Forecast__c PRF;
		
		u = [SELECT id, firstname, lastname
				FROM User 
				WHERE firstname !=null 
				AND lastname!= null
				limit 1];
		te_u = new Time_Entry_User__c(name = u.firstname + ' ' + u.lastname, user__c = u.id);
		insert te_u;
		Date startDate = GPL.getMonday(date.today());
		tb = new Time_Bong__c(Time_Entry_User__c = te_u.id, 
							Start_Date__c = startDate);
							
		insert tb;
		Opportunity firstOpportunity = new Opportunity();
        firstOpportunity.Name = '° Roshen';
        firstOpportunity.StageName = '° Roshen';
        firstOpportunity.PriceBook2Id = Test.getStandardPricebookId();
        firstOpportunity.CloseDate = Date.newInstance(2015, 1, 1);
        insert firstOpportunity;
        Product2 testProduct = new Product2();
        testProduct.Name = 'Salesforce Developer';
        testProduct.isActive = true;
        testProduct.CanUseQuantitySchedule = true;
        insert testProduct;
        PricebookEntry testPricebookEntry = new PricebookEntry();
        testPricebookEntry.Pricebook2Id = Test.getStandardPricebookId();
        testPricebookEntry.Product2Id = testProduct.Id;
        testPricebookEntry.UnitPrice = 99;
        testPricebookEntry.isActive = true;
        insert testPricebookEntry;
        OpportunityLineItem firstLineItem = new OpportunityLineItem();
        firstLineItem.PricebookEntryId = testPricebookEntry.Id;
        firstLineItem.ServiceDate = Date.newInstance(2015, 1, 10);
        firstLineItem.UnitPrice = 1200;
        firstLineItem.Quantity = 1;
        firstLineItem.Unit__c = 'Manntag(e)';
        firstLineItem.OpportunityId = firstOpportunity.Id;
        firstLineItem.Mitarbeiter_Rolle__c = 'Management Consultant';
        insert firstLineItem;
		oli = [SELECT id, Mitarbeiter_Rolle__c, PricebookEntry.Product2Id, OpportunityId
						FROM OpportunityLineItem 
						WHERE PricebookEntry.Product2Id != null
						AND OpportunityId != null
						AND Mitarbeiter_Rolle__c != null
						limit 1];
		te = new Time_Entry__c(Time_Booking__c = tb.id, From__c = '10:00', to__c = '18:00', Work_Start__c = startDate, 
								Description_of_work__c = 'desc', opportunity__c = oli.OpportunityId, 
								product__c = oli.PricebookEntry.Product2Id, Billable__c = true);
		insert te;
		oa = new Opportunity_Assignment__c(opportunity__c =  oli.OpportunityId, Time_Entry_User__c = te_u.id);
		insert oa;
		PRF = new Produkt_Ressourcen_Forecast__c(Product__c = te.product__c, Opportunity_TS_BETA__c = te.opportunity__c, Time_Entry_User__c = te_u.id);
		insert PRF;
		
		/** edit **/
		controller = new ApexPages.StandardController(te);
    	testedPageController = new TimeEntryCont(controller);
    	testedPageController.changeProdcuts();
    	testedPageController.opportunityName = oli.OpportunityId;
    	testedPageController.productName = oli.PricebookEntry.Product2Id;
    	testedPageController.save();
    	
    	/** new **/
    	te = new Time_Entry__c(Time_Booking__c = tb.id, From__c = '10:00', to__c = '18:00', Work_Start__c = startDate, 
								Description_of_work__c = 'desc', opportunity__c = oli.OpportunityId, 
								product__c = oli.PricebookEntry.Product2Id, Billable__c = true);
		testedPage = Page.TimeEntry;
      	Test.setCurrentPage(testedPage);
     	testedPage.getParameters().put('user', string.valueof(u.id));
		controller = new ApexPages.StandardController(te);
    	testedPageController = new TimeEntryCont(controller);
    	testedPageController.opportunityName = oli.OpportunityId;
    	testedPageController.productName = oli.PricebookEntry.Product2Id;
    	testedPageController.save();
    	
    	/** userChanged **/
    	testedPageController.userChanged();
    	
	}
		
	static testMethod void test_WeeklyTimesheetsCont() {
		WeeklyTimesheetsCont controller;
		Time_Bong__c tb;
		user u;
		Time_Entry_User__c te_u;
		PageReference testedPage;
		
		u = [SELECT id, firstname, lastname
				FROM User 
				WHERE firstname !=null 
				AND lastname!= null
				AND isActive = true
				limit 1];
		te_u = new Time_Entry_User__c(name = u.firstname + ' ' + u.lastname, user__c = u.id);
		insert te_u;
		Date startDate = GPL.getMonday(date.today());
		tb = new Time_Bong__c(Time_Entry_User__c = te_u.id, 
							Start_Date__c = startDate);
		insert tb;
		System.runAs(u) {
			testedPage = Page.WeeklyTimesheets;
	      	Test.setCurrentPage(testedPage);
			controller = new WeeklyTimesheetsCont();
			controller.newTimeEntry();
		}
	}
	
	static testMethod void test_WeeklyTimesheetsAdminCont() {
		WeeklyTimesheetsAdminCont controller;
		Time_Bong__c tb;
		User u;
		Time_Entry_User__c te_u;
		PageReference testedPage;
		
		u = [SELECT id, firstname, lastname
				FROM User 
				WHERE firstname !=null 
				AND lastname!= null
				limit 1];
		te_u = new Time_Entry_User__c(name = u.firstname + ' ' + u.lastname, user__c = u.id);
		insert te_u;
		Date startDate = GPL.getMonday(date.today());
		tb = new Time_Bong__c(Time_Entry_User__c = te_u.id, 
							Start_Date__c = startDate);
		insert tb;
		controller = new WeeklyTimesheetsAdminCont();
		List<SelectOption> Users = controller.users;
		controller.user = te_u.id;
		controller.showTimeSheets();
	}
	
	/* tests the time-off handling in triggers */
	/*
	static testMethod void test_triggersVacation() {
		id vacationOppId = [SELECT Id FROM Opportunity WHERE Name = 'YOUR SL INTERN'].id;
		id pricebookId = [SELECT Pricebook2Id FROM Opportunity WHERE Name = 'YOUR SL INTERN'].Pricebook2Id;
		
		// new vacation entry
		Product2 p = new Product2();
		p.Name='TestProd';
		p.Produktname_lang__c = 'TestHeaderDescription';
		p.IsActive = true;
		insert p;
		
		Pricebook2 StdPb =[select name,isactive from Pricebook2 where isStandard=true];
		if(!StdPb.isactive){
		StdPb.isactive=true;
		Database.update(StdPb);
		}
		
		// sumTotalPrice = double
		double sumTotalPrice = 2.0;
		
		// SumOfPhase = double
		double SumOfPhase = 0.0;
		
		//pbe = pricebook entry (standard)
		PricebookEntry pbe;
		pbe = new PricebookEntry();
		pbe.Pricebook2Id=StdPb.id;
		pbe.Product2Id=p.id;
		pbe.UnitPrice = sumTotalPrice;
		pbe.IsActive=true;
		insert pbe;
		
		//pbe = pricebook entry (for price book associated with vacation opportunity)
		pbe = new PricebookEntry();
		pbe.Pricebook2Id=pricebookId;
		pbe.Product2Id=p.id;
		pbe.UnitPrice = sumTotalPrice;
		pbe.IsActive=true;
		insert pbe;
		
		// oli = OpportunityLineItem
		OpportunityLineItem oli = new OpportunityLineItem();
		oli.OpportunityId = vacationOppId;
		oli.PricebookEntryId = pbe.Id;
		oli.Quantity = 2.0;
		oli.TotalPrice = oli.Quantity * sumTotalPrice;
		insert oli;
		
		//creating the Time_Entry__c
		user u = [SELECT id, firstname, lastname
				FROM User 
				WHERE firstname !=null 
				AND lastname!= null
				limit 1];
		Date startDate = GPL.getMonday(date.today());
		Time_Bong__c tb = new Time_Bong__c(user__c = u.id, 
							Start_Date__c = startDate);
		insert tb;
		Time_Entry__c te = new Time_Entry__c(Time_Booking__c = tb.id, From__c = '10:00', to__c = '18:00', Work_Start__c = startDate, 
								Description_of_work__c = 'desc', opportunity__c = vacationOppId, 
								product__c = oli.PricebookEntry.Product2Id, Billable__c = true);
		insert te;
    	
    	delete te;
    	
    	delete oli;
	}
	*/
}