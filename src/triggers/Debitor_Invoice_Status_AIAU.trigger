trigger Debitor_Invoice_Status_AIAU on Debitor_Invoice_Status__c (after insert, after update) {
	list<id> AusgangsRechIds = new list<id>();
	list<Debitoren_Rechnung__c> AusRechs;
		
	for(Debitor_Invoice_Status__c invoiceStatus : trigger.new) {
		AusgangsRechIds.add(invoiceStatus.Debitor_Invoice__c);
	}
	
	AusRechs = new list<Debitoren_Rechnung__c>([SELECT Id, Paid__c, Payment_Status__c FROM Debitoren_Rechnung__c WHERE Id IN: AusgangsRechIds]);
	for(Debitoren_Rechnung__c AusRech : AusRechs) {
		for(Debitor_Invoice_Status__c invoiceStatus : trigger.new) {
			if(invoiceStatus.Debitor_Invoice__c == AusRech.id) {
				AusRech.Paid__c = invoiceStatus.Paid_new__c;
				AusRech.Payment_Status__c = invoiceStatus.Payment_Status__c;
			}
		}
	}
	
	update AusRechs;
}