public with sharing class OpportunityLineItemScheduleTracker{
    private static OpportunityLineItemScheduleTracker InstanceOfTracker;
    @TestVisible private static Boolean AlreadyRun = false;
    @TestVisible private static Boolean AlreadyProcessed = false;
    @TestVisible private Map<Id, Map<Id, OpportunityLineItemSchedule>> OppLineIdToOpportunityLineItemScheduleWithId;
    private Map<Id, Resource_Schedule__c> OppLineItemScheduleIdToResourceSchedule;
    @TestVisible private Map<Id, Id> OppLineItemIdToContactId;
    public static final String UPDATE_EVENT_TYPE = 'Update';
    public static final String INSERT_EVENT_TYPE = 'Insert';
    public static final String DELETE_EVENT_TYPE = 'Delete';
    
    private OpportunityLineItemScheduleTracker(){
        OppLineIdToOpportunityLineItemScheduleWithId = new Map<Id, Map<Id, OpportunityLineItemSchedule>>();
        OppLineItemIdToContactId = new Map<Id, Id>();
    }

    public static OpportunityLineItemScheduleTracker getInstance(){
        if(InstanceOfTracker == null)
            InstanceOfTracker = new OpportunityLineItemScheduleTracker();
        return InstanceOfTracker;
    }

    public void prepareDataForReflectingScheduleChanges(Map<Id, SObject> old_opportunity_line_items){
        if(!AlreadyRun)
            OppLineIdToOpportunityLineItemScheduleWithId = getOppLineIdToOpportunityLineItemScheduleWithIds(old_opportunity_line_items.keySet());
        for(SObject line_item_sobject : old_opportunity_line_items.values()){
            OpportunityLineItem line_item = (OpportunityLineItem)line_item_sobject;
            OppLineItemIdToContactId.put(line_item.Id, line_item.Contact__c);
        }
        AlreadyRun = true;
    }

    private Map<Id, Map<Id, OpportunityLineItemSchedule>> getOppLineIdToOpportunityLineItemScheduleWithIds(Set<Id> opp_line_items_to_search){
        Map<Id, Map<Id, OpportunityLineItemSchedule>> opp_line_id_to_opp_line_item_schedule = new Map<Id, Map<Id, OpportunityLineItemSchedule>>();
        for(OpportunityLineItemSchedule schedule: [SELECT Quantity, ScheduleDate, Id, OpportunityLineItem.Id, Description 
                                                    FROM OpportunityLineItemSchedule 
                                                    WHERE OpportunityLineItem.Id IN :opp_line_items_to_search 
                                                    AND Description != :OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT]){
            if(!opp_line_id_to_opp_line_item_schedule.containsKey(schedule.OpportunityLineItem.Id))
                opp_line_id_to_opp_line_item_schedule.put(schedule.OpportunityLineItem.Id, new Map<Id, OpportunityLineItemSchedule>());
            opp_line_id_to_opp_line_item_schedule.get(schedule.OpportunityLineItem.Id).put(schedule.Id, schedule);
        }
        return opp_line_id_to_opp_line_item_schedule;
    }
    
    public void createResourceScheduleEntries(){
        if(!OppLineIdToOpportunityLineItemScheduleWithId.isEmpty() && !AlreadyProcessed){
            List<Resource_Schedule__c> resources_to_upsert = new List<Resource_Schedule__c>();
            for(Id opp_line_item_id : OppLineIdToOpportunityLineItemScheduleWithId.keySet()){
                Set<Id> all_schedules = OppLineIdToOpportunityLineItemScheduleWithId.get(opp_line_item_id).keySet();
                getRelatedResourceSchedules(all_schedules);
                for(Id schedule_id : all_schedules){
                    Resource_Schedule__c event = createEvent(OppLineIdToOpportunityLineItemScheduleWithId.get(opp_line_item_id).get(schedule_id), OppLineItemIdToContactId.get(opp_line_item_id));
                    if(event.Old_value__c != event.New_value__c)
                        resources_to_upsert.add(event);
                }
            }
            AlreadyProcessed = true;
            upsert resources_to_upsert;
        }
    }

    private void getRelatedResourceSchedules(Set<Id> all_schedules){
        OppLineItemScheduleIdToResourceSchedule = new Map<Id, Resource_Schedule__c>();
        List<Resource_Schedule__c> related_resource_schedules = [SELECT ContactId__c, Event__c, Old_value__c, New_value__c, Scheduled_Date__c, OpportunityLineItemScheduleId__c
                                FROM Resource_Schedule__c WHERE OpportunityLineItemScheduleId__c IN :all_schedules];
        for(Resource_Schedule__c related_schedule:related_resource_schedules){
            OppLineItemScheduleIdToResourceSchedule.put(related_schedule.OpportunityLineItemScheduleId__c, related_schedule);
        }
    }

    private Resource_Schedule__c createEvent(OpportunityLineItemSchedule schedule, String contact_id){
        Resource_Schedule__c update_schedule;
        if(OppLineItemScheduleIdToResourceSchedule.containsKey(schedule.Id))
            update_schedule = OppLineItemScheduleIdToResourceSchedule.get(schedule.Id);
        else
            update_schedule = new Resource_Schedule__c();
        update_schedule.ContactId__c = contact_id;
        update_schedule.Old_value__c = getOldValue(schedule.Description);
        update_schedule.Event__c = getEvent(Decimal.valueOf(update_schedule.Old_value__c), schedule.Quantity);
        update_schedule.Scheduled_Date__c = schedule.ScheduleDate;
        update_schedule.New_value__c = String.valueOf(schedule.Quantity);
        update_schedule.OpportunityLineItemScheduleId__c = schedule.Id;
        return update_schedule;
    }

    @TestVisible private String getOldValue(String description){
        if(description == null)
            description = '0';
        return description;
    }
    @TestVisible private String getEvent(Decimal old_quantity, Decimal new_quantity){
        if(old_quantity == 0 && new_quantity != 0)
            return INSERT_EVENT_TYPE;
        else if(old_quantity != 0 && new_quantity == 0)
            return DELETE_EVENT_TYPE;
        else
            return UPDATE_EVENT_TYPE;
    }
}