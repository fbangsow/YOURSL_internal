public without sharing class PsoToolController{
    private static Map<Id, PsoToolController> UserIdToPsoToolInstance= new Map<Id, PsoToolController>();
    @TestVisible private PsoToolDataSetWrapper DataSet;
    @TestVisible private List<Opportunity> Opportunities;
    @TestVisible private Map<String, Contact> ContactIdsToContacts;
    @TestVisible private Map<String, Map<String, Map<String, OpportunityLineItem>>> ContactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap;
    @TestVisible private Date StartDate;
    @TestVisible private Date EndDate;
    @TestVisible private List<Id> OpportunitiesToShow;
    private Map<String, Decimal> OppLineItemScheduleIdToNumberOfDays;
    @TestVisible private Map<String, Map<String, RawStats>> OppLineItemIdToDateRangeToRawStats;
    @TestVisible private Map<String, Map<String, RawStats>> ContactIdToDateRangeToRawStats;
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
    public static final String COMPANY_NAME = 'YOUR SL GmbH';
    private Integer NumberOfShownMonthes = 2;

    private PsoToolController(){
        OpportunitiesToShow = new List<Id>();
        setStartDate(Date.today());
    }

    public static PsoToolController getInstance(){
        createInstanceIfDoesntExist();
        return UserIdToPsoToolInstance.get(UserInfo.getUserId());
    }

    private static void createInstanceIfDoesntExist(){
        if(!UserIdToPsoToolInstance.containsKey(UserInfo.getUserId())){
            PsoToolController pso_tool_instance = new PsoToolController();
            UserIdToPsoToolInstance.put(UserInfo.getUserId(), pso_tool_instance);
        }
    }

    public PsoToolDataSetWrapper getDataSet(){
        DataSet = new PsoToolDataSetWrapper();
        queryData();
        ContactIdsToContacts = new Map<String, Contact>();
        DataSet.StartDate = this.StartDate.format();
        DataSet.EndDate = this.EndDate.format();
        DataSet.Customers = getCustomers(true);
        DataSet.Resources = getResourcesAvailabilityData();
        return DataSet;
    }

    public PsoToolController setStartDate(Date passed_date){
        this.StartDate = passed_date.toStartOfMonth();
        Date helper_date = this.StartDate.addMonths(NumberOfShownMonthes - 1);
        this.EndDate = Date.newInstance(helper_date.year(), helper_date.month(), Date.daysInMonth(helper_date.year(), helper_date.month()));
        return this;
    }

    public PsoToolController setSelectedOpportunities(List<Id> selected_opportunities){
        this.OpportunitiesToShow = selected_opportunities;
        return this;
    }

    @TestVisible private void queryData(){
        getOpportunities();
        List<OpportunityLineItem> opportunity_line_items = [SELECT Contact__r.Id, Product2.Name, ServiceDate, Opportunity.Name, Opportunity.Id, Quantity,
                                    (SELECT OpportunityLineItemId, ScheduleDate, Quantity
                                        FROM OpportunityLineItemSchedules
                                        WHERE Description !=:OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT)
                                        FROM OpportunityLineItem
                                        WHERE Contact__r.Id IN :getRelatedContactIds()
                                        AND (Managed_by_PSO_Tool__c = true OR Opportunity.Name LIKE : (SPECIAL_OPPORTUNITY + '%'))];
        buildDataStructure(opportunity_line_items);
        List<Planning_statistics__c> planning_statistics_info = [SELECT Data_Type__c, Days__c, End_Date__c, OpportunityLineItemId__c, Revenue__c, Start_Date__c, Time_Type__c, Contact__r.Id
                                        FROM Planning_statistics__c
                                        WHERE Start_Date__c >= :this.StartDate AND End_Date__c <= :this.EndDate];
        processStatistics(planning_statistics_info);
    }

    private void getOpportunities(){
        Opportunities = [SELECT Id, Name, Account.Name, Account.Id, Projektleiter_YOUR_SL__r.Name, Projektstatus__c,
                                    (SELECT Contact__r.Name, Contact__r.Id, Contact__r.Account.Name, Contact__r.Title, Contact__r.LastName, Quantity, Product2.Name, ServiceDate, UnitPrice, LastModifiedDate
                                        FROM OpportunityLineItems
                                        WHERE Contact__r.LastName != 'All' AND
                                        Unit__c = 'Manntag(e)')
                                        FROM Opportunity
                                        WHERE Id IN :getOpportunitiesToShow()
                                        AND
                                        Project_Start_Date__c <= :this.EndDate AND
                                        Project_End_Date__c >= :this.StartDate
                                        AND Managed_by_PSO_Tool__c = true];
    }

    @TestVisible private List<Id> getOpportunitiesToShow(){
        if(OpportunitiesToShow.isEmpty())
            return getRelatedOpportunityIds();
        else
            return OpportunitiesToShow;
    }

    private List<Id> getRelatedOpportunityIds(){
        if(PROFILE_ID_TO_PROFILE_NAME_FOR_ADMIN_MODE.containsKey(UserInfo.getProfileId()))
            return getAllOpportunityIds();
        else
            return getOnlyRelatedOpportunityIds();
    }

    private List<Id> getAllOpportunityIds(){
        List<Id> all_ids = new List<Id>();
        List<Opportunity> Opportunities = [SELECT Id FROM Opportunity WHERE Managed_by_PSO_Tool__c = true];
        for(Opportunity single_opportunity: Opportunities){
            all_ids.add(single_opportunity.Id);
        }
        return all_ids;
    }

    private List<Id> getOnlyRelatedOpportunityIds(){
        List<OpportunityTeamMember> team_members = [SELECT OpportunityId FROM OpportunityTeamMember WHERE UserId =: UserInfo.getUserId()];
        List<Id> opportunityIds = new List<Id>();
        for(OpportunityTeamMember team_member: team_members){
            opportunityIds.add(team_member.OpportunityId);
        }
        return opportunityIds;
    }

    private Set<Id> getRelatedContactIds(){
        Set<Id> contact_ids = new Set<Id>();
        for(Opportunity opp: Opportunities){
            for(OpportunityLineItem item: opp.OpportunityLineItems){
                contact_ids.add(item.Contact__r.Id);
            }
        }
        return contact_ids;
    }

    private void buildDataStructure(List<OpportunityLineItem> opportunity_line_items){
        ContactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap = new Map<String, Map<String, Map<String, OpportunityLineItem>>>();
        for(OpportunityLineItem item: opportunity_line_items){
            if(!ContactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.containsKey(item.Contact__r.Id)){
                ContactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.put(item.Contact__r.Id, getOpportunityIdToOpportunityLineItemMap(item));
            }
            else{
                if(!ContactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.get(item.Contact__r.Id).containsKey(item.Opportunity.Id)){
                    ContactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.get(item.Contact__r.Id).put(item.Opportunity.Id, new Map<String, OpportunityLineItem>{item.Id => item});
                }
                else{
                    ContactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.get(item.Contact__r.Id).get(item.Opportunity.Id).put(item.Id, item);
                }
            }
        }
    }

    private Map<String, Map<String, OpportunityLineItem>> getOpportunityIdToOpportunityLineItemMap(OpportunityLineItem item){
        Map<String, Map<String, OpportunityLineItem>> new_map = new Map<String, Map<String, OpportunityLineItem>>();
        new_map.put(item.Opportunity.Id, new Map<String, OpportunityLineItem>{item.Id => item});
        return new_map;
    }

    @TestVisible private void processStatistics(List<Planning_statistics__c> planning_statistics){
        OppLineItemIdToDateRangeToRawStats = new Map<String, Map<String, RawStats>>();
        ContactIdToDateRangeToRawStats = new Map<String, Map<String, RawStats>>();
        for(Planning_statistics__c entry : planning_statistics){
            String key_for_nested_map = entry.Start_Date__c.format() + ' - ' + entry.End_Date__c.format();
            buildOppLineItemIdToDateRangeToRawStats(entry, key_for_nested_map);
            buildContactIdToDateRangeToRawStats(entry, key_for_nested_map);
        }
    }

    @TestVisible private void buildOppLineItemIdToDateRangeToRawStats(Planning_statistics__c entry, String key_for_nested_map){
        if(!OppLineItemIdToDateRangeToRawStats.containsKey(entry.OpportunityLineItemId__c))
            OppLineItemIdToDateRangeToRawStats.put(entry.OpportunityLineItemId__c, new Map<String, RawStats>());
        if(!OppLineItemIdToDateRangeToRawStats.get(entry.OpportunityLineItemId__c).containsKey(key_for_nested_map))
            OppLineItemIdToDateRangeToRawStats.get(entry.OpportunityLineItemId__c).put(key_for_nested_map, new RawStats(entry));
        if(entry.Data_Type__c == PLANNED_STATISTIC_TYPE){
            OppLineItemIdToDateRangeToRawStats.get(entry.OpportunityLineItemId__c).get(key_for_nested_map).PlannedDays = entry.Days__c;
            OppLineItemIdToDateRangeToRawStats.get(entry.OpportunityLineItemId__c).get(key_for_nested_map).PlannedRevenue = entry.Revenue__c;
        }
        if(entry.Data_Type__c == ACTUAL_STATISTIC_TYPE){
            OppLineItemIdToDateRangeToRawStats.get(entry.OpportunityLineItemId__c).get(key_for_nested_map).ActualDays = entry.Days__c;
            OppLineItemIdToDateRangeToRawStats.get(entry.OpportunityLineItemId__c).get(key_for_nested_map).ActualRevenue = entry.Revenue__c;
        }
    }

    @TestVisible private void buildContactIdToDateRangeToRawStats(Planning_statistics__c entry, String key_for_nested_map){
        if(!ContactIdToDateRangeToRawStats.containsKey(entry.Contact__r.Id))
            ContactIdToDateRangeToRawStats.put(entry.Contact__r.Id, new Map<String, RawStats>());
        if(!ContactIdToDateRangeToRawStats.get(entry.Contact__r.Id).containsKey(key_for_nested_map))
            ContactIdToDateRangeToRawStats.get(entry.Contact__r.Id).put(key_for_nested_map, new RawStats(entry));
        if(entry.Data_Type__c == PLANNED_STATISTIC_TYPE){
            ContactIdToDateRangeToRawStats.get(entry.Contact__r.Id).get(key_for_nested_map).PlannedDays += entry.Days__c;
            ContactIdToDateRangeToRawStats.get(entry.Contact__r.Id).get(key_for_nested_map).PlannedRevenue += entry.Revenue__c;
        }
        if(entry.Data_Type__c == ACTUAL_STATISTIC_TYPE){
            ContactIdToDateRangeToRawStats.get(entry.Contact__r.Id).get(key_for_nested_map).ActualDays += entry.Days__c;
            ContactIdToDateRangeToRawStats.get(entry.Contact__r.Id).get(key_for_nested_map).ActualRevenue += entry.Revenue__c;
        }
    }

    @TestVisible private List<Customer> getCustomers(Boolean with_resources){
        Map<Id, Customer> customers = new Map<Id, Customer>();
        for(Opportunity opp: Opportunities){
            if(!customers.containsKey(opp.Account.Id)){
                customers.put(opp.Account.Id, getCustomer(opp));
            }
            customers.get(opp.Account.Id).Projects.add(getProject(opp, with_resources));
        }
        return customers.values();
    }

    @TestVisible private Customer getCustomer(Opportunity opp){
        Customer new_customer = new Customer();
        new_customer.AccountName = opp.Account.Name;
        new_customer.AccountId = opp.Account.Id;
        new_customer.Projects = new List<Project>();
        return new_customer;
    }

    @TestVisible private Project getProject(Opportunity opp, Boolean with_resources){
        Project new_project = new Project();
        new_project.OpportunityName = opp.Name;
        new_project.OurProjectManager = opp.Projektleiter_YOUR_SL__r.Name;
        new_project.ProjectManagerId = opp.Projektleiter_YOUR_SL__r.Id;
        new_project.OpportunityId = opp.Id;
        new_project.ProjectStatus = opp.Projektstatus__c;
        if(with_resources)
            new_project.Resources = getResources(opp);
        return new_project;
    }

    @TestVisible private List<Resource> getResources(Opportunity opp){
        Map<String, Resource> resources = new Map<String, Resource> ();
        for(OpportunityLineItem line_item: opp.OpportunityLineItems){
            if(line_item.Contact__r != null)
                ContactIdsToContacts.put(line_item.Contact__r.Id, line_item.Contact__r);
            String key_for_map = line_item.Contact__r.Name + line_item.Product2.Name;
            if(!resources.containsKey(key_for_map)){
                resources.put(line_item.Contact__r.Name + line_item.Product2.Name, getResource(opp.Id, line_item));
            }
            else{
                resources.get(key_for_map).SoldDays += WORKING_HOURS_IN_DAY*line_item.Quantity;
                resources.get(key_for_map).Staffing.addAll(getStaffingForResourceForOpportunity(opp.Id, line_item));
                checkIfMonthIsWithinRangeAndPutInMap(resources.get(key_for_map), line_item);
                resources.get(key_for_map).Statistics.addAll(getStatsForOppLineItem(line_item.Id));
                if(Datetime.valueOf(resources.get(key_for_map).LastModifiedDate) < line_item.LastModifiedDate)
                    resources.get(key_for_map).LastModifiedDate = line_item.LastModifiedDate.format('yyyy-MM-dd HH:mm:ss');
            }
        }
        countPlannedDaysAndFilterStaffingByDates(resources);
        return resources.values();
    }

    @TestVisible private Resource getResource(String opp_id, OpportunityLineItem line_item){
        Resource new_resource = new Resource();
        new_resource.ResourceName = line_item.Contact__r.Name;
        new_resource.ContactId = line_item.Contact__r.Id;
        new_resource.Product = line_item.Product2.Name;
        new_resource.SalesPrice = line_item.UnitPrice;
        new_resource.SoldDays = WORKING_HOURS_IN_DAY*line_item.Quantity;
        new_resource.LastModifiedDate = line_item.LastModifiedDate.format('yyyy-MM-dd HH:mm:ss');
        new_resource.Staffing = getStaffingForResourceForOpportunity(opp_id, line_item);
        new_resource.MonthToLimitMap = new Map<String, String>();
        new_resource.MonthToOppLineItemIdMap = new Map<String, String>();
        new_resource.Statistics = getStatsForOppLineItem(line_item.Id);
        checkIfMonthIsWithinRangeAndPutInMap(new_resource, line_item);
        return new_resource;
    }

    @TestVisible private void checkIfMonthIsWithinRangeAndPutInMap(Resource resource, OpportunityLineItem item){
        if(item.ServiceDate >= this.StartDate && item.ServiceDate <= this.EndDate){
            resource.MonthToLimitMap.put(String.valueOf(item.ServiceDate.month()), String.valueOf(item.Quantity));
            resource.MonthToOppLineItemIdMap.put(String.valueOf(item.ServiceDate.month()), item.Id);
        }
    }

    @TestVisible private List<Staffing> getStaffingForResourceForOpportunity(String opp_id, OpportunityLineItem line_item){
        List<Staffing> schedule = new List<Staffing>();
        if(ContactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.containsKey(line_item.Contact__r.Id)){
            if(ContactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.get(line_item.Contact__r.Id).containsKey(opp_id)){
                if(ContactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.get(line_item.Contact__r.Id).get(opp_id).containsKey(line_item.Id)){
                    for(OpportunityLineItemSchedule time_entry: ContactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.get(line_item.Contact__r.Id).get(opp_id).get(line_item.Id).OpportunityLineItemSchedules){
                        if(time_entry.Quantity != 0)
                            schedule.add(getStaffingForScheduleEntry(time_entry));
                    }
                }
            }
        }
        return schedule;
    }

    @TestVisible private Staffing getStaffingForScheduleEntry(OpportunityLineItemSchedule time_entry){
        Staffing new_staff = new Staffing();
        new_staff.Day = time_entry.ScheduleDate.format();
        new_staff.Staff = time_entry.Quantity*WORKING_HOURS_IN_DAY;
        new_staff.SpecialOccasion = false;
        return new_staff;
    }

    @TestVisible private void countPlannedDaysAndFilterStaffingByDates(Map<String, Resource> resources){
        for(String key : resources.keySet()){
            Decimal planned_days = 0;
            List<Staffing> filteredStaffing = new List<Staffing>();
            for(Staffing specificStaff: resources.get(key).Staffing){
                planned_days += specificStaff.Staff;
                if(Date.parse(specificStaff.Day) >= this.StartDate && Date.parse(specificStaff.Day) <= this.EndDate) {
                    filteredStaffing.add(specificStaff);
                }
            }
            resources.get(key).Staffing = filteredStaffing;
            resources.get(key).PlannedDays = String.valueOf(planned_days);
        }
    }

    @TestVisible private List<ResourceInfo> getResourcesAvailabilityData(){
        Map<String, ResourceInfo> contactIdToResourceAvailabilityData = new Map<String, ResourceInfo>();
        for(String contact_id: ContactIdsToContacts.keySet()){
            if(!contactIdToResourceAvailabilityData.containsKey(contact_id)){
                ResourceInfo newInfo = new ResourceInfo();
                newInfo.ResourceName = ContactIdsToContacts.get(contact_id).Name;
                newInfo.LastName = ContactIdsToContacts.get(contact_id).LastName;
                newInfo.Title = ContactIdsToContacts.get(contact_id).Title;
                newInfo.AccountName = ContactIdsToContacts.get(contact_id).Account.Name;
                newInfo.Staffing = new List<Staffing>();
                newInfo.ContactId = contact_id;
                newInfo.Statistics = getStatsForContact(contact_id);
                contactIdToResourceAvailabilityData.put(contact_id, newInfo);
            }
            if(ContactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.containsKey(contact_id)){
                contactIdToResourceAvailabilityData.get(contact_id).Staffing.addAll(getStaffingForResource(ContactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.get(contact_id).values()));
            }
        }
        return contactIdToResourceAvailabilityData.values();
    }

    @TestVisible private List<Staffing> getStaffingForResource(List<Map<String, OpportunityLineItem>> opp_line_item_id_to_opportunity_line_item){
        Map<String, Staffing> DateToStaffingForResourceMap = new Map<String, Staffing>();
        for(Map<String, OpportunityLineItem> opp_line_item_id_to_line_items: opp_line_item_id_to_opportunity_line_item){
            for(OpportunityLineItem item: opp_line_item_id_to_line_items.values()){
                if(checkIfSpecialOccasion(item.Opportunity.Name) && item.ServiceDate >= this.StartDate && item.ServiceDate <= this.EndDate)
                    DateToStaffingForResourceMap = addStaffing(DateToStaffingForResourceMap, getStaffingForSpecialOccasionEntry(item));
                else{
                    for(OpportunityLineItemSchedule time_entry:item.OpportunityLineItemSchedules){
                        if(time_entry.ScheduleDate >= this.StartDate && time_entry.ScheduleDate <= this.EndDate){
                            DateToStaffingForResourceMap = addStaffing(DateToStaffingForResourceMap, getStaffingForScheduleEntry(time_entry));
                        }
                    }
                }
            }
        }
        return DateToStaffingForResourceMap.values();
    }

    @TestVisible private Boolean checkIfSpecialOccasion(String opp_name){
        Boolean is_special_occasion = false;
        if(opp_name.contains(SPECIAL_OPPORTUNITY))
            is_special_occasion = true;
        return is_special_occasion;
    }

    @TestVisible private Map<String, Staffing> addStaffing(Map<String, Staffing> existing_stuffing, Staffing new_item_to_add){
        if(!existing_stuffing.containsKey(new_item_to_add.Day)){
            existing_stuffing.put(new_item_to_add.Day, new_item_to_add);
        }
        else {
            existing_stuffing.get(new_item_to_add.Day).Staff += new_item_to_add.Staff;
            if(new_item_to_add.SpecialOccasion)
                existing_stuffing.get(new_item_to_add.Day).SpecialOccasion = new_item_to_add.SpecialOccasion;
        }
        return existing_stuffing;
    }

    @TestVisible private Staffing getStaffingForSpecialOccasionEntry(OpportunityLineItem item){
        Staffing new_staff = new Staffing();
        new_staff.Day = item.ServiceDate.format();
        new_staff.Staff = item.Quantity*WORKING_HOURS_IN_DAY;
        new_staff.SpecialOccasion = true;
        return new_staff;
    }

    public Result allocateResource(String opp_line_item_id, Date selected_date, Decimal number_of_days){
        OpportunityLineItemSchedule changed_or_created_line_item_schedule;
        List<OpportunityLineItem> changed_opportunity_line_items = [SELECT UnitPrice, Quantity,
                            (SELECT Quantity, Description FROM OpportunityLineItemSchedules WHERE ScheduleDate =:selected_date
                                AND Description != :OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT ORDER BY LastModifiedDate DESC)
                            FROM OpportunityLineItem WHERE Id =: opp_line_item_id];
        if(changed_opportunity_line_items.isEmpty())
            return new Result('OpportunityLineItem is not found');
        OpportunityLineItem changed_opportunity_line_item = changed_opportunity_line_items.get(0);
        if(changed_opportunity_line_item.OpportunityLineItemSchedules.size()>0)
            changed_or_created_line_item_schedule = changed_opportunity_line_item.OpportunityLineItemSchedules.get(0);
        else
            changed_or_created_line_item_schedule = createNewOpportunityLineItemSchedule(opp_line_item_id, selected_date);
        changed_or_created_line_item_schedule.Quantity = number_of_days;
        try{
            return new Result(Database.upsert(changed_or_created_line_item_schedule));
        } catch(DmlException e){
            return new Result(e);
        }
    }

    @TestVisible private OpportunityLineItemSchedule createNewOpportunityLineItemSchedule(String opp_line_item_id, Date selected_date){
        OpportunityLineItemSchedule created_line_item_schedule = new OpportunityLineItemSchedule();
        created_line_item_schedule.ScheduleDate = selected_date;
        created_line_item_schedule.OpportunityLineItemId = opp_line_item_id;
        created_line_item_schedule.Type = 'Quantity';
        return created_line_item_schedule;
    }

    @TestVisible private List<Stats> getStatsForOppLineItem(String opp_line_item_id){
        List<Stats> stats = new List<Stats>();
        if(OppLineItemIdToDateRangeToRawStats.containsKey(opp_line_item_id)){
            for(RawStats stat_entry : OppLineItemIdToDateRangeToRawStats.get(opp_line_item_id).values())
                stats.add(getNewStat(stat_entry));
        }
        return stats;
    }

    @TestVisible private List<Stats> getStatsForContact(String contact_id){
        List<Stats> stats = new List<Stats>();
        if(ContactIdToDateRangeToRawStats.containsKey(contact_id)){
            for(RawStats stat_entry : ContactIdToDateRangeToRawStats.get(contact_id).values())
                stats.add(getNewStat(stat_entry));
        }
        return stats;
    }

    @TestVisible private Stats getNewStat(RawStats raw_stat_entry){
        Stats new_stat = new Stats();
        new_stat.StartDate = raw_stat_entry.StartDate.format();
        new_stat.EndDate = raw_stat_entry.EndDate.format();
        new_stat.Days = raw_stat_entry.ActualDays.stripTrailingZeros().toPlainString() + '/' + raw_stat_entry.PlannedDays.stripTrailingZeros().toPlainString();
        new_stat.Revenue = raw_stat_entry.ActualRevenue.stripTrailingZeros().toPlainString() + '/' + raw_stat_entry.PlannedRevenue.stripTrailingZeros().toPlainString();
        return new_stat;
    }

    public AccountsAndTheirOpportunities getAccountsAndOpportunities(){
        AccountsAndTheirOpportunities accounts_and_opportunities = new AccountsAndTheirOpportunities();
        getOpportunities();
        accounts_and_opportunities.Customers = getCustomers(false);
        accounts_and_opportunities.IsAllowedToRunScript = PROFILE_ID_TO_PROFILE_NAME_FOR_ADMIN_MODE.containsKey(UserInfo.getProfileId());
        return accounts_and_opportunities;
    }

    public ProjectHealthReasons getProjectHealthReasons(){
        ProjectHealthReasons container_object = new ProjectHealthReasons();
        container_object.ReasonsLabelToValue = new Map<String, String>();
        List<Schema.PicklistEntry> field_result = Opportunity.Projektstatus__c.getDescribe().getPicklistValues();
        for(Schema.PicklistEntry entry:field_result)
            container_object.ReasonsLabelToValue.put(entry.getLabel(), entry.getValue());
        return container_object;
    }

    public void setProjectHealthReason(String opportunity_id, String value){
        List<Opportunity> selected_opportunities = [SELECT Projektstatus__c FROM Opportunity WHERE Id =: opportunity_id];
        if(selected_opportunities.isEmpty())
            throw new OpportunityNotFoundException('Opportunity is not found');
        Opportunity opportunity_to_update = selected_opportunities.get(0);
        opportunity_to_update.Projektstatus__c = value;
        update opportunity_to_update;
    }

    public class PsoToolDataSetWrapper{
        public String StartDate;
        public String EndDate;
        public List<Customer> Customers;
        public List<ResourceInfo> Resources;

        public String JSON(){
            JSONGenerator jeyson = JSON.createGenerator(false);
            jeyson.writeStartObject();
            jeyson.writeStringField('StartDate', StartDate);
            jeyson.writeStringField('EndDate', EndDate);
            jeyson.writeObjectField('Customers', Customers);
            sortAndWriteResources(jeyson);
            jeyson.writeEndObject();
            return jeyson.getAsString();
        }

        private void sortAndWriteResources(JSONGenerator jeyson){
            Resources.sort();
            jeyson.writeFieldName('Resources');
            jeyson.writeStartArray();
            for(ResourceInfo resource: Resources)
                jeyson.writeObject(resource);
            jeyson.writeEndArray();
        }
    }

    public class AccountsAndTheirOpportunities{
        public List<Customer> Customers;
        public Boolean IsAllowedToRunScript;

        public String JSON(){
            return JSON.serialize(this);
        }
    }

    public class ProjectHealthReasons{
        public Map<String,String> ReasonsLabelToValue;

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
        public String ProjectStatus;
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

    public class ResourceInfo implements Comparable{
        public String ResourceName;
        public String Title;
        public String AccountName;
        @TestVisible private String LastName;
        public String ContactId;
        public List<Staffing> Staffing;
        public List<Stats> Statistics;

        public Integer compareTo(Object compare_to){
            ResourceInfo resource_info_to_compare = (ResourceInfo)compare_to;
            if(AccountName == COMPANY_NAME && resource_info_to_compare.AccountName != COMPANY_NAME)
                return -1;
            else if(AccountName != COMPANY_NAME && resource_info_to_compare.AccountName == COMPANY_NAME)
                return 1;
            else if(AccountName != resource_info_to_compare.AccountName)
                return AccountName.compareTo(resource_info_to_compare.AccountName);
            else
                return compareBasedOnTitle(resource_info_to_compare);
        }

        private Integer compareBasedOnTitle(ResourceInfo resource_info_to_compare){
            if(Title != resource_info_to_compare.Title)
                return Title.compareTo(resource_info_to_compare.Title);
            else
                return compareBasedOnLastName(resource_info_to_compare);
        }

        private Integer compareBasedOnLastName(ResourceInfo resource_info_to_compare){
            return LastName.compareTo(resource_info_to_compare.LastName);
        }
    }

    public class Stats{
        public String StartDate;
        public String EndDate;
        public String Days;
        public String Revenue;
    }

    public class RawStats{
        public Date StartDate;
        public Date EndDate;
        public Decimal PlannedDays;
        public Decimal PlannedRevenue;
        public Decimal ActualDays;
        public Decimal ActualRevenue;

        public RawStats(Planning_statistics__c entry){
            this.StartDate = entry.Start_Date__c;
            this.EndDate = entry.End_Date__c;
            this.PlannedDays = 0;
            this.PlannedRevenue = 0;
            this.ActualDays = 0;
            this.ActualRevenue = 0;
        }
    }

    public class Result{
        public Boolean IsSuccess;
        public String ErrorMessage;
        public Database.UpsertResult ReturnedResult;

        public Result(Database.UpsertResult result){
            IsSuccess = result.isSuccess();
            if(!result.getErrors().isEmpty())
                ErrorMessage = result.getErrors().get(0).getMessage();
            ReturnedResult = result;
        }

        public Result(DmlException e){
            IsSuccess = false;
            ErrorMessage = e.getDmlMessage(0);
        }

        public Result(String custom_error_message){
            IsSuccess = false;
            ErrorMessage = custom_error_message;
        }
    }

    public class OpportunityNotFoundException extends Exception{}
    public class OpportunityLineItemQuantityLimitIsReachedException extends Exception{}
}