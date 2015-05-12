public with sharing class OppLineItem_After_insert_Trigger_Test {
    public static testmethod void test()
    {
    	//-*-*-*-*-*-*-*-*-*-
        // A C C O U N T
        //-*-*-*-*-*-*-*-*-*-
        Account acc = new Account(name='test');
        insert acc;
        

        //-*-*-*-*-*-*-*-*-*-
        // C O N T A C T
        //-*-*-*-*-*-*-*-*-*-
        Contact c = new Contact(LastName='test',AccountId=acc.Id);
        insert c;
        
         //-*-*-*-*-*-*-*-*-*-
        // P R O D U C T
        //-*-*-*-*-*-*-*-*-*-                
        Product2 p = new product2(name='x');
        insert p;
        
        //-*-*-*-*-*-*-*-*-*-
        // P R I C E B O O K
        //-*-*-*-*-*-*-*-*-*-
        Pricebook2 stdPb = [select Id from Pricebook2 where isStandard=true limit 1];
        insert new PricebookEntry(pricebook2id = stdPb.id, product2id = p.id,unitprice=1.0, isActive=true);

        Pricebook2 pb = new pricebook2(name='test');
        insert pb;
        
        PricebookEntry pbe = new PricebookEntry(pricebook2id=pb.id, product2id=p.id, unitprice=1.0, isActive=true);
        insert pbe;
 
        //-*-*-*-*-*-*-*-*-*-
        // O P P O R T U N I T Y
        //-*-*-*-*-*-*-*-*-*-
        Opportunity o = new Opportunity(AccountId=acc.Id,name='test', pricebook2id=pb.id,stageName='Open', CloseDate=Date.newInstance(2006,10,10));
        insert o;
        
        //-*-*-*-*-*-*-*-*-*-
        // O P P O R T U N I T Y L I N E I T E M
        //-*-*-*-*-*-*-*-*-*-
        OpportunityLineItem oli = new OpportunityLineItem(opportunityid=o.id, pricebookentryid=pbe.id, unitprice=1.5, quantity=2);
        insert oli;
        update oli;


    }
}