/* **************************************************************

// Created by: Alexander Faust	

// Description: Reset's fields which are set by TimeEntry creation.This caused problems while cloning opportunities

// Testclass: Opportunity_BI_Test

// Last modified by: Alexander Faust

// Last modified date: 10.12.2012

// Latests changes: creation

// ************************************************************** */

trigger Opportunity_BI on Opportunity (before insert) {
	
	for(Opportunity o: trigger.new){
		if(o.Total_amount_credit_invoices__c > 0.0){
			o.Total_amount_credit_invoices__c = 0.0;
		}
		if(o.Sum_of_Hours_billable__c > 0.0){
			o.Sum_of_Hours_billable__c = 0.0;
		}
		if(o.Sum_of_Hours_non_billable__c > 0.0){
			o.Sum_of_Hours_non_billable__c = 0.0;
		}
	}

}