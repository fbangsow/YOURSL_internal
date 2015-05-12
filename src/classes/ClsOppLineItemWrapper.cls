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