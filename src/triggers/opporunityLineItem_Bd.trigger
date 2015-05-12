trigger opporunityLineItem_Bd on OpportunityLineItem (before delete) {
	
	for(OpportunityLineItem oli : trigger.old){
		if(oli.Total_Booked_Hours_billable__c > 0){
			oli.addError('Can not delete record due to booked billable hours! \r Please contact your Administrator');
		}
	}

}