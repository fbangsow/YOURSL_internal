trigger QuotePhaseSumChange on QuoteLineItem (after update, after insert, after delete) {
	double sumTotalPrice = 0.0;
	if (Trigger.isUpdate){
		for (QuoteLineItem qli1 : Trigger.old) {
			sumTotalPrice = qli1.TotalPrice;
			Set <Id> phaseId = new Set<Id>();
			phaseId.add(qli1.QuotePhase__c);
			List <QuotePhase__c> ALLphaseToUpdate = [select id, Sum_of_Phases__c from QuotePhase__c where id in : phaseId];
			
			for (QuotePhase__c phaseToUpdate : ALLphaseToUpdate) {
				phaseToUpdate.Sum_of_Phases__c = phaseToUpdate.Sum_of_Phases__c - sumTotalPrice;
				update phaseToUpdate;
			}
		}
		for (QuoteLineItem qli2 : Trigger.new) {
			sumTotalPrice = qli2.TotalPrice;
			Set <Id> phaseId = new Set<Id>();
			phaseId.add(qli2.QuotePhase__c);

			List <QuotePhase__c> ALLphaseToUpdate = [select id, Sum_of_Phases__c from QuotePhase__c where id in : phaseId];
			for (QuotePhase__c phaseToUpdate : ALLphaseToUpdate) {
				phaseToUpdate.Sum_of_Phases__c = phaseToUpdate.Sum_of_Phases__c + sumTotalPrice;
				update phaseToUpdate;
			}
		}
	}
		if (Trigger.isInsert){
			for (QuoteLineItem qli3 : Trigger.new) {
				sumTotalPrice = qli3.TotalPrice;
				Set <Id> phaseId = new Set<Id>();
				phaseId.add(qli3.QuotePhase__c);
				List <QuotePhase__c> ALLphaseToUpdate = [select id, Sum_of_Phases__c from QuotePhase__c where id in : phaseId];
				for (QuotePhase__c phaseToUpdate : ALLphaseToUpdate) {
					phaseToUpdate.Sum_of_Phases__c = phaseToUpdate.Sum_of_Phases__c + sumTotalPrice;
					update phaseToUpdate;
				}
			}
		}
			if (Trigger.isDelete){
			for (QuoteLineItem qli4 : Trigger.old) {
				sumTotalPrice = qli4.TotalPrice;
				Set <Id> phaseId = new Set<Id>();
				phaseId.add(qli4.QuotePhase__c);
				List <QuotePhase__c> ALLphaseToUpdate = [select id, Sum_of_Phases__c from QuotePhase__c where id in : phaseId];
				for (QuotePhase__c phaseToUpdate : ALLphaseToUpdate) {
					phaseToUpdate.Sum_of_Phases__c = phaseToUpdate.Sum_of_Phases__c - sumTotalPrice;
					update phaseToUpdate;
				}
			}
		}
}