/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData=true)
private class TimeEntryUserTest {

    static testMethod void myUnitTest() {
    	Contact test_contact = new Contact();
        test_contact.FirstName = 'Jango';
        test_contact.LastName = 'All';
        insert test_contact;
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

    	System.RunAs(currentuser){
	    	System.Test.startTest();
			Account testAcc = new Account(Name ='TestACC');

			testAcc.BillingCity ='testcity';
			testAcc.BillingStreet = 'teststreet';
			testAcc.BillingPostalCode = '1234';
			// insert Account
			insert testAcc;
			//testAcc=[SELECT Id, Name FROM Account WHERE Name=:'TestACC' LIMIT 1];

			Account accYOURSL = new Account(Name ='YOUR SL GmbH',
			BillingCity ='testcity',BillingStreet = 'teststreet',BillingPostalCode = '1234');
			// insert Account
			insert accYOURSL;
			//accYOURSL=[SELECT Id, Name FROM Account WHERE Name=:'YOUR SL GmbH' LIMIT 1];

				//new User
		//	User c = [SELECT ID, Name,LastName,FirstName FROM USER LIMIT 1];
			//User currentuser = [SELECT Id, Contact_ID__c FROM User WHERE Id =: System.UserInfo.getUserId()];


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
			OpportunityLineItem testOppLineItem14User = new OpportunityLineItem(OpportunityId=testOpp4User.Id, Leistung_erbracht__c = false, PricebookEntryId=pbe4User.Id, UnitPrice=1.5, Quantity=32.00, Unit__c='Manntag(e)',ServiceDate = System.today(),Contact__c = currentcontact.Id);
			insert testOppLineItem14User;

			OpportunityLineItem testOppLineItemPreSales = new OpportunityLineItem(OpportunityId=testOppPreSales.Id, Leistung_erbracht__c = false, PricebookEntryId=pbePreSales.Id, UnitPrice=1.5, Quantity=32.00, Unit__c='Manntag(e)',ServiceDate = System.today(),Contact__c = dummycontact.Id);
			insert testOppLineItemPreSales;

			OpportunityLineItem testOppLineItemInternal = new OpportunityLineItem(OpportunityId=testOppInternal.Id, Leistung_erbracht__c = false, PricebookEntryId=pbeInternal.Id, UnitPrice=1.5, Quantity=32.00, Unit__c='Manntag(e)',ServiceDate = System.today(),Contact__c = dummycontact.Id);
			insert testOppLineItemInternal;

			/*Contact co = new Contact(
				LastName = 'TestKontakt',
				Account = testAcc
			);*/



			String oppyLinkSub = System.URL.getSalesforceBaseUrl().getHost();
			String oppyLink4User = 'https://'
						+ oppyLinkSub.substring(2,6)
				    	+ 'salesforce.com'
				    	+ '/'
				    	+testOppLineItem14User.Id;

			String oppyLinkPreSales = 'https://'
						+ oppyLinkSub.substring(2,6)
				    	+ 'salesforce.com'
				    	+ '/'
				    	+ testOppLineItemPreSales.Id;

			String oppyLinkInternal = 'https://'
						+ oppyLinkSub.substring(2,6)
				    	+ 'salesforce.com'
				    	+ '/'
				    	+ testOppLineItemInternal.Id;




			TimeEntry__c timeE_4User = new TimeEntry__c(
				Contact__c = currentcontact.Id,
				Date__c = System.today(),
				Opportunity__c = testOpp4User.Id,
				Time__c = 4.0,
				Opportunity_Product__c	= oppyLink4User,
				Opportunity_Product_ID__c = testOppLineItem14User.Id,
				Billable__c = true
			);

			TimeEntry__c timeE_PreSales = new TimeEntry__c(
				Contact__c = currentcontact.Id,
				Date__c = System.today(),
				Opportunity__c = testOpp4User.Id,
				Time__c = 4.0,
				Opportunity_Product__c	= oppyLinkPreSales,
				Opportunity_Product_ID__c = testOppLineItemPreSales.Id,
				Billable__c = false
			);


			TimeEntry__c timeE_internal = new TimeEntry__c(
				Contact__c = currentcontact.Id,
				Date__c = System.today(),
				Opportunity__c = testOppInternal.Id,
				Time__c = 4.0,
				Opportunity_Product__c	= oppyLinkInternal,
				Opportunity_Product_ID__c = testOppLineItemInternal.Id,
				Billable__c = false
			);


	        insert timeE_4User;
	        insert timeE_PreSales;
	        insert timeE_internal;

			ApexPages.StandardController controller = new ApexPages.StandardController(timeE_4User);
			//controller.getRecord();
			//Test.setCurrentPage(timeE_4User);
			TimeEntry4UserExtension tE4 = new TimeEntry4UserExtension(controller);
			testOppLineItem14User = [SELECT Id, Quantity, ServiceDate, Total_booked_days__c,Total_Booked_Hours__c,Total_Booked_Hours_billable__c,Quantity_in_Hours__c  FROM OpportunityLineItem WHERE Id =: testOppLineItem14User.Id];
			Decimal ddaysleft = tE4.proofHoursLeft(testOppLineItem14User);
			System.assertEquals(ddaysleft, ((32.0*8)-(4.0)));
			//System.assertEquals(ddaysleft, 10.0);
			testOppLineItem14User.Contact__c = currentcontact.Id;
			tE4.getProjectTypeList();
			tE4.selectedProjectType = '4User';
			tE4.objTimeEntry.Date__c = System.today();
			tE4.objTimeEntry.Contact__c = currentcontact.Id;
			//tE4.selectOppsAndLineItems4User();
			tE4.getOpportunityList();
			tE4.getOpportunityLineItemList();
			tE4.getSelectedContactList();
			tE4.selectedOpp = testOpp4User.Id;
			tE4.selectedTask = testOppLineItem14User.Id;
			PageReference prView = tE4.save();


			Report timeSheetOverviewID = [SELECT Id FROM Report WHERE DeveloperName = 'Time_Sheet_Overview2'];
    		String sReportURL = System.URL.getSalesforceBaseUrl().getHost();
    		sReportURL = 'https://'
    						+ sReportURL.substring(2,6)
				    		+ 'salesforce.com'
				    		+ '/'
				    		+ timeSheetOverviewID;



    		PageReference timeSheetReport = new ApexPages.Pagereference(sReportURL+'?pv0='+currentcontact.FirstName+'%20'+currentcontact.LastName);

			PageReference timeentryPage = new ApexPages.StandardController(timeE_4User).view();
			System.assertEquals(tE4.objTimeEntry.Contact__c , currentcontact.Id);
			//System.assertEquals(prView, timeSheetReport );
			/*Test.setCurrentPage(prView);
			prView.save().getURL();
			Page.nextPage().getURL();*/

			//https://cs7.salesforce.com/01pM0000000DUvj

			controller = new ApexPages.StandardController(timeE_PreSales);
			//controller.getRecord();
			//Test.setCurrentPage(timeE_4User);






			tE4 = new TimeEntry4UserExtension(controller);

			tE4.selectOppsAndLineItemsPreSales();
			tE4.getProjectTypeList();
			tE4.selectedProjectType = 'SalesSupport';
			tE4.getOpportunityList();
			tE4.getOpportunityLineItemList();
			tE4.selectedOpp = testOppPreSales.Id;
			tE4.selectedTask = testOppLineItemPreSales.Id;
			tE4.save();

			controller = new ApexPages.StandardController(timeE_internal);
			controller.getRecord();
			//Test.setCurrentPage(timeE_4User);
			tE4 = new TimeEntry4UserExtension(controller);

			tE4.selectOppsAndLineItemsInternal();
			tE4.getProjectTypeList();
			tE4.selectedProjectType = 'internal';
			tE4.getOpportunityList();
			tE4.getOpportunityLineItemList();
			tE4.selectedOpp = testOppInternal.Id;
			tE4.selectedTask = testOppLineItemInternal.Id;
			tE4.save();
			tE4.save_and_new();


			// test without assigned Task
			testOppLineItem14User.Contact__c = dummycontact.Id;
			update testOppLineItem14User;
			controller = new ApexPages.StandardController(timeE_4User);
			//controller.getRecord();
			//Test.setCurrentPage(timeE_4User);
/*			tE4 = new TimeEntry4UserExtension(controller);
			testOppLineItem14User.Contact__c = currentcontact.Id;
			tE4.selectOppsAndLineItems4User();
			tE4.getProjectTypeList();
			tE4.selectedProjectType = '4User';
			tE4.getOpportunityList();
			tE4.getOpportunityLineItemList();
			tE4.selectedOpp = testOpp4User.Id;*/

			// test without assigned Task
/*			delete testOppLineItem14User;
			update testOpp4User;
			//timeE_4User.Opportunity__c = testOpp4User.Id;
			controller = new ApexPages.StandardController(timeE_4User);
			//controller.getRecord();
			//Test.setCurrentPage(timeE_4User);
			tE4 = new TimeEntry4UserExtension(controller);
			testOppLineItem14User.Contact__c = currentcontact.Id;
			tE4.selectOppsAndLineItems4User();
			tE4.getProjectTypeList();
			tE4.selectedProjectType = '4User';
			tE4.getOpportunityList();
			tE4.getOpportunityLineItemList();
			tE4.selectedOpp = testOpp4User.Id;*/
			System.Test.stopTest();
	    }
    }//System.RunAs
}