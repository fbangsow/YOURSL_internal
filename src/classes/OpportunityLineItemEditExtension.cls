public with sharing class OpportunityLineItemEditExtension {
    public Decimal SelectedQuantity {public get; public set;}
    public Decimal SelectedPrice {public get; public set;}
    @TestVisible private OpportunityLineItem LineItem;
    @TestVisible private List<OpportunityLineItemSchedule> ExistingSchedules;
    public Boolean ShowControls {public get; private set;}

    public OpportunityLineItemEditExtension(ApexPages.StandardController std_controller) {
        this.LineItem = (OpportunityLineItem)std_controller.getRecord();
        SelectedQuantity = this.LineItem.Quantity;
        SelectedPrice = this.LineItem.UnitPrice;
        ShowControls = true;
        checkIfOpportunityLineItemCanBeProcessed();
    }

    private void checkIfOpportunityLineItemCanBeProcessed(){
        if(!this.LineItem.Managed_by_PSO_Tool__c){
            ShowControls = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'This opportunity line item is not allowed to be processed by the PSO Tool'));
        }
    }

    public PageReference save(){
        setPermitFieldForChanges();
        deleteExistingSchedules();
        updateLineItem();
        restoreSchedules();
        return redirectToOpportunityLineItemView();
    }

    private void setPermitFieldForChanges(){
        this.LineItem.Change_Parameters__c = true;
        update this.LineItem;
    }

    private void deleteExistingSchedules(){
        ExistingSchedules = [SELECT Quantity, ScheduleDate, Description, Type, OpportunityLineItemId FROM OpportunityLineItemSchedule WHERE OpportunityLineItem.Id =: this.LineItem.Id];
        delete ExistingSchedules;
    }

    private void updateLineItem(){
        OpportunityLineItem item = [SELECT Quantity, UnitPrice, Change_Parameters__c FROM OpportunityLineItem WHERE Id =: this.LineItem.Id];
        item.Quantity = SelectedQuantity;
        item.UnitPrice = SelectedPrice;
        update item;
    }

    private void restoreSchedules(){
        List<OpportunityLineItemSchedule> schedules_to_be_restored = new List<OpportunityLineItemSchedule>();
        for(OpportunityLineItemSchedule schedule : ExistingSchedules)
            if(schedule.Description != OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT)
                schedules_to_be_restored.add(createScheduleBasedOnOldRecord(schedule));
        if(schedules_to_be_restored.size()>0)
            insert schedules_to_be_restored;
    }

    public PageReference redirectToOpportunityLineItemView(){
        PageReference opportunity_line_item_page = new ApexPages.StandardController(this.LineItem).view();
        opportunity_line_item_page.setRedirect(true);
        return opportunity_line_item_page;
    }

    private OpportunityLineItemSchedule createScheduleBasedOnOldRecord(OpportunityLineItemSchedule old_schedule){
        OpportunityLineItemSchedule new_schedule = new OpportunityLineItemSchedule();
        new_schedule.Quantity = old_schedule.Quantity;
        new_schedule.ScheduleDate = old_schedule.ScheduleDate;
        new_schedule.Type = old_schedule.Type;
        new_schedule.OpportunityLineItemId = old_schedule.OpportunityLineItemId;
        return new_schedule;
    }
}