/* **************************************************************
// Created by: Alexander Faust
// Description: rolls up the Amount_Total__c field of Kreditor__c to Total_Amount_credit_invoices__c on Opportuntiy
// Testclass: Kreditor_afterAllTest
// Last modified by: Alexander Faust
// Last modified date: 06.12.2012
// Latests changes: adding header
// ************************************************************** */
trigger Kreditor_afterAll on Kreditor__c (after delete, after insert, after undelete, 
after update) {
	
	 if(trigger.isInsert || trigger.isUpdate || trigger.isUnDelete){
         
        list<RollUpSummaryUtility.fieldDefinition> fieldDefinitions = 
        new list<RollUpSummaryUtility.fieldDefinition> {
            new RollUpSummaryUtility.fieldDefinition('SUM', 'Amount_Total__c', 
            'Total_amount_credit_invoices__c')
        };
         
        RollUpSummaryUtility.rollUpTrigger(fieldDefinitions, trigger.new, 
        'Kreditor__c', 'Opportunity__c', 'Opportunity', '');
         
    }
     
    if(trigger.isDelete){
         
        list<RollUpSummaryUtility.fieldDefinition> fieldDefinitions = 
        new list<RollUpSummaryUtility.fieldDefinition> {
            new RollUpSummaryUtility.fieldDefinition('SUM', 'Amount_Total__c', 
            'Total_amount_credit_invoices__c')
        };
         
        RollUpSummaryUtility.rollUpTrigger(fieldDefinitions, trigger.old, 
        'Kreditor__c', 'Opportunity__c', 'Opportunity', '');
         
    }

}