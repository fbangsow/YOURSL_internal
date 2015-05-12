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
@isTest
private class TestQuotePhaseWrapper {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Account testaccount = new Account (Name = 'TestAccount');
        insert testaccount;
        Date onedate = Date.valueOf('2009-04-04');
        Product2 testprod = new Product2(Name='TestProduct',Description='TestDescription',
        								Produktname_lang__c='TestDescription' );
        
        Opportunity testopportunity = new Opportunity (Name = 'TestOpp', 
        							StageName = 'Prospecting', 
        							CloseDate = onedate, 
        							AccountId = testaccount.Id);
        insert testopportunity;
        
        Quote testquote = new Quote ( Name = 'TestQuote', 
        					OpportunityId = testopportunity.Id );
        insert testquote;
        
        QuotePhase__c testphase = new QuotePhase__c ( 
        										QuotePhaseName_Formula__c = 'Phase 00: 123456890', 
        										Quote__c = testquote.Id );
        insert testphase;
        
        QuoteLineItem testlineitem = new QuoteLineItem(
        							QuotePhase__c = testphase.Id, 
        							QuoteId = testquote.Id);
        
	      
	  QuotePhaseWrapper qwp=new QuotePhaseWrapper();
	  qwp.quoteLineItems.add(testlineitem);
	  qwp.quotePhase =testphase;
    }
}