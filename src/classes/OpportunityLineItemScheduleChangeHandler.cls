public with sharing class OpportunityLineItemScheduleChangeHandler{
    private static OpportunityLineItemScheduleChangeHandler InstanceOfHandler;
    @TestVisible private Map<String, Decimal> OpportunityLineItemIdToDifferenceInNumberOfDays;
    public static final String UNPLANNED_COMMENT = 'UNPLANNED';
    public static final String DEFAULT_TYPE = 'Quantity';
    @TestVisible private static Map<Id, Boolean> OpportunityIdToHasRunAlready = new Map<Id, Boolean>();

    private OpportunityLineItemScheduleChangeHandler(){
        OpportunityLineItemIdToDifferenceInNumberOfDays = new Map<String, Decimal>();
    }

    public static OpportunityLineItemScheduleChangeHandler getInstance(){
        if(InstanceOfHandler == null)
            InstanceOfHandler = new OpportunityLineItemScheduleChangeHandler();
        return InstanceOfHandler;
    }

    public void addOpportunityLineItem(SObject old_so, Sobject new_so){
        OpportunityLineItem old_opp_line_item = (OpportunityLineItem)old_so;
        OpportunityLineItem new_opp_line_item = (OpportunityLineItem)new_so;
        if(old_opp_line_item.Quantity != new_opp_line_item.Quantity && !hasRunAlready(new_opp_line_item.Id) && !new_opp_line_item.Change_Parameters__c && new_opp_line_item.Managed_by_PSO_Tool__c && new_opp_line_item.Unit__c == 'Manntag(e)')
            OpportunityLineItemIdToDifferenceInNumberOfDays.put(new_opp_line_item.Id, old_opp_line_item.Quantity  - new_opp_line_item.Quantity);
        if(old_opp_line_item.Change_Parameters__c && new_opp_line_item.Quantity != 0)
            new_opp_line_item.Change_Parameters__c = false;
    }

    @TestVisible private Boolean hasRunAlready(Id new_opp_line_item_id){
        if(!OpportunityIdToHasRunAlready.containsKey(new_opp_line_item_id))
            OpportunityIdToHasRunAlready.put(new_opp_line_item_id, false);
        return OpportunityIdToHasRunAlready.get(new_opp_line_item_id);
    }

    public void upsertUnplannedSchedules(){
        List<OpportunityLineItemSchedule> schedules_to_be_upserted = new List<OpportunityLineItemSchedule>();
        if(OpportunityLineItemIdToDifferenceInNumberOfDays.values().size()>0){
            Map<String, OpportunityLineItemSchedule> unplanned_opportunity_line_items_to_schedule_ids = new Map<String, OpportunityLineItemSchedule>();
            List<OpportunityLineItemSchedule> unplanned_schedules = [SELECT Id, OpportunityLineItem.Id, Quantity FROM OpportunityLineItemSchedule WHERE OpportunityLineItem.Id IN :OpportunityLineItemIdToDifferenceInNumberOfDays.keySet() AND Description =: UNPLANNED_COMMENT];
            Map<String, Date> opportunity_line_item_id_to_service_date = getOpportunityLineItemIdToServiceDateMap(OpportunityLineItemIdToDifferenceInNumberOfDays.keySet());
            if(unplanned_schedules.size() > 0)
                for(OpportunityLineItemSchedule schedule: unplanned_schedules)
                    unplanned_opportunity_line_items_to_schedule_ids.put(schedule.OpportunityLineItem.Id, schedule);
            for(String opp_line_item_id: OpportunityLineItemIdToDifferenceInNumberOfDays.keySet()){
                if(unplanned_opportunity_line_items_to_schedule_ids.containsKey(opp_line_item_id)){
                    OpportunityLineItemSchedule unplanned_schedule_to_be_updated = unplanned_opportunity_line_items_to_schedule_ids.get(opp_line_item_id);
                    unplanned_schedule_to_be_updated.Quantity += OpportunityLineItemIdToDifferenceInNumberOfDays.get(opp_line_item_id);
                    schedules_to_be_upserted.add(unplanned_schedule_to_be_updated);
                }
                else{
                    OpportunityLineItemSchedule unplanned_schedule_to_be_inserted = getUnplannedOpportunityLineItemSchedule(OpportunityLineItemIdToDifferenceInNumberOfDays.get(opp_line_item_id), opp_line_item_id, opportunity_line_item_id_to_service_date.get(opp_line_item_id));
                    schedules_to_be_upserted.add(unplanned_schedule_to_be_inserted);
                }
                OpportunityIdToHasRunAlready.put(opp_line_item_id, true);
            }
            OpportunityLineItemIdToDifferenceInNumberOfDays.clear();
        }
        if(schedules_to_be_upserted.size()>0){
            upsert schedules_to_be_upserted;
            schedules_to_be_upserted.clear();
        }
    }

    private Map<String, Date> getOpportunityLineItemIdToServiceDateMap (Set<String> opp_line_item_ids){
        Map<String, Date> opportunity_line_item_id_to_service_date = new Map<String, Date>();
        for(OpportunityLineItem item: [SELECT ServiceDate FROM OpportunityLineItem WHERE Id IN :opp_line_item_ids]){
            if(item.ServiceDate == null){
                System.debug('### opportunity line item that doesn\'t have ServiceDate ' + item);
                throw new ServiceDateIsNotSetException('Please set Date for this Opportunity Line Item');
            }
            opportunity_line_item_id_to_service_date.put(item.Id, item.ServiceDate);
        }
        return opportunity_line_item_id_to_service_date;
    }

    @TestVisible private OpportunityLineItemSchedule getUnplannedOpportunityLineItemSchedule(Decimal difference_between_old_and_new_quantity, String opp_line_item_id, Date service_date){
        OpportunityLineItemSchedule unplanned_oli = new OpportunityLineItemSchedule();
        unplanned_oli.Description = UNPLANNED_COMMENT;
        unplanned_oli.Quantity = difference_between_old_and_new_quantity;
        unplanned_oli.Type = DEFAULT_TYPE;
        unplanned_oli.OpportunityLineItemId = opp_line_item_id;
        unplanned_oli.ScheduleDate = service_date;
        return unplanned_oli;
    }

    public void resetVariableThatPreventsInfiniteRecursion(Sobject new_so){
        OpportunityLineItem new_opp_line_item = (OpportunityLineItem)new_so;
        OpportunityIdToHasRunAlready.put(new_opp_line_item.Id, false);
    }

    public class ServiceDateIsNotSetException extends Exception{}
}