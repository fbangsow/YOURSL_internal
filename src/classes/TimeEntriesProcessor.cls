global class TimeEntriesProcessor implements Database.Batchable<sObject>{
    @TestVisible private Date StartDate;
    @TestVisible private Date EndDate;
    @TestVisible private Date JobDate;

    global TimeEntriesProcessor (Date start_date, Date end_date, Date job_date){
        StartDate = start_date;
        EndDate = end_date;
        JobDate = job_date;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        Map <Id,OpportunityLineItem> managed_opp_line_items =
        new Map <Id, OpportunityLineItem>([Select ID FROM OpportunityLineItem WHERE Managed_by_PSO_Tool__c = true AND Unit__c = 'Manntag(e)'
                                          AND Opportunity.Name != :(PsoToolController.SPECIAL_OPPORTUNITY + '%')
                                          AND ServiceDate >= :StartDate.toStartOfMonth()
                                          AND ServiceDate <= :Date.newInstance(EndDate.year(), EndDate.month(), Date.daysInMonth(EndDate.year(), EndDate.month()))]);
        return Database.getQueryLocator([SELECT ID, Opportunity_Product_ID__c, Date__c, Time__c
                                       FROM TimeEntry__c
                                       WHERE Date__c >= : StartDate
                                       AND Date__c <= : EndDate
                                       AND Billable__c = true
                                       AND Opportunity_Product_ID__c != null
                                       AND Opportunity_Product_ID__c IN :managed_opp_line_items.keySet()
                                       ORDER BY Date__c ASC ]);
    }

    global void execute(Database.BatchableContext BC, List<TimeEntry__c> time_entries_scope){
        List<ActualSchedules> actual_schedules = processTimeEntriesIntoDataSet(time_entries_scope);
        List<OpportunityLineItemSchedule> existing_schedules = [SELECT ScheduleDate, Quantity, OpportunityLineItem.Id FROM OpportunityLineItemSchedule
                                                                WHERE OpportunityLineItem.Id IN :getRelatedOppLineItemIds(actual_schedules)
                                                                AND Description != :OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT
                                                                AND OpportunityLineItem.Managed_by_PSO_Tool__c = true
                                                                AND OpportunityLineItem.Opportunity.Name != : (PsoToolController.SPECIAL_OPPORTUNITY + '%')
                                                                AND OpportunityLineItem.Unit__c = 'Manntag(e)'];
        Map<Id, Map<Date, OpportunityLineItemSchedule>> opp_line_item_id_to_schedule_date_to_schedule = processExistingSchedulesIntoDataSet(existing_schedules);
        List<OpportunityLineItemSchedule> schedules_to_upsert = new List<OpportunityLineItemSchedule>();
        for(ActualSchedules schedule : actual_schedules){
            if(opp_line_item_id_to_schedule_date_to_schedule.containsKey(schedule.OpportunityLineItemId) && opp_line_item_id_to_schedule_date_to_schedule.get(schedule.OpportunityLineItemId).containsKey(schedule.ScheduleDate)){
                opp_line_item_id_to_schedule_date_to_schedule.get(schedule.OpportunityLineItemId).get(schedule.ScheduleDate).Quantity += schedule.Hours/8;
                schedules_to_upsert.add(opp_line_item_id_to_schedule_date_to_schedule.get(schedule.OpportunityLineItemId).get(schedule.ScheduleDate));
            }else
                schedules_to_upsert.add(getNewScheduleForActualSchedule(schedule));
        }
        if(!schedules_to_upsert.isEmpty())
            upsert schedules_to_upsert;
    }

    private List<ActualSchedules> processTimeEntriesIntoDataSet(List<TimeEntry__c> time_entries){
        Map<String, ActualSchedules> opportunity_line_item_id_to_schedule = new Map<String, ActualSchedules>();
        for (TimeEntry__c entry: time_entries) {
            String key_to_map = entry.Opportunity_Product_ID__c + '/' + entry.Date__c;
            if(!opportunity_line_item_id_to_schedule.containsKey(key_to_map))
                opportunity_line_item_id_to_schedule.put(key_to_map, getActualSchedule(entry));
            else
                opportunity_line_item_id_to_schedule.get(key_to_map).Hours += entry.Time__c;
        }
        return opportunity_line_item_id_to_schedule.values();
    }

    private Map<Id, Map<Date, OpportunityLineItemSchedule>> processExistingSchedulesIntoDataSet(List<OpportunityLineItemSchedule> schedules){
        Map<Id, Map<Date, OpportunityLineItemSchedule>> opp_line_item_id_to_schedule_date_to_schedule = new Map<Id, Map<Date, OpportunityLineItemSchedule>>();
        for(OpportunityLineItemSchedule schedule : schedules){
            if(!opp_line_item_id_to_schedule_date_to_schedule.containsKey(schedule.OpportunityLineItem.Id))
                opp_line_item_id_to_schedule_date_to_schedule.put(schedule.OpportunityLineItem.Id, new Map<Date, OpportunityLineItemSchedule>());
            if(!opp_line_item_id_to_schedule_date_to_schedule.get(schedule.OpportunityLineItem.Id).containsKey(schedule.ScheduleDate))
                opp_line_item_id_to_schedule_date_to_schedule.get(schedule.OpportunityLineItem.Id).put(schedule.ScheduleDate, schedule);
        }
        return opp_line_item_id_to_schedule_date_to_schedule;
    }

    private ActualSchedules getActualSchedule(TimeEntry__c entry){
        ActualSchedules new_entry = new ActualSchedules();
        new_entry.OpportunityLineItemId = entry.Opportunity_Product_ID__c;
        new_entry.Hours = entry.Time__c;
        new_entry.ScheduleDate = entry.Date__c;
        return new_entry;
    }

    private Set<Id> getRelatedOppLineItemIds(List<ActualSchedules> schedules){
        Set<Id> opp_line_item_ids = new Set<Id>();
        for(ActualSchedules schedule: schedules)
            opp_line_item_ids.add(schedule.OpportunityLineItemId);
        return opp_line_item_ids;
    }

    private OpportunityLineItemSchedule getNewScheduleForActualSchedule(ActualSchedules schedule){
        OpportunityLineItemSchedule new_schedule = new OpportunityLineItemSchedule();
        new_schedule.OpportunityLineItemId = schedule.OpportunityLineItemId;
        new_schedule.Quantity = schedule.Hours / 8;
        new_schedule.ScheduleDate = schedule.ScheduleDate;
        new_schedule.Type = OpportunityLineItemScheduleChangeHandler.DEFAULT_TYPE;
        return new_schedule;
    }

    global void finish(Database.BatchableContext BC){
        StatisticsCalculator.getInstance(JobDate, false).createStatistics();
    }

    public class ActualSchedules{
        public Id OpportunityLineItemId;
        public Decimal Hours;
        public Date ScheduleDate;
    }
}