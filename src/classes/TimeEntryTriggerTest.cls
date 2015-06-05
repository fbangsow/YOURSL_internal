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
@isTest (SeeAllData=true)
private class TimeEntryTriggerTest {

    static testMethod void myUnitTest() {
        Account testAcc = new Account(Name ='TestACC');
		
		testAcc.BillingCity ='testcity';
		testAcc.BillingStreet = 'teststreet';
		testAcc.BillingPostalCode = '1234';
		// insert Account
		insert testAcc;
		testAcc=[SELECT Id, Name FROM Account WHERE Name=:'TestACC' LIMIT 1];
			
			//new User
		User c = [SELECT ID, Name FROM USER LIMIT 1];
		
		//Product2
		Product2 testProduct= new Product2( Name='TestProduct',IsActive=true);
		insert testProduct;
		testProduct =[SELECT Name, Id,IsActive FROM Product2 WHERE Name=:'TestProduct'];
		
		
		//Pricebook2 temppb = [SELECT Id, Name, IsActive FROM Pricebook2 WHERE IsStandard = true limit 1];
		
		/*Pricebook2 mypb = new Pricebook2(
			Name='myPricebook',
			IsActive = true
		);
		
		insert mypb;*/
		
		Pricebook2 temppb = [SELECT Id, Name, IsActive, IsStandard FROM Pricebook2 WHERE IsStandard = true limit 1];
		
		System.debug('xxxxxxxxxxxxxxxxxxxx DEBUG: Name'+temppb.Name+' IsActive '+temppb.IsActive+' ID '+temppb.Id + temppb.IsStandard);
		
		//pricebookEntry new
		PricebookEntry testpbe2= new PricebookEntry( Pricebook2Id=temppb.Id, Product2Id= testProduct.Id, UnitPrice=249.0, IsActive=true,UseStandardPrice=false);
		insert testpbe2;
		
		
		//Opportunity
		Opportunity testOpp1 = new Opportunity(Pricebook2Id= temppb.Id,Name ='TestOpp1' ,AccountId= testAcc.Id,  CloseDate= System.today().addDays(9));
		testOpp1.StageName='Qualification'; 
		insert testOpp1;
				
		//OpportunityLineItem
		OpportunityLineItem testOppLineItem1 = new OpportunityLineItem(OpportunityId=testOpp1.Id, PricebookEntryId=testpbe2.Id, ServiceDate = Date.newInstance(2015, 6, 1), UnitPrice=1.5, Quantity=32.00, Unit__c='Manntag(e)');
		insert testOppLineItem1;
		
		Contact co = new Contact(
			LastName = 'TestKontakt',
			Account = testAcc
		);
		
		insert co;
		
		/*String sUrlRewrite = System.URL.getSalesforceBaseUrl().getHost();
	    	// c.cs7.visual.force.com
	    	sUrlRewrite = 'https://'
	    					+ sUrlRewrite.substring(2,6) 
					    	+ 'salesforce.com'
					    	+ '/'
					    	+ selectedTask;*/
					    	
		String oppyLink = System.URL.getSalesforceBaseUrl().getHost();
		oppyLink = 'https://'
					+ oppyLink.substring(2,6) 
			    	+ 'salesforce.com'
			    	+ '/'
			    	+testOppLineItem1.Id;
			    	
		
		
		
		TimeEntry__c timeE = new TimeEntry__c(
			Contact__c = co.Id,
			Date__c = System.today(),
			Opportunity__c = testOpp1.Id,
			Time__c = 4.0,
			Opportunity_Product__c	= oppyLink,
			Opportunity_Product_ID__c = testOppLineItem1.Id,
			Billable__c = true
		);
		
		TimeEntry__c timeE_unbillable = new TimeEntry__c(
			Contact__c = co.Id,
			Date__c = System.today(),
			Opportunity__c = testOpp1.Id,
			Time__c = 4.0,
			Opportunity_Product__c	= oppyLink,
			Opportunity_Product_ID__c = testOppLineItem1.Id,
			Billable__c = false
		);
        
        
        insert timeE;
        insert timeE_unbillable;
        
        timeE.Time__c = 4.0;
        timeE_unbillable.Time__c = 4.0;
        
        timeE.Billable__c = false;
        timeE_unbillable.Billable__c = true;
        
        update timeE;
        update timeE_unbillable;
        
        
        delete timeE;
        delete timeE_unbillable;
        
        
    }
}