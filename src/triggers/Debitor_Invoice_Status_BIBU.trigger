trigger Debitor_Invoice_Status_BIBU on Debitor_Invoice_Status__c (before insert, before update) {
	
	if(Trigger.isInsert) {
		//Allow only one Ausgangsrechnungsstatus per Ausgangsrechnung
		list<id> AusgangsRechIds = new list<id>();
		list <Debitor_Invoice_Status__c> AusgangsRechStatuses;
		
		for(Debitor_Invoice_Status__c invoiceStatus : trigger.new) {
			AusgangsRechIds.add(invoiceStatus.Debitor_Invoice__c);
		}
		AusgangsRechStatuses = new list <Debitor_Invoice_Status__c> ([SELECT Id, Debitor_Invoice__c, Debitor_Invoice__r.name FROM Debitor_Invoice_Status__c WHERE Debitor_Invoice__c IN: AusgangsRechIds]);
		if(AusgangsRechStatuses.size() > 0) {
			for(Debitor_Invoice_Status__c AusgangsRechStatus : AusgangsRechStatuses) {
				for(Debitor_Invoice_Status__c invoiceStatus : trigger.new) {
					if(invoiceStatus.Debitor_Invoice__c == AusgangsRechStatus.Debitor_Invoice__c) {
						invoiceStatus.addError('Cannot save this Ausgangsrechnungsstatus: ' + AusgangsRechStatus.Debitor_Invoice__r.name + ' has already one Ausgangsrechnungsstatus');
					}
				}
			}
		}
	}
	
	/*id bank1TransferId = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Bank HVB *0343' LIMIT 1].id; //Kontorahmen 1200
	id bank2TransferId = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Bank HVB *8380' LIMIT 1].id; //Kontorahmen 1201
	id bank3TransferId = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Deutsche Bank *3200' LIMIT 1].id; //Kontorahmen 1210
	id bank4TransferId = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Bank HVB *9333' LIMIT 1].id; //Kontorahmen 1220
	//id directDebitId = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Bank' LIMIT 1].id;
	id creditCard0Id = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Mastercard xx1000931' LIMIT 1].id;//1361
	id creditCard1Id = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Mastercard x20452043' LIMIT 1].id;//1365
	id creditCard2Id = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Mastercard xx9019208' LIMIT 1].id;//1362
	id creditCard3Id = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'MasterCard Lufthansa TCS *0330' LIMIT 1].id;
	id creditCard4Id = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'MasterCard TCS *8341' LIMIT 1].id;
	id creditCard5Id = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'MasterCard THK *8333' LIMIT 1].id;
	id cashId = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Kasse'].id;
	id cashTHK = [SELECT id FROM Chart_of_Accounts__c WHERE Account_Type__c = 'Kreditoren' and Account_Description__c = 'Köhler Thorsten,' LIMIT 1].Id;*/
	Map<Id, AccountAssignment__c> assignmentsMap = new Map<Id, AccountAssignment__c>([SELECT ID, PaymentMethod__c, Kontenrahmen__c FROM AccountAssignment__c]);
	Map<String, ID> paymentToAccountMap = new Map<String, Id>();
	if(assignmentsMap != null){
		for(AccountAssignment__c ass : assignmentsMap.values()){
			paymentToAccountMap.put(ass.PaymentMethod__c, ass.Kontenrahmen__c);
		}
	}
	
	list<id> invoiceIds = new list<id>();	
	map<id, Debitoren_Rechnung__c> idToInvoice = new map<id, Debitoren_Rechnung__c>();
	
	//setting the ids of the VAT Accounts, getting the ids of all accounts (in order to set Debitornummer__c)			
	for(Debitor_Invoice_Status__c invoiceStatus : trigger.new) {
		invoiceIds.add(invoiceStatus.Debitor_Invoice__c);
	}
	idToInvoice = new map<id, Debitoren_Rechnung__c>([SELECT Id, VAT_Account__c, Debitorennummer__c FROM Debitoren_Rechnung__c]);
	for(integer i = 0; i < trigger.new.size(); i++) {
		trigger.new[i].VAT_Account__c = idToInvoice.get(trigger.new[i].Debitor_Invoice__c).VAT_Account__c;
		
		if(idToInvoice.get(trigger.new[i].Debitor_Invoice__c).Debitorennummer__c != null) {
			trigger.new[i].Debitorennummer__c = idToInvoice.get(trigger.new[i].Debitor_Invoice__c).Debitorennummer__c;
		} else {
			trigger.new[i].addError('Cannot save Ausgangsrechnungsstatus, Ausgangsrechnung has no Debitorennummer');
		}
		
		trigger.new[i].Debitorennummer__c = idToInvoice.get(trigger.new[i].Debitor_Invoice__c).Debitorennummer__c;
		if(Trigger.isInsert && trigger.new[i].Payment_Status__c == 'Paid' ||
			Trigger.isUpdate && trigger.new[i].Payment_Status__c == 'Paid' && trigger.old[i].Payment_Status__c != 'Paid') 
		{
			if(trigger.new[i].Paid_new__c == null) {
				trigger.new[i].Paid_new__c = Date.today();
			}
			/*if(trigger.new[i].Payment_method__c == 'Überweisung für Bank HVB *0343' || trigger.new[i].Payment_method__c == 'Bankeinzug für Bank HVB *0343' ) {trigger.new[i].credit_account__c = bank1TransferId;}
			if(trigger.new[i].Payment_method__c == 'Überweisung für Bank HVB *8380' || trigger.new[i].Payment_method__c == 'Bankeinzug für Bank HVB *8380' ) {trigger.new[i].credit_account__c = bank2TransferId;}
			if(trigger.new[i].Payment_method__c == 'Überweisung für Deutsche Bank' || trigger.new[i].Payment_method__c == 'Bankeinzug für Deutsche Bank' ) {trigger.new[i].credit_account__c = bank3TransferId;}
			if(trigger.new[i].Payment_method__c == 'Überweisung für Bank HVB *9333' || trigger.new[i].Payment_method__c == 'Bankeinzug für Bank HVB *9333' ) {trigger.new[i].credit_account__c = bank4TransferId;}
			if(trigger.new[i].Payment_method__c == 'KK THK *0931') {trigger.new[i].credit_account__c = creditCard0Id;}
			if(trigger.new[i].Payment_method__c == 'KK LSch. *2043') {trigger.new[i].credit_account__c = creditCard1Id;}
			if(trigger.new[i].Payment_method__c == 'KK TCS *9208') {trigger.new[i].credit_account__c = creditCard2Id;}
			if(trigger.new[i].Payment_method__c == 'KK TCS Lufthansa *0330') {trigger.new[i].credit_account__c = creditCard3Id;}
			if(trigger.new[i].Payment_method__c == 'KK TCS *8341') {trigger.new[i].credit_account__c = creditCard4Id;}
			if(trigger.new[i].Payment_method__c == 'KK THK *8333') {trigger.new[i].credit_account__c = creditCard5Id;}
			if(trigger.new[i].Payment_method__c == 'Bar') {trigger.new[i].credit_account__c = cashId;}
			if(trigger.new[i].Payment_method__c == 'bezahlt THK'){trigger.new[i].credit_account__c = cashTHK;}*/
			ID accountToAssign = paymentToAccountMap.get(trigger.new[i].Payment_method__c);
			if(accountToAssign != null){
				if(String.isBlank(trigger.new[i].credit_account__c)){
					trigger.new[i].credit_account__c = accountToAssign;
				}
				
			}
			
		}

	}

}