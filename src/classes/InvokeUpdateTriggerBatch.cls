/* **************************************************************
// Creater: Alexander Faust
// Description: Batch Class which kicks the update process of the given sObject without
//              any record manipulation.Used when update trigger is implemnted and object needs to
				be updatet in order to fire the trigger ( no record changes!)
// Testclass: testmethod included in class
// Apex Class Access: no limitations
// Last modified by: Alexander Faust
// Last modified date: 06.12.2012
// Latests changes: adding header
// ************************************************************** */


global class InvokeUpdateTriggerBatch implements Database.Batchable<sObject> {
 
  private String sObjectName;
 
  global InvokeUpdateTriggerBatch(String sObjectName) {
    this.sObjectName = sObjectName;
  }
 
  global Database.QueryLocator start(Database.BatchableContext BC){
 
    String query = 'SELECT Id FROM ' + sObjectName;
    return Database.getQueryLocator(query);   
 
  }
 
  global void execute(Database.BatchableContext BC, List<sObject> scope){   
 
    //Just update the records.  That's all!
    update scope;
 
     }
 
  global void finish(Database.BatchableContext BC){
 
      System.debug('Batch Process Complete');
 
  }
  
  global testmethod static void Test(){
  	    test.startTest();
  	    Account a = new Account(Name='TestAccount');
  	    insert a;
        database.executebatch(new InvokeUpdateTriggerBatch('Account'));
        test.stopTest();
  }
  
  /*
  	Run Class by entering the following lines in ExecuteAnonymus:
  	InvokeUpdateTriggerBatch batch = new InvokeUpdateTriggerBatch('sObjectName');
	Id batchId = Database.executeBatch(batch);
  */
 
}