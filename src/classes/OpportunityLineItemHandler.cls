public without sharing class OpportunityLineItemHandler implements ITrigger
{
    public void bulkBefore(){
        if(Trigger.isUpdate)
            OpportunityLineItemScheduleTracker.getInstance().prepareDataForReflectingScheduleChanges(Trigger.oldMap);
    }

    public void bulkAfter(){}

    public void beforeInsert(SObject so){}

    public void beforeUpdate(SObject old_so, SObject so){
        OpportunityLineItemScheduleChangeHandler.getInstance().addOpportunityLineItem(old_so, so);
        OpportunityLineItemScheduleDescrHandler.getInstance().addIdToSet(so);
    }

    public void beforeDelete(SObject so){}

    public void afterInsert(SObject so){}

    public void afterUpdate(SObject old_so, SObject so){
        OpportunityLineItemScheduleChangeHandler.getInstance().resetVariableThatPreventsInfiniteRecursion(so);
    }

    public void afterDelete(SObject so){}

    public void postProcessing(){
        OpportunityLineItemScheduleChangeHandler.getInstance().upsertUnplannedSchedules();
        OpportunityLineItemScheduleTracker.getInstance().createResourceScheduleEntries();
        OpportunityLineItemScheduleDescrHandler.getInstance().updateCommentsToHaveCurrentValue();
    }
}