/* **************************************************************
// Creater: ??
// Last modified by: Alexander Placidi
// Last modified date: 08.09.2014
// Latests changes: ??
// 					08.09.2014: added two new bank accounts, removed old credit cards, added this header
// ************************************************************** */
trigger Kreditor_Invoice_Status_BIBU on Kreditor_Invoice_Status__c (before insert, before update) {
	
	/*Id bank1TransferId = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Bank HVB *0343' LIMIT 1].id; //Kontorahmen 1200
	Id bank2TransferId = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Bank HVB *8380' LIMIT 1].id; //Kontorahmen 1201
	Id bank3TransferId = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Deutsche Bank *3200' LIMIT 1].id; //Kontorahmen 1210
	Id bank4TransferId = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Bank HVB *9333' LIMIT 1].id; //Kontorahmen 1220
	
    Id bank5TransferId = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Bank HVB *9250 Sparkonto' LIMIT 1].id;
    Id bank6TransferId = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Bank HVB *1982 USD' LIMIT 1].id;
    
    //id directDebitId = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Bank' LIMIT 1].id;
	//Id creditCard0Id = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Mastercard xx1000931' LIMIT 1].id;//1361
	//Id creditCard1Id = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Mastercard x20452043' LIMIT 1].id;//1365
	//Id creditCard2Id = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Mastercard xx9019208' LIMIT 1].id;//1362
	Id creditCard3Id = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'MasterCard Lufthansa TCS *0330' LIMIT 1].id;//1366
// ts
	Id creditCard4Id = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'MasterCard TCS *8341' LIMIT 1].id;// 1367
	Id creditCard5Id = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'MasterCard THK *8333' LIMIT 1].id;// 1368
	Id creditCard6Id = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'MasterCard Porsche TCS *0873' LIMIT 1].id;// 1370
	Id creditCard7Id = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'MasterCard L.Sch. *8499' LIMIT 1].id;// kontorahmen 1363
	
	Id cashId = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Kasse'].id;//1000
	Id cashTHK = [SELECT id FROM Chart_of_Accounts__c WHERE Account_Type__c = 'Kreditoren' and Account_Description__c = 'Köhler Thorsten,' LIMIT 1].Id;//71001
	Id cashTS = [SELECT id FROM Chart_of_Accounts__c WHERE Account_Type__c = 'Kreditoren' and Account_Description__c = 'Scheuermann Torsten,' LIMIT 1].Id; //71901  */

	Map<Id, AccountAssignment__c> assignmentsMap = new Map<Id, AccountAssignment__c>([SELECT ID, PaymentMethod__c, Kontenrahmen__c FROM AccountAssignment__c]);
	Map<String, ID> paymentToAccountMap = new Map<String, Id>();
	if(assignmentsMap != null){
		for(AccountAssignment__c ass : assignmentsMap.values()){
			paymentToAccountMap.put(ass.PaymentMethod__c, ass.Kontenrahmen__c);
		}
	}
	


	list<id> invoiceIds = new list<id>();
	map<id, Kreditor__c> idToInvoice = new map<id, Kreditor__c>();
	
	//setting the ids of the VAT Accounts, getting the ids of all accounts (in order to set Kreditorennummer__c)			
	for(Kreditor_Invoice_Status__c invoiceStatus : trigger.new) {
		invoiceIds.add(invoiceStatus.Kreditor_Invoice__c);
	}
	idToInvoice = new map<id, Kreditor__c>([SELECT Id, VAT_Account_new__c, Kreditorennummer__c FROM Kreditor__c WHERE Id IN: invoiceIds]);
	for(integer i = 0; i < trigger.new.size(); i++) {
		trigger.new[i].VAT_Account__c = idToInvoice.get(trigger.new[i].Kreditor_Invoice__c).VAT_Account_new__c;
		if(idToInvoice.get(trigger.new[i].Kreditor_Invoice__c).Kreditorennummer__c != null) {
			trigger.new[i].Kreditorennummer__c = idToInvoice.get(trigger.new[i].Kreditor_Invoice__c).Kreditorennummer__c;
		} else {
			trigger.new[i].addError('Cannot save Eingangsrechnungsstatus, Eingangsrechnung has no Kreditorennummer');
		}
		if(Trigger.isInsert && trigger.new[i].Payment_Status__c == 'Paid' ||
			Trigger.isUpdate && trigger.new[i].Payment_Status__c == 'Paid') 
		{
			if(trigger.new[i].Paid_new__c == null) {
				trigger.new[i].Paid_new__c = Date.today();
			}
			
			/*if(trigger.new[i].Payment_method__c == 'Überweisung für Bank HVB *0343' || trigger.new[i].Payment_method__c == 'Bankeinzug für Bank HVB *0343' ) {trigger.new[i].credit_account__c = bank1TransferId;}
			if(trigger.new[i].Payment_method__c == 'Überweisung für Bank HVB *8380' || trigger.new[i].Payment_method__c == 'Bankeinzug für Bank HVB *8380' ) {trigger.new[i].credit_account__c = bank2TransferId;}
			if(trigger.new[i].Payment_method__c == 'Überweisung für Deutsche Bank' || trigger.new[i].Payment_method__c == 'Bankeinzug für Deutsche Bank' ) {trigger.new[i].credit_account__c = bank3TransferId;}
			if(trigger.new[i].Payment_method__c == 'Überweisung für Bank HVB *9333' || trigger.new[i].Payment_method__c == 'Bankeinzug für Bank HVB *9333' ) {trigger.new[i].credit_account__c = bank4TransferId;}
			
			if(trigger.new[i].Payment_method__c == 'Überweisung für Bank HVB *9250 Sparkonto' || trigger.new[i].Payment_method__c == 'Bankeinzug für Bank HVB *9250 Sparkonto' ) {trigger.new[i].credit_account__c = bank5TransferId;}            
			if(trigger.new[i].Payment_method__c == 'Überweisung für Bank HVB *1982 USD' || trigger.new[i].Payment_method__c == 'Bankeinzug für Bank HVB *1982 USD' ) {trigger.new[i].credit_account__c = bank6TransferId;}
            
            //if(trigger.new[i].Payment_method__c == 'KK THK *0931') {trigger.new[i].credit_account__c = creditCard0Id;}
			//if(trigger.new[i].Payment_method__c == 'KK LSch. *2043') {trigger.new[i].credit_account__c = creditCard1Id;}
			//if(trigger.new[i].Payment_method__c == 'KK TCS *9208') {trigger.new[i].credit_account__c = creditCard2Id;}
			if(trigger.new[i].Payment_method__c == 'KK TCS Lufthansa *0330') {trigger.new[i].credit_account__c = creditCard3Id;}
			if(trigger.new[i].Payment_method__c == 'KK TCS *8341') {trigger.new[i].credit_account__c = creditCard4Id;}
			if(trigger.new[i].Payment_method__c == 'KK THK *8333') {trigger.new[i].credit_account__c = creditCard5Id;}
			if(trigger.new[i].Payment_method__c == 'Bar') {trigger.new[i].credit_account__c = cashId;}
			if(trigger.new[i].Payment_method__c == 'bezahlt THK'){trigger.new[i].credit_account__c = cashTHK;}
			if(trigger.new[i].Payment_method__c == 'MasterCard Porsche TCS *0873'){trigger.new[i].credit_account__c = creditCard6Id;}
			if(trigger.new[i].Payment_method__c == 'KK LSch *8499') {trigger.new[i].credit_account__c = creditCard7Id;}
			if(trigger.new[i].Payment_method__c == 'bezahlt TCS') {trigger.new[i].credit_account__c = cashTS;}*/
			ID accountToAssign = paymentToAccountMap.get(trigger.new[i].Payment_method__c);
			if(accountToAssign != null){
				if(String.isBlank(trigger.new[i].credit_account__c)){
					trigger.new[i].credit_account__c = accountToAssign;
				}
				
			}
			
			
		}
		if(Trigger.isInsert && trigger.new[i].Payment_Status__c == 'Unpaid' ||
			Trigger.isUpdate && trigger.new[i].Payment_Status__c == 'Unpaid') 
		{
			if(trigger.new[i].Payment_method__c == null) {
				trigger.new[i].credit_account__c = null;
				trigger.new[i].Paid_new__c = null;}
		}
	}
}