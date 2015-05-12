trigger Kreditor_Invoice_Status_aInsert_aUpdate on Kreditor_Invoice_Status__c (before insert, before update) {
	
		Chart_of_Accounts__c Kasse = [SELECT Id, Name FROM Chart_of_Accounts__c WHERE Name = '1000' LIMIT 1];
		Chart_of_Accounts__c Bank = [SELECT Id, Name FROM Chart_of_Accounts__c WHERE Name = '1200' LIMIT 1];
//		List <Kreditor_Invoice_Status__c> lstKreditorStatus;
//		lstKreditorStatus= Trigger.new;
//		List <Id> lstKreditor = lstKreditorStatus.get(Kreditor_Invoice__c);
//		//[SELECT Id FROM Kreditor__c WHERE Id IN  :lstKreditorStatus.get(Kreditor_Invoice__c)];
		//List <Id> idKreditorId = new List <Id>();
		//Map <Id, Kreditor__c> mapKreditor = new Map <Id, Kreditor__c>{};
	list<id> idsOfKreditor = new list<id>();
	for(Kreditor_Invoice_Status__c objKreditorStatus : Trigger.new){
		idsOfKreditor.add(objKreditorStatus.Kreditor_Invoice__c);
	}
	list<Kreditor__c> lstKreditor = [SELECT Id, Outgoing_Invoice__c, Name FROM Kreditor__c WHERE Id IN: idsOfKreditor];
		//Kreditor__c objKreditor = [SELECT Id, Outgoing_Invoice__c, Name FROM Kreditor__c WHERE Id =: objKreditorStatus.Kreditor_Invoice__c];
	list<Kreditor__c> lstKreditorToUpdate = new list<Kreditor__c>();
	for(Kreditor_Invoice_Status__c objKreditorStatus : Trigger.new) {
		for(Kreditor__c objKreditor : lstKreditor) {
			if(objKreditor.Id == objKreditorStatus.Kreditor_Invoice__c) {
				if(objKreditorStatus.debit_account__c == Kasse.Id || objKreditorStatus.debit_account__c == Bank.Id) {
					objKreditor.Outgoing_Invoice__c = false;
				} else {
					objKreditor.Outgoing_Invoice__c = true;	
			
				}
			}
			lstKreditorToUpdate.add(objKreditor);
		}
	}
	update lstKreditorToUpdate;
}