@isTest
private class TestQuotePhaseSumChangeTrigger {

    static testMethod void TestQuotePhaseSumChangeTrigger() {
        // TO DO: implement unit test
        
        Account testaccount = new Account (Name = 'TestAccount');
        insert testaccount;
        Date onedate = Date.valueOf('2009-04-04');
        Product2 testprod = new Product2(Name='TestProduct',
        								Description='TestDescription',
        								Produktname_lang__c = 'TestHeaderDescription'
        								);
        insert testprod;
        
        Opportunity testopportunity = new Opportunity (Name = 'TestOpp', 
        							StageName = 'Prospecting', 
        							CloseDate = onedate, 
        							AccountId = testaccount.Id);
        insert testopportunity;
        
		// Get the standard pricebook
		Pricebook2 pb =[select name,isactive from Pricebook2 where isStandard=true];
		/*if(!pb.isactive){
		pb.isactive=true;
		Database.update(pb);
		}*/
		
		Quote testquote = new Quote ( Name = 'TestQuote', 
        					OpportunityId = testopportunity.Id,
        					Pricebook2Id=pb.id );
        insert testquote;
        
        QuotePhase__c testphase = new QuotePhase__c ( 
        										QuotePhaseName_Formula__c = 'Phase 00: 123456890', 
        										Quote__c = testquote.Id );
        insert testphase;
		// get valid stage name
		OpportunityStage stage=[select Masterlabel from OpportunityStage where Masterlabel != '' limit 1];
		
		// setup basic opportunity
		Opportunity opp = new Opportunity();
		opp.Name='TestOpp';
		opp.AccountID=testaccount.id;
		opp.CloseDate=date.today();
		opp.StageName=stage.masterlabel;
		opp.Pricebook2Id=pb.id;
		insert opp;
		
		// Create a product2
		Product2 p = new Product2();
		p.Name='TestProd';
		p.Produktname_lang__c ='TestDescription';
		p.IsActive=true;
		insert p;
		

		double sumTotalPrice = 2.0;
		//Create pricebook entry
		PricebookEntry pbe=new PricebookEntry();
		pbe.Pricebook2Id=pb.id;
		pbe.Product2Id=p.id;
		pbe.UnitPrice = sumTotalPrice;
		pbe.IsActive=true;
		insert pbe;
		double SumOfPhase = 0.0;
		
		system.assertEquals(testphase.Sum_of_Phases__c, null);
		
		// create opportunity line item
		QuoteLineItem testlineitem = new QuoteLineItem();
		QuoteLineItem test2lineitem = new QuoteLineItem();
		testlineitem.QuoteId=testquote.id;
		testlineitem.PricebookEntryId=pbe.id;
		testlineitem.quantity=1;
		testlineitem.discount=0.0;  
		//testlineitem.totalprice = sumTotalPrice;
		testlineitem.Sort_Order__c = 1;
		testlineitem.QuotePhase__c = testphase.Id;
		testlineitem.UnitPrice = sumTotalPrice;
		insert testlineitem;
		system.assertNotEquals(testphase.Sum_of_Phases__c, SumOfPhase);
		system.assertEquals(testlineitem.TotalPrice, testphase.Sum_of_Phases__c);
		test2lineitem = [select Id, TotalPrice, UnitPrice, quantity from QuoteLineItem where Id =: testlineitem.Id];
		system.assertEquals(testlineitem.UnitPrice, sumTotalPrice);

		// create opportunity line item
		testlineitem.quantity=2;
		update testlineitem;
		system.assertEquals(testlineitem.TotalPrice, testphase.Sum_of_Phases__c);
		test2lineitem = [select Id, TotalPrice, UnitPrice, quantity from QuoteLineItem where Id =: testlineitem.Id];
		system.assertEquals(testlineitem.quantity, test2lineitem.quantity);
		system.assertEquals(testlineitem.UnitPrice, test2lineitem.UnitPrice);
		system.assertEquals(testlineitem.quantity, test2lineitem.quantity);
		system.assertEquals(testlineitem.TotalPrice, testphase.Sum_of_Phases__c);
		delete testlineitem;
		system.assertEquals(null, testphase.Sum_of_Phases__c);
		try {
			    update testlineitem;
			} catch (system.Dmlexception e) {
			    system.assert( e.getMessage().contains('entity is deleted'));
			}

    }
}