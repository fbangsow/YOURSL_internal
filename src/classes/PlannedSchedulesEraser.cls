global class PlannedSchedulesEraser implements Database.Batchable<sObject>{
     @TestVisible private Date StartDate;
     @TestVisible private Date EndDate;
     @TestVisible private Date JobDate;

    global PlannedSchedulesEraser(Date start_date, Date end_date, Date job_date){
        StartDate = start_date;
        EndDate = end_date;
        JobDate = job_date;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT ID
                                        FROM OpportunityLineItemSchedule
                                        WHERE Description != :OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT
                                        AND ScheduleDate >= : StartDate
                                        AND ScheduleDate <= : EndDate
                                        AND OpportunityLineItem.Managed_by_PSO_Tool__c = true
                                        AND OpportunityLineItem.Opportunity.Name != : (PsoToolController.SPECIAL_OPPORTUNITY + '%')
                                        AND OpportunityLineItem.Unit__c = 'Manntag(e)'
                                        ORDER BY ScheduleDate ASC]);
    }

    global void execute(Database.BatchableContext BC, List<OpportunityLineItemSchedule> opportunity_line_item_scope){
        delete opportunity_line_item_scope;
    }

    global void finish(Database.BatchableContext BC){
        Database.executeBatch(new TimeEntriesProcessor(StartDate, EndDate, JobDate));
    }
}