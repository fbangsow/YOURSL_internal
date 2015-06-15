public without sharing class OpportunityLineItemScheduleDescrHandler {
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
        if(new_item.Managed_by_PSO_Tool__c && new_item.Unit__c == 'Manntag(e)')
            UpdatedOpportunityLineItemIds.add(new_item.Id);
    }

    public void updateCommentsToHaveCurrentValue(){
        if(UpdatedOpportunityLineItemIds.size() > 0){
            List<OpportunityLineItemSchedule> schedules_to_update = new List<OpportunityLineItemSchedule>();
            List<OpportunityLineItemSchedule> schedules = [SELECT Quantity, Description FROM OpportunityLineItemSchedule WHERE OpportunityLineItem.Id IN :UpdatedOpportunityLineItemIds AND Description != :OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT];
            for(OpportunityLineItemSchedule schedule : schedules){
                if(schedule.Description == null || schedule.Quantity != Decimal.valueOf(Schedule.Description)){
                    schedule.Description = String.valueOf(schedule.Quantity);
                    schedules_to_update.add(schedule);
                }
            }
            if(!schedules_to_update.isEmpty())
                update schedules_to_update;
            UpdatedOpportunityLineItemIds.clear();
        }
    }
}