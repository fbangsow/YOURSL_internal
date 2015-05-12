@isTest
private class TestExtensionControllerQuote {

    public static testMethod void testExtensionControllerQuote() {
        
        // testaccount
        Account testaccount = new Account (Name = 'TestAccount');
        insert testaccount;
        
        // onedate
        Date onedate = Date.valueOf('2009-04-04');
        
        // testprod
        Product2 testprod = new Product2(Name='TestProduct',Description='TestDescription');
        testprod.Produktname_lang__c = 'TestHeaderDescription';
        insert testprod;
        
        // testopportunity
        Opportunity testopportunity = new Opportunity (Name = 'TestOpp', 
                                    StageName = 'Prospecting', 
                                    CloseDate = onedate, 
                                    AccountId = testaccount.Id);
        insert testopportunity;
        
        // pb = standart Pricebook
        Pricebook2 pb =[select name,isactive from Pricebook2 where isStandard=true];
      /*  if(!pb.isactive){
        pb.isactive=true;
        Database.update(pb);
        }*/
        
        // testquote
        Quote testquote = new Quote ( Name = 'TestQuote', 
                            OpportunityId = testopportunity.Id,
                            Pricebook2Id=pb.id );
        insert testquote;
        
        // testphase
        QuotePhase__c testphase = new QuotePhase__c ( 
                                                QuotePhaseName_Formula__c = 'Phase 00: 123456890', 
                                                Quote__c = testquote.Id
                                                );
        insert testphase;
        
        // stage = OpportunityStage for Masterlabel
        OpportunityStage stage=[select Masterlabel from OpportunityStage where Masterlabel != '' limit 1];
        
        // opp = Opportunity
        Opportunity opp = new Opportunity();
        opp.Name='TestOpp';
        opp.AccountID=testaccount.id;
        opp.CloseDate=date.today();
        opp.StageName=stage.masterlabel;
        opp.Pricebook2Id=pb.id;
        insert opp;
        
        // p = Product
        Product2 p = new Product2();
        p.Name='TestProd';
        p.Produktname_lang__c ='TestDescription';
        p.IsActive=true;
        insert p;
        
        // sumTotalPrice = double
        double sumTotalPrice = 2.0;
        
        // SumOfPhase = double
        double SumOfPhase = 0.0;
        
        //pbe = pricebook entry
        PricebookEntry pbe=new PricebookEntry();
        pbe.Pricebook2Id=pb.id;
        pbe.Product2Id=p.id;
        pbe.UnitPrice = sumTotalPrice;
        pbe.IsActive=true;
        insert pbe;
        
        
        // testlineitem = QuoteLineItem
        // test2lineitem = QuoteLineItem
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

       /* // qwp = QuotePhaseWrapper
        QuotePhaseWrapper qwp=new QuotePhaseWrapper();
        qwp.quoteLineItems.add(testlineitem);
        qwp.quotePhase =testphase;
*/
        //user
        Profile admin = [select id, name from Profile where name = 'System Administrator' OR name = 'Systemadministrator']; 
        List<User> testusers = [select email, id, name, ProfileId from user where isActive=true and ProfileId= :admin.Id LIMIT 1];
        system.assert ( testusers.size() == 1);

        for (Integer i = 0; i < 1;i++){
            System.runAs(testusers[i]) {
                system.debug('username' + testusers[i].name);
            }}
        
        // generate page
        PageReference pageRef = Page.Quote2PDF_Page;
        pageRef.getParameters().put('id', testquote.id); 
        Test.setCurrentPage(pageRef);
        
        //System.Debug('#testquote:' + testquote); positiv
        
                System.Debug('#QuoteLineItems: ' + [Select o.New_Section_Headline__c, 
                    o.Sort_Order__c,   
                    o.Quantity, 
                    o.Einheit__c, 
                    o.PricebookEntry.Name, 
                    o.PricebookEntryId, 
                    o.Product_lineitem_description__c, 
                    o.QLI_Explanation_of_Singleprice__c,
                    o.UnitPrice, 
                    o.TotalPrice
                   From QuoteLineItem o 
                   Where o.QuoteId =: ApexPages.currentpage().getParameters().get('id')
                   ORDER BY Sort_Order__c ASC limit 100
            ]);
        
        ApexPages.Standardcontroller controller = New ApexPages.StandardController(testquote);
        
        //System.Debug('#controller: ' + controller); == 'ApexPages.StandardController[Quote]'
        ExtensionControllerQuote ext = new ExtensionControllerQuote(controller); 
        ext.init();
        
        String nextPage = controller.save().getUrl();
        string testquoteid = '/' + testquote.Id;
        //nextPage = '/' + nextPage;
        
        // Verify that page fails without parameters  
        System.assertEquals( testquoteid.substring(0,16),  nextPage.substring(0,16));
//      system.debug('testquoteid.substring(0,18) ' + testquoteid.substring(0,12));
//      system.debug('nextPage' + nextPage);
//        List<QuotePhaseWrapper> testextquotePhases = new List<QuotePhaseWrapper>();
        List<QuoteLineItem> testextQuoteLineItemsSorted = new List<QuoteLineItem>();
//        List<QuotePhase__c> testextQuotePhaseSorted = new List<QuotePhase__c>();
        
        //System.currentPageReference().getParameters().put('testquote.Id', testquote.id);
    
//        ext.QuotePhaseSorted.add(testphase);
        ext.QuoteLineItemsSorted.add(testlineitem);
//        ext.quotePhases.add(qwp);
        
        //system.assertequals(ext.QuotePhaseSorted[0].Id,testphase.Id);
        system.assertequals(ext.QuoteLineItemsSorted[0].Id,testlineitem.Id);
        //system.assertequals(ext.quotePhases[0],qwp);

        //qwp.quotePhase = testphase;
        //qwp.quoteLineItems.add(testlineitem);
        system.debug(ApexPages.currentPage().getUrl());
        try {
            //system.assertEquals(qwp.quotePhase, ext.QuotePhaseSorted[0]);
            //system.assertEquals(qwp.quoteLineItems[0], ext.QuoteLineItemsSorted[0]);
            //system.assertEquals(qwp, ext.quotePhases[0]);
        }
        catch (ListException e) {
            system.debug('Test failed Alex!');
        }
        
        
        //List<QuotePhaseWrapper> quotePhases  = new List<QuotePhaseWrapper> () ;
        List<QuoteLineItem> QuoteLineItemsSorted = new List<QuoteLineItem>() ;
        //List<QuotePhase__c> QuotePhaseSorted = new List<QuotePhase__c>() ;
        Quote selectedQuote = new Quote();
        
        /*   QuotePhaseSorted = new List<QuotePhase__c>();
           QuotePhaseSorted = [
                                Select Id From QuotePhase__c Where Id = :testphase.Id
                                ORDER BY Name ASC limit 100
            ];
        */    
               QuoteLineItemsSorted = new List<QuoteLineItem>();
                QuoteLineItemsSorted =
                               [ Select Id From QuoteLineItem Where QuoteId =: testquote.Id
                               ORDER BY Sort_Order__c ASC limit 100
                ];
                
/*       List<QuotePhaseWrapper> quotePhases2  = new List<QuotePhaseWrapper> () ;

       for (QuotePhase__c phase : QuotePhaseSorted)
       {
           QuotePhaseWrapper qwp2=new QuotePhaseWrapper();
           qwp2.quotePhase = testphase;
           for (QuoteLineItem qli : [ Select Id,
                                     QuoteId, PricebookEntryId, quantity, discount, totalprice, Sort_Order__c, QuotePhase__c, UnitPrice
                                    From QuoteLineItem Where QuoteId =: testquote.Id])
           {
               system.assert(qli.QuotePhase__c == QuotePhaseSorted[0].Id);
                   qwp2.quoteLineItems.add(qli);
           }
           quotePhases2.add(qwp2); 
       }
*/       
       //system.assert( ext.QuotePhaseSorted == QuotePhaseSorted);
//        system.debug('ext.QuotePhaseSorted' + ext.QuotePhaseSorted.size() );
//        system.debug('quotePhases2' + quotePhases2 );
        //system.assertequals(quotePhases2[0].quotePhase.Id,testphase.Id);
        //system.assertequals(quotePhases2[0].quoteLineItems[0].Id,testlineitem.Id);
        //system.assertequals(quotePhases[1],qwp);

    } // end testmethod
    
    
        static testMethod void TestQuotePhaseSumChangeTrigger() {
        // TO DO: implement unit test
        
        Account testaccount = new Account (Name = 'TestAccount');
        insert testaccount;
        Date onedate = Date.valueOf('2009-04-04');
        Product2 testprod = new Product2(Name='TestProduct',Description='TestDescription', Produktname_lang__c = 'TestHeaderDescription');

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
    
    
    
} // end class