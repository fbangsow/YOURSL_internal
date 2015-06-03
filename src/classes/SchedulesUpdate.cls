/* ------------------------------------
@Project : PSO Tool
@Company: MOLD TEK
@Author: Phani Joshi
@Creation date: 25/03/2015  
@Description : This is Scheduled class which will run weekly(sunday) and Monthly(1st of every month) and updates planning statistics
and oppprtunitylineItemSchedule objects.
---------------------------------------*/
Public class SchedulesUpdate implements Schedulable {
   
   Public void execute(SchedulableContext SC) {
   		
   		Datetime d = system.today();
   		String dateValue = String.valueOf(d.format('MM/dd/yyyy'));
        batchPSOTool b = new batchPSOTool(dateValue,false,false);
        Database.executeBatch(b);      
   }
   
}