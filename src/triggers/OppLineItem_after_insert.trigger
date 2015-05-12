trigger OppLineItem_after_insert on OpportunityLineItem (after insert, after update, after delete) {
	Produkt_Ressourcen_Forecast__c prf = new Produkt_Ressourcen_Forecast__c();
	Produkt_Ressourcen_Forecast__c prf2 = new Produkt_Ressourcen_Forecast__c();
	List<Produkt_Ressourcen_Forecast__c> prf3 = new List<Produkt_Ressourcen_Forecast__c>();
	PricebookEntry prbe = new PricebookEntry();
	

	
	if(trigger.isUpdate){
		
		
		OpportunityLineItem oli;
		for ( Integer i=0 ; i < trigger.new.size(); i++){
		oli = trigger.new[i];
		prf3 = [SELECT Id,  Opportunity_Line_Item_Id__c FROM Produkt_Ressourcen_Forecast__c WHERE Opportunity_Line_Item_Id__c =: oli.Id];
		if(prf3.size()==1){
			prf2 = prf3[0];
			prf2.Unit__c = oli.Unit__c;
			prf2.Sales_Price__c = oli.UnitPrice;
			prf2.SFDC_Lizenz_Preis__c = oli.SFDC_Lizenz_Preis__c;
			prf2.Quantity__c = oli.Quantity;
			prbe = [SELECT Id, Product2Id, ProductCode from PricebookEntry WHERE  Id =: oli.PricebookEntryId];
			prf2.Product__c = prbe.Product2Id;
			prf2.Cost_Type__c = oli.Kostenart_del__c;
			prf2.Cost__c = oli.Cost__c;
			prf2.Product_Code__c = prbe.ProductCode;
			prbe = [SELECT Id, Product2Id, ProductCode from PricebookEntry WHERE  Id =: oli.PricebookEntryId];
			prf2.Product__c = prbe.Product2Id;
			prf2.Product_Code__c = prbe.ProductCode;
			prf2.Contact__c = oli.Contact__c;
			prf2.Subunternehmen_a__c = oli.Sub_Unternehmen__c;
			
			update prf2;
		}
		}
	}
	if(trigger.isInsert){
		OpportunityLineItem oli;
		for ( Integer i=0 ; i < trigger.new.size(); i++){
		oli = trigger.new[i];
			prf = new Produkt_Ressourcen_Forecast__c(Opportunity_TS_BETA__c = oli.OpportunityId);
			prf.Unit__c = oli.Unit__c; 
			prf.Sales_Price__c = oli.UnitPrice;
			prf.SFDC_Lizenz_Preis__c = oli.SFDC_Lizenz_Preis__c;
			prf.Quantity__c = oli.Quantity;
			prbe = [SELECT Id, Product2Id, ProductCode from PricebookEntry WHERE  Id =: oli.PricebookEntryId];
			prf.Product__c = prbe.Product2Id;
			prf.Cost_Type__c = oli.Kostenart_del__c;
			prf.Opportunity_Line_Item_Id__c = oli.Id;
			prf.Cost__c = oli.Cost__c;
			prf.Product_Code__c = prbe.ProductCode;
			prf.Contact__c = oli.Contact__c;
			prf.Subunternehmen_a__c = oli.Sub_Unternehmen__c;
			//prf.Opportunity_TS_BETA__c = oli.OpportunityId;
			System.debug('+++++++'+' oppid: '+ oli.OpportunityId + ' oli.Id: '+oli.Id );
			System.debug('+++++++'+' prbe.Product2Id: '+ prbe.Product2Id + ' prbe.ProductCode: '+prbe.ProductCode );
			insert prf;
		}
	}
	if(trigger.isDelete){
		
		prf3 = [SELECT Id,  Opportunity_Line_Item_Id__c FROM Produkt_Ressourcen_Forecast__c WHERE Opportunity_Line_Item_Id__c =: trigger.old[0].Id];
		if(prf3.size()==1){
			delete prf3;
		}
	}

}