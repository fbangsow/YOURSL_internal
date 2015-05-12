trigger opportunityLineItem_A on OpportunityLineItem (after delete, after insert, after undelete, after update) {
	list<id> oppIds = new list<id>();
	list<OpportunityLineItem> OLIs = new list<OpportunityLineItem>();
	list<Opportunity> opps = new list<Opportunity>();
	map<id, double> oppToSumBillable = new map<id, double>();
	map<id, double> oppToSumNonBillable = new map<id, double>();
	
	
	if(Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
		for(OpportunityLineItem t : trigger.new) {
			oppIds.add(t.Opportunityid);
		}
	} else { //Trigger.isDelete
		for(OpportunityLineItem t : trigger.old) {
			oppIds.add(t.Opportunityid);
		}
	}
	
	OLIs = new list<OpportunityLineItem>([SELECT id, Total_Booked_Hours_billable__c, Total_booked_hours_non_billable__c, Opportunityid 
				FROM OpportunityLineItem
				WHERE Opportunityid IN : oppIds]);
	for(OpportunityLineItem ol : OLIs) {
		if(ol.Total_Booked_Hours_billable__c != null && ol.Total_Booked_Hours_billable__c != 0) {
			if(oppToSumBillable.containsKey(ol.Opportunityid)) {
				oppToSumBillable.put(ol.Opportunityid, oppToSumBillable.get(ol.Opportunityid) + ol.Total_Booked_Hours_billable__c);
			} else {
				oppToSumBillable.put(ol.Opportunityid, ol.Total_Booked_Hours_billable__c);
			}
		}
		if(ol.Total_booked_hours_non_billable__c != null && ol.Total_booked_hours_non_billable__c != 0) {
			if(oppToSumNonBillable.containsKey(ol.Opportunityid)) {
				oppToSumNonBillable.put(ol.Opportunityid, oppToSumNonBillable.get(ol.Opportunityid) + ol.Total_booked_hours_non_billable__c);
			} else {
				oppToSumNonBillable.put(ol.Opportunityid, ol.Total_booked_hours_non_billable__c);
			}
		}
	}
	
	opps = new list<Opportunity>([Select id, Sum_of_Hours_billable__c, Sum_of_Hours_non_billable__c 
									FROM Opportunity
									WHERE id IN : oppIds]);
	for(Opportunity opp : opps) {
		if(oppToSumBillable.containsKey(opp.id)) {
			opp.Sum_of_Hours_billable__c = oppToSumBillable.get(opp.id);
		} else {
			opp.Sum_of_Hours_billable__c = 0;
		}
		if(oppToSumNonBillable.containsKey(opp.id)) {
			opp.Sum_of_Hours_non_billable__c = oppToSumNonBillable.get(opp.id);
		} else {
			opp.Sum_of_Hours_non_billable__c = 0;
		}
	}
	update opps;
}