public with sharing class ClsOppLineItemWrapper {
	public OpportunityLineItem oppItem {get; set;}
	public PricebookEntry pbeName {get; set;}
	public Date oppNewDate {get; set;}

   public ClsOppLineItemWrapper() {
      pbeName = new PricebookEntry();
      oppItem = new OpportunityLineItem();
      Date oppNewDate = date.today();
   }

    static testMethod void myTest() {
        Product2 test_product = new Product2();
        test_product.Name = 'Salesforce Developer';
        test_product.isActive = true;
        test_product.CanUseQuantitySchedule = true;
        insert test_product;
        PricebookEntry price_book_entry = new PricebookEntry();
        price_book_entry.Pricebook2Id = Test.getStandardPricebookId();
        price_book_entry.Product2Id = test_product.Id;
        price_book_entry.UnitPrice = 99;
        price_book_entry.isActive = true;
        insert price_book_entry;
        Opportunity test_opportunity = new Opportunity();
        test_opportunity.Name = 'YOUR SL GmbH';
        test_opportunity.StageName = 'YOUR SL GmbH';
        test_opportunity.PriceBook2Id = Test.getStandardPricebookId();
        test_opportunity.CloseDate = Date.newInstance(2015, 1, 1);
        test_opportunity.Managed_by_PSO_Tool__c = true;
        test_opportunity.Projektstatus__c = 'Terrible';
        insert test_opportunity;
        OpportunityLineItem line_item = new OpportunityLineItem();
        line_item.ServiceDate = Date.newInstance(2015, 1, 10);
        line_item.UnitPrice = 1200;
        line_item.Quantity = 1;
        line_item.Unit__c = 'Manntag(e)';
        line_item.OpportunityId = test_opportunity.Id;
        line_item.PricebookEntryId = price_book_entry.Id;
        insert line_item;
       ClsOppLineItemWrapper twrapper = new ClsOppLineItemWrapper();
       PricebookEntry tpbe = new PricebookEntry();
       OpportunityLineItem toli = [SELECT Id, ServiceDate, Quantity, PricebookEntryId, OpportunityId, Leistung_erbracht__c FROM OpportunityLineItem WHERE IsDeleted = FALSE LIMIT 1];
       Date tdate = date.today();

       tpbe = [SELECT Id, ProductCode, Product2Id, Pricebook2Id, Name FROM PricebookEntry WHERE Id =: toli.PricebookEntryId ];

       twrapper.oppItem = toli;
       twrapper.oppNewDate = tdate;
       twrapper.pbeName = tpbe;

       System.assertEquals(twrapper.oppItem.Id, toli.Id);
       System.assertEquals(twrapper.oppNewDate, date.today());
       System.assertEquals(twrapper.pbeName.Id, toli.PricebookEntryId);
   }
}