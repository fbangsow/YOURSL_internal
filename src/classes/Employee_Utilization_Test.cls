// * **************************************************************
// Creater: Chris Sandra Schautt
// Description: This Testclass is for the Employee_Utilization_Controller and the Employee_Utilization_AI_AU.
//				I insert an account, a campaigne,a contact, a product2, a pricebookentry,a OpportunityLineItem, a,Opportunity 
// 				Time Endtys and Employee Utilizations.
// Testclass: Employee_Utilization_Test
// Apex Class Access: no limitations/Profilenames
// Last modified by: Cris Sandra Schautt
// Last modified date: 02.04.2012
// Latests changes: -
// ************************************************************** 

@isTest(SeeAllData=true)
private class Employee_Utilization_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Profile testProfile = [SELECT Id,Name FROM Profile WHERE PermissionsModifyAllData = true LIMIT 1];
		User currentuser = [SELECT Id, FirstName, LastName FROM User WHERE ProfileId =: testProfile.Id AND IsActive=true LIMIT 1];
		
		Contact currentcontact = new Contact (
			FirstName = currentuser.FirstName,
			LastName = currentuser.LastName
		);
		
		insert currentcontact;
		
		currentcontact = [SELECT Id,Name,FirstName,LastName FROM Contact WHERE LastName =: currentcontact.LastName LIMIT 1];
		currentuser.Contact_ID__c = currentcontact.Id;
		update currentuser;
			
		//User dummyuser = new User(LastName = 'All', User.Alias = 'dummy', User.Email = 'dummyuser'];
//		Contact currentcontact = [SELECT Id, Name, FirstName, LastName FROM Contact WHERE Id =: currentuser.Contact_ID__c LIMIT 1];
		Contact dummycontact = [SELECT Id, Name, FirstName, LastName FROM Contact WHERE LastName = 'All' LIMIT 1];
		list<Contact> listContact=new list<Contact>();
		
		
		
    	System.RunAs(currentuser){
	    	System.Test.startTest();
			Account testAcc = new Account(Name ='TestACC');
				
			testAcc.BillingCity ='testcity';
			testAcc.BillingStreet = 'teststreet';
			testAcc.BillingPostalCode = '1234';
			// insert Account
			insert testAcc;
			testAcc=[SELECT Id, Name FROM Account WHERE Name=:'TestACC' LIMIT 1];
			
			Account accYOURSL = new Account(Name ='YOUR SL GmbH',
			BillingCity ='testcity',BillingStreet = 'teststreet',BillingPostalCode = '1234');
			// insert Account
			insert accYOURSL;
			accYOURSL=[SELECT Id, Name FROM Account WHERE Name=:'YOUR SL GmbH' LIMIT 1];
		//crate Contacts	
		for(Integer i=0;i<5;i++){
			Contact tempContact= new Contact (LastName='test'+i, PSO_Member__c=True, AccountId= accYOURSL.Id); 
			listContact.add(tempContact);
		}//for(Integer i=0;i<4;i++)
		try{
			insert listContact;
		}catch(DmlException dex){
				ApexPages.addMessages(dex);
			}// end try
		listContact=[Select Id, Name, PSO_Member__c FROM Contact WHERE PSO_Member__c=:true];
				//new User
		//	User c = [SELECT ID, Name,LastName,FirstName FROM USER LIMIT 1];
			//User currentuser = [SELECT Id, Contact_ID__c FROM User WHERE Id =: System.UserInfo.getUserId()];
			
		// list of EmployeeUtilisation enter
		
		list<Employee_Utilization__c> listUt = new list<Employee_Utilization__c>();
		for(Integer i =0;i<5;i++){
			Employee_Utilization__c tempUt = new Employee_Utilization__c( Planed_Monday__c=6, Planed_Tuesday__c=6, Planed_Wednesday__c=7,  Planed_Thursday__c=9, Planed_Friday__c=2, Date_Monday__c=System.today().toStartOfWeek(), Contact__c=listContact[i].Id,
							Planed_unbillable_hours_on_Friday__c = 1.0, Planed_unbillable_hours_on_Monday__c = 1.0,
							Planed_unbillable_hours_on_Thursday__c = 1.0, Planed_unbillable_hours_on_Tuesday__c = 1.0,
							Planed_unbillable_hours_on_Wednesday__c= 1.0, Unbillable_Project_on_Friday__c = 'urlaub',
							Unbillable_Project_on_Monday__c ='urlaub', Unbillable_Project_on_Thursday__c ='urlaub',
							Unbillable_Project_on_Tuesday__c ='urlaub', Unbillable_Project_on_Wednesday__c ='urlaub',
							Maximum_hours_in_week__c = 17);
			listUt.add(tempUt);
		}try{
			insert listUt;
		}catch(DmlException dex){
				ApexPages.addMessages(dex);
		}// end try
		listUt = [Select KW__c, Year__c, Month__c, Planed_Week__c,Planed_Wednesday__c, Planed_Tuesday__c, 
    						Planed_Thursday__c, Planed_Monday__c, Planed_Friday__c,
    						Project_on_Monday__c, Project_on_Tuesday__c, Project_on_Wednesday__c,
							Project_on_Thursday__c, Project_on_Friday__c, PSO_Ressource__c, Name, Id,
 							Date_Wednesday__c, Date_Tuesday__c, Date_Thursday__c, Date_Monday__c, Date_Friday__c, Contact__c,
 							Completeness_Wednesday__c,Completeness_Tuesday__c,Completeness_Thursday__c,Completeness_Monday__c,
 							Completeness_Friday__c,Billed_on_Wednesday__c,Billed_on_Tuesday__c,Billed_on_Thursday__c,
  							Billed_on_Monday__c,Billed_on_Friday__c, Billed_Hour_in_Week__c ,
  							Planed_unbillable_hours_on_Friday__c, Planed_unbillable_hours_on_Monday__c,
							Planed_unbillable_hours_on_Thursday__c, Planed_unbillable_hours_on_Tuesday__c,
							Planed_unbillable_hours_on_Wednesday__c, Unbillable_Project_on_Friday__c,
							Unbillable_Project_on_Monday__c, Unbillable_Project_on_Thursday__c,
							Unbillable_Project_on_Tuesday__c, Unbillable_Project_on_Wednesday__c, Weekly_Auslastung__c
  							FROM Employee_Utilization__c WHERE Date_Monday__c=: System.today().toStartOfWeek()];
			//Product2
			Product2 Product4User= new Product2( Name='TestProduct',IsActive=true);
			insert Product4User;
			//Product4User =[SELECT Name, Id,IsActive FROM Product2 WHERE Name=:'TestProduct'];
	
			Product2 productUnbillablePreSales= new Product2( 
			Name = 'UNBILLABLE Pre Sales',
			IsActive = true,
			Family = 'Business Consulting',
			Product_Category__c = 'Consulting',
			Produktname_lang__c = 'UNBILLABLE Pre Sales');
			insert productUnbillablePreSales;
			//productUnbillablePreSales = [SELECT Name, Id,IsActive FROM Product2 WHERE Name=:'UNBILLABLE Pre Sales' LIMIT 1];
			
			Product2 productUnbillableInternal= new Product2( 
			Name = 'Feiertage',
			IsActive = true,
			Family = '',
			Product_Category__c = '',
			Produktname_lang__c = 'UNBILLABLE Pre Sales');
			insert productUnbillableInternal;
			//productUnbillableInternal =[SELECT Name, Id,IsActive FROM Product2 WHERE Name =: 'Feiertage' AND IsActive = true LIMIT 1];
	
			
			
			//Pricebook2 temppb = [SELECT Id, Name, IsActive FROM Pricebook2 WHERE IsStandard = true limit 1];
			
			/*Pricebook2 mypb = new Pricebook2(
				Name='myPricebook',
				IsActive = true
			);
			
			insert mypb;*/
			
			Pricebook2 temppb = [SELECT Id, Name, IsActive, IsStandard FROM Pricebook2 WHERE IsStandard = true limit 1];
			
			//System.debug('xxxxxxxxxxxxxxxxxxxx DEBUG: Name'+temppb.Name+' IsActive '+temppb.IsActive+' ID '+temppb.Id + temppb.IsStandard);
			
			//pricebookEntry new
			PricebookEntry pbe4User= new PricebookEntry( Pricebook2Id=temppb.Id, Product2Id= Product4User.Id, UnitPrice=249.0, IsActive=true,UseStandardPrice=false);
			insert pbe4User;
			
			PricebookEntry pbeInternal= new PricebookEntry( Pricebook2Id=temppb.Id, Product2Id= productUnbillableInternal.Id, UnitPrice=249.0, IsActive=true,UseStandardPrice=false);
			if([SELECT COUNT() FROM PricebookEntry WHERE Pricebook2Id =: temppb.Id AND Product2Id =: productUnbillableInternal.Id] > 0){
				pbeInternal = [SELECT Id, Name, Pricebook2Id, Product2Id FROM PricebookEntry WHERE Pricebook2Id =: temppb.Id AND Product2Id =: productUnbillableInternal.Id];
			}else{
				insert pbeInternal;
			}
			
			PricebookEntry pbePreSales= new PricebookEntry( Pricebook2Id=temppb.Id, Product2Id= productUnbillablePreSales.Id, UnitPrice=249.0, IsActive=true,UseStandardPrice=false);
			if([SELECT COUNT() FROM PricebookEntry WHERE Pricebook2Id =: temppb.Id AND Product2Id =: productUnbillablePreSales.Id] > 0){
				pbePreSales = [SELECT Id, Name, Pricebook2Id, Product2Id FROM PricebookEntry WHERE Pricebook2Id =: temppb.Id AND Product2Id =: productUnbillablePreSales.Id];
			}else{
				insert pbePreSales;
			}
			
			OpportunityStage stageWON = [Select MasterLabel, IsWon, IsActive, Id, DefaultProbability From OpportunityStage WHERE DefaultProbability = 100 AND IsWon = true AND IsActive = true];
			
			//Opportunity
			Opportunity testOpp4User = new Opportunity(Pricebook2Id= temppb.Id,Name ='TestOpp4User' ,AccountId= testAcc.Id,  CloseDate= System.today().addDays(-9), StageName = stageWON.MasterLabel);
			insert testOpp4User;
			
			//Opportunity
			Opportunity testOppPreSales = new Opportunity(Pricebook2Id= temppb.Id,Name ='TestOppPreSales' ,AccountId= testAcc.Id,  CloseDate= System.today().addDays(-9), StageName = stageWON.MasterLabel);
			insert testOppPreSales;
			
			Opportunity testOppInternal = new Opportunity(Pricebook2Id= temppb.Id, Name ='TestOppInternal' ,AccountId= accYOURSL.Id,  CloseDate= System.today().addDays(-9), StageName = stageWON.MasterLabel);
			insert testOppInternal;
			
					
			//OpportunityLineItem
			list<OpportunityLineItem> listOppLiI= new list<OpportunityLineItem>();
			for(Integer i = 0;i<5;i++){
			OpportunityLineItem testOppLineItem14User = new OpportunityLineItem(OpportunityId=testOpp4User.Id, Leistung_erbracht__c = false, PricebookEntryId=pbe4User.Id, UnitPrice=1.5, Quantity=33.00, Unit__c='Manntag(e)',ServiceDate = System.today().toStartOfWeek(),Contact__c = listContact[i].Id);
			listOppLiI.add(testOppLineItem14User);
			}
			try{
			insert listOppLiI;
			}catch(DmlException dex){
					ApexPages.addMessages(dex);
			}// end try
		
			String oppyLinkSub = System.URL.getSalesforceBaseUrl().getHost();
			String oppyLink4User = 'https://'
						+ oppyLinkSub.substring(2,6) 
				    	+ 'salesforce.com'
				    	+ '/'
				    	+listOppLiI[1].Id;
				    	
			
				    	
			
			
			list<TimeEntry__c> listTEnt= new list<TimeEntry__c>();
			for(Integer i=0;i<5;i++){
					TimeEntry__c timeE_4User = new TimeEntry__c(
					Contact__c = listContact[i].Id,
					Date__c = System.today().toStartOfWeek()+i,
					Opportunity__c = testOpp4User.Id,
					Time__c = 10.00,
					Opportunity_Product__c	= oppyLink4User,
					Opportunity_Product_ID__c = listOppLiI[i].Id,
					Billable__c = true
				);
				listTEnt.add(timeE_4User);
			}// End for(Integer i=0;i<4;i++)
	        
	        try{
				insert listTEnt;
			}catch(DmlException dex){
					ApexPages.addMessages(dex);
			}// end try
			list<Employee_Utilization__c> listEmUt = new list<Employee_Utilization__c>();
	        
	         for(Integer i=0;i<5;i++){
				Employee_Utilization__c emUt = new Employee_Utilization__c(
					Contact__c = listContact[i].Id,
					Date_Monday__c = System.today().toStartOfWeek(),
					Planed_Monday__c= 1, Planed_Tuesday__c=3,Planed_Wednesday__c=4,
					Planed_Thursday__c=7,Planed_Friday__c=9, Maximum_hours_in_week__c= 20,
					Planed_unbillable_hours_on_Friday__c = 1.0, Planed_unbillable_hours_on_Monday__c = 1.0,
					Planed_unbillable_hours_on_Thursday__c = 1.0, Planed_unbillable_hours_on_Tuesday__c = 1.0,
					Planed_unbillable_hours_on_Wednesday__c= 1.0, Unbillable_Project_on_Friday__c = 'urlaub',
					Unbillable_Project_on_Monday__c ='urlaub', Unbillable_Project_on_Thursday__c ='urlaub',
					Unbillable_Project_on_Tuesday__c ='urlaub', Unbillable_Project_on_Wednesday__c ='urlaub'

				);
				listEmUt.add(emUt);
	         }//End for
	         try{
				insert listEmUt;
			}catch(DmlException dex){
					ApexPages.addMessages(dex);
			}// end try
			listEmUt = [Select KW__c, Year__c, Month__c, Planed_Week__c,Planed_Wednesday__c, Planed_Tuesday__c, 
    						Planed_Thursday__c, Planed_Monday__c, Planed_Friday__c,
    						Project_on_Monday__c, Project_on_Tuesday__c, Project_on_Wednesday__c,
							Project_on_Thursday__c, Project_on_Friday__c, PSO_Ressource__c, Name, Id,
 							Date_Wednesday__c, Date_Tuesday__c, Date_Thursday__c, Date_Monday__c, Date_Friday__c, Contact__c,
 							Completeness_Wednesday__c,Completeness_Tuesday__c,Completeness_Thursday__c,Completeness_Monday__c,
 							Completeness_Friday__c,Billed_on_Wednesday__c,Billed_on_Tuesday__c,Billed_on_Thursday__c,
  							Billed_on_Monday__c,Billed_on_Friday__c, Billed_Hour_in_Week__c,Maximum_hours_in_week__c,
  							Planed_unbillable_hours_on_Friday__c, Planed_unbillable_hours_on_Monday__c,
							Planed_unbillable_hours_on_Thursday__c, Planed_unbillable_hours_on_Tuesday__c,
							Planed_unbillable_hours_on_Wednesday__c, Unbillable_Project_on_Friday__c,
							Unbillable_Project_on_Monday__c, Unbillable_Project_on_Thursday__c,
							Unbillable_Project_on_Tuesday__c, Unbillable_Project_on_Wednesday__c, Weekly_Auslastung__c 
  							FROM Employee_Utilization__c];
			 ApexPages.StandardController sc = new ApexPages.StandardController(listEmUt[0]);
			
			 Employee_Utilization_Controller clsEmployeeUt = new Employee_Utilization_Controller();
	         clsEmployeeUt.myRefresh();
	         clsEmployeeUt.myCancel();
	         
	         Employee_Utilization_Edit_Extension extEmployeeUt = new Employee_Utilization_Edit_Extension(sc);
	         extEmployeeUt.selectedContact = listContact[0].Id;
	         extEmployeeUt.getSelectedContactList();
	         extEmployeeUt.getSelectedDateList();
	         extEmployeeUt.selectedDate = '1';
	         extEmployeeUt.save1();
	         extEmployeeUt.selectedDate = '2';
	         extEmployeeUt.save1();
	         extEmployeeUt.selectedDate = '3';
	         extEmployeeUt.save1();
	         extEmployeeUt.selectedDate = '4';
	         extEmployeeUt.save1();
	         extEmployeeUt.selectedDate = '5';
	         extEmployeeUt.save1();
	         extEmployeeUt.selectedDate = '6';
	         extEmployeeUt.save1();
	         extEmployeeUt.selectedDate = '7';
	         extEmployeeUt.save1();
	         extEmployeeUt.selectedDate = '8';
	         extEmployeeUt.save1();
	         extEmployeeUt.selectedDate = '9';
	         extEmployeeUt.save1();
	         extEmployeeUt.selectedDate = 'noDate';
	         extEmployeeUt.save1();
	         extEmployeeUt.selectedDate = '1';
	         extEmployeeUt.selectedContact = 'nocontact';
	         extEmployeeUt.save1();
	         extEmployeeUt.selectedDate = null;
	         extEmployeeUt.save1();
	         
    	}// End System.RunAs(currentuser)
	}// static testMethod void myUnitTest()
}// End private class Employee_Utilization_Test