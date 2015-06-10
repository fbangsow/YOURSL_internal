@isTest
private class PsoToolControllerTest {

    @isTest static void testGetInstanceReturnsTheSameObject() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Test.startTest();
                PsoToolController new_instance = PsoToolController.getInstance();
            Test.stopTest();
            System.assertEquals(PsoToolController.getInstance(), new_instance, 'Singleton should return the same instance');
            System.assertNotEquals(null, new_instance.StartDate, 'StartDate should be set');
            System.assertNotEquals(null, new_instance.EndDate, 'EndDate should be set');
        }
    }

    @isTest static void testGetDataSetReturnsTheRightObject() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Test.startTest();
                Object data_set = PsoToolController.getInstance().getDataSet();
            Test.stopTest();
            System.assert(data_set instanceof PsoToolController.PsoToolDataSetWrapper, 'Method should return an instance of PsoToolDataSetWrapper class');
            PsoToolController.PsoToolDataSetWrapper data_set_object = (PsoToolController.PsoToolDataSetWrapper)data_set;
            System.assertNotEquals(null, data_set_object.StartDate, 'StartDate should be set');
            System.assertNotEquals(null, data_set_object.EndDate, 'EndDate should be set');
        }
    }

    @isTest static void testGetDataSetSetsTheRightDatesWhenWePassTheStartingMonth() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Date new_years_eve = Date.newInstance(2015, 1, 3);
            Test.startTest();
                Object data_set = PsoToolController.getInstance().setStartDate(new_years_eve).getDataSet();
            Test.stopTest();
            System.assert(data_set instanceof PsoToolController.PsoToolDataSetWrapper, 'Method should return an instance of PsoToolDataSetWrapper class');
            PsoToolController.PsoToolDataSetWrapper data_set_object = (PsoToolController.PsoToolDataSetWrapper)data_set;
            System.assertEquals(Date.newInstance(2015, 1, 1), Date.parse(data_set_object.StartDate), 'StartDate should be the first day of the passed month');
            System.assertEquals(Date.newInstance(2015, 2, 28), Date.parse(data_set_object.EndDate), 'EndDate should be the last day of the passed month + 3 months');
        }
    }

    @isTest static void testQueryDataFindsTheRightOpportunitiesAndBuildsDataSet() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            new_instance.startDate = Date.newInstance(2015, 1, 1);
            new_instance.endDate = Date.newInstance(2015, 3, 31);
            setup_data.createTestData();
            setup_data.createPlannedStatisticalData();
            setup_data.createActualStatisticalData();
            Test.startTest();
                new_instance.queryData();
            Test.stopTest();
            System.assertEquals(2, new_instance.opportunities.size(), 'This property should have 2 test opportunities');
            System.assert(new_instance.contactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.containsKey(setup_data.TestContact.Id));
            Map<String, Map<String, OpportunityLineItem>> opportunitiesToOppLineItemIdToOppLineItems = new_instance.contactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.get(setup_data.TestContact.Id);
            System.assertEquals(2, opportunitiesToOppLineItemIdToOppLineItems.values().size());
            System.assert(opportunitiesToOppLineItemIdToOppLineItems.containsKey(setup_data.FirstOpportunity.Id));
            System.assert(opportunitiesToOppLineItemIdToOppLineItems.containsKey(setup_data.SecondOpportunity.Id));
            Map<String, OpportunityLineItem> lineOppsThatBelongToFirstOpportunity = opportunitiesToOppLineItemIdToOppLineItems.get(setup_data.FirstOpportunity.Id);
            System.assertEquals(1, lineOppsThatBelongToFirstOpportunity.values().size());
            System.assert(lineOppsThatBelongToFirstOpportunity.containsKey(setup_data.FirstLineItem.Id));
            Map<String, OpportunityLineItem> lineOppsThatBelongToSecondOpportunity = opportunitiesToOppLineItemIdToOppLineItems.get(setup_data.SecondOpportunity.Id);
            System.assertEquals(2, lineOppsThatBelongToSecondOpportunity.values().size());
            System.assert(lineOppsThatBelongToSecondOpportunity.containsKey(setup_data.SecondLineItem.Id));
            System.assert(new_instance.OppLineItemIdToDateRangeToDataTypeToStatisticsEntry.containsKey(setup_data.FirstLineItem.Id));
        }
    }

    @isTest static void testQueryDataFindsAllOpportunitiesForAdmins() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            new_instance.startDate = Date.newInstance(2015, 1, 1);
            new_instance.endDate = Date.newInstance(2015, 3, 31);
            setup_data.createTestDataForAdmins();
            setup_data.createPlannedStatisticalData();
            setup_data.createActualStatisticalData();
            Test.startTest();
                new_instance.queryData();
            Test.stopTest();
            System.assertEquals(2, new_instance.opportunities.size(), 'This property should have 2 test opportunities');
            System.assert(new_instance.contactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.containsKey(setup_data.TestContact.Id));
            Map<String, Map<String, OpportunityLineItem>> opportunitiesToOppLineItemIdToOppLineItems = new_instance.contactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.get(setup_data.TestContact.Id);
            System.assertEquals(2, opportunitiesToOppLineItemIdToOppLineItems.values().size());
            System.assert(opportunitiesToOppLineItemIdToOppLineItems.containsKey(setup_data.FirstOpportunity.Id));
            System.assert(opportunitiesToOppLineItemIdToOppLineItems.containsKey(setup_data.SecondOpportunity.Id));
            Map<String, OpportunityLineItem> lineOppsThatBelongToFirstOpportunity = opportunitiesToOppLineItemIdToOppLineItems.get(setup_data.FirstOpportunity.Id);
            System.assertEquals(1, lineOppsThatBelongToFirstOpportunity.values().size());
            System.assert(lineOppsThatBelongToFirstOpportunity.containsKey(setup_data.FirstLineItem.Id));
            Map<String, OpportunityLineItem> lineOppsThatBelongToSecondOpportunity = opportunitiesToOppLineItemIdToOppLineItems.get(setup_data.SecondOpportunity.Id);
            System.assertEquals(2, lineOppsThatBelongToSecondOpportunity.values().size());
            System.assert(lineOppsThatBelongToSecondOpportunity.containsKey(setup_data.SecondLineItem.Id));
            System.assert(new_instance.OppLineItemIdToDateRangeToDataTypeToStatisticsEntry.containsKey(setup_data.FirstLineItem.Id));
        }
    }

    @isTest static void testQueryDataDoesntFindAllOpportunitiesForNonAdmins() {
        SetupDataClass setup_data = new SetupDataClass('YOUR SL Standard User');
        PsoToolController new_instance;
        System.runAs(setup_data.TestUser) {
            new_instance = PsoToolController.getInstance();
            new_instance.startDate = Date.newInstance(2015, 1, 1);
            new_instance.endDate = Date.newInstance(2015, 3, 31);
            setup_data.createTestDataForAdmins();
            setup_data.createPlannedStatisticalData();
            setup_data.createActualStatisticalData();
        }
        setup_data.createAnotherUser();
        System.runAs(setup_data.AnotherUser) {
            Test.startTest();
                new_instance.queryData();
            Test.stopTest();
            System.assertEquals(0, new_instance.opportunities.size(), 'This property should have 0 test opportunities');
        }
    }

    @isTest static void testProcessStatisticsCreatesRightData(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            setup_data.createTestData();
            setup_data.createPlannedStatisticalData();
            setup_data.createActualStatisticalData();
            List<Planning_statistics__c> planning_statistics_info = [SELECT Data_Type__c, Days__c, End_Date__c, OpportunityLineItemId__c, Revenue__c, Start_Date__c, Time_Type__c 
                                        FROM Planning_statistics__c 
                                        WHERE OpportunityLineItemId__c =: setup_data.FirstLineItem.Id];
            Test.startTest();
                new_instance.processStatistics(planning_statistics_info);
            Test.stopTest();
            System.assert(new_instance.OppLineItemIdToDateRangeToDataTypeToStatisticsEntry.containsKey(setup_data.FirstLineItem.Id));
            String key_for_nested_map = setup_data.PlannedNumbers.Start_Date__c.format() + ' - ' + setup_data.PlannedNumbers.End_Date__c.format();
            System.assert(new_instance.OppLineItemIdToDateRangeToDataTypeToStatisticsEntry.get(setup_data.FirstLineItem.Id).containsKey(key_for_nested_map));
            System.assert(new_instance.OppLineItemIdToDateRangeToDataTypeToStatisticsEntry.get(setup_data.FirstLineItem.Id).get(key_for_nested_map).containsKey(PsoToolController.PLANNED_STATISTIC_TYPE));
            System.assertEquals(setup_data.PlannedNumbers.Id, new_instance.OppLineItemIdToDateRangeToDataTypeToStatisticsEntry.get(setup_data.FirstLineItem.Id).get(key_for_nested_map).get(PsoToolController.PLANNED_STATISTIC_TYPE).Id);
            System.assert(new_instance.OppLineItemIdToDateRangeToDataTypeToStatisticsEntry.get(setup_data.FirstLineItem.Id).get(key_for_nested_map).containsKey(PsoToolController.ACTUAL_STATISTIC_TYPE));
            System.assertEquals(setup_data.ActualNumbers.Id, new_instance.OppLineItemIdToDateRangeToDataTypeToStatisticsEntry.get(setup_data.FirstLineItem.Id).get(key_for_nested_map).get(PsoToolController.ACTUAL_STATISTIC_TYPE).Id);
        }
    }

    @isTest static void testGetCustomersReturnsListOfCustomers() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            new_instance.startDate = Date.newInstance(2015, 1, 1);
            new_instance.endDate = Date.newInstance(2015, 3, 31);
            setup_data.createTestData();
            new_instance.queryData();
            new_instance.ContactIdsToContacts = new Map<String, Contact>();
            Test.startTest();
                List<PsoToolController.Customer> customers = new_instance.getCustomers(true);
            Test.stopTest();
            System.assertEquals(2, customers.size());
            System.assertNotEquals(null, customers.get(0).AccountName);
            System.assertNotEquals(null, customers.get(0).AccountId);
            System.assertEquals(1, customers.get(0).Projects.size());
        }
    }

    @isTest static void testGetCustomerReturnsCustomer() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            new_instance.startDate = Date.newInstance(2015, 1, 1);
            new_instance.endDate = Date.newInstance(2015, 3, 31);
            setup_data.createTestData();
            new_instance.queryData();
            new_instance.ContactIdsToContacts = new Map<String, Contact>();
            Opportunity opp = [SELECT Name, Account.Name, Account.Id FROM Opportunity WHERE id =: setup_data.FirstOpportunity.Id];
            Test.startTest();
                PsoToolController.Customer customer = new_instance.getCustomer(opp);
            Test.stopTest();
            System.assertEquals(setup_data.FirstAccount.Name, customer.AccountName);
            System.assertEquals(setup_data.FirstAccount.Id, customer.AccountId);
        }
    }

    @isTest static void testGetProjectReturnsProject() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            new_instance.startDate = Date.newInstance(2015, 1, 1);
            new_instance.endDate = Date.newInstance(2015, 3, 31);
            setup_data.createTestData();
            new_instance.queryData();
            new_instance.ContactIdsToContacts = new Map<String, Contact>();
            Opportunity opp = [SELECT Id, Name, Account.Name, Account.Id, Projektleiter_YOUR_SL__r.Name, Projektstatus__c,
                                    (SELECT Contact__r.Name, Contact__r.Id, Quantity, Product2.Name, ServiceDate, UnitPrice, LastModifiedDate
                                        FROM OpportunityLineItems) 
                                        FROM Opportunity 
                                        WHERE Id =: setup_data.FirstOpportunity.Id];
            Test.startTest();
                PsoToolController.Project project = new_instance.getProject(opp, true);
            Test.stopTest();
            System.assertEquals(setup_data.FirstOpportunity.Name, project.OpportunityName);
            System.assertEquals(setup_data.TestContact.FirstName + ' ' + setup_data.TestContact.LastName, project.OurProjectManager);
            System.assertEquals(setup_data.TestContact.Id, project.ProjectManagerId);
            System.assertEquals(setup_data.FirstOpportunity.Id, project.OpportunityId);
            System.assertEquals(setup_data.FirstOpportunity.Projektstatus__c, project.ProjectStatus);
            System.assertEquals(1, project.Resources.size());
        }
    }

    @isTest static void testGetResourcesReturnsListOfResources() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            new_instance.startDate = Date.newInstance(2015, 1, 1);
            new_instance.endDate = Date.newInstance(2015, 3, 31);
            setup_data.createTestData();
            new_instance.queryData();
            new_instance.ContactIdsToContacts = new Map<String, Contact>();
            Opportunity opp = [SELECT Id, Name, Account.Name, Account.Id, Projektleiter_YOUR_SL__r.Name,
                                    (SELECT Contact__r.Name, Contact__r.Id, Quantity, Product2.Name, ServiceDate, UnitPrice, LastModifiedDate
                                        FROM OpportunityLineItems)
                                        FROM Opportunity 
                                        WHERE Id =: setup_data.SecondOpportunity.Id];
            Test.startTest();
                List<PsoToolController.Resource> resources = new_instance.getResources(opp);
            Test.stopTest();
            System.assertEquals(1, resources.size());
            System.assertEquals(setup_data.TestContact.FirstName + ' ' + setup_data.TestContact.LastName, resources.get(0).ResourceName);
            System.assertEquals(setup_data.TestContact.Id, resources.get(0).ContactId);
            System.assertEquals(setup_data.TestProduct.Name, resources.get(0).Product);
            System.assertEquals(1200, resources.get(0).SalesPrice);
            System.assertEquals(setup_data.SecondLineItem.Quantity*8 + setup_data.ThirdLineItem.Quantity*8, resources.get(0).SoldDays);
            System.assertNotEquals(null, resources.get(0).LastModifiedDate);
            System.assertEquals(2, resources.get(0).Staffing.size());
            System.assertEquals(2, resources.get(0).MonthToLimitMap.size());
            System.assertEquals(2, resources.get(0).MonthToOppLineItemIdMap.size());
        }
    }

    @isTest static void testGetResourceSetsAllProperties() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            new_instance.startDate = Date.newInstance(2015, 1, 1);
            new_instance.endDate = Date.newInstance(2015, 3, 31);
            setup_data.createTestData();
            new_instance.queryData();
            new_instance.ContactIdsToContacts = new Map<String, Contact>();
            Opportunity opp = [SELECT Id, Name, Account.Name, Account.Id, Projektleiter_YOUR_SL__r.Name,
                                    (SELECT Contact__r.Name, Contact__r.Id, Quantity, Product2.Name, ServiceDate, UnitPrice, LastModifiedDate
                                        FROM OpportunityLineItems)
                                        FROM Opportunity 
                                        WHERE Id =: setup_data.FirstOpportunity.Id];
            Test.startTest();
                PsoToolController.Resource resource = new_instance.getResource(opp.Id, opp.OpportunityLineItems.get(0));
            Test.stopTest();
            System.assertEquals(setup_data.TestContact.FirstName + ' ' + setup_data.TestContact.LastName, resource.ResourceName);
            System.assertEquals(setup_data.TestContact.Id, resource.ContactId);
            System.assertEquals(setup_data.TestProduct.Name, resource.Product);
            System.assertEquals(setup_data.FirstLineItem.UnitPrice, resource.SalesPrice);
            System.assertEquals(setup_data.FirstLineItem.Quantity*PsoToolController.WORKING_HOURS_IN_DAY, resource.SoldDays);
            System.assertEquals(opp.OpportunityLineItems.get(0).LastModifiedDate.format('yyyy-MM-dd HH:mm:ss'), resource.LastModifiedDate);
            System.assertEquals(1, resource.MonthToLimitMap.size());
            System.assertEquals(1, resource.MonthToOppLineItemIdMap.size());
            System.assertNotEquals(null, resource.Statistics.size());
        }
    }

    @isTest static void testCheckIfMonthIsWithinRangeAndPutInMapPopulatesRightProperties(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            new_instance.startDate = Date.newInstance(2015, 1, 1);
            new_instance.endDate = Date.newInstance(2015, 3, 31);
            setup_data.createTestData();
            PsoToolController.Resource new_resource = new PsoToolController.Resource();
            new_resource.MonthToLimitMap = new Map<String, String>();
            new_resource.MonthToOppLineItemIdMap = new Map<String, String>();
            Test.startTest();
                new_instance.checkIfMonthIsWithinRangeAndPutInMap(new_resource, setup_data.FirstLineItem);
            Test.stopTest();
            System.assertEquals(1, new_resource.MonthToLimitMap.size());
            String number_of_month = String.valueOf(setup_data.FirstLineItem.ServiceDate.month());
            System.assert(new_resource.MonthToLimitMap.containsKey(number_of_month));
            System.assertEquals(setup_data.FirstLineItem.Quantity, Decimal.valueOf(new_resource.MonthToLimitMap.get(number_of_month)));
            System.assertEquals(1, new_resource.MonthToOppLineItemIdMap.size());
            System.assert(new_resource.MonthToOppLineItemIdMap.containsKey(number_of_month));
            System.assertEquals(setup_data.FirstLineItem.Id, new_resource.MonthToOppLineItemIdMap.get(number_of_month));
        }
    }

    @isTest static void tesGetStaffingForResourceForOpportunityReturnsStaffingList(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            new_instance.startDate = Date.newInstance(2015, 1, 1);
            new_instance.endDate = Date.newInstance(2015, 3, 31);
            setup_data.createTestData();
            new_instance.queryData();
            OpportunityLineItem opp_line_item = [SELECT Contact__r.Name, Contact__r.Id, Quantity, Product2.Name, ServiceDate, UnitPrice, LastModifiedDate
                                        FROM OpportunityLineItem
                                        WHERE Id =: setup_data.SecondLineItem.Id];
            Test.startTest();
                List<PsoToolController.Staffing> staffings = new_instance.getStaffingForResourceForOpportunity(setup_data.SecondOpportunity.Id, opp_line_item);
            Test.stopTest();
            System.assertEquals(3, staffings.size());
        }
    }

    @isTest static void testGetStaffingForScheduleEntryReturnsProperStaffingObject(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            setup_data.createTestData();
            Test.startTest();
                PsoToolController.Staffing staffing = new_instance.getStaffingForScheduleEntry(setup_data.Schedule);
            Test.stopTest();
            System.assertEquals(setup_data.Schedule.ScheduleDate, Date.parse(staffing.Day));
            System.assertEquals(setup_data.Schedule.Quantity*8, staffing.Staff);
            System.assertEquals(false, staffing.SpecialOccasion);
        }
    }

    @isTest static void testCountPlannedDaysAndFilterStaffingByDatesCountsPlannedDaysAndFiltersStaffing(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            new_instance.startDate = Date.newInstance(2015, 1, 1);
            new_instance.endDate = Date.newInstance(2015, 3, 31);
            Map<String, PsoToolController.Resource> resources = new Map<String, PsoToolController.Resource>();
            PsoToolController.Resource new_resource = new PsoToolController.Resource();
            new_resource.Staffing = new List<PsoToolController.Staffing>();
            PsoToolController.Staffing staffing_within_range = new PsoToolController.Staffing ();
            staffing_within_range.Day = Date.newInstance(2015, 1, 15).format();
            staffing_within_range.Staff = 0.5;
            PsoToolController.Staffing another_staffing_within_range = new PsoToolController.Staffing ();
            another_staffing_within_range.Day =  Date.newInstance(2015, 3, 23).format();
            another_staffing_within_range.Staff = 1;
            PsoToolController.Staffing staffing_not_within_range = new PsoToolController.Staffing();
            staffing_not_within_range.Day = Date.newInstance(2015, 4, 3).format();
            staffing_not_within_range.Staff = 2;
            new_resource.Staffing.add(staffing_within_range);
            new_resource.Staffing.add(another_staffing_within_range);
            new_resource.Staffing.add(staffing_not_within_range);
            resources.put('1', new_resource);
            Test.startTest();
                new_instance.countPlannedDaysAndFilterStaffingByDates(resources);
            Test.stopTest();
            System.assertEquals(2, resources.get('1').Staffing.size());
            System.assertEquals(3.5, Decimal.valueOf(resources.get('1').PlannedDays));
        }
    }

    @isTest static void testGetResourcesAvailabilityDataReturnsCorrectData(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            new_instance.startDate = Date.newInstance(2015, 1, 1);
            new_instance.endDate = Date.newInstance(2015, 3, 31);
            setup_data.createTestData();
            new_instance.queryData();
            new_instance.contactIdsToContacts = new Map<String, Contact>();
            Opportunity opp = [SELECT Id, Name, Account.Name, Account.Id, Projektleiter_YOUR_SL__r.Name,
                        (SELECT Contact__r.Name, Contact__r.Id, Contact__r.Account.Name, Contact__r.Title, Contact__r.LastName, Quantity, Product2.Name, ServiceDate, UnitPrice, LastModifiedDate
                            FROM OpportunityLineItems)
                            FROM Opportunity 
                            WHERE Id =: setup_data.SecondOpportunity.Id];
            new_instance.getResources(opp);
            Test.startTest();
                List<PsoToolController.ResourceInfo> staffing = new_instance.getResourcesAvailabilityData();
            Test.stopTest();
            System.assertEquals(1, staffing.size());
            System.assertEquals(setup_data.TestContact.FirstName + ' ' + setup_data.TestContact.LastName, staffing.get(0).ResourceName);
            System.assertEquals(2, staffing.get(0).Staffing.size());
            System.assertEquals(setup_data.TestContact.Id, staffing.get(0).ContactId);
        }
    }

    @isTest static void testGetStaffingForResourceCreatesCorrectStaffing(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            new_instance.startDate = Date.newInstance(2015, 1, 1);
            new_instance.endDate = Date.newInstance(2015, 3, 31);
            setup_data.createTestData();
            OpportunityLineItem opp_line_item = [SELECT Contact__r.Name, Contact__r.Id, Quantity, Product2.Name, ServiceDate, UnitPrice, LastModifiedDate, Opportunity.Name,
                            (SELECT OpportunityLineItemId, ScheduleDate, Quantity 
                                        FROM OpportunityLineItemSchedules
                                        WHERE Description != :OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT)
                            FROM OpportunityLineItem
                            WHERE Id =: setup_data.SecondLineItem.Id];
            Map<String, OpportunityLineItem> map_with_opp_line_item = new Map<String, OpportunityLineItem>();
            map_with_opp_line_item.put('key', opp_line_item);
            List<Map<String, OpportunityLineItem>> argument_to_pass = new List<Map<String, OpportunityLineItem>>();
            argument_to_pass.add(map_with_opp_line_item);
            Test.startTest();
                List<PsoToolController.Staffing> staffing = new_instance.getStaffingForResource(argument_to_pass);
            Test.stopTest();
            System.assertEquals(2, staffing.size());
        }
    }

    @isTest static void testGetStaffingForResourceCreatesCorrectStaffingForHolidayOpportunities(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            new_instance.startDate = Date.newInstance(2015, 1, 1);
            new_instance.endDate = Date.newInstance(2015, 3, 31);
            setup_data.createHolidayOpportunityAndTestDataForIt();
            OpportunityLineItem opp_line_item = [SELECT Contact__r.Name, Contact__r.Id, Quantity, Product2.Name, ServiceDate, UnitPrice, LastModifiedDate, Opportunity.Name
                            FROM OpportunityLineItem
                            WHERE Id =: setup_data.HolidayLineItem.Id];
            Map<String, OpportunityLineItem> map_with_opp_line_item = new Map<String, OpportunityLineItem>();
            map_with_opp_line_item.put('key', opp_line_item);
            List<Map<String, OpportunityLineItem>> argument_to_pass = new List<Map<String, OpportunityLineItem>>();
            argument_to_pass.add(map_with_opp_line_item);
            Test.startTest();
                List<PsoToolController.Staffing> staffing = new_instance.getStaffingForResource(argument_to_pass);
            Test.stopTest();
            System.assertEquals(1, staffing.size());
        }
    }

    @isTest static void testCheckIfSpecialOccasionReturnsTrueForHolidayOpportunity(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            Test.startTest();
                Boolean is_holiday_opportunity = new_instance.checkIfSpecialOccasion(PsoToolController.SPECIAL_OPPORTUNITY);
            Test.stopTest();
            System.assertEquals(true, is_holiday_opportunity);
        }
    }

    @isTest static void testAddStaffingAddsQuantityForTheSameDays(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            PsoToolController.Staffing first_staffing = new PsoToolController.Staffing ();
            first_staffing.Day = Date.newInstance(2015, 1, 15).format();
            first_staffing.Staff = 0.5;
            first_staffing.SpecialOccasion = false;
            PsoToolController.Staffing another_staffing_in_the_same_day = new PsoToolController.Staffing ();
            another_staffing_in_the_same_day.Day =  Date.newInstance(2015, 1, 15).format();
            another_staffing_in_the_same_day.Staff = 0.4;
            another_staffing_in_the_same_day.SpecialOccasion = true;
            Map<String, PsoToolController.Staffing> existing_staffing = new Map<String, PsoToolController.Staffing>();
            existing_staffing.put(first_staffing.Day, first_staffing);
            Test.startTest();
                Map<String, PsoToolController.Staffing> result_staffing = new_instance.addStaffing(existing_staffing, another_staffing_in_the_same_day);
            Test.stopTest();
            System.assertEquals(1, result_staffing.values().size());
            System.assertEquals(0.9, result_staffing.values().get(0).Staff);
            System.assertEquals(true, result_staffing.values().get(0).SpecialOccasion);
        }
    }

    @isTest static void testAddStaffingAddsAnotherStaffingForDifferentDays(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            PsoToolController.Staffing first_staffing = new PsoToolController.Staffing ();
            first_staffing.Day = Date.newInstance(2015, 1, 15).format();
            first_staffing.Staff = 0.5;
            first_staffing.SpecialOccasion = false;
            PsoToolController.Staffing another_staffing = new PsoToolController.Staffing();
            another_staffing.Day =  Date.newInstance(2015, 3, 23).format();
            another_staffing.Staff = 0.4;
            another_staffing.SpecialOccasion = false;
            Map<String, PsoToolController.Staffing> existing_staffing = new Map<String, PsoToolController.Staffing>();
            existing_staffing.put(first_staffing.Day, first_staffing);
            Test.startTest();
                Map<String, PsoToolController.Staffing> result_staffing = new_instance.addStaffing(existing_staffing, another_staffing);
            Test.stopTest();
            System.assertEquals(2, result_staffing.values().size());
        }
    }

    @isTest static void testGetStaffingForSpecialOccasionEntry(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            new_instance.startDate = Date.newInstance(2015, 1, 1);
            new_instance.endDate = Date.newInstance(2015, 3, 31);
            setup_data.createHolidayOpportunityAndTestDataForIt();
            Test.startTest();
                PsoToolController.Staffing single_staffing = new_instance.getStaffingForSpecialOccasionEntry(setup_data.HolidayLineItem);
            Test.stopTest();
            System.assertEquals(setup_data.HolidayLineItem.ServiceDate, Date.parse(single_staffing.Day));
            System.assertEquals(setup_data.HolidayLineItem.Quantity*PsoToolController.WORKING_HOURS_IN_DAY, single_staffing.Staff);
            System.assertEquals(true, single_staffing.SpecialOccasion);
        }
    }

    @isTest static void testAllocateResourceInsertsNewRecordForNewDate(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            setup_data.createTestData();
            Date selected_date = Date.newInstance(2015, 3, 31);
            Decimal selected_quantity = 1;
            Test.startTest();
                new_instance.allocateResource(setup_data.FirstLineItem.Id, selected_date, selected_quantity);
            Test.stopTest();
            List<OpportunityLineItemSchedule> Schedules = [SELECT OpportunityLineItemId, ScheduleDate, Quantity 
                                        FROM OpportunityLineItemSchedule
                                        WHERE Description != :OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT 
                                        AND OpportunityLineItemId = :setup_data.FirstLineItem.Id ORDER BY ScheduleDate DESC];
            System.assertEquals(2, Schedules.size());
            System.assertEquals(selected_date, Schedules.get(0).ScheduleDate);
            System.assertEquals(selected_quantity, Schedules.get(0).Quantity);
        }
    }

    @isTest static void testAllocateResourceUpdatesExistingRecord(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            setup_data.createTestData();
            Date selected_date = Date.newInstance(2015, 1, 10);
            Decimal selected_quantity = 0.5;
            Test.startTest();
                new_instance.allocateResource(setup_data.FirstLineItem.Id, selected_date, selected_quantity);
            Test.stopTest();
            List<OpportunityLineItemSchedule> Schedules = [SELECT OpportunityLineItemId, ScheduleDate, Quantity 
                                        FROM OpportunityLineItemSchedule
                                        WHERE Description != :OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT 
                                        AND OpportunityLineItemId = :setup_data.FirstLineItem.Id ORDER BY ScheduleDate DESC];
            System.assertEquals(1, Schedules.size());
            System.assertEquals(selected_date, Schedules.get(0).ScheduleDate);
            System.assertEquals(selected_quantity, Schedules.get(0).Quantity);
        }
    }

    @isTest static void testAllocateResourceThrowsExceptionForUnexistingOpportunityLineItemId(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            setup_data.createTestData();
            Date selected_date = Date.newInstance(2015, 1, 10);
            Decimal selected_quantity = 0.5;
            Boolean exception_is_caught = false;
            Test.startTest();
                try{
                    new_instance.allocateResource(setup_data.FirstAccount.Id, selected_date, selected_quantity);
                } catch(PsoToolController.OpportunityLineItemNotFoundException e){
                    exception_is_caught = true;
                }
            Test.stopTest();
            System.assertEquals(true, exception_is_caught);
        }
    }

    @isTest static void testCreateNewOpportunityLineItemScheduleCreatesRegularSchedule(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            setup_data.createTestData();
            Date selected_date = Date.newInstance(2015, 2, 2);
            Test.startTest();
                OpportunityLineItemSchedule Schedule = new_instance.createNewOpportunityLineItemSchedule(setup_data.FirstLineItem.Id, selected_date);
            Test.stopTest();
            System.assertEquals(selected_date, Schedule.ScheduleDate);
            System.assertEquals(setup_data.FirstLineItem.Id, Schedule.OpportunityLineItemId);
            System.assertEquals('Quantity', Schedule.Type);
        }
    }

    @isTest static void testGetStatsCreatesStats(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            new_instance.startDate = Date.newInstance(2015, 1, 1);
            new_instance.endDate = Date.newInstance(2015, 3, 31);
            setup_data.createTestData();
            setup_data.createPlannedStatisticalData();
            setup_data.createActualStatisticalData();
            new_instance.queryData();
            Test.startTest();
                List<PsoToolController.Stats> stats = new_instance.getStats(setup_data.FirstLineItem.Id);
            Test.stopTest();
            System.assertEquals(1, stats.size());
            System.assertEquals(setup_data.ActualNumbers.Days__c + '/' +setup_data.PlannedNumbers.Days__c, stats.get(0).Days);
            System.assertEquals(setup_data.ActualNumbers.Revenue__c + '/' + setup_data.PlannedNumbers.Revenue__c, stats.get(0).Revenue);
            System.assertEquals(setup_data.PlannedNumbers.Start_Date__c, Date.parse(stats.get(0).StartDate));
            System.assertEquals(setup_data.PlannedNumbers.End_Date__c, Date.parse(stats.get(0).EndDate));
        }
    }

    @isTest static void testGetStatsCreatesStatsWhenThereIsNoPlannedNumbers(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            new_instance.startDate = Date.newInstance(2015, 1, 1);
            new_instance.endDate = Date.newInstance(2015, 3, 31);
            setup_data.createTestData();
            setup_data.createActualStatisticalData();
            new_instance.queryData();
            Test.startTest();
                List<PsoToolController.Stats> stats = new_instance.getStats(setup_data.FirstLineItem.Id);
            Test.stopTest();
            System.assertEquals(1, stats.size());
            System.assertEquals(setup_data.ActualNumbers.Days__c + '/0', stats.get(0).Days);
            System.assertEquals(setup_data.ActualNumbers.Revenue__c + '/0', stats.get(0).Revenue);
            System.assertEquals(setup_data.ActualNumbers.Start_Date__c, Date.parse(stats.get(0).StartDate));
            System.assertEquals(setup_data.ActualNumbers.End_Date__c, Date.parse(stats.get(0).EndDate));
        }
    }

    @isTest static void testGetStatsCreatesStatsWhenThereIsNoActualNumbers(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            new_instance.startDate = Date.newInstance(2015, 1, 1);
            new_instance.endDate = Date.newInstance(2015, 3, 31);
            setup_data.createTestData();
            setup_data.createPlannedStatisticalData();
            new_instance.queryData();
            Test.startTest();
                List<PsoToolController.Stats> stats = new_instance.getStats(setup_data.FirstLineItem.Id);
            Test.stopTest();
            System.assertEquals(1, stats.size());
            System.assertEquals('0/' + setup_data.PlannedNumbers.Days__c, stats.get(0).Days);
            System.assertEquals('0/' + setup_data.PlannedNumbers.Revenue__c, stats.get(0).Revenue);
            System.assertEquals(setup_data.PlannedNumbers.Start_Date__c, Date.parse(stats.get(0).StartDate));
            System.assertEquals(setup_data.PlannedNumbers.End_Date__c, Date.parse(stats.get(0).EndDate));
        }
    }

    @isTest static void testGetDefaultNewStatSetsExpectedValues(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            new_instance.startDate = Date.newInstance(2015, 1, 1);
            new_instance.endDate = Date.newInstance(2015, 3, 31);
            setup_data.createTestData();
            setup_data.createPlannedStatisticalData();
            Test.startTest();
                PsoToolController.Stats stat = new_instance.getDefaultNewStat(setup_data.PlannedNumbers);
            Test.stopTest();
            System.assertEquals(setup_data.PlannedNumbers.Start_Date__c, Date.parse(stat.StartDate));
            System.assertEquals(setup_data.PlannedNumbers.End_Date__c, Date.parse(stat.EndDate));
            System.assertEquals('0/0', stat.Days);
            System.assertEquals('0/0', stat.Revenue);
        }
    }

    @isTest static void testGetDataSetInJsonReturnsJson() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Test.startTest();
                String json = PsoToolController.getInstance().getDataSet().JSON();
            Test.stopTest();
            System.assertNotEquals(null, json);
        }
    }

    @isTest static void testQueryDataDoesntSeeOpportunitiesAndOpportunitiesWhenCheckboxIsNotSet(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            new_instance.startDate = Date.newInstance(2015, 1, 1);
            new_instance.endDate = Date.newInstance(2015, 3, 31);
            setup_data.createTestData();
            setup_data.FirstOpportunity.Managed_by_PSO_Tool__c = false;
            update setup_data.FirstOpportunity;
            Test.startTest();
                new_instance.queryData();
            Test.stopTest();
            System.assertEquals(1, new_instance.opportunities.size(), 'This property should have 1 test opportunity');
            System.assertNotEquals(setup_data.FirstOpportunity.Id, new_instance.opportunities.get(0).Id);
            System.assert(new_instance.contactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.containsKey(setup_data.TestContact.Id));
            Map<String, Map<String, OpportunityLineItem>> opportunitiesToOppLineItemIdToOppLineItems = new_instance.contactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.get(setup_data.TestContact.Id);
            System.assertEquals(2, opportunitiesToOppLineItemIdToOppLineItems.values().size());
            System.assert(opportunitiesToOppLineItemIdToOppLineItems.containsKey(setup_data.FirstOpportunity.Id));
        }
    }

    @isTest static void testSetStartDateSetsTheRightValue() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Date start_date = Date.newInstance(2015, 6, 2);
            Test.startTest();
                PsoToolController new_instance = PsoToolController.getInstance().setStartDate(start_date);
            Test.stopTest();
            System.assertEquals(Date.newInstance(2015, 6, 1), new_instance.StartDate);
            System.assertEquals(Date.newInstance(2015, 7, 31), new_instance.EndDate);
        }
    }

    @isTest static void testSetSelectedOpportunitiesSetsTheRightValue() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Date start_date = Date.newInstance(2015, 6, 2);
            setup_data.createTestData();
            List<Id> opportunities_to_add = new List<Id>();
            opportunities_to_add.add(setup_data.FirstOpportunity.Id);
            Test.startTest();
                PsoToolController new_instance = PsoToolController.getInstance().setSelectedOpportunities(opportunities_to_add);
            Test.stopTest();
            System.assertEquals(1, new_instance.OpportunitiesToShow.size());
            System.assertEquals(setup_data.FirstOpportunity.Id, new_instance.OpportunitiesToShow.get(0));
        }
    }

    @isTest static void testGetOpportunitiesReturnesTheExpectedResultWhenWeHaveSelectedOpportunities() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Date start_date = Date.newInstance(2015, 6, 2);
            setup_data.createTestData();
            List<Id> opportunities_to_add = new List<Id>();
            opportunities_to_add.add(setup_data.FirstOpportunity.Id);
            PsoToolController.getInstance().setSelectedOpportunities(opportunities_to_add);
            Test.startTest();
                List<Id> opportunities_to_show = PsoToolController.getInstance().getOpportunitiesToShow();
            Test.stopTest();
            System.assertEquals(1, opportunities_to_show.size());
            System.assertEquals(setup_data.FirstOpportunity.Id, opportunities_to_show.get(0));
        }
    }

    @isTest static void testGetOpportunitiesReturnesTheExpectedResultWhenWeDontHaveSelectedOpportunities() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Date start_date = Date.newInstance(2015, 6, 2);
            setup_data.createTestData();
            Test.startTest();
                List<Id> opportunities_to_show = PsoToolController.getInstance().getOpportunitiesToShow();
            Test.stopTest();
            System.assertEquals(2, opportunities_to_show.size());
        }
    }

    @isTest static void testGetAccountsAndOpportunitiesReturnsTheListWith2AccountsEachOfWhichHasAProject() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            new_instance.startDate = Date.newInstance(2015, 1, 1);
            new_instance.endDate = Date.newInstance(2015, 3, 31);
            setup_data.createTestData();
            Test.startTest();
                Object data_set = PsoToolController.getInstance().getAccountsAndOpportunities();
            Test.stopTest();
            System.assert(data_set instanceof PsoToolController.AccountsAndTheirOpportunities, 'Method should return an instance of AccountsAndTheirOpportunities class');
            PsoToolController.AccountsAndTheirOpportunities data_set_object = (PsoToolController.AccountsAndTheirOpportunities)data_set;
            System.assertEquals(2, data_set_object.Customers.size());
            System.assertEquals(1, data_set_object.Customers.get(0).Projects.size());
            System.assertEquals(1, data_set_object.Customers.get(1).Projects.size());
            System.assertEquals(true, data_set_object.IsAllowedToRunScript);
        }
    }

    @isTest static void testGetDataSetInJsonReturnsSortedJson() {
        SetupDataClass setup_data = new SetupDataClass();
        PsoToolController.ResourceInfo resource1 = new PsoToolController.ResourceInfo();
        resource1.AccountName = PsoToolController.COMPANY_NAME;
        resource1.Title = 'Developer';
        resource1.LastName = 'Batman';
        PsoToolController.ResourceInfo resource2 = new PsoToolController.ResourceInfo();
        resource2.AccountName = PsoToolController.COMPANY_NAME;
        resource2.Title = 'Consultant';
        resource2.LastName = 'Batman';
        PsoToolController.ResourceInfo resource3 = new PsoToolController.ResourceInfo();
        resource3.AccountName = 'Some zalando company';
        resource3.Title = 'Developer';
        resource3.LastName = 'Batman';
        PsoToolController.ResourceInfo resource4 = new PsoToolController.ResourceInfo();
        resource4.AccountName = PsoToolController.COMPANY_NAME;
        resource4.Title = 'Consultant';
        resource4.LastName = 'Superman';
        PsoToolController.ResourceInfo resource5 = new PsoToolController.ResourceInfo();
        resource5.AccountName = 'Some company';
        resource5.Title = 'Developer';
        resource5.LastName = 'Batman';
        PsoToolController new_instance = PsoToolController.getInstance();
        new_instance.startDate = Date.newInstance(2015, 1, 1);
        new_instance.endDate = Date.newInstance(2015, 2, 28);
        PsoToolController.PsoToolDataSetWrapper wrapper = new_instance.getDataSet();
        wrapper.Resources = new List<PsoToolController.ResourceInfo>();
        wrapper.Resources.add(resource1);
        wrapper.Resources.add(resource2);
        wrapper.Resources.add(resource3);
        wrapper.Resources.add(resource4);
        wrapper.Resources.add(resource5);
        System.runAs(setup_data.TestUser) {
            Test.startTest();
                String json = wrapper.JSON();
            Test.stopTest();
            String expected_json = '{'+
                '"StartDate":"01.01.2015",' +
                '"EndDate":"28.02.2015",' +
                '"Customers":[],' +
                '"Resources":[' +
                '{"Title":"Consultant","Staffing":null,"ResourceName":null,"LastName":"Batman","ContactId":null,"AccountName":"YOUR SL GmbH"},' +
                '{"Title":"Consultant","Staffing":null,"ResourceName":null,"LastName":"Superman","ContactId":null,"AccountName":"YOUR SL GmbH"},' +
                '{"Title":"Developer","Staffing":null,"ResourceName":null,"LastName":"Batman","ContactId":null,"AccountName":"YOUR SL GmbH"},' +
                '{"Title":"Developer","Staffing":null,"ResourceName":null,"LastName":"Batman","ContactId":null,"AccountName":"Some company"},' +
                '{"Title":"Developer","Staffing":null,"ResourceName":null,"LastName":"Batman","ContactId":null,"AccountName":"Some zalando company"}]}';
            System.assertEquals(expected_json, json);
        }
    }

    @isTest static void testGetProjectHealthReasonsReturnsSomething() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Test.startTest();
                Object data_set = PsoToolController.getInstance().getProjectHealthReasons();
            Test.stopTest();
            System.assert(data_set instanceof PsoToolController.ProjectHealthReasons, 'Method should return an instance of ProjectHealthReasons class');
            PsoToolController.ProjectHealthReasons data_set_object = (PsoToolController.ProjectHealthReasons)data_set;
            System.assert(!data_set_object.ReasonsLabelToValue.isEmpty());
        }
    }

    @isTest static void testGetProjectHealthReasonsReturnsSomethingInJson() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Test.startTest();
                String json = PsoToolController.getInstance().getProjectHealthReasons().JSON();
            Test.stopTest();
            System.assertNotEquals(null, json);
        }
    }

    @isTest static void testSetProjectHealthReasonUpdatesProjectStatus() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData();
            String new_status = 'Not fishy';
            Test.startTest();
                PsoToolController.getInstance().setProjectHealthReason(setup_data.FirstOpportunity.Id, new_status);
            Test.stopTest();
            Opportunity opp = [SELECT Projektstatus__c FROM Opportunity WHERE Id =: setup_data.FirstOpportunity.Id];
            System.assertEquals(new_status, opp.Projektstatus__c);
        }
    }

    @isTest static void testSetProjectHealthReasonThrowsExceptionWhenOppIdDoesntExist() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Boolean exception_is_caught = false;
            Test.startTest();
                try{
                    PsoToolController.getInstance().setProjectHealthReason('strange_id', 'new_status');
                } catch(PsoToolController.OpportunityNotFoundException e){
                    exception_is_caught = true;
                }
            Test.stopTest();
            System.assert(exception_is_caught);
        }
    }

    @isTest static void testGetStatsDoesntCreateStatsWhenItsOutOfDateRange(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            new_instance.StartDate = Date.newInstance(2015, 2, 1);
            new_instance.EndDate = Date.newInstance(2015, 3, 31);
            setup_data.createTestData();
            setup_data.createPlannedStatisticalData();
            setup_data.createActualStatisticalData();
            new_instance.queryData();
            Test.startTest();
                List<PsoToolController.Stats> stats = new_instance.getStats(setup_data.FirstLineItem.Id);
            Test.stopTest();
            System.assertEquals(0, stats.size());
        }
    }

    private class SetupDataClass {
        public Account FirstAccount;
        public Account SecondAccount;
        public Contact TestContact;
        public Opportunity FirstOpportunity;
        public Opportunity SecondOpportunity;
        public Opportunity HolidayOpportunity;
        public OpportunityLineItem FirstLineItem;
        public OpportunityLineItem SecondLineItem;
        public OpportunityLineItem ThirdLineItem;
        public OpportunityLineItem HolidayLineItem;
        public PricebookEntry TestPricebookEntry;
        public Product2 TestProduct;
        public User TestUser;
        public User AnotherUser;
        public OpportunityLineItemSchedule Schedule;
        public Planning_statistics__c PlannedNumbers;
        public Planning_statistics__c ActualNumbers;
        private String DesiredProfile = 'System Administrator';

        public SetupDataClass() {
            this.TestUser = UserUtility.createNewUser(DesiredProfile);
            insert TestUser;
        }

        public SetupDataClass(String desired_profile){
            this.DesiredProfile = desired_profile;
            this.TestUser = UserUtility.createNewUser(DesiredProfile);
            insert TestUser;
        }

        public void createAnotherUser(){
            this.AnotherUser = UserUtility.createNewUser(DesiredProfile);
            insert AnotherUser;
        }

        public void createTestData() {
            createAndInsertAccounts();
            createAndInsertContactForUser();
            createAndInsertOpportunities();
            createAndInsertProduct();
            createAndInsertPriceBookEntry();
            makeTheTestUserToBeOpportunityMember();
            createOpportunityLineItems();
            createOpportunityLineItemsSchedule();
        }

        public void createTestDataForAdmins() {
            createAndInsertAccounts();
            createAndInsertContactForUser();
            createAndInsertOpportunities();
            createAndInsertProduct();
            createAndInsertPriceBookEntry();
            createOpportunityLineItems();
            createOpportunityLineItemsSchedule();
        }

        private void createAndInsertAccounts(){
            this.FirstAccount = new Account();
            this.FirstAccount.Name = 'First company';
            this.SecondAccount = new Account();
            this.SecondAccount.Name = 'Second company';
            insert new List<Sobject> {this.FirstAccount, this.SecondAccount};
        }

        private void createAndInsertContactForUser() {
            this.TestContact = new Contact();
            this.TestContact.FirstName = testUser.FirstName;
            this.TestContact.LastName = testUser.LastName;
            insert this.TestContact;
        }
        
        private void createAndInsertProduct() {
            this.TestProduct = new Product2();
            this.TestProduct.Name = 'Salesforce Developer';
            this.TestProduct.isActive = true;
            this.TestProduct.CanUseQuantitySchedule = true;
            insert this.TestProduct;
        }

        private void createAndInsertPriceBookEntry(){
            this.TestPricebookEntry = new PricebookEntry();
            this.TestPricebookEntry.Pricebook2Id = Test.getStandardPricebookId();
            this.TestPricebookEntry.Product2Id = this.TestProduct.Id;
            this.TestPricebookEntry.UnitPrice = 99;
            this.TestPricebookEntry.isActive = true;
            insert this.TestPricebookEntry;
        }

        private void createAndInsertOpportunities(){
            this.FirstOpportunity = new Opportunity();
            this.FirstOpportunity.Name = '° Roshen';
            this.FirstOpportunity.StageName = '° Roshen';
            this.FirstOpportunity.PriceBook2Id = Test.getStandardPricebookId();
            this.FirstOpportunity.AccountId = this.FirstAccount.Id;
            this.FirstOpportunity.CloseDate = Date.newInstance(2015, 1, 1);
            this.FirstOpportunity.Projektleiter_YOUR_SL__c = this.TestContact.Id;
            this.FirstOpportunity.Managed_by_PSO_Tool__c = true;
            this.FirstOpportunity.Projektstatus__c = 'Terrible';
            this.SecondOpportunity = new Opportunity();
            this.SecondOpportunity.Name = 'Apple iWatch';
            this.SecondOpportunity.StageName = 'iWatch';
            this.SecondOpportunity.PriceBook2Id = Test.getStandardPricebookId();
            this.SecondOpportunity.AccountId = this.SecondAccount.Id;
            this.SecondOpportunity.CloseDate = Date.newInstance(2015, 1, 1);
            this.SecondOpportunity.Projektleiter_YOUR_SL__c = this.TestContact.Id;
            this.SecondOpportunity.Managed_by_PSO_Tool__c = true;
            this.FirstOpportunity.Projektstatus__c = 'Fishy';
            insert new List<Sobject> {this.FirstOpportunity, this.SecondOpportunity};
        }

        private void makeTheTestUserToBeOpportunityMember(){
            OpportunityTeamMember firstMember = new OpportunityTeamMember();
            firstMember.UserId = this.testUser.Id;
            firstMember.OpportunityId = this.FirstOpportunity.Id;
            OpportunityTeamMember secondMember = new OpportunityTeamMember();
            secondMember.UserId = this.testUser.Id;
            secondMember.OpportunityId = this.SecondOpportunity.Id;
            insert new List<Sobject> {firstMember, secondMember};
        }

        private void createOpportunityLineItems(){
            this.FirstLineItem = new OpportunityLineItem();
            this.FirstLineItem.Contact__c = this.TestContact.Id;
            this.FirstLineItem.PricebookEntryId = this.TestPricebookEntry.Id;
            this.FirstLineItem.ServiceDate = Date.newInstance(2015, 1, 10);
            this.FirstLineItem.UnitPrice = 1200;
            this.FirstLineItem.Quantity = 1;
            this.FirstLineItem.Unit__c = 'Manntag(e)';
            this.FirstLineItem.OpportunityId = this.FirstOpportunity.Id;
            this.SecondLineItem = new OpportunityLineItem();
            this.SecondLineItem.Contact__c = this.TestContact.Id;
            this.SecondLineItem.PricebookEntryId = this.TestPricebookEntry.Id;
            this.SecondLineItem.ServiceDate = Date.newInstance(2015, 1, 10);
            this.SecondLineItem.UnitPrice = 1200;
            this.SecondLineItem.Quantity = 1.5;
            this.SecondLineItem.Unit__c = 'Manntag(e)';
            this.SecondLineItem.OpportunityId = this.SecondOpportunity.Id;
            this.ThirdLineItem = new OpportunityLineItem();
            this.ThirdLineItem.Contact__c = this.TestContact.Id;
            this.ThirdLineItem.PricebookEntryId = this.TestPricebookEntry.Id;
            this.ThirdLineItem.ServiceDate = Date.newInstance(2015, 2, 10);
            this.ThirdLineItem.UnitPrice = 1200;
            this.ThirdLineItem.Quantity = 10;
            this.ThirdLineItem.Unit__c = 'Manntag(e)';
            this.ThirdLineItem.OpportunityId = this.SecondOpportunity.Id;
            insert new List<Sobject> {this.FirstLineItem, this.SecondLineItem, this.ThirdLineItem};
        }

        private void createOpportunityLineItemsSchedule(){
            Schedule = new OpportunityLineItemSchedule();
            Schedule.OpportunityLineItemId = this.FirstLineItem.Id;
            Schedule.ScheduleDate = Date.newInstance(2015, 1, 10);
            Schedule.Quantity = 1;
            Schedule.Type = 'Quantity';
            OpportunityLineItemSchedule secondSchedule = new OpportunityLineItemSchedule();
            secondSchedule.OpportunityLineItemId = this.SecondLineItem.Id;
            secondSchedule.ScheduleDate = Date.newInstance(2015, 1, 10);
            secondSchedule.Quantity = 1;
            secondSchedule.Type = 'Quantity';
            OpportunityLineItemSchedule thirdSchedule = new OpportunityLineItemSchedule();
            thirdSchedule.OpportunityLineItemId = this.SecondLineItem.Id;
            thirdSchedule.ScheduleDate = Date.newInstance(2015, 1, 11);
            thirdSchedule.Quantity = 0.5;
            thirdSchedule.Type = 'Quantity';
            OpportunityLineItemSchedule forthSchedule = new OpportunityLineItemSchedule();
            forthSchedule.OpportunityLineItemId = this.SecondLineItem.Id;
            forthSchedule.ScheduleDate = Date.newInstance(2015, 4, 11);
            forthSchedule.Quantity = 0.4;
            forthSchedule.Type = 'Quantity';
            insert new List<Sobject> {Schedule, secondSchedule, thirdSchedule, forthSchedule};
        }

        public void createHolidayOpportunityAndTestDataForIt(){
            createAndInsertAccounts();
            createAndInsertContactForUser();
            createHolidayOpportunity();
            createAndInsertProduct();
            createAndInsertPriceBookEntry();
            makeTheTestUserToBeTheHolidayOpportunityMember();
            createHolidayOpportunityLineItem();
        }

        private void createHolidayOpportunity(){
            this.HolidayOpportunity = new Opportunity();
            this.HolidayOpportunity.Name = PsoToolController.SPECIAL_OPPORTUNITY;
            this.HolidayOpportunity.StageName = PsoToolController.SPECIAL_OPPORTUNITY;
            this.HolidayOpportunity.PriceBook2Id = Test.getStandardPricebookId();
            this.HolidayOpportunity.AccountId = this.FirstAccount.Id;
            this.HolidayOpportunity.CloseDate = Date.newInstance(2015, 1, 1);
            this.HolidayOpportunity.Projektleiter_YOUR_SL__c = this.TestContact.Id;
            this.HolidayOpportunity.Managed_by_PSO_Tool__c = true;
            insert this.HolidayOpportunity;
        }

        private void makeTheTestUserToBeTheHolidayOpportunityMember(){
            OpportunityTeamMember firstMember = new OpportunityTeamMember();
            firstMember.UserId = this.testUser.Id;
            firstMember.OpportunityId = this.HolidayOpportunity.Id;
            insert firstMember;
        }

        private void createHolidayOpportunityLineItem(){
            this.HolidayLineItem = new OpportunityLineItem();
            this.HolidayLineItem.Contact__c = this.TestContact.Id;
            this.HolidayLineItem.PricebookEntryId = this.TestPricebookEntry.Id;
            this.HolidayLineItem.ServiceDate = Date.newInstance(2015, 1, 10);
            this.HolidayLineItem.UnitPrice = 1200;
            this.HolidayLineItem.Quantity = 1;
            this.HolidayLineItem.Unit__c = 'Manntag(e)';
            this.HolidayLineItem.OpportunityId = this.HolidayOpportunity.Id;
            insert this.HolidayLineItem;
        }

        public void createPlannedStatisticalData(){
            PlannedNumbers = new Planning_statistics__c();
            PlannedNumbers.Data_Type__c = PsoToolController.PLANNED_STATISTIC_TYPE;
            PlannedNumbers.Days__c = 5;
            PlannedNumbers.Revenue__c = 1000;
            PlannedNumbers.OpportunityLineItemId__c = this.FirstLineItem.Id;
            PlannedNumbers.Start_Date__c = Date.newInstance(2015, 1, 1);
            PlannedNumbers.End_Date__c = Date.newInstance(2015, 1, 31);
            PlannedNumbers.Time_Type__c = 'Monthly';
            insert PlannedNumbers;
        }

        public void createActualStatisticalData(){
            ActualNumbers = new Planning_statistics__c();
            ActualNumbers.Data_Type__c = PsoToolController.ACTUAL_STATISTIC_TYPE;
            ActualNumbers.Days__c = 10;
            ActualNumbers.Revenue__c = 2000;
            ActualNumbers.OpportunityLineItemId__c = this.FirstLineItem.Id;
            ActualNumbers.Start_Date__c = Date.newInstance(2015, 1, 1);
            ActualNumbers.End_Date__c = Date.newInstance(2015, 1, 31);
            ActualNumbers.Time_Type__c = 'Monthly';
            insert ActualNumbers;
        }
    }
}