@isTest
private class PsoToolControllerTest {

    @isTest static void testGetInstanceReturnsDifferentObjects() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Test.startTest();
                PsoToolController new_instance = PsoToolController.getInstance();
            Test.stopTest();
            System.assertNotEquals(PsoToolController.getInstance(), new_instance, 'Method should not return the same instance');
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
            PsoToolController new_instance = PsoToolController.getInstance().showAllOpportunities().showAllContacts();
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
            System.assert(new_instance.OppLineItemIdToDateRangeToRawStats.containsKey(setup_data.FirstLineItem.Id));
            System.assert(new_instance.ContactIdToDateRangeToRawStats.containsKey(setup_data.TestContact.Id));
        }
    }

    @isTest static void testQueryDataFindsAllOpportunitiesForAdmins() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance().showAllOpportunities().showAllContacts();
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
            System.assert(new_instance.OppLineItemIdToDateRangeToRawStats.containsKey(setup_data.FirstLineItem.Id));
            System.assert(new_instance.ContactIdToDateRangeToRawStats.containsKey(setup_data.TestContact.Id));
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

    @isTest static void testBuildOppLineItemIdToDateRangeToRawStatsCreatesRightData(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            setup_data.createTestData();
            setup_data.createPlannedStatisticalData();
            setup_data.createActualStatisticalData();
            new_instance.OppLineItemIdToDateRangeToRawStats = new Map<String, Map<String, PsoToolController.RawStats>>();
            String key_for_nested_map = setup_data.PlannedNumbers.Start_Date__c.format() + ' - ' + setup_data.PlannedNumbers.End_Date__c.format();
            Test.startTest();
                new_instance.buildOppLineItemIdToDateRangeToRawStats(setup_data.PlannedNumbers, key_for_nested_map);
                new_instance.buildOppLineItemIdToDateRangeToRawStats(setup_data.ActualNumbers, key_for_nested_map);
            Test.stopTest();
            System.assert(new_instance.OppLineItemIdToDateRangeToRawStats.containsKey(setup_data.FirstLineItem.Id));
            System.assert(new_instance.OppLineItemIdToDateRangeToRawStats.get(setup_data.FirstLineItem.Id).containsKey(key_for_nested_map));
            System.assertEquals(setup_data.PlannedNumbers.Start_Date__c, new_instance.OppLineItemIdToDateRangeToRawStats.get(setup_data.FirstLineItem.Id).get(key_for_nested_map).StartDate);
            System.assertEquals(setup_data.PlannedNumbers.End_Date__c, new_instance.OppLineItemIdToDateRangeToRawStats.get(setup_data.FirstLineItem.Id).get(key_for_nested_map).EndDate);
            System.assertEquals(setup_data.PlannedNumbers.Days__c, new_instance.OppLineItemIdToDateRangeToRawStats.get(setup_data.FirstLineItem.Id).get(key_for_nested_map).PlannedDays);
            System.assertEquals(setup_data.PlannedNumbers.Revenue__c, new_instance.OppLineItemIdToDateRangeToRawStats.get(setup_data.FirstLineItem.Id).get(key_for_nested_map).PlannedRevenue);
            System.assertEquals(setup_data.ActualNumbers.Days__c, new_instance.OppLineItemIdToDateRangeToRawStats.get(setup_data.FirstLineItem.Id).get(key_for_nested_map).ActualDays);
            System.assertEquals(setup_data.ActualNumbers.Revenue__c, new_instance.OppLineItemIdToDateRangeToRawStats.get(setup_data.FirstLineItem.Id).get(key_for_nested_map).ActualRevenue);
        }
    }

    @isTest static void testBuildContactIdToDateRangeToRawStatsCreatesRightData(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            setup_data.createTestData();
            setup_data.createPlannedStatisticalData();
            setup_data.createActualStatisticalData();
            setup_data.createAdditionalStatisticalData();
            List<Planning_statistics__c> planning_statistics_info = [SELECT Data_Type__c, Days__c, End_Date__c, OpportunityLineItemId__c, Revenue__c, Start_Date__c, Time_Type__c, Contact__r.Id
                                        FROM Planning_statistics__c];
            new_instance.ContactIdToDateRangeToRawStats = new Map<String, Map<String, PsoToolController.RawStats>>();
            String key_for_nested_map = setup_data.PlannedNumbers.Start_Date__c.format() + ' - ' + setup_data.PlannedNumbers.End_Date__c.format();
            Test.startTest();
                for(Planning_statistics__c info: planning_statistics_info)
                    new_instance.buildContactIdToDateRangeToRawStats(info, key_for_nested_map);
            Test.stopTest();
            System.assert(new_instance.ContactIdToDateRangeToRawStats.containsKey(setup_data.TestContact.Id));
            System.assert(new_instance.ContactIdToDateRangeToRawStats.get(setup_data.TestContact.Id).containsKey(key_for_nested_map));
            System.assertEquals(setup_data.PlannedNumbers.Start_Date__c, new_instance.ContactIdToDateRangeToRawStats.get(setup_data.TestContact.Id).get(key_for_nested_map).StartDate);
            System.assertEquals(setup_data.PlannedNumbers.End_Date__c, new_instance.ContactIdToDateRangeToRawStats.get(setup_data.TestContact.Id).get(key_for_nested_map).EndDate);
            System.assertEquals(setup_data.PlannedNumbers.Days__c + setup_data.AdditionalPlannedNumbers.Days__c, new_instance.ContactIdToDateRangeToRawStats.get(setup_data.TestContact.Id).get(key_for_nested_map).PlannedDays);
            System.assertEquals(setup_data.PlannedNumbers.Revenue__c + setup_data.AdditionalPlannedNumbers.Revenue__c, new_instance.ContactIdToDateRangeToRawStats.get(setup_data.TestContact.Id).get(key_for_nested_map).PlannedRevenue);
            System.assertEquals(setup_data.ActualNumbers.Days__c + setup_data.AdditionalActualNumbers.Days__c, new_instance.ContactIdToDateRangeToRawStats.get(setup_data.TestContact.Id).get(key_for_nested_map).ActualDays);
            System.assertEquals(setup_data.ActualNumbers.Revenue__c + setup_data.AdditionalActualNumbers.Revenue__c, new_instance.ContactIdToDateRangeToRawStats.get(setup_data.TestContact.Id).get(key_for_nested_map).ActualRevenue);
        }
    }

    @isTest static void testGetCustomersReturnsListOfCustomers() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            new_instance.startDate = Date.newInstance(2015, 1, 1);
            new_instance.endDate = Date.newInstance(2015, 3, 31);
            setup_data.createTestData();
            new_instance.ShowAllOpportunities = true;
            new_instance.ShowAllContacts = true;
            new_instance.queryData();
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
            PsoToolController new_instance = PsoToolController.getInstance().showAllOpportunities().showAllContacts();
            new_instance.startDate = Date.newInstance(2015, 1, 1);
            new_instance.endDate = Date.newInstance(2015, 3, 31);
            setup_data.createTestData();
            new_instance.queryData();
            Opportunity opp = [SELECT Id, Name, Account.Name, Account.Id, Projektleiter_YOUR_SL__r.Name,
                                    (SELECT Contact__r.Name, Contact__r.Id, Quantity, Product2.Name, ServiceDate, UnitPrice, LastModifiedDate
                                        FROM OpportunityLineItems)
                                        FROM Opportunity
                                        WHERE Id =: setup_data.SecondOpportunity.Id];
            Test.startTest();
                List<PsoToolController.Resource> resources = new_instance.getResources(opp);
            Test.stopTest();
            System.assertEquals(2, resources.size());
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
            new_instance.ShowAllOpportunities = true;
            new_instance.ShowAllContacts = true;
            new_instance.queryData();
            OpportunityLineItem opp_line_item = [SELECT Contact__r.Name, Contact__r.Id, Quantity, Product2.Name, ServiceDate, UnitPrice, LastModifiedDate
                                        FROM OpportunityLineItem
                                        WHERE Id =: setup_data.SecondLineItem.Id];
            Test.startTest();
                List<PsoToolController.Staffing> staffings = new_instance.getStaffingForResourceForOpportunity(setup_data.SecondOpportunity.Id, opp_line_item);
            Test.stopTest();
            System.assertEquals(4, staffings.size());
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
            System.assertEquals(0, staffing.HoursOff);
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
            PsoToolController new_instance = PsoToolController.getInstance().showAllOpportunities().showAllContacts();
            new_instance.startDate = Date.newInstance(2015, 1, 1);
            new_instance.endDate = Date.newInstance(2015, 3, 31);
            setup_data.createTestData();
            setup_data.createPlannedStatisticalData();
            setup_data.createActualStatisticalData();
            new_instance.queryData();
            Opportunity opp = [SELECT Id, Name, Account.Name, Account.Id, Projektleiter_YOUR_SL__r.Name,
                        (SELECT Contact__r.Name, Contact__r.Id, Contact__r.Account.Name, Contact__r.Title, Contact__r.LastName, Quantity, Product2.Name, ServiceDate, UnitPrice, LastModifiedDate
                            FROM OpportunityLineItems)
                            FROM Opportunity
                            WHERE Id =: setup_data.SecondOpportunity.Id];
            new_instance.getResources(opp);
            Test.startTest();
                List<PsoToolController.ResourceInfo> staffing = new_instance.getResourcesAvailabilityData(true);
            Test.stopTest();
            System.assertEquals(2, staffing.size());
            System.assertEquals(setup_data.TestContact.FirstName + ' ' + setup_data.TestContact.LastName, staffing.get(0).ResourceName);
            System.assertEquals(2, staffing.get(0).Staffing.size());
            System.assertEquals(setup_data.TestContact.Id, staffing.get(0).ContactId);
            System.assertEquals(1, staffing.get(0).Statistics.size());
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
            first_staffing.HoursOff = 0.1;
            PsoToolController.Staffing another_staffing_in_the_same_day = new PsoToolController.Staffing ();
            another_staffing_in_the_same_day.Day =  Date.newInstance(2015, 1, 15).format();
            another_staffing_in_the_same_day.Staff = 0.4;
            another_staffing_in_the_same_day.HoursOff = 0.5;
            Map<String, PsoToolController.Staffing> existing_staffing = new Map<String, PsoToolController.Staffing>();
            existing_staffing.put(first_staffing.Day, first_staffing);
            Test.startTest();
                Map<String, PsoToolController.Staffing> result_staffing = new_instance.addStaffing(existing_staffing, another_staffing_in_the_same_day);
            Test.stopTest();
            System.assertEquals(1, result_staffing.values().size());
            System.assertEquals(0.9, result_staffing.values().get(0).Staff);
            System.assertEquals(0.6, result_staffing.values().get(0).HoursOff);
        }
    }

    @isTest static void testAddStaffingAddsAnotherStaffingForDifferentDays(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            PsoToolController.Staffing first_staffing = new PsoToolController.Staffing ();
            first_staffing.Day = Date.newInstance(2015, 1, 15).format();
            first_staffing.Staff = 0.5;
            first_staffing.HoursOff = 0;
            PsoToolController.Staffing another_staffing = new PsoToolController.Staffing();
            another_staffing.Day =  Date.newInstance(2015, 3, 23).format();
            another_staffing.Staff = 0.4;
            another_staffing.HoursOff = 0;
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
            System.assertEquals(setup_data.HolidayLineItem.Quantity*PsoToolController.WORKING_HOURS_IN_DAY, single_staffing.HoursOff);
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
                PsoToolController.Result result = new_instance.allocateResource(setup_data.FirstLineItem.Id, selected_date, selected_quantity);
            Test.stopTest();
            System.assert(result.IsSuccess);
            System.assertEquals(null, result.ErrorMessage);
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
                PsoToolController.Result result = new_instance.allocateResource(setup_data.FirstLineItem.Id, selected_date, selected_quantity);
            Test.stopTest();
            System.assert(result.IsSuccess);
            System.assertEquals(null, result.ErrorMessage);
            List<OpportunityLineItemSchedule> Schedules = [SELECT OpportunityLineItemId, ScheduleDate, Quantity
                                        FROM OpportunityLineItemSchedule
                                        WHERE Description != :OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT
                                        AND OpportunityLineItemId = :setup_data.FirstLineItem.Id ORDER BY ScheduleDate DESC];
            System.assertEquals(1, Schedules.size());
            System.assertEquals(selected_date, Schedules.get(0).ScheduleDate);
            System.assertEquals(selected_quantity, Schedules.get(0).Quantity);
        }
    }

    @isTest static void testAllocateResourceReturnsFailedResult(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            setup_data.createTestData();
            Date selected_date = Date.newInstance(2015, 1, 10);
            Decimal selected_quantity = 0.5;
            Test.startTest();
                PsoToolController.Result result = new_instance.allocateResource(setup_data.FirstAccount.Id, selected_date, selected_quantity);
            Test.stopTest();
            System.assert(!result.IsSuccess);
            System.assertEquals('OpportunityLineItem is not found', result.ErrorMessage);
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
                List<PsoToolController.Stats> stats = new_instance.getStatsForOppLineItem(setup_data.FirstLineItem.Id);
            Test.stopTest();
            System.assertEquals(1, stats.size());
            System.assertEquals(setup_data.ActualNumbers.Days__c + '/' +setup_data.PlannedNumbers.Days__c, stats.get(0).Days);
            System.assertEquals(setup_data.ActualNumbers.Revenue__c + '/' + setup_data.PlannedNumbers.Revenue__c, stats.get(0).Revenue);
            System.assertEquals(setup_data.PlannedNumbers.Start_Date__c, Date.parse(stats.get(0).StartDate));
            System.assertEquals(setup_data.PlannedNumbers.End_Date__c, Date.parse(stats.get(0).EndDate));
            System.assertEquals(setup_data.PlannedNumbers.Days__c, stats.get(0).PlannedDays);
            System.assertEquals(setup_data.ActualNumbers.Days__c, stats.get(0).ActualDays);
            System.assertEquals(setup_data.PlannedNumbers.Revenue__c, stats.get(0).PlannedRevenue);
            System.assertEquals(setup_data.ActualNumbers.Revenue__c, stats.get(0).ActualRevenue);
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
                List<PsoToolController.Stats> stats = new_instance.getStatsForOppLineItem(setup_data.FirstLineItem.Id);
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
                List<PsoToolController.Stats> stats = new_instance.getStatsForOppLineItem(setup_data.FirstLineItem.Id);
            Test.stopTest();
            System.assertEquals(1, stats.size());
            System.assertEquals('0/' + setup_data.PlannedNumbers.Days__c, stats.get(0).Days);
            System.assertEquals('0/' + setup_data.PlannedNumbers.Revenue__c, stats.get(0).Revenue);
            System.assertEquals(setup_data.PlannedNumbers.Start_Date__c, Date.parse(stats.get(0).StartDate));
            System.assertEquals(setup_data.PlannedNumbers.End_Date__c, Date.parse(stats.get(0).EndDate));
        }
    }

    @isTest static void testGetNewStatSetsExpectedValues(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance();
            setup_data.createTestData();
            setup_data.createPlannedStatisticalData();
            PsoToolController.RawStats raw_stat = new PsoToolController.RawStats(setup_data.PlannedNumbers);
            raw_stat.PlannedDays = 5;
            raw_stat.PlannedRevenue = 1000;
            raw_stat.ActualDays = 10;
            raw_stat.ActualRevenue = 2000;
            raw_stat.StartDate = Date.newInstance(2015, 1, 1);
            raw_stat.EndDate = Date.newInstance(2015, 3, 31);
            Test.startTest();
                PsoToolController.Stats stat = new_instance.getNewStat(raw_stat);
            Test.stopTest();
            System.assertEquals(raw_stat.StartDate, Date.parse(stat.StartDate));
            System.assertEquals(raw_stat.EndDate, Date.parse(stat.EndDate));
            System.assertEquals(raw_stat.ActualDays + '/' + raw_stat.PlannedDays, stat.Days);
            System.assertEquals(raw_stat.ActualRevenue + '/' + raw_stat.PlannedRevenue, stat.Revenue);
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

    @isTest static void testQueryDataDoesntSeeOpportunitiesAndTheirSchedulesWhenCheckboxIsNotSet(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            PsoToolController new_instance = PsoToolController.getInstance().showAllOpportunities().showAllContacts();
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
            System.assertEquals(1, opportunitiesToOppLineItemIdToOppLineItems.values().size());
            System.assert(!opportunitiesToOppLineItemIdToOppLineItems.containsKey(setup_data.FirstOpportunity.Id));
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

    @isTest static void testSetSelectedContactsSetsTheRightValue() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Date start_date = Date.newInstance(2015, 6, 2);
            setup_data.createTestData();
            List<Id> contacts_to_add = new List<Id>();
            contacts_to_add.add(setup_data.TestContact.Id);
            Test.startTest();
                PsoToolController new_instance = PsoToolController.getInstance().setSelectedContacts(contacts_to_add);
            Test.stopTest();
            System.assertEquals(1, new_instance.ContactsToShow.size());
            System.assert(new_instance.ContactsToShow.contains(setup_data.TestContact.Id));
        }
    }

    @isTest static void testGetOpportunitiesReturnesTheExpectedResultWhenWeHaveSelectedOpportunities() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Date start_date = Date.newInstance(2015, 6, 2);
            setup_data.createTestData();
            List<Id> opportunities_to_add = new List<Id>();
            opportunities_to_add.add(setup_data.FirstOpportunity.Id);
            Test.startTest();
                List<Id> opportunities_to_show = PsoToolController.getInstance().setSelectedOpportunities(opportunities_to_add).getOpportunitiesToShow();
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
                List<Id> opportunities_to_show = PsoToolController.getInstance().showAllContacts().showAllOpportunities().getOpportunitiesToShow();
            Test.stopTest();
            System.assertEquals(2, opportunities_to_show.size());
        }
    }

    @isTest static void testGetFilterValuesReturnsTheListWith2AccountsEachOfWhichHasAProject() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Date new_years_eve = Date.newInstance(2015, 1, 1);
            setup_data.createTestData();
            Test.startTest();
                Object data_set = PsoToolController.getInstance().setStartDate(new_years_eve).getFilterValues();
            Test.stopTest();
            System.assert(data_set instanceof PsoToolController.FilterValues, 'Method should return an instance of FilterValues class');
            PsoToolController.FilterValues data_set_object = (PsoToolController.FilterValues)data_set;
            System.assertEquals(2, data_set_object.Customers.size());
            System.assertEquals(1, data_set_object.Customers.get(0).Projects.size());
            System.assertEquals(1, data_set_object.Customers.get(1).Projects.size());
            System.assertEquals(true, data_set_object.IsAllowedToRunScript);
            System.assertEquals(2, data_set_object.Resources.size());
        }
    }

    @isTest static void testgetFilterValuesReturnsJson() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Date new_years_eve = Date.newInstance(2015, 1, 1);
            setup_data.createTestData();
            Test.startTest();
                String json = PsoToolController.getInstance().setStartDate(new_years_eve).getFilterValues().JSON();
            Test.stopTest();
            System.assertNotEquals(null, json);
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
        new_instance.StartDate = Date.newInstance(2015, 1, 1);
        new_instance.EndDate = Date.newInstance(2015, 2, 28);
        new_instance.ShowAllOpportunities = true;
        new_instance.ShowAllContacts = true;
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
                '{"Title":"Consultant","Statistics":null,"Staffing":null,"ResourceName":null,"LastName":"Batman","ContactId":null,"AccountName":"YOUR SL GmbH"},' +
                '{"Title":"Consultant","Statistics":null,"Staffing":null,"ResourceName":null,"LastName":"Superman","ContactId":null,"AccountName":"YOUR SL GmbH"},' +
                '{"Title":"Developer","Statistics":null,"Staffing":null,"ResourceName":null,"LastName":"Batman","ContactId":null,"AccountName":"YOUR SL GmbH"},' +
                '{"Title":"Developer","Statistics":null,"Staffing":null,"ResourceName":null,"LastName":"Batman","ContactId":null,"AccountName":"Some company"},' +
                '{"Title":"Developer","Statistics":null,"Staffing":null,"ResourceName":null,"LastName":"Batman","ContactId":null,"AccountName":"Some zalando company"}]}';
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
                List<PsoToolController.Stats> stats = new_instance.getStatsForOppLineItem(setup_data.FirstLineItem.Id);
            Test.stopTest();
            System.assertEquals(0, stats.size());
        }
    }

    @isTest static void testGetStatsForContactCreatesStats(){
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
                List<PsoToolController.Stats> stats = new_instance.getStatsForContact(setup_data.TestContact.Id);
            Test.stopTest();
            System.assertEquals(1, stats.size());
            System.assertEquals(setup_data.ActualNumbers.Days__c + '/' +setup_data.PlannedNumbers.Days__c, stats.get(0).Days);
            System.assertEquals(setup_data.ActualNumbers.Revenue__c + '/' + setup_data.PlannedNumbers.Revenue__c, stats.get(0).Revenue);
            System.assertEquals(setup_data.PlannedNumbers.Start_Date__c, Date.parse(stats.get(0).StartDate));
            System.assertEquals(setup_data.PlannedNumbers.End_Date__c, Date.parse(stats.get(0).EndDate));
        }
    }

    @isTest static void testGetDataSetThatReturnsAllOpportunitiesAndAllContacts() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Date date_of_execution = Date.newInstance(2015, 1, 1);
            setup_data.createTestData();
            Test.startTest();
                Object data_set = PsoToolController.getInstance().showAllOpportunities().showAllContacts().setStartDate(date_of_execution).getDataSet();
            Test.stopTest();
            System.assert(data_set instanceof PsoToolController.PsoToolDataSetWrapper, 'Method should return an instance of PsoToolDataSetWrapper class');
            PsoToolController.PsoToolDataSetWrapper data_set_object = (PsoToolController.PsoToolDataSetWrapper)data_set;
            System.assertNotEquals(null, data_set_object.StartDate, 'StartDate should be set');
            System.assertNotEquals(null, data_set_object.EndDate, 'EndDate should be set');
            System.assertNotEquals(null, data_set_object.Customers);
            System.assertEquals(2, data_set_object.Customers.size());
            System.assertNotEquals(null, data_set_object.Resources);
            System.assertEquals(2, data_set_object.Resources.size());
        }
    }

    @isTest static void testGetDataSetThatReturnsAllOpportunities() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Date date_of_execution = Date.newInstance(2015, 1, 1);
            setup_data.createTestData();
            Test.startTest();
                Object data_set = PsoToolController.getInstance().showAllOpportunities().setStartDate(date_of_execution).getDataSet();
            Test.stopTest();
            System.assert(data_set instanceof PsoToolController.PsoToolDataSetWrapper, 'Method should return an instance of PsoToolDataSetWrapper class');
            PsoToolController.PsoToolDataSetWrapper data_set_object = (PsoToolController.PsoToolDataSetWrapper)data_set;
            System.assertNotEquals(null, data_set_object.StartDate, 'StartDate should be set');
            System.assertNotEquals(null, data_set_object.EndDate, 'EndDate should be set');
            System.assertNotEquals(null, data_set_object.Customers);
            System.assertEquals(2, data_set_object.Customers.size());
            System.assertNotEquals(null, data_set_object.Resources);
        }
    }

    @isTest static void testGetDataSetThatReturnsAllOpportunitiesForSelectedContacts() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Date date_of_execution = Date.newInstance(2015, 1, 1);
            setup_data.createTestData();
            List<Id> contact_ids = new List<Id>();
            contact_ids.add(setup_data.SecondTestContact.Id);
            Test.startTest();
                Object data_set = PsoToolController.getInstance().showAllOpportunities().setSelectedContacts(contact_ids).setStartDate(date_of_execution).getDataSet();
            Test.stopTest();
            System.assert(data_set instanceof PsoToolController.PsoToolDataSetWrapper, 'Method should return an instance of PsoToolDataSetWrapper class');
            PsoToolController.PsoToolDataSetWrapper data_set_object = (PsoToolController.PsoToolDataSetWrapper)data_set;
            System.assertNotEquals(null, data_set_object.StartDate, 'StartDate should be set');
            System.assertNotEquals(null, data_set_object.EndDate, 'EndDate should be set');
            System.assertNotEquals(null, data_set_object.Customers);
            System.assertEquals(2, data_set_object.Customers.size());
            System.assertNotEquals(null, data_set_object.Resources);
            System.assertEquals(1, data_set_object.Resources.size());
        }
    }

    @isTest static void testGetDataSetThatReturnsSelectedOpportunitiesForAllContacts() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Date date_of_execution = Date.newInstance(2015, 1, 1);
            setup_data.createTestData();
            List<Id> opportunities_ids = new List<Id>();
            opportunities_ids.add(setup_data.SecondOpportunity.Id);
            Test.startTest();
                Object data_set = PsoToolController.getInstance().showAllContacts().setSelectedOpportunities(opportunities_ids).setStartDate(date_of_execution).getDataSet();
            Test.stopTest();
            System.assert(data_set instanceof PsoToolController.PsoToolDataSetWrapper, 'Method should return an instance of PsoToolDataSetWrapper class');
            PsoToolController.PsoToolDataSetWrapper data_set_object = (PsoToolController.PsoToolDataSetWrapper)data_set;
            System.assertNotEquals(null, data_set_object.StartDate, 'StartDate should be set');
            System.assertNotEquals(null, data_set_object.EndDate, 'EndDate should be set');
            System.assertNotEquals(null, data_set_object.Customers);
            System.assertEquals(1, data_set_object.Customers.size());
            System.assertNotEquals(null, data_set_object.Resources);
            System.assertEquals(2, data_set_object.Resources.size());
        }
    }

    @isTest static void testGetDataSetThatReturnsSelectedOpportunitiesForSelectedContacts() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Date date_of_execution = Date.newInstance(2015, 1, 1);
            setup_data.createTestData();
            List<Id> contact_ids = new List<Id>();
            contact_ids.add(setup_data.SecondTestContact.Id);
            List<Id> opportunities_ids = new List<Id>();
            opportunities_ids.add(setup_data.SecondOpportunity.Id);
            Test.startTest();
                Object data_set = PsoToolController.getInstance().setSelectedContacts(contact_ids).setSelectedOpportunities(opportunities_ids).setStartDate(date_of_execution).getDataSet();
            Test.stopTest();
            System.assert(data_set instanceof PsoToolController.PsoToolDataSetWrapper, 'Method should return an instance of PsoToolDataSetWrapper class');
            PsoToolController.PsoToolDataSetWrapper data_set_object = (PsoToolController.PsoToolDataSetWrapper)data_set;
            System.assertNotEquals(null, data_set_object.StartDate, 'StartDate should be set');
            System.assertNotEquals(null, data_set_object.EndDate, 'EndDate should be set');
            System.assertNotEquals(null, data_set_object.Customers);
            System.assertEquals(1, data_set_object.Customers.size());
            System.assertNotEquals(null, data_set_object.Resources);
            System.assertEquals(1, data_set_object.Resources.size());
        }
    }

    @isTest static void testGetDataSetThatReturnsSelectedOpportunities() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Date date_of_execution = Date.newInstance(2015, 1, 1);
            setup_data.createTestData();
            List<Id> opportunities_ids = new List<Id>();
            opportunities_ids.add(setup_data.SecondOpportunity.Id);
            Test.startTest();
                Object data_set = PsoToolController.getInstance().setSelectedOpportunities(opportunities_ids).setStartDate(date_of_execution).getDataSet();
            Test.stopTest();
            System.assert(data_set instanceof PsoToolController.PsoToolDataSetWrapper, 'Method should return an instance of PsoToolDataSetWrapper class');
            PsoToolController.PsoToolDataSetWrapper data_set_object = (PsoToolController.PsoToolDataSetWrapper)data_set;
            System.assertNotEquals(null, data_set_object.StartDate, 'StartDate should be set');
            System.assertNotEquals(null, data_set_object.EndDate, 'EndDate should be set');
            System.assertNotEquals(null, data_set_object.Customers);
            System.assertEquals(1, data_set_object.Customers.size());
            System.assertNotEquals(null, data_set_object.Resources);
        }
    }

    @isTest static void testGetDataSetThatReturnsAllContacts() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Date date_of_execution = Date.newInstance(2015, 1, 1);
            setup_data.createTestData();
            Test.startTest();
                Object data_set = PsoToolController.getInstance().showAllContacts().setStartDate(date_of_execution).getDataSet();
            Test.stopTest();
            System.assert(data_set instanceof PsoToolController.PsoToolDataSetWrapper, 'Method should return an instance of PsoToolDataSetWrapper class');
            PsoToolController.PsoToolDataSetWrapper data_set_object = (PsoToolController.PsoToolDataSetWrapper)data_set;
            System.assertNotEquals(null, data_set_object.StartDate, 'StartDate should be set');
            System.assertNotEquals(null, data_set_object.EndDate, 'EndDate should be set');
            System.assertEquals(null, data_set_object.Customers);
            System.assertNotEquals(null, data_set_object.Resources);
            System.assertEquals(2, data_set_object.Resources.size());
        }
    }

    @isTest static void testGetDataSetThatReturnsSelectedContacts() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Date date_of_execution = Date.newInstance(2015, 1, 1);
            setup_data.createTestData();
            List<Id> contact_ids = new List<Id>();
            contact_ids.add(setup_data.SecondTestContact.Id);
            Test.startTest();
                Object data_set = PsoToolController.getInstance().setSelectedContacts(contact_ids).setStartDate(date_of_execution).getDataSet();
            Test.stopTest();
            System.assert(data_set instanceof PsoToolController.PsoToolDataSetWrapper, 'Method should return an instance of PsoToolDataSetWrapper class');
            PsoToolController.PsoToolDataSetWrapper data_set_object = (PsoToolController.PsoToolDataSetWrapper)data_set;
            System.assertNotEquals(null, data_set_object.StartDate, 'StartDate should be set');
            System.assertNotEquals(null, data_set_object.EndDate, 'EndDate should be set');
            System.assertEquals(null, data_set_object.Customers);
            System.assertNotEquals(null, data_set_object.Resources);
            System.assertEquals(1, data_set_object.Resources.size());
        }
    }

    @isTest static void testGetDataSetThatReturnsNoCustomersWhenNothingIsSelected() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Date date_of_execution = Date.newInstance(2015, 1, 1);
            setup_data.createTestData();
            List<Id> contact_ids = new List<Id>();
            contact_ids.add(setup_data.SecondTestContact.Id);
            Test.startTest();
                Object data_set = PsoToolController.getInstance().setStartDate(date_of_execution).getDataSet();
            Test.stopTest();
            System.assert(data_set instanceof PsoToolController.PsoToolDataSetWrapper, 'Method should return an instance of PsoToolDataSetWrapper class');
            PsoToolController.PsoToolDataSetWrapper data_set_object = (PsoToolController.PsoToolDataSetWrapper)data_set;
            System.assertNotEquals(null, data_set_object.StartDate, 'StartDate should be set');
            System.assertNotEquals(null, data_set_object.EndDate, 'EndDate should be set');
            System.assertEquals(null, data_set_object.Customers);
        }
    }

    private class SetupDataClass {
        public Account FirstAccount;
        public Account SecondAccount;
        public Contact TestContact;
        public Contact SecondTestContact;
        public Opportunity FirstOpportunity;
        public Opportunity SecondOpportunity;
        public Opportunity HolidayOpportunity;
        public OpportunityLineItem FirstLineItem;
        public OpportunityLineItem SecondLineItem;
        public OpportunityLineItem ThirdLineItem;
        public OpportunityLineItem ForthLineItem;
        public OpportunityLineItem HolidayLineItem;
        public PricebookEntry TestPricebookEntry;
        public Product2 TestProduct;
        public User TestUser;
        public User AnotherUser;
        public OpportunityLineItemSchedule Schedule;
        public Planning_statistics__c PlannedNumbers;
        public Planning_statistics__c ActualNumbers;
        public Planning_statistics__c AdditionalPlannedNumbers;
        public Planning_statistics__c AdditionalActualNumbers;
        private String DesiredProfile = 'System Administrator';

        public SetupDataClass() {
            TestUser = UserUtility.createNewUser(DesiredProfile);
            insert TestUser;
        }

        public SetupDataClass(String desired_profile){
            DesiredProfile = desired_profile;
            TestUser = UserUtility.createNewUser(DesiredProfile);
            insert TestUser;
        }

        public void createAnotherUser(){
            AnotherUser = UserUtility.createNewUser(DesiredProfile);
            insert AnotherUser;
        }

        public void createTestData() {
            createAndInsertAccounts();
            createAndInsertContacts();
            createAndInsertOpportunities();
            createAndInsertProduct();
            createAndInsertPriceBookEntry();
            makeTheTestUserToBeOpportunityMember();
            createOpportunityLineItems();
            createOpportunityLineItemsSchedule();
        }

        public void createTestDataForAdmins() {
            createAndInsertAccounts();
            createAndInsertContacts();
            createAndInsertOpportunities();
            createAndInsertProduct();
            createAndInsertPriceBookEntry();
            createOpportunityLineItems();
            createOpportunityLineItemsSchedule();
        }

        private void createAndInsertAccounts(){
            FirstAccount = new Account();
            FirstAccount.Name = 'First company';
            SecondAccount = new Account();
            SecondAccount.Name = 'Second company';
            insert new List<Sobject> {FirstAccount, SecondAccount};
        }

        private void createAndInsertContacts() {
            TestContact = new Contact();
            TestContact.FirstName = testUser.FirstName;
            TestContact.LastName = testUser.LastName;
            TestContact.Inactive__c = false;
            TestContact.RecordTypeId = '012D0000000QokP';
            insert TestContact;
            SecondTestContact = new Contact();
            SecondTestContact.FirstName = 'Michel';
            SecondTestContact.LastName = 'Yakovtsov';
            SecondTestContact.Inactive__c = false;
            SecondTestContact.RecordTypeId = '012D0000000QokP';
            insert SecondTestContact;
        }

        private void createAndInsertProduct() {
            TestProduct = new Product2();
            TestProduct.Name = 'Salesforce Developer';
            TestProduct.isActive = true;
            TestProduct.CanUseQuantitySchedule = true;
            insert TestProduct;
        }

        private void createAndInsertPriceBookEntry(){
            TestPricebookEntry = new PricebookEntry();
            TestPricebookEntry.Pricebook2Id = Test.getStandardPricebookId();
            TestPricebookEntry.Product2Id = TestProduct.Id;
            TestPricebookEntry.UnitPrice = 99;
            TestPricebookEntry.isActive = true;
            insert TestPricebookEntry;
        }

        private void createAndInsertOpportunities(){
            FirstOpportunity = new Opportunity();
            FirstOpportunity.Name = '° Roshen';
            FirstOpportunity.StageName = '° Roshen';
            FirstOpportunity.PriceBook2Id = Test.getStandardPricebookId();
            FirstOpportunity.AccountId = FirstAccount.Id;
            FirstOpportunity.CloseDate = Date.newInstance(2015, 1, 1);
            FirstOpportunity.Projektleiter_YOUR_SL__c = TestContact.Id;
            FirstOpportunity.Managed_by_PSO_Tool__c = true;
            FirstOpportunity.Projektstatus__c = 'Terrible';
            SecondOpportunity = new Opportunity();
            SecondOpportunity.Name = 'Apple iWatch';
            SecondOpportunity.StageName = 'iWatch';
            SecondOpportunity.PriceBook2Id = Test.getStandardPricebookId();
            SecondOpportunity.AccountId = SecondAccount.Id;
            SecondOpportunity.CloseDate = Date.newInstance(2015, 1, 1);
            SecondOpportunity.Projektleiter_YOUR_SL__c = TestContact.Id;
            SecondOpportunity.Managed_by_PSO_Tool__c = true;
            FirstOpportunity.Projektstatus__c = 'Fishy';
            insert new List<Sobject> {FirstOpportunity, SecondOpportunity};
        }

        private void makeTheTestUserToBeOpportunityMember(){
            OpportunityTeamMember first_member = new OpportunityTeamMember();
            first_member.UserId = TestUser.Id;
            first_member.OpportunityId = FirstOpportunity.Id;
            OpportunityTeamMember second_member = new OpportunityTeamMember();
            second_member.UserId = TestUser.Id;
            second_member.OpportunityId = SecondOpportunity.Id;
            insert new List<Sobject> {first_member, second_member};
        }

        private void createOpportunityLineItems(){
            FirstLineItem = new OpportunityLineItem();
            FirstLineItem.Contact__c = TestContact.Id;
            FirstLineItem.PricebookEntryId = TestPricebookEntry.Id;
            FirstLineItem.ServiceDate = Date.newInstance(2015, 1, 10);
            FirstLineItem.UnitPrice = 1200;
            FirstLineItem.Quantity = 1;
            FirstLineItem.Unit__c = 'Manntag(e)';
            FirstLineItem.OpportunityId = FirstOpportunity.Id;
            SecondLineItem = new OpportunityLineItem();
            SecondLineItem.Contact__c = TestContact.Id;
            SecondLineItem.PricebookEntryId = TestPricebookEntry.Id;
            SecondLineItem.ServiceDate = Date.newInstance(2015, 1, 10);
            SecondLineItem.UnitPrice = 1200;
            SecondLineItem.Quantity = 1.5;
            SecondLineItem.Unit__c = 'Manntag(e)';
            SecondLineItem.OpportunityId = SecondOpportunity.Id;
            ThirdLineItem = new OpportunityLineItem();
            ThirdLineItem.Contact__c = TestContact.Id;
            ThirdLineItem.PricebookEntryId = TestPricebookEntry.Id;
            ThirdLineItem.ServiceDate = Date.newInstance(2015, 2, 10);
            ThirdLineItem.UnitPrice = 1200;
            ThirdLineItem.Quantity = 10;
            ThirdLineItem.Unit__c = 'Manntag(e)';
            ThirdLineItem.OpportunityId = SecondOpportunity.Id;
            ForthLineItem = new OpportunityLineItem();
            ForthLineItem.Contact__c = SecondTestContact.Id;
            ForthLineItem.PricebookEntryId = TestPricebookEntry.Id;
            ForthLineItem.ServiceDate = Date.newInstance(2015, 2, 10);
            ForthLineItem.UnitPrice = 1200;
            ForthLineItem.Quantity = 10;
            ForthLineItem.Unit__c = 'Manntag(e)';
            ForthLineItem.OpportunityId = SecondOpportunity.Id;
            insert new List<Sobject> {FirstLineItem, SecondLineItem, ThirdLineItem, ForthLineItem};
        }

        private void createOpportunityLineItemsSchedule(){
            Schedule = new OpportunityLineItemSchedule();
            Schedule.OpportunityLineItemId = FirstLineItem.Id;
            Schedule.ScheduleDate = Date.newInstance(2015, 1, 10);
            Schedule.Quantity = 1;
            Schedule.Type = 'Quantity';
            OpportunityLineItemSchedule second_schedule = new OpportunityLineItemSchedule();
            second_schedule.OpportunityLineItemId = SecondLineItem.Id;
            second_schedule.ScheduleDate = Date.newInstance(2015, 1, 10);
            second_schedule.Quantity = 1;
            second_schedule.Type = 'Quantity';
            OpportunityLineItemSchedule third_schedule = new OpportunityLineItemSchedule();
            third_schedule.OpportunityLineItemId = SecondLineItem.Id;
            third_schedule.ScheduleDate = Date.newInstance(2015, 1, 11);
            third_schedule.Quantity = 0.5;
            third_schedule.Type = 'Quantity';
            OpportunityLineItemSchedule forth_schedule = new OpportunityLineItemSchedule();
            forth_schedule.OpportunityLineItemId = SecondLineItem.Id;
            forth_schedule.ScheduleDate = Date.newInstance(2015, 4, 11);
            forth_schedule.Quantity = 0.4;
            forth_schedule.Type = 'Quantity';
            OpportunityLineItemSchedule fifth_schedule = new OpportunityLineItemSchedule();
            fifth_schedule.OpportunityLineItemId = SecondLineItem.Id;
            fifth_schedule.ScheduleDate = Date.newInstance(2015, 4, 11);
            fifth_schedule.Quantity = 0.4;
            fifth_schedule.Type = 'Quantity';
            insert new List<Sobject> {Schedule, second_schedule, third_schedule, forth_schedule, fifth_schedule};
        }

        public void createHolidayOpportunityAndTestDataForIt(){
            createAndInsertAccounts();
            createAndInsertContacts();
            createHolidayOpportunity();
            createAndInsertProduct();
            createAndInsertPriceBookEntry();
            makeTheTestUserToBeTheHolidayOpportunityMember();
            createHolidayOpportunityLineItem();
        }

        private void createHolidayOpportunity(){
            HolidayOpportunity = new Opportunity();
            HolidayOpportunity.Name = PsoToolController.SPECIAL_OPPORTUNITY;
            HolidayOpportunity.StageName = PsoToolController.SPECIAL_OPPORTUNITY;
            HolidayOpportunity.PriceBook2Id = Test.getStandardPricebookId();
            HolidayOpportunity.AccountId = FirstAccount.Id;
            HolidayOpportunity.CloseDate = Date.newInstance(2015, 1, 1);
            HolidayOpportunity.Projektleiter_YOUR_SL__c = TestContact.Id;
            HolidayOpportunity.Managed_by_PSO_Tool__c = true;
            insert HolidayOpportunity;
        }

        private void makeTheTestUserToBeTheHolidayOpportunityMember(){
            OpportunityTeamMember first_member = new OpportunityTeamMember();
            first_member.UserId = TestUser.Id;
            first_member.OpportunityId = HolidayOpportunity.Id;
            insert first_member;
        }

        private void createHolidayOpportunityLineItem(){
            HolidayLineItem = new OpportunityLineItem();
            HolidayLineItem.Contact__c = TestContact.Id;
            HolidayLineItem.PricebookEntryId = TestPricebookEntry.Id;
            HolidayLineItem.ServiceDate = Date.newInstance(2015, 1, 10);
            HolidayLineItem.UnitPrice = 1200;
            HolidayLineItem.Quantity = 1;
            HolidayLineItem.Unit__c = 'Manntag(e)';
            HolidayLineItem.OpportunityId = HolidayOpportunity.Id;
            insert HolidayLineItem;
        }

        public void createPlannedStatisticalData(){
            PlannedNumbers = new Planning_statistics__c();
            PlannedNumbers.Data_Type__c = PsoToolController.PLANNED_STATISTIC_TYPE;
            PlannedNumbers.Days__c = 5;
            PlannedNumbers.Revenue__c = 1000;
            PlannedNumbers.OpportunityLineItemId__c = FirstLineItem.Id;
            PlannedNumbers.Start_Date__c = Date.newInstance(2015, 1, 1);
            PlannedNumbers.End_Date__c = Date.newInstance(2015, 1, 31);
            PlannedNumbers.Time_Type__c = 'Monthly';
            PlannedNumbers.Contact__c = TestContact.Id;
            insert PlannedNumbers;
        }

        public void createActualStatisticalData(){
            ActualNumbers = new Planning_statistics__c();
            ActualNumbers.Data_Type__c = PsoToolController.ACTUAL_STATISTIC_TYPE;
            ActualNumbers.Days__c = 10;
            ActualNumbers.Revenue__c = 2000;
            ActualNumbers.OpportunityLineItemId__c = FirstLineItem.Id;
            ActualNumbers.Start_Date__c = Date.newInstance(2015, 1, 1);
            ActualNumbers.End_Date__c = Date.newInstance(2015, 1, 31);
            ActualNumbers.Time_Type__c = 'Monthly';
            ActualNumbers.Contact__c = TestContact.Id;
            insert ActualNumbers;
        }

        public void createAdditionalStatisticalData(){
            AdditionalPlannedNumbers = new Planning_statistics__c();
            AdditionalPlannedNumbers.Data_Type__c = PsoToolController.PLANNED_STATISTIC_TYPE;
            AdditionalPlannedNumbers.Days__c = 7;
            AdditionalPlannedNumbers.Revenue__c = 1500;
            AdditionalPlannedNumbers.OpportunityLineItemId__c = this.SecondLineItem.Id;
            AdditionalPlannedNumbers.Start_Date__c = Date.newInstance(2015, 1, 1);
            AdditionalPlannedNumbers.End_Date__c = Date.newInstance(2015, 1, 31);
            AdditionalPlannedNumbers.Time_Type__c = 'Monthly';
            AdditionalPlannedNumbers.Contact__c = TestContact.Id;
            AdditionalActualNumbers = new Planning_statistics__c();
            AdditionalActualNumbers.Data_Type__c = PsoToolController.ACTUAL_STATISTIC_TYPE;
            AdditionalActualNumbers.Days__c = 14;
            AdditionalActualNumbers.Revenue__c = 300;
            AdditionalActualNumbers.OpportunityLineItemId__c = SecondLineItem.Id;
            AdditionalActualNumbers.Start_Date__c = Date.newInstance(2015, 1, 1);
            AdditionalActualNumbers.End_Date__c = Date.newInstance(2015, 1, 31);
            AdditionalActualNumbers.Time_Type__c = 'Monthly';
            AdditionalActualNumbers.Contact__c = this.TestContact.Id;
            insert new List<Sobject> {AdditionalPlannedNumbers, AdditionalActualNumbers};
        }
    }
}