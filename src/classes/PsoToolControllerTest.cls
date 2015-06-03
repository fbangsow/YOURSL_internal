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
            System.assertNotEquals(null, data_set_object.TimeStamp, 'TimeStamp should be set');
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
            System.assertEquals(Date.newInstance(2015, 3, 31), Date.parse(data_set_object.EndDate), 'EndDate should be the last day of the passed month + 3 months');
            System.assertNotEquals(null, data_set_object.TimeStamp, 'TimeStamp should be set');
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
            System.assert(new_instance.contactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.containsKey(setup_data.testContact.Id));
            Map<String, Map<String, OpportunityLineItem>> opportunitiesToOppLineItemIdToOppLineItems = new_instance.contactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.get(setup_data.testContact.Id);
            System.assertEquals(2, opportunitiesToOppLineItemIdToOppLineItems.values().size());
            System.assert(opportunitiesToOppLineItemIdToOppLineItems.containsKey(setup_data.firstOpportunity.Id));
            System.assert(opportunitiesToOppLineItemIdToOppLineItems.containsKey(setup_data.secondOpportunity.Id));
            Map<String, OpportunityLineItem> lineOppsThatBelongToFirstOpportunity = opportunitiesToOppLineItemIdToOppLineItems.get(setup_data.firstOpportunity.Id);
            System.assertEquals(1, lineOppsThatBelongToFirstOpportunity.values().size());
            System.assert(lineOppsThatBelongToFirstOpportunity.containsKey(setup_data.firstLineItem.Id));
            Map<String, OpportunityLineItem> lineOppsThatBelongToSecondOpportunity = opportunitiesToOppLineItemIdToOppLineItems.get(setup_data.secondOpportunity.Id);
            System.assertEquals(2, lineOppsThatBelongToSecondOpportunity.values().size());
            System.assert(lineOppsThatBelongToSecondOpportunity.containsKey(setup_data.secondLineItem.Id));
            System.assert(new_instance.OppLineItemIdToDateRangeToDataTypeToStatisticsEntry.containsKey(setup_data.firstLineItem.Id));
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
            System.assert(new_instance.contactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.containsKey(setup_data.testContact.Id));
            Map<String, Map<String, OpportunityLineItem>> opportunitiesToOppLineItemIdToOppLineItems = new_instance.contactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.get(setup_data.testContact.Id);
            System.assertEquals(2, opportunitiesToOppLineItemIdToOppLineItems.values().size());
            System.assert(opportunitiesToOppLineItemIdToOppLineItems.containsKey(setup_data.firstOpportunity.Id));
            System.assert(opportunitiesToOppLineItemIdToOppLineItems.containsKey(setup_data.secondOpportunity.Id));
            Map<String, OpportunityLineItem> lineOppsThatBelongToFirstOpportunity = opportunitiesToOppLineItemIdToOppLineItems.get(setup_data.firstOpportunity.Id);
            System.assertEquals(1, lineOppsThatBelongToFirstOpportunity.values().size());
            System.assert(lineOppsThatBelongToFirstOpportunity.containsKey(setup_data.firstLineItem.Id));
            Map<String, OpportunityLineItem> lineOppsThatBelongToSecondOpportunity = opportunitiesToOppLineItemIdToOppLineItems.get(setup_data.secondOpportunity.Id);
            System.assertEquals(2, lineOppsThatBelongToSecondOpportunity.values().size());
            System.assert(lineOppsThatBelongToSecondOpportunity.containsKey(setup_data.secondLineItem.Id));
            System.assert(new_instance.OppLineItemIdToDateRangeToDataTypeToStatisticsEntry.containsKey(setup_data.firstLineItem.Id));
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
                                        WHERE OpportunityLineItemId__c =: setup_data.firstLineItem.Id];
            Test.startTest();
                new_instance.processStatistics(planning_statistics_info);
            Test.stopTest();
            System.assert(new_instance.OppLineItemIdToDateRangeToDataTypeToStatisticsEntry.containsKey(setup_data.firstLineItem.Id));
            String key_for_nested_map = setup_data.plannedNumbers.Start_Date__c.format() + ' - ' + setup_data.plannedNumbers.End_Date__c.format();
            System.assert(new_instance.OppLineItemIdToDateRangeToDataTypeToStatisticsEntry.get(setup_data.firstLineItem.Id).containsKey(key_for_nested_map));
            System.assert(new_instance.OppLineItemIdToDateRangeToDataTypeToStatisticsEntry.get(setup_data.firstLineItem.Id).get(key_for_nested_map).containsKey(PsoToolController.PLANNED_STATISTIC_TYPE));
            System.assertEquals(setup_data.plannedNumbers.Id, new_instance.OppLineItemIdToDateRangeToDataTypeToStatisticsEntry.get(setup_data.firstLineItem.Id).get(key_for_nested_map).get(PsoToolController.PLANNED_STATISTIC_TYPE).Id);
            System.assert(new_instance.OppLineItemIdToDateRangeToDataTypeToStatisticsEntry.get(setup_data.firstLineItem.Id).get(key_for_nested_map).containsKey(PsoToolController.ACTUAL_STATISTIC_TYPE));
            System.assertEquals(setup_data.actualNumbers.Id, new_instance.OppLineItemIdToDateRangeToDataTypeToStatisticsEntry.get(setup_data.firstLineItem.Id).get(key_for_nested_map).get(PsoToolController.ACTUAL_STATISTIC_TYPE).Id);
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
            new_instance.contactIdsToNamesMap = new Map<String, String>();
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
            new_instance.contactIdsToNamesMap = new Map<String, String>();
            Opportunity opp = [SELECT Name, Account.Name, Account.Id FROM Opportunity WHERE id =: setup_data.firstOpportunity.Id];
            Test.startTest();
                PsoToolController.Customer customer = new_instance.getCustomer(opp);
            Test.stopTest();
            System.assertEquals(setup_data.firstAccount.Name, customer.AccountName);
            System.assertEquals(setup_data.firstAccount.Id, customer.AccountId);
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
            new_instance.contactIdsToNamesMap = new Map<String, String>();
            Opportunity opp = [SELECT Id, Name, Account.Name, Account.Id, Projektleiter_YOUR_SL__r.Name,
                                    (SELECT Contact__r.Name, Contact__r.Id, Quantity, Product2.Name, ServiceDate, UnitPrice, LastModifiedDate
                                        FROM OpportunityLineItems) 
                                        FROM Opportunity 
                                        WHERE Id =: setup_data.firstOpportunity.Id];
            Test.startTest();
                PsoToolController.Project project = new_instance.getProject(opp, true);
            Test.stopTest();
            System.assertEquals(setup_data.firstOpportunity.Name, project.OpportunityName);
            System.assertEquals(setup_data.testContact.FirstName + ' ' + setup_data.testContact.LastName, project.OurProjectManager);
            System.assertEquals(setup_data.testContact.Id, project.ProjectManagerId);
            System.assertEquals(setup_data.firstOpportunity.Id, project.OpportunityId);
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
            new_instance.contactIdsToNamesMap = new Map<String, String>();
            Opportunity opp = [SELECT Id, Name, Account.Name, Account.Id, Projektleiter_YOUR_SL__r.Name,
                                    (SELECT Contact__r.Name, Contact__r.Id, Quantity, Product2.Name, ServiceDate, UnitPrice, LastModifiedDate
                                        FROM OpportunityLineItems)
                                        FROM Opportunity 
                                        WHERE Id =: setup_data.secondOpportunity.Id];
            Test.startTest();
                List<PsoToolController.Resource> resources = new_instance.getResources(opp);
            Test.stopTest();
            System.assertEquals(1, resources.size());
            System.assertEquals(setup_data.testContact.FirstName + ' ' + setup_data.testContact.LastName, resources.get(0).ResourceName);
            System.assertEquals(setup_data.testContact.Id, resources.get(0).ContactId);
            System.assertEquals(setup_data.testProduct.Name, resources.get(0).Product);
            System.assertEquals(1200, resources.get(0).SalesPrice);
            System.assertEquals(setup_data.secondLineItem.Quantity*8 + setup_data.thirdLineItem.Quantity*8, resources.get(0).SoldDays);
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
            new_instance.contactIdsToNamesMap = new Map<String, String>();
            Opportunity opp = [SELECT Id, Name, Account.Name, Account.Id, Projektleiter_YOUR_SL__r.Name,
                                    (SELECT Contact__r.Name, Contact__r.Id, Quantity, Product2.Name, ServiceDate, UnitPrice, LastModifiedDate
                                        FROM OpportunityLineItems)
                                        FROM Opportunity 
                                        WHERE Id =: setup_data.firstOpportunity.Id];
            Test.startTest();
                PsoToolController.Resource resource = new_instance.getResource(opp.Id, opp.OpportunityLineItems.get(0));
            Test.stopTest();
            System.assertEquals(setup_data.testContact.FirstName + ' ' + setup_data.testContact.LastName, resource.ResourceName);
            System.assertEquals(setup_data.testContact.Id, resource.ContactId);
            System.assertEquals(setup_data.testProduct.Name, resource.Product);
            System.assertEquals(setup_data.firstLineItem.UnitPrice, resource.SalesPrice);
            System.assertEquals(setup_data.firstLineItem.Quantity*PsoToolController.WORKING_HOURS_IN_DAY, resource.SoldDays);
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
                new_instance.checkIfMonthIsWithinRangeAndPutInMap(new_resource, setup_data.firstLineItem);
            Test.stopTest();
            System.assertEquals(1, new_resource.MonthToLimitMap.size());
            String number_of_month = String.valueOf(setup_data.firstLineItem.ServiceDate.month());
            System.assert(new_resource.MonthToLimitMap.containsKey(number_of_month));
            System.assertEquals(setup_data.firstLineItem.Quantity, Decimal.valueOf(new_resource.MonthToLimitMap.get(number_of_month)));
            System.assertEquals(1, new_resource.MonthToOppLineItemIdMap.size());
            System.assert(new_resource.MonthToOppLineItemIdMap.containsKey(number_of_month));
            System.assertEquals(setup_data.firstLineItem.Id, new_resource.MonthToOppLineItemIdMap.get(number_of_month));
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
                                        WHERE Id =: setup_data.secondLineItem.Id];
            Test.startTest();
                List<PsoToolController.Staffing> staffings = new_instance.getStaffingForResourceForOpportunity(setup_data.secondOpportunity.Id, opp_line_item);
            Test.stopTest();
            System.assertEquals(3, staffings.size());
        }
    }

    @isTest static void tesGetStaffingForScheduleEntryReturnsProperStaffingObject(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            setup_data.createTestData();
            Test.startTest();
                PsoToolController.Staffing staffing = new_instance.getStaffingForScheduleEntry(setup_data.schedule);
            Test.stopTest();
            System.assertEquals(setup_data.schedule.ScheduleDate, Date.parse(staffing.Day));
            System.assertEquals(setup_data.schedule.Quantity*8, staffing.Staff);
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
            new_instance.contactIdsToNamesMap = new Map<String, String>();
            Opportunity opp = [SELECT Id, Name, Account.Name, Account.Id, Projektleiter_YOUR_SL__r.Name,
                        (SELECT Contact__r.Name, Contact__r.Id, Quantity, Product2.Name, ServiceDate, UnitPrice, LastModifiedDate
                            FROM OpportunityLineItems)
                            FROM Opportunity 
                            WHERE Id =: setup_data.secondOpportunity.Id];
            new_instance.getResources(opp);
            Test.startTest();
                List<PsoToolController.ResourceInfo> staffing = new_instance.getResourcesAvailabilityData();
            Test.stopTest();
            System.assertEquals(1, staffing.size());
            System.assertEquals(setup_data.testContact.FirstName + ' ' + setup_data.testContact.LastName, staffing.get(0).ResourceName);
            System.assertEquals(2, staffing.get(0).Staffing.size());
            System.assertEquals(setup_data.testContact.Id, staffing.get(0).ContactId);
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
                            WHERE Id =: setup_data.secondLineItem.Id];
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
                            WHERE Id =: setup_data.holidayLineItem.Id];
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
                PsoToolController.Staffing single_staffing = new_instance.getStaffingForSpecialOccasionEntry(setup_data.holidayLineItem);
            Test.stopTest();
            System.assertEquals(setup_data.holidayLineItem.ServiceDate, Date.parse(single_staffing.Day));
            System.assertEquals(setup_data.holidayLineItem.Quantity*PsoToolController.WORKING_HOURS_IN_DAY, single_staffing.Staff);
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
                new_instance.allocateResource(setup_data.firstLineItem.Id, selected_date, selected_quantity);
            Test.stopTest();
            List<OpportunityLineItemSchedule> schedules = [SELECT OpportunityLineItemId, ScheduleDate, Quantity 
                                        FROM OpportunityLineItemSchedule
                                        WHERE Description != :OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT 
                                        AND OpportunityLineItemId = :setup_data.firstLineItem.Id ORDER BY ScheduleDate DESC];
            System.assertEquals(2, schedules.size());
            System.assertEquals(selected_date, schedules.get(0).ScheduleDate);
            System.assertEquals(selected_quantity, schedules.get(0).Quantity);
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
                new_instance.allocateResource(setup_data.firstLineItem.Id, selected_date, selected_quantity);
            Test.stopTest();
            List<OpportunityLineItemSchedule> schedules = [SELECT OpportunityLineItemId, ScheduleDate, Quantity 
                                        FROM OpportunityLineItemSchedule
                                        WHERE Description != :OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT 
                                        AND OpportunityLineItemId = :setup_data.firstLineItem.Id ORDER BY ScheduleDate DESC];
            System.assertEquals(1, schedules.size());
            System.assertEquals(selected_date, schedules.get(0).ScheduleDate);
            System.assertEquals(selected_quantity, schedules.get(0).Quantity);
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
                    new_instance.allocateResource(setup_data.firstAccount.Id, selected_date, selected_quantity);
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
                OpportunityLineItemSchedule schedule = new_instance.createNewOpportunityLineItemSchedule(setup_data.firstLineItem.Id, selected_date);
            Test.stopTest();
            System.assertEquals(selected_date, schedule.ScheduleDate);
            System.assertEquals(setup_data.firstLineItem.Id, schedule.OpportunityLineItemId);
            System.assertEquals('Quantity', schedule.Type);
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
                List<PsoToolController.Stats> stats = new_instance.getStats(setup_data.firstLineItem.Id);
            Test.stopTest();
            System.assertEquals(1, stats.size());
            System.assertEquals(setup_data.actualNumbers.Days__c + '/' +setup_data.plannedNumbers.Days__c, stats.get(0).Days);
            System.assertEquals(setup_data.actualNumbers.Revenue__c + '/' + setup_data.plannedNumbers.Revenue__c, stats.get(0).Revenue);
            System.assertEquals(setup_data.plannedNumbers.Start_Date__c, Date.parse(stats.get(0).StartDate));
            System.assertEquals(setup_data.plannedNumbers.End_Date__c, Date.parse(stats.get(0).EndDate));
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
                List<PsoToolController.Stats> stats = new_instance.getStats(setup_data.firstLineItem.Id);
            Test.stopTest();
            System.assertEquals(1, stats.size());
            System.assertEquals(setup_data.actualNumbers.Days__c + '/0', stats.get(0).Days);
            System.assertEquals(setup_data.actualNumbers.Revenue__c + '/0', stats.get(0).Revenue);
            System.assertEquals(setup_data.actualNumbers.Start_Date__c, Date.parse(stats.get(0).StartDate));
            System.assertEquals(setup_data.actualNumbers.End_Date__c, Date.parse(stats.get(0).EndDate));
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
                List<PsoToolController.Stats> stats = new_instance.getStats(setup_data.firstLineItem.Id);
            Test.stopTest();
            System.assertEquals(1, stats.size());
            System.assertEquals('0/' + setup_data.plannedNumbers.Days__c, stats.get(0).Days);
            System.assertEquals('0/' + setup_data.plannedNumbers.Revenue__c, stats.get(0).Revenue);
            System.assertEquals(setup_data.plannedNumbers.Start_Date__c, Date.parse(stats.get(0).StartDate));
            System.assertEquals(setup_data.plannedNumbers.End_Date__c, Date.parse(stats.get(0).EndDate));
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
                PsoToolController.Stats stat = new_instance.getDefaultNewStat(setup_data.plannedNumbers);
            Test.stopTest();
            System.assertEquals(setup_data.plannedNumbers.Start_Date__c, Date.parse(stat.StartDate));
            System.assertEquals(setup_data.plannedNumbers.End_Date__c, Date.parse(stat.EndDate));
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
            setup_data.firstOpportunity.Managed_by_PSO_Tool__c = false;
            update setup_data.firstOpportunity;
            Test.startTest();
                new_instance.queryData();
            Test.stopTest();
            System.assertEquals(1, new_instance.opportunities.size(), 'This property should have 1 test opportunity');
            System.assertNotEquals(setup_data.firstOpportunity.Id, new_instance.opportunities.get(0).Id);
            System.assert(new_instance.contactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.containsKey(setup_data.testContact.Id));
            Map<String, Map<String, OpportunityLineItem>> opportunitiesToOppLineItemIdToOppLineItems = new_instance.contactIdToOpportunityIdToOpportunityLineItemIdToOpportunityLineItemsMap.get(setup_data.testContact.Id);
            System.assertEquals(2, opportunitiesToOppLineItemIdToOppLineItems.values().size());
            System.assert(opportunitiesToOppLineItemIdToOppLineItems.containsKey(setup_data.firstOpportunity.Id));
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
            System.assertEquals(Date.newInstance(2015, 8, 31), new_instance.EndDate);
        }
    }

    @isTest static void testSetSelectedOpportunitiesSetsTheRightValue() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Date start_date = Date.newInstance(2015, 6, 2);
            setup_data.createTestData();
            List<Id> opportunities_to_add = new List<Id>();
            opportunities_to_add.add(setup_data.firstOpportunity.Id);
            Test.startTest();
                PsoToolController new_instance = PsoToolController.getInstance().setSelectedOpportunities(opportunities_to_add);
            Test.stopTest();
            System.assertEquals(1, new_instance.OpportunitiesToShow.size());
            System.assertEquals(setup_data.firstOpportunity.Id, new_instance.OpportunitiesToShow.get(0));
        }
    }

    @isTest static void testGetOpportunitiesReturnesTheExpectedResultWhenWeHaveSelectedOpportunities() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Date start_date = Date.newInstance(2015, 6, 2);
            setup_data.createTestData();
            List<Id> opportunities_to_add = new List<Id>();
            opportunities_to_add.add(setup_data.firstOpportunity.Id);
            PsoToolController.getInstance().setSelectedOpportunities(opportunities_to_add);
            Test.startTest();
                List<Id> opportunities_to_show = PsoToolController.getInstance().getOpportunitiesToShow();
            Test.stopTest();
            System.assertEquals(1, opportunities_to_show.size());
            System.assertEquals(setup_data.firstOpportunity.Id, opportunities_to_show.get(0));
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
        }
    }

    private class SetupDataClass {
        public Account firstAccount;
        public Account secondAccount;
        public Contact testContact;
        public Opportunity firstOpportunity;
        public Opportunity secondOpportunity;
        public Opportunity holidayOpportunity;
        public OpportunityLineItem firstLineItem;
        public OpportunityLineItem secondLineItem;
        public OpportunityLineItem thirdLineItem;
        public OpportunityLineItem holidayLineItem;
        public PricebookEntry testPricebookEntry;
        public Product2 testProduct;
        public User TestUser;
        public User AnotherUser;
        public OpportunityLineItemSchedule schedule;
        public Planning_statistics__c plannedNumbers;
        public Planning_statistics__c actualNumbers;
        private String DesiredProfile = 'System Administrator';

        public SetupDataClass() {
            this.testUser = UserUtility.createNewUser(DesiredProfile);
            insert testUser;
        }

        public SetupDataClass(String desired_profile){
            this.DesiredProfile = desired_profile;
            this.testUser = UserUtility.createNewUser(DesiredProfile);
            insert testUser;
        }

        public void createAnotherUser(){
            this.anotherUser = UserUtility.createNewUser(DesiredProfile);
            insert anotherUser;
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
            this.firstAccount = new Account();
            this.firstAccount.Name = 'First company';
            this.secondAccount = new Account();
            this.secondAccount.Name = 'Second company';
            insert new List<Sobject> {this.firstAccount, this.secondAccount};
        }

        private void createAndInsertContactForUser() {
            this.testContact = new Contact();
            this.testContact.FirstName = testUser.FirstName;
            this.testContact.LastName = testUser.LastName;
            insert this.testContact;
        }
        
        private void createAndInsertProduct() {
            this.testProduct = new Product2();
            this.testProduct.Name = 'Salesforce Developer';
            this.testProduct.isActive = true;
            this.testProduct.CanUseQuantitySchedule = true;
            insert this.testProduct;
        }

        private void createAndInsertPriceBookEntry(){
            this.testPricebookEntry = new PricebookEntry();
            this.testPricebookEntry.Pricebook2Id = Test.getStandardPricebookId();
            this.testPricebookEntry.Product2Id = this.testProduct.Id;
            this.testPricebookEntry.UnitPrice = 99;
            this.testPricebookEntry.isActive = true;
            insert this.testPricebookEntry;
        }

        private void createAndInsertOpportunities(){
            this.firstOpportunity = new Opportunity();
            this.firstOpportunity.Name = '° Roshen';
            this.firstOpportunity.StageName = '° Roshen';
            this.firstOpportunity.PriceBook2Id = Test.getStandardPricebookId();
            this.firstOpportunity.AccountId = this.firstAccount.Id;
            this.firstOpportunity.CloseDate = Date.newInstance(2015, 1, 1);
            this.firstOpportunity.Projektleiter_YOUR_SL__c = this.testContact.Id;
            this.firstOpportunity.Managed_by_PSO_Tool__c = true;
            this.secondOpportunity = new Opportunity();
            this.secondOpportunity.Name = 'Apple iWatch';
            this.secondOpportunity.StageName = 'iWatch';
            this.secondOpportunity.PriceBook2Id = Test.getStandardPricebookId();
            this.secondOpportunity.AccountId = this.secondAccount.Id;
            this.secondOpportunity.CloseDate = Date.newInstance(2015, 1, 1);
            this.secondOpportunity.Projektleiter_YOUR_SL__c = this.testContact.Id;
            this.secondOpportunity.Managed_by_PSO_Tool__c = true;
            insert new List<Sobject> {this.firstOpportunity, this.secondOpportunity};
        }

        private void makeTheTestUserToBeOpportunityMember(){
            OpportunityTeamMember firstMember = new OpportunityTeamMember();
            firstMember.UserId = this.testUser.Id;
            firstMember.OpportunityId = this.firstOpportunity.Id;
            OpportunityTeamMember secondMember = new OpportunityTeamMember();
            secondMember.UserId = this.testUser.Id;
            secondMember.OpportunityId = this.secondOpportunity.Id;
            insert new List<Sobject> {firstMember, secondMember};
        }

        private void createOpportunityLineItems(){
            this.firstLineItem = new OpportunityLineItem();
            this.firstLineItem.Contact__c = this.testContact.Id;
            this.firstLineItem.PricebookEntryId = this.testPricebookEntry.Id;
            this.firstLineItem.ServiceDate = Date.newInstance(2015, 1, 10);
            this.firstLineItem.UnitPrice = 1200;
            this.firstLineItem.Quantity = 1;
            this.firstLineItem.Unit__c = 'Manntag(e)';
            this.firstLineItem.OpportunityId = this.firstOpportunity.Id;
            this.secondLineItem = new OpportunityLineItem();
            this.secondLineItem.Contact__c = this.testContact.Id;
            this.secondLineItem.PricebookEntryId = this.testPricebookEntry.Id;
            this.secondLineItem.ServiceDate = Date.newInstance(2015, 1, 10);
            this.secondLineItem.UnitPrice = 1200;
            this.secondLineItem.Quantity = 1.5;
            this.secondLineItem.Unit__c = 'Manntag(e)';
            this.secondLineItem.OpportunityId = this.secondOpportunity.Id;
            this.thirdLineItem = new OpportunityLineItem();
            this.thirdLineItem.Contact__c = this.testContact.Id;
            this.thirdLineItem.PricebookEntryId = this.testPricebookEntry.Id;
            this.thirdLineItem.ServiceDate = Date.newInstance(2015, 2, 10);
            this.thirdLineItem.UnitPrice = 1200;
            this.thirdLineItem.Quantity = 10;
            this.thirdLineItem.Unit__c = 'Manntag(e)';
            this.thirdLineItem.OpportunityId = this.secondOpportunity.Id;
            insert new List<Sobject> {this.firstLineItem, this.secondLineItem, this.thirdLineItem};
        }

        private void createOpportunityLineItemsSchedule(){
            schedule = new OpportunityLineItemSchedule();
            schedule.OpportunityLineItemId = this.firstLineItem.Id;
            schedule.ScheduleDate = Date.newInstance(2015, 1, 10);
            schedule.Quantity = 1;
            schedule.Type = 'Quantity';
            OpportunityLineItemSchedule secondSchedule = new OpportunityLineItemSchedule();
            secondSchedule.OpportunityLineItemId = this.secondLineItem.Id;
            secondSchedule.ScheduleDate = Date.newInstance(2015, 1, 10);
            secondSchedule.Quantity = 1;
            secondSchedule.Type = 'Quantity';
            OpportunityLineItemSchedule thirdSchedule = new OpportunityLineItemSchedule();
            thirdSchedule.OpportunityLineItemId = this.secondLineItem.Id;
            thirdSchedule.ScheduleDate = Date.newInstance(2015, 1, 11);
            thirdSchedule.Quantity = 0.5;
            thirdSchedule.Type = 'Quantity';
            OpportunityLineItemSchedule forthSchedule = new OpportunityLineItemSchedule();
            forthSchedule.OpportunityLineItemId = this.secondLineItem.Id;
            forthSchedule.ScheduleDate = Date.newInstance(2015, 4, 11);
            forthSchedule.Quantity = 0.4;
            forthSchedule.Type = 'Quantity';
            insert new List<Sobject> {schedule, secondSchedule, thirdSchedule, forthSchedule};
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
            this.holidayOpportunity = new Opportunity();
            this.holidayOpportunity.Name = PsoToolController.SPECIAL_OPPORTUNITY;
            this.holidayOpportunity.StageName = PsoToolController.SPECIAL_OPPORTUNITY;
            this.holidayOpportunity.PriceBook2Id = Test.getStandardPricebookId();
            this.holidayOpportunity.AccountId = this.firstAccount.Id;
            this.holidayOpportunity.CloseDate = Date.newInstance(2015, 1, 1);
            this.holidayOpportunity.Projektleiter_YOUR_SL__c = this.testContact.Id;
            this.holidayOpportunity.Managed_by_PSO_Tool__c = true;
            insert this.holidayOpportunity;
        }

        private void makeTheTestUserToBeTheHolidayOpportunityMember(){
            OpportunityTeamMember firstMember = new OpportunityTeamMember();
            firstMember.UserId = this.testUser.Id;
            firstMember.OpportunityId = this.holidayOpportunity.Id;
            insert firstMember;
        }

        private void createHolidayOpportunityLineItem(){
            this.holidayLineItem = new OpportunityLineItem();
            this.holidayLineItem.Contact__c = this.testContact.Id;
            this.holidayLineItem.PricebookEntryId = this.testPricebookEntry.Id;
            this.holidayLineItem.ServiceDate = Date.newInstance(2015, 1, 10);
            this.holidayLineItem.UnitPrice = 1200;
            this.holidayLineItem.Quantity = 1;
            this.holidayLineItem.Unit__c = 'Manntag(e)';
            this.holidayLineItem.OpportunityId = this.holidayOpportunity.Id;
            insert this.holidayLineItem;
        }

        public void createPlannedStatisticalData(){
            plannedNumbers = new Planning_statistics__c();
            plannedNumbers.Data_Type__c = PsoToolController.PLANNED_STATISTIC_TYPE;
            plannedNumbers.Days__c = 5;
            plannedNumbers.Revenue__c = 1000;
            plannedNumbers.OpportunityLineItemId__c = this.firstLineItem.Id;
            plannedNumbers.Start_Date__c = Date.newInstance(2015, 1, 1);
            plannedNumbers.End_Date__c = Date.newInstance(2015, 1, 31);
            plannedNumbers.Time_Type__c = 'Monthly';
            insert plannedNumbers;
        }

        public void createActualStatisticalData(){
            actualNumbers = new Planning_statistics__c();
            actualNumbers.Data_Type__c = PsoToolController.ACTUAL_STATISTIC_TYPE;
            actualNumbers.Days__c = 10;
            actualNumbers.Revenue__c = 2000;
            actualNumbers.OpportunityLineItemId__c = this.firstLineItem.Id;
            actualNumbers.Start_Date__c = Date.newInstance(2015, 1, 1);
            actualNumbers.End_Date__c = Date.newInstance(2015, 1, 31);
            actualNumbers.Time_Type__c = 'Monthly';
            insert actualNumbers;
        }
    }
}