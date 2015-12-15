/* **************************************************************
// Creater: Krishnakumar P Iyer
// Description: Trigger to update the Owner for MBO from the selected Contact
// Testclass: MBOTriggerHandlerTest.cls
// Apex Class Access: no limitations
// Last modified by: Krishnakumar P Iyer
// Last modified date: 25.11.2015
// Latests changes: creation
// ************************************************************** */


trigger MBOUpdateBefore on Ziel__c (before insert, before update) {

	//Invoking handler class to update the Owner for MBO from the selected Contact 
    MBOTriggerHandler handler = new MBOTriggerHandler();
    handler.handleTrigger(trigger.new);
    
}