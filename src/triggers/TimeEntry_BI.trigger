/* **************************************************************
// Created by: Alexander Faust	
// Description: Sets Line Item Description from Line Item on Time Entry
// Testclass: TimeEntryTriggerTest
// Last modified by: Alexander Faust
// Last modified date: 28.02.2013
// Latests changes: creation
// ************************************************************** */
trigger TimeEntry_BI on TimeEntry__c (before insert) {
	String sLineItemDescription = [SELECT Leistungsbeschreibung_del__c FROM OpportunityLineItem WHERE Id =: trigger.new[0].Opportunity_Product_ID__c ].Leistungsbeschreibung_del__c;
	
	trigger.new[0].Line_Item_Description__c = sLineItemDescription==null?'':sLineItemDescription;
}