trigger TimeOffRequest_AI_AU on Time_Off_Request__c (After Insert, After Update,before  Update, before  Insert) {

    if(Trigger.isAfter){
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
    
    if (Trigger.isBefore){
        
        for(Time_Off_Request__c request :Trigger.new){
            request.Start_Date__c = DateUtility.getFirstDayForWeekNumberAndYear(Integer.valueOf(request.Year__c),Integer.valueOf(request.Calendar_Week__c));
            request.End_Date__c   = DateUtility.getFirstDayForWeekNumberAndYear(Integer.valueOf(request.Year__c),Integer.valueOf(request.Calendar_Week__c)).addDays(6);
        }
        
    }
}