public without sharing class PsoToolController{
    private static Map<Id, PsoToolController> userIdToPsoToolInstance= new Map<Id, PsoToolController>();
    private PsoToolDataSetWrapper dataSet;
    @TestVisible private List<Opportunity> opportunities;
    private String currentUserId;
    @TestVisible private Map<String, String> contactIdsToNamesMap;
    @TestVisible private Map<String, Map<String, Map<String, OpportunityLineItem>>> contactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap;
    @TestVisible private Date startDate;
    @TestVisible private Date endDate;
    private List<String> opportunityLineItemIds;
    private Map<String, Decimal> OppLineItemScheduleIdToNumberOfDays;
    @TestVisible private Map<String, Map<String, Map<String, Planning_statistics__c>>> OppLineItemIdToDateRangeToDataTypeToStatisticsEntry;
    public static final String SPECIAL_OPPORTUNITY = '° Urlaub/Krankheit/Feiertage';
    public static final String PLANNED_STATISTIC_TYPE = 'Planned';
    public static final String ACTUAL_STATISTIC_TYPE = 'Actual';
    public static final Decimal WORKING_HOURS_IN_DAY = 8;
    private final Map<Id, String> PROFILE_ID_TO_PROFILE_NAME_FOR_ADMIN_MODE = new Map<Id, String>{
        '00e20000000kdol' => 'System Administrator',
        '00eD0000001QniK' => 'YOUR SL Assistance',
        '00eD0000001hihX' => 'YOUR SL Management User',
        '00eD0000001higZ' => 'YOUR SL System Administrator'
        };
    
    private PsoToolController(){
        opportunityLineItemIds = new List<String>();
    }

    public static PsoToolController getInstance(){
        createInstanceIfDoesntExist();
        return userIdToPsoToolInstance.get(UserInfo.getUserId());
    }

    private static void createInstanceIfDoesntExist(){
        if(!userIdToPsoToolInstance.containsKey(UserInfo.getUserId())){
            PsoToolController pso_tool_instance = new PsoToolController();
            userIdToPsoToolInstance.put(UserInfo.getUserId(), pso_tool_instance);
        }
    }

    public PsoToolDataSetWrapper getDataSet(Date passedDate){
        dataSet = new PsoToolDataSetWrapper();
        setDatesRange(passedDate);
        queryData();
        contactIdsToNamesMap = new Map<String, String>();
        dataSet.StartDate = this.startDate.format();
        dataSet.EndDate = this.endDate.format();
        dataSet.TimeStamp = Datetime.now().format('yyyy-MM-dd HH:mm:ss');
        dataSet.Customers = getCustomers();
        dataSet.Resources = getResourcesAvailabilityData();
        return dataSet;
    }

    public PsoToolDataSetWrapper getDataSet(){
        return getDataSet(Date.Today());
    }

    private void setDatesRange(Date passedDate){
        this.startDate = passedDate.toStartOfMonth();
        Date helperDate = this.startDate.addMonths(2);
        this.endDate = Date.newInstance(helperDate.year(), helperDate.month(), Date.daysInMonth(helperDate.year(), helperDate.month()));
    }

    @TestVisible private void queryData(){
        opportunities = [SELECT Id, Name, Account.Name, Account.Id, Projektleiter_YOUR_SL__r.Name,
                                    (SELECT Contact__r.Name, Contact__r.Id, Quantity, Product2.Name, ServiceDate, UnitPrice, LastModifiedDate
                                        FROM OpportunityLineItems
                                        WHERE Contact__r.LastName != 'All' AND
                                        Unit__c = 'Manntag(e)') 
                                        FROM Opportunity 
                                        WHERE Id IN :getRelatedOpportunityIds() 
                                        AND 
                                        Project_Start_Date__c <= :this.endDate AND 
                                        Project_End_Date__c >= :this.startDate 
                                        AND Managed_by_PSO_Tool__c = true
                                        ];
        List<OpportunityLineItem> opportunitylineItems = [SELECT Contact__r.Id, Product2.Name, ServiceDate, Opportunity.Name, Opportunity.Id, Quantity,
                                    (SELECT OpportunityLineItemId, ScheduleDate, Quantity 
                                        FROM OpportunityLineItemSchedules
                                        WHERE Description !=:OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT)
                                        FROM OpportunityLineItem
                                        WHERE Contact__r.Id IN :getRelatedContactIds()];
        buildDataStructure(opportunitylineItems);
        List<Planning_statistics__c> planning_statistics_info = [SELECT Data_Type__c, Days__c, End_Date__c, OpportunityLineItemId__c, Revenue__c, Start_Date__c, Time_Type__c 
                                        FROM Planning_statistics__c 
                                        WHERE OpportunityLineItemId__c IN :opportunityLineItemIds];
        processStatistics(planning_statistics_info);
    }

    private List<Id> getRelatedOpportunityIds(){
        this.currentUserId = UserInfo.getUserId();
        if(PROFILE_ID_TO_PROFILE_NAME_FOR_ADMIN_MODE.containsKey(UserInfo.getProfileId()))
            return getAllOpportunityIds();
        else
            return getOnlyRelatedOpportunityIds();
    }

    private List<Id> getAllOpportunityIds(){
        List<Id> all_ids = new List<Id>();
        List<Opportunity> opportunities = [SELECT Id FROM Opportunity WHERE Managed_by_PSO_Tool__c = true];
        for(Opportunity single_opportunity: opportunities){
            all_ids.add(single_opportunity.Id);
        }
        return all_ids;
    }

    private List<Id> getOnlyRelatedOpportunityIds(){
        List<OpportunityTeamMember> teamMembers = [SELECT OpportunityId FROM OpportunityTeamMember WHERE UserId =: this.currentUserId];
        List<Id> opportunityIds = new List<Id>();
        for(OpportunityTeamMember teamMember: teamMembers){
            opportunityIds.add(teamMember.OpportunityId);
        }
        return opportunityIds;
    }

    private Set<Id> getRelatedContactIds(){
        Set<Id> contactIds = new Set<Id>();
        for(Opportunity opp: opportunities){
            for(OpportunityLineItem item: opp.OpportunityLineItems){
                contactIds.add(item.Contact__r.Id);
                opportunityLineItemIds.add(item.Id);
            }
        }
        return contactIds;
    }

    private void buildDataStructure(List<OpportunityLineItem> opportunity_line_items){
        contactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap = new Map<String, Map<String, Map<String, OpportunityLineItem>>>();
        for(OpportunityLineItem item: opportunity_line_items){
            if(!contactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.containsKey(item.Contact__r.Id)){
                contactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.put(item.Contact__r.Id, getOpportunityIdToOpportunityLineItemMap(item));
            }
            else{
                if(!contactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.get(item.Contact__r.Id).containsKey(item.Opportunity.Id)){
                    contactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.get(item.Contact__r.Id).put(item.Opportunity.Id, new Map<String, OpportunityLineItem>{item.Id => item});
                }
                else{
                    contactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.get(item.Contact__r.Id).get(item.Opportunity.Id).put(item.Id, item);
                }
            }
        }
    }

    private Map<String, Map<String, OpportunityLineItem>> getOpportunityIdToOpportunityLineItemMap(OpportunityLineItem item){
        Map<String, Map<String, OpportunityLineItem>> newMap = new Map<String, Map<String, OpportunityLineItem>>();
        newMap.put(item.Opportunity.Id, new Map<String, OpportunityLineItem>{item.Id => item});
        return newMap;
    }

    @TestVisible private void processStatistics(List<Planning_statistics__c> planning_statistics){
        OppLineItemIdToDateRangeToDataTypeToStatisticsEntry = new Map<String, Map<String, Map<String, Planning_statistics__c>>>();
        for(Planning_statistics__c entry : planning_statistics){
            if(!OppLineItemIdToDateRangeToDataTypeToStatisticsEntry.containsKey(entry.OpportunityLineItemId__c))
                OppLineItemIdToDateRangeToDataTypeToStatisticsEntry.put(entry.OpportunityLineItemId__c, new Map<String, Map<String, Planning_statistics__c>>());
            String keyForNestedMap = entry.Start_Date__c.format() + ' - ' + entry.End_Date__c.format();
            if(!OppLineItemIdToDateRangeToDataTypeToStatisticsEntry.get(entry.OpportunityLineItemId__c).containsKey(keyForNestedMap))
                OppLineItemIdToDateRangeToDataTypeToStatisticsEntry.get(entry.OpportunityLineItemId__c).put(keyForNestedMap, new Map<String, Planning_statistics__c>());
            if(!OppLineItemIdToDateRangeToDataTypeToStatisticsEntry.get(entry.OpportunityLineItemId__c).get(keyForNestedMap).containsKey(entry.Data_Type__c))
                OppLineItemIdToDateRangeToDataTypeToStatisticsEntry.get(entry.OpportunityLineItemId__c).get(keyForNestedMap).put(entry.Data_Type__c, entry);
        }
    }

    @TestVisible private List<Customer> getCustomers(){
        Map<Id, Customer> customers = new Map<Id, Customer>();
        for(Opportunity opp: opportunities){
            if(!customers.containsKey(opp.Account.Id)){
                customers.put(opp.Account.Id, getCustomer(opp));
            }
            customers.get(opp.Account.Id).Projects.add(getProject(opp));
        }
        return customers.values();
    }

    @TestVisible private Customer getCustomer(Opportunity opp){
        Customer newCustomer = new Customer();
        newCustomer.AccountName = opp.Account.Name;
        newCustomer.AccountId = opp.Account.Id;
        newCustomer.Projects = new List<Project>();
        return newCustomer;
    }

    @TestVisible private Project getProject(Opportunity opp){
        Project newProject = new Project();
        newProject.OpportunityName = opp.Name;
        newProject.OurProjectManager = opp.Projektleiter_YOUR_SL__r.Name;
        newProject.ProjectManagerId = opp.Projektleiter_YOUR_SL__r.Id;
        newProject.OpportunityId = opp.Id;
        newProject.Resources = getResources(opp);
        return newProject;
    }

    @TestVisible private List<Resource> getResources(Opportunity opp){
        Map<String, Resource> resources = new Map<String, Resource> ();
        for(OpportunityLineItem lineItem: opp.OpportunityLineItems){
            contactIdsToNamesMap.put(lineItem.Contact__r.Id, lineItem.Contact__r.Name);
            String keyForMap = lineItem.Contact__r.Name + lineItem.Product2.Name;
            if(!resources.containsKey(keyForMap)){
                resources.put(lineItem.Contact__r.Name + lineItem.Product2.Name, getResource(opp.Id, lineItem));
            }
            else{
                resources.get(keyForMap).SoldDays += WORKING_HOURS_IN_DAY*lineItem.Quantity;
                resources.get(keyForMap).Staffing.addAll(getStaffingForResourceForOpportunity(opp.Id, lineItem));
                checkIfMonthIsWithinRangeAndPutInMap(resources.get(keyForMap), lineItem);
                resources.get(keyForMap).Statistics.addAll(getStats(lineItem.Id));
                if(Datetime.valueOf(resources.get(keyForMap).LastModifiedDate) < lineItem.LastModifiedDate)
                    resources.get(keyForMap).LastModifiedDate = lineItem.LastModifiedDate.format('yyyy-MM-dd HH:mm:ss');
            }
        }
        countPlannedDaysAndFilterStaffingByDates(resources);
        return resources.values();
    }

    @TestVisible private Resource getResource(String oppId, OpportunityLineItem lineItem){
        Resource newResource = new Resource();
        newResource.ResourceName = lineItem.Contact__r.Name;
        newResource.ContactId = lineItem.Contact__r.Id;
        newResource.Product = lineItem.Product2.Name;
        newResource.SalesPrice = lineItem.UnitPrice;
        newResource.SoldDays = WORKING_HOURS_IN_DAY*lineItem.Quantity;
        newResource.LastModifiedDate = lineItem.LastModifiedDate.format('yyyy-MM-dd HH:mm:ss');
        newResource.Staffing = getStaffingForResourceForOpportunity(oppId, lineItem);
        newResource.MonthToLimitMap = new Map<String, String>();
        newResource.MonthToOppLineItemIdMap = new Map<String, String>();
        newResource.Statistics = getStats(lineItem.Id);
        checkIfMonthIsWithinRangeAndPutInMap(newResource, lineItem);
        return newResource;
    }

    @TestVisible private void checkIfMonthIsWithinRangeAndPutInMap(Resource resource, OpportunityLineItem item){
        if(item.ServiceDate >= this.startDate && item.ServiceDate <= this.endDate){
            resource.MonthToLimitMap.put(String.valueOf(item.ServiceDate.month()), String.valueOf(item.Quantity));
            resource.MonthToOppLineItemIdMap.put(String.valueOf(item.ServiceDate.month()), item.Id);
        }
    }

    @TestVisible private List<Staffing> getStaffingForResourceForOpportunity(String oppId, OpportunityLineItem lineItem){
        List<Staffing> schedule = new List<Staffing>();
        if(contactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.containsKey(lineItem.Contact__r.Id)){
            if(contactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.get(lineItem.Contact__r.Id).containsKey(oppId)){
                if(contactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.get(lineItem.Contact__r.Id).get(oppId).containsKey(lineItem.Id)){
                    for(OpportunityLineItemSchedule timeEntry: contactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.get(lineItem.Contact__r.Id).get(oppId).get(lineItem.Id).OpportunityLineItemSchedules){
                        if(timeEntry.Quantity != 0)
                            schedule.add(getStaffingForScheduleEntry(timeEntry));
                    }
                }
            }
        }
        return schedule;
    }

    @TestVisible private Staffing getStaffingForScheduleEntry(OpportunityLineItemSchedule timeEntry){
        Staffing newStaff = new Staffing();
        newStaff.Day = timeEntry.ScheduleDate.format();
        newStaff.Staff = timeEntry.Quantity*WORKING_HOURS_IN_DAY;
        newStaff.SpecialOccasion = false;
        return newStaff;
    }

    @TestVisible private void countPlannedDaysAndFilterStaffingByDates(Map<String, Resource> resources){
        for(String key : resources.keySet()){
            Decimal plannedDays = 0;
            List<Staffing> filteredStaffing = new List<Staffing>();
            for(Staffing specificStaff: resources.get(key).Staffing){
                plannedDays += specificStaff.Staff;
                if(Date.parse(specificStaff.Day) >= this.startDate && Date.parse(specificStaff.Day) <= this.endDate) {
                    filteredStaffing.add(specificStaff);
                }
            }
            resources.get(key).Staffing = filteredStaffing;
            resources.get(key).PlannedDays = String.valueOf(plannedDays);
        }
    }

    @TestVisible private List<ResourceInfo> getResourcesAvailabilityData(){
        Map<String, ResourceInfo> contactIdToResourceAvailabilityData = new Map<String, ResourceInfo>();
        for(String contactId: contactIdsToNamesMap.keySet()){
            if(!contactIdToResourceAvailabilityData.containsKey(contactId)){
                ResourceInfo newInfo = new ResourceInfo();
                newInfo.ResourceName = contactIdsToNamesMap.get(contactId);
                newInfo.Staffing = new List<Staffing>();
                newInfo.ContactId = contactId;
                contactIdToResourceAvailabilityData.put(contactId, newInfo);
            }
            if(contactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.containsKey(contactId)){
                contactIdToResourceAvailabilityData.get(contactId).Staffing.addAll(getStaffingForResource(contactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.get(contactId).values()));
            }
        }
        return contactIdToResourceAvailabilityData.values();
    }

    @TestVisible private List<Staffing> getStaffingForResource(List<Map<String, OpportunityLineItem>> oppLineItemIdToOpportunityLineItemMap){
        Map<String, Staffing> DateToStaffingForResourceMap = new Map<String, Staffing>();
        for(Map<String, OpportunityLineItem> oppLineItemIdToLineItems: oppLineItemIdToOpportunityLineItemMap){
            for(OpportunityLineItem item: oppLineItemIdToLineItems.values()){
                if(checkIfSpecialOccasion(item.Opportunity.Name) && item.ServiceDate >= this.startDate && item.ServiceDate <= this.endDate)
                    DateToStaffingForResourceMap = addStaffing(DateToStaffingForResourceMap, getStaffingForSpecialOccasionEntry(item));
                else{
                    for(OpportunityLineItemSchedule timeEntry:item.OpportunityLineItemSchedules){
                        if(timeEntry.ScheduleDate >= this.startDate && timeEntry.ScheduleDate <= this.endDate){
                            DateToStaffingForResourceMap = addStaffing(DateToStaffingForResourceMap, getStaffingForScheduleEntry(timeEntry));
                        }
                    }
                }
            }
        }
        return DateToStaffingForResourceMap.values();
    }

    @TestVisible private Boolean checkIfSpecialOccasion(String oppName){
        Boolean isSpecialOccasion = false;
        if(oppName.contains(SPECIAL_OPPORTUNITY))
            isSpecialOccasion = true;
        return isSpecialOccasion;
    }

    @TestVisible private Map<String, Staffing> addStaffing(Map<String, Staffing> existingStuffing, Staffing newItemToAdd){
        if(!existingStuffing.containsKey(newItemToAdd.Day)){
            existingStuffing.put(newItemToAdd.Day, newItemToAdd);
        }
        else {
            existingStuffing.get(newItemToAdd.Day).Staff += newItemToAdd.Staff;
            if(newItemToAdd.SpecialOccasion)
                existingStuffing.get(newItemToAdd.Day).SpecialOccasion = newItemToAdd.SpecialOccasion;
        }
        return existingStuffing;
    }

    @TestVisible private Staffing getStaffingForSpecialOccasionEntry(OpportunityLineItem item){
        Staffing newStaff = new Staffing();
        newStaff.Day = item.ServiceDate.format();
        newStaff.Staff = item.Quantity*WORKING_HOURS_IN_DAY;
        newStaff.SpecialOccasion = true;
        return newStaff;
    }

    public void allocateResource(String oppLineItemId, Date selectedDate, Decimal numberOfDays){
        OpportunityLineItemSchedule changedOrCreatedLineItemSchedule;
        List<OpportunityLineItem> changedOpportunityLineItems = [SELECT UnitPrice, Quantity, 
                            (SELECT Quantity, Description FROM OpportunityLineItemSchedules WHERE ScheduleDate =:selectedDate 
                                AND Description != :OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT ORDER BY LastModifiedDate DESC) 
                            FROM OpportunityLineItem WHERE Id =: oppLineItemId];
        if(changedOpportunityLineItems.size() == 0)
            throw new OpportunityLineItemNotFoundException('OpportunityLineItem is not found');
        OpportunityLineItem changedOpportunityLineItem = changedOpportunityLineItems.get(0);
        if(changedOpportunityLineItem.OpportunityLineItemSchedules.size()>0)
            changedOrCreatedLineItemSchedule = changedOpportunityLineItem.OpportunityLineItemSchedules.get(0);
        else
            changedOrCreatedLineItemSchedule = createNewOpportunityLineItemSchedule(oppLineItemId, selectedDate);
        changedOrCreatedLineItemSchedule.Quantity = numberOfDays;
        upsert changedOrCreatedLineItemSchedule;
    }

    @TestVisible private OpportunityLineItemSchedule createNewOpportunityLineItemSchedule(String oppLineItemId, Date selectedDate){
        OpportunityLineItemSchedule createdLineItemSchedule = new OpportunityLineItemSchedule();
        createdLineItemSchedule.ScheduleDate = selectedDate;
        createdLineItemSchedule.OpportunityLineItemId = oppLineItemId;
        createdLineItemSchedule.Type = 'Quantity';
        return createdLineItemSchedule;
    }

    @TestVisible private List<Stats> getStats(String opp_line_item_id){
        List<Stats> stats = new List<Stats>();
        if(OppLineItemIdToDateRangeToDataTypeToStatisticsEntry.containsKey(opp_line_item_id)){
            for(Map<String, Planning_statistics__c> stat_entries : OppLineItemIdToDateRangeToDataTypeToStatisticsEntry.get(opp_line_item_id).values()){
                Stats new_stat = getDefaultNewStat(stat_entries.values().get(0));
                if(stat_entries.containsKey(PLANNED_STATISTIC_TYPE)){
                    new_stat.Days = new_stat.Days.split('/').get(0) + '/' + stat_entries.get(PLANNED_STATISTIC_TYPE).Days__c.stripTrailingZeros().toPlainString();
                    new_stat.Revenue = new_stat.Revenue.split('/').get(0) + '/' + stat_entries.get(PLANNED_STATISTIC_TYPE).Revenue__c.stripTrailingZeros().toPlainString();
                }
                if(stat_entries.containsKey(ACTUAL_STATISTIC_TYPE)){
                    new_stat.Days = stat_entries.get(ACTUAL_STATISTIC_TYPE).Days__c.stripTrailingZeros().toPlainString() + '/' + new_stat.Days.split('/').get(1);
                    new_stat.Revenue = stat_entries.get(ACTUAL_STATISTIC_TYPE).Revenue__c.stripTrailingZeros().toPlainString() + '/' + new_stat.Revenue.split('/').get(1);
                }
                stats.add(new_stat);
            }
        }
        return stats;
    }

    @TestVisible private Stats getDefaultNewStat(Planning_statistics__c stat_entry){
        Stats new_stat = new Stats();
        new_stat.StartDate = stat_entry.Start_Date__c.format();
        new_stat.EndDate = stat_entry.End_Date__c.format();
        new_stat.Days = '0/0';
        new_stat.Revenue = '0/0';
        return new_stat;
    }

    public class PsoToolDataSetWrapper{
        public String StartDate;
        public String EndDate;
        public String TimeStamp;
        public List<Customer> Customers;
        public List<ResourceInfo> Resources;

        public String JSON(){
            return JSON.serialize(this);
        }
    }

    public class Customer{
        public String AccountName;
        public String AccountId;
        public List<Project> Projects;
    }

    public class Project {
        public String OpportunityName;
        public String OurProjectManager;
        public String ProjectManagerId;
        public String OpportunityId;
        public List<Resource> Resources;
    }

    public class Resource{
        public String ResourceName;
        public String ContactId;
        public String Product;
        public Decimal SalesPrice;
        public String PlannedDays;
        public Decimal SoldDays;
        public String LastModifiedDate;
        public List<Staffing> Staffing;
        public Map<String, String> MonthToLimitMap;
        public Map<String, String> MonthToOppLineItemIdMap;
        public List<Stats> Statistics;
    }

    public class Staffing {
        public String Day;
        public Decimal Staff;
        public Boolean SpecialOccasion;
    }

    public class ResourceInfo{
        public String ResourceName;
        public String ContactId;
        public List<Staffing> Staffing;
    }

    public class Stats{
        public String StartDate;
        public String EndDate;
        public String Days;
        public String Revenue;
    }

    public class OpportunityLineItemNotFoundException extends Exception{}
    public class OpportunityLineItemQuantityLimitIsReachedException extends Exception{}
}