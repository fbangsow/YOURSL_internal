public with sharing class OpportunityLineItemScheduleDescrHandler {
    private static OpportunityLineItemScheduleDescrHandler InstanceOfHandler;
    @TestVisible private Set<Id> UpdatedOpportunityLineItemIds;
    private OpportunityLineItemScheduleDescrHandler(){
        UpdatedOpportunityLineItemIds = new Set<Id>();
    }

    public static OpportunityLineItemScheduleDescrHandler getInstance(){
        if(InstanceOfHandler == null)
            InstanceOfHandler = new OpportunityLineItemScheduleDescrHandler();
        return InstanceOfHandler;
    }

    public void addIdToSet(SObject so){
        OpportunityLineItem new_item = (OpportunityLineItem)so;
        if(new_item.Managed_by_PSO_Tool__c)
            UpdatedOpportunityLineItemIds.add(new_item.Id);
    }

    public void updateCommentsToHaveCurrentValue(){
        if(UpdatedOpportunityLineItemIds.size() > 0){
            List<OpportunityLineItemSchedule> schedules = [SELECT Quantity, Description FROM OpportunityLineItemSchedule WHERE OpportunityLineItem.Id IN :UpdatedOpportunityLineItemIds AND Description != :OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT];
            for(OpportunityLineItemSchedule schedule : schedules){
                schedule.Description = String.valueOf(schedule.Quantity);
            }
            update schedules;
            UpdatedOpportunityLineItemIds.clear();
        }
    }
}