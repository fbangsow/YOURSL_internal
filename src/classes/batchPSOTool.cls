global class batchPSOTool implements Database.Batchable<sObject>
{
    String DateValue { get;set;}
    Boolean IsWeeklyManualRun { get;set;}
    Boolean IsMonthylManualRun { get;set;}
    
    global batchPSOTool(String dateVal,Boolean isWeekly, Boolean isMonthly){
        DateValue = dateVal;
        IsWeeklyManualRun = isWeekly;
        IsMonthylManualRun = isMonthly;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Id,Name FROM Opportunity limit 1';
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<Opportunity> scope)
    {
         PlanningScheduleUpdate updateSchedule = new PlanningScheduleUpdate(DateValue, IsWeeklyManualRun,IsMonthylManualRun);   
    }
       
    global void finish(Database.BatchableContext BC)
    {
    }
}