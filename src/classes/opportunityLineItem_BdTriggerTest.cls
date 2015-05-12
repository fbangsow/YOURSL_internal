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
private class opportunityLineItem_BdTriggerTest {

    static testMethod void myUnitTest() {
			Account testAcc = new Account(
				Name ='TestACC',
				BillingCity ='testcity',
				BillingStreet = 'teststreet',
				BillingPostalCode = '1234'
			);
				
			insert testAcc;
			
			Product2 testProduct= new Product2(
				 Name='TestProduct',
				 IsActive=true
			);
			insert testProduct;
			
			Pricebook2 temppb = [SELECT Id, Name, IsActive, IsStandard FROM Pricebook2 WHERE IsStandard = true limit 1];
			
			PricebookEntry pbe= new PricebookEntry( Pricebook2Id=temppb.Id, Product2Id= testProduct.Id, UnitPrice=249.0, IsActive=true,UseStandardPrice=false);
			insert pbe;
			
			OpportunityStage stageWON = [Select MasterLabel, IsWon, IsActive, Id, DefaultProbability From OpportunityStage WHERE DefaultProbability = 100 AND IsWon = true AND IsActive = true];
			
			Opportunity testOpp = new Opportunity(
				Pricebook2Id= temppb.Id,
				Name ='TestOpp' ,
				AccountId= testAcc.Id,
				CloseDate= System.today().addDays(-9),
				StageName = stageWON.Masterlabel
			);
			insert testOpp;
			
			OpportunityLineItem testOLI = new OpportunityLineItem(
				OpportunityId=testOpp.Id, 
				Leistung_erbracht__c = false, 
				PricebookEntryId=pbe.Id, 
				UnitPrice=1.5, 
				Quantity=32.00, 
				Unit__c='Manntag(e)',
				ServiceDate = System.today(),
				Total_Booked_Hours_billable__c = 20.00
			);
			insert testOLI;
			
			try{
				delete testOLI;
			}catch(Exception e){
				 e.getMessage().contains('Can not delete record due to booked billable hours');
			}
			
			
			
			
			
    }
}