public with sharing class OpportunityLineItemsEditExtension {
    public Decimal SelectedQuantity {public get; public set;}
    public Decimal SelectedPrice {public get; public set;}
    public Opportunity SelectedOpportunity {public get; public set;}
    @TestVisible private List<OpportunityLineItemSchedule> ExistingSchedules;
    public Boolean ShowControls {public get; private set;}
    public Decimal TotalRevenueBefore {public get; private set;}
    public Map<Id, LineItem> LineItems {public get; public set;}
    public List<Id> OrderedListOfKeys {public get; private set;}

    public OpportunityLineItemsEditExtension(ApexPages.StandardController std_controller) {
        this.SelectedOpportunity = [SELECT Name, Managed_by_PSO_Tool__c, (SELECT Contact__r.Name, Quantity, Product2.Name, ServiceDate, UnitPrice
                                        FROM OpportunityLineItems WHERE Unit__c = 'Manntag(e)' 
                                        ORDER BY Contact__r.Name, ServiceDate ASC)
                                            FROM Opportunity WHERE Id =: ApexPages.currentPage().getParameters().get('id')];
        ShowControls = true;
        checkIfOpportunityCanBeProcessed();
        checkIfOpportunityHasLineItems();
        createHelperObject();
        queryExistingSchedules();
    }

    private void checkIfOpportunityCanBeProcessed(){
        if(!this.SelectedOpportunity.Managed_by_PSO_Tool__c){
            ShowControls = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'This opportunity is not allowed to be processed by the PSO Tool'));
        }
    }

    private void checkIfOpportunityHasLineItems(){
        if(this.SelectedOpportunity.OpportunityLineItems.size()==0){
            ShowControls = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'This opportunity has no opportunity line items to edit'));
        }
    }

    private void createHelperObject(){
        TotalRevenueBefore = 0;
        LineItems = new Map<Id, LineItem>();
        OrderedListOfKeys = new List<Id>();
        for (OpportunityLineItem item: this.SelectedOpportunity.OpportunityLineItems){
            TotalRevenueBefore+= item.Quantity*item.UnitPrice;
            LineItems.put(item.Id, new LineItem(item));
            OrderedListOfKeys.add(item.Id);
        }
    }

    private void queryExistingSchedules(){
        List<OpportunityLineItemSchedule> schedules = [SELECT Description, Quantity, ScheduleDate, OpportunityLineItem.Id FROM OpportunityLineItemSchedule WHERE OpportunityLineItem.Id IN :LineItems.keySet()];
        Map<Id, List<OpportunityLineItemSchedule>> opp_line_item_id_to_schedules = new Map<Id, List<OpportunityLineItemSchedule>>();
        Map<Id, Decimal> opp_line_item_id_to_unplanned_schedule = new Map<Id, Decimal>();
        for(OpportunityLineItemSchedule schedule :schedules){
            if(!opp_line_item_id_to_schedules.containsKey(schedule.OpportunityLineItem.Id))
                opp_line_item_id_to_schedules.put(schedule.OpportunityLineItem.Id, new List<OpportunityLineItemSchedule>());
            opp_line_item_id_to_schedules.get(schedule.OpportunityLineItem.Id).add(schedule);
            if(schedule.Description == OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT)
                opp_line_item_id_to_unplanned_schedule.put(schedule.OpportunityLineItem.Id, schedule.Quantity);
        }
        for(Id opp_line_item_id : LineItems.keySet()){
            if(opp_line_item_id_to_unplanned_schedule.containsKey(opp_line_item_id))
                LineItems.get(opp_line_item_id).UnplannedDays = opp_line_item_id_to_unplanned_schedule.get(opp_line_item_id);
            else{
                if(opp_line_item_id_to_schedules.containsKey(opp_line_item_id))
                    LineItems.get(opp_line_item_id).UnplannedDays = 0;
                else
                    LineItems.get(opp_line_item_id).UnplannedDays = LineItems.get(opp_line_item_id).LineItem.Quantity;
            }
        }
    }

    public PageReference save(){
        Map<Id, OpportunityLineItem> items_to_be_updated = getChangedLineItems();
        if(items_to_be_updated.size()>0){
            setPermitFieldForChanges(items_to_be_updated.values());
            deleteExistingSchedules(items_to_be_updated.keySet());
            updateLineItem(items_to_be_updated.keySet());
            restoreSchedules();
        }
        return redirectToOpportunityView();
    }

    private Map<Id, OpportunityLineItem> getChangedLineItems(){
        Map<Id, OpportunityLineItem> changed_items = new Map<Id, OpportunityLineItem>();
        for(LineItem item: LineItems.values())
            if(item.LineItem.Quantity != item.SelectedQuantity)
                changed_items.put(item.LineItem.Id, item.LineItem);
        return changed_items;
    }

    private void setPermitFieldForChanges(List<OpportunityLineItem> items_to_be_updated){
        for(OpportunityLineItem item: items_to_be_updated)
            item.Change_Parameters__c = true;
        update items_to_be_updated;
    }

    private void deleteExistingSchedules(Set<Id> line_items_ids){
        ExistingSchedules = [SELECT Quantity, ScheduleDate, Description, Type, OpportunityLineItemId FROM OpportunityLineItemSchedule WHERE OpportunityLineItem.Id IN :line_items_ids];
        delete ExistingSchedules;
    }

    private void updateLineItem(Set<Id> line_items_ids){
        List<OpportunityLineItem> items = [SELECT Quantity, UnitPrice, Change_Parameters__c FROM OpportunityLineItem WHERE Id IN : line_items_ids];
        for(OpportunityLineItem item :items){
            item.Quantity = LineItems.get(item.Id).SelectedQuantity;
            item.UnitPrice = LineItems.get(item.Id).LineItem.UnitPrice;
        }
        update items;
    }

    private void restoreSchedules(){
        List<OpportunityLineItemSchedule> schedules_to_be_restored = new List<OpportunityLineItemSchedule>();
        for(OpportunityLineItemSchedule schedule : ExistingSchedules)
            if(schedule.Description != OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT)
                schedules_to_be_restored.add(createScheduleBasedOnOldRecord(schedule));
        if(schedules_to_be_restored.size()>0)
            insert schedules_to_be_restored;
    }

    public PageReference redirectToOpportunityView(){
        PageReference opportunity_line_item_page = new ApexPages.StandardController(this.SelectedOpportunity).view();
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
    
    public class LineItem{
        public OpportunityLineItem LineItem {public get; private set;}
        public Decimal SelectedQuantity {public get; public set;}
        public Decimal UnplannedDays {public get; private set;}

        public LineItem(OpportunityLineItem item){
            this.LineItem = item;
            this.SelectedQuantity = item.Quantity;
        }
    }
}