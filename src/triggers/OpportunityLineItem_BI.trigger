/* **************************************************************

// Created by: Alexander Faust	

// Description: Reset's fields which are set by TimeEntry creation.This caused problems while cloning opportunities

// Testclass: Opportunity_BI_Test

// Last modified by: Alexander Faust

// Last modified date: 10.12.2012

// Latests changes: creation

// ************************************************************** */

trigger OpportunityLineItem_BI on OpportunityLineItem (before insert) {

	for(OpportunityLineItem oli: trigger.new){
		if(oli.Total_Booked_Hours_billable__c > 0.0){
			oli.Total_Booked_Hours_billable__c = 0.0;
		}
		if(oli.Total_booked_hours_non_billable__c > 0.0){
			oli.Total_booked_hours_non_billable__c = 0.0;
		}
	}
}