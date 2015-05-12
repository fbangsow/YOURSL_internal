trigger TimeOffRequest_AI_AU on Time_Off_Request__c (After Insert, After Update) {

    List<Time_Off_Request__c> listToBeProcessed = new List<Time_Off_Request__c>();
    for(Time_Off_Request__c request : Trigger.newMap.values()){
        
        if(request.Approval_Status__c == 'Approved')
        {
            listToBeProcessed.add(request);
        }
        
    }
    
    if(listToBeProcessed.size() > 0){
        ClsOffTimeRequestProcessor process = new ClsOffTimeRequestProcessor(listToBeProcessed);
    }
}