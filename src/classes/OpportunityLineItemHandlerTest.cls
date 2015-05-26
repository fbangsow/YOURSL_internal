@isTest
private class OpportunityLineItemHandlerTest {

    @isTest static void testInsertingSchedulesCreatesInsertEntryOfResourceSchedule() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData();
            Test.startTest();
                setup_data.createOpportunityLineItemsSchedule();
            Test.stopTest();
            List<Resource_Schedule__c> related_resource_schedules = [SELECT ContactId__c, Event__c, Old_value__c, New_value__c, Scheduled_Date__c, OpportunityLineItemScheduleId__c
                                FROM Resource_Schedule__c WHERE OpportunityLineItemScheduleId__c =: setup_data.schedule.Id];
            System.assertEquals(1, related_resource_schedules.size());
            System.assertEquals(setup_data.testContact.Id, related_resource_schedules.get(0).ContactId__c);
            System.assertEquals(0, Decimal.valueOf(related_resource_schedules.get(0).Old_value__c));
            System.assertEquals(OpportunityLineItemScheduleTracker.INSERT_EVENT_TYPE, related_resource_schedules.get(0).Event__c);
            System.assertEquals(setup_data.schedule.ScheduleDate, related_resource_schedules.get(0).Scheduled_Date__c);
            System.assertEquals(setup_data.schedule.Quantity, Decimal.valueOf(related_resource_schedules.get(0).New_value__c));
            System.assertEquals(setup_data.schedule.Id, related_resource_schedules.get(0).OpportunityLineItemScheduleId__c);
        }
    }

    @isTest static void testUpdatingSchedulesCreatesUpdateEntryOfResourceSchedule() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData();
            setup_data.createOpportunityLineItemsSchedule();
            setup_data.schedule.Quantity = 0.5;
            OpportunityLineItemScheduleTracker.AlreadyRun = false;
            OpportunityLineItemScheduleTracker.AlreadyProcessed = false;
            Test.startTest();
                update setup_data.schedule;
            Test.stopTest();
            List<Resource_Schedule__c> related_resource_schedules = [SELECT ContactId__c, Event__c, Old_value__c, New_value__c, Scheduled_Date__c, OpportunityLineItemScheduleId__c
                                FROM Resource_Schedule__c WHERE OpportunityLineItemScheduleId__c =: setup_data.schedule.Id];
            System.assertEquals(1, related_resource_schedules.size());
            System.assertEquals(setup_data.testContact.Id, related_resource_schedules.get(0).ContactId__c);
            System.assertEquals(1, Decimal.valueOf(related_resource_schedules.get(0).Old_value__c));
            System.assertEquals(OpportunityLineItemScheduleTracker.UPDATE_EVENT_TYPE, related_resource_schedules.get(0).Event__c);
            System.assertEquals(setup_data.schedule.ScheduleDate, related_resource_schedules.get(0).Scheduled_Date__c);
            System.assertEquals(0.5, Decimal.valueOf(related_resource_schedules.get(0).New_value__c));
            System.assertEquals(setup_data.schedule.Id, related_resource_schedules.get(0).OpportunityLineItemScheduleId__c);
        }
    }

    @isTest static void testDeletingSchedulesCreatesUpdateEntryOfResourceSchedule() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData();
            setup_data.createOpportunityLineItemsSchedule();
            setup_data.schedule.Quantity = 0;
            OpportunityLineItemScheduleTracker.AlreadyRun = false;
            OpportunityLineItemScheduleTracker.AlreadyProcessed = false;
            Test.startTest();
                update setup_data.schedule;
            Test.stopTest();
            List<Resource_Schedule__c> related_resource_schedules = [SELECT ContactId__c, Event__c, Old_value__c, New_value__c, Scheduled_Date__c, OpportunityLineItemScheduleId__c
                                FROM Resource_Schedule__c WHERE OpportunityLineItemScheduleId__c =: setup_data.schedule.Id];
            System.assertEquals(1, related_resource_schedules.size());
            System.assertEquals(setup_data.testContact.Id, related_resource_schedules.get(0).ContactId__c);
            System.assertEquals(1, Decimal.valueOf(related_resource_schedules.get(0).Old_value__c));
            System.assertEquals(OpportunityLineItemScheduleTracker.DELETE_EVENT_TYPE, related_resource_schedules.get(0).Event__c);
            System.assertEquals(setup_data.schedule.ScheduleDate, related_resource_schedules.get(0).Scheduled_Date__c);
            System.assertEquals(0, Decimal.valueOf(related_resource_schedules.get(0).New_value__c));
            System.assertEquals(setup_data.schedule.Id, related_resource_schedules.get(0).OpportunityLineItemScheduleId__c);
        }
    }

    @isTest static void testInsertingSchedulesInsertsUnplannedSchedule() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData();
            Test.startTest();
                setup_data.createOpportunityLineItemsSchedule();
            Test.stopTest();
            List<OpportunityLineItemSchedule> unplanned_schedules = [SELECT Id, OpportunityLineItem.Id, Quantity FROM OpportunityLineItemSchedule WHERE OpportunityLineItem.Id = :setup_data.firstLineItem.Id AND Description =: OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT];
            System.assertEquals(1, unplanned_schedules.size());
            System.assertEquals(setup_data.firstLineItem.Quantity - setup_data.schedule.Quantity, unplanned_schedules.get(0).Quantity);
            OpportunityLineItem changed_item = [SELECT UnitPrice, Quantity FROM OpportunityLineItem WHERE id =: setup_data.firstLineItem.Id];
            System.assertEquals(setup_data.firstLineItem.UnitPrice ,changed_item.UnitPrice);
            System.assertEquals(setup_data.firstLineItem.Quantity ,changed_item.Quantity);
        }
    }

    @isTest static void testUpdatingSchedulesInsertsUnplannedSchedule() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData();
            setup_data.createOpportunityLineItemsSchedule();
            setup_data.schedule.Quantity = 0.1;
            Test.startTest();
                update setup_data.schedule;
            Test.stopTest();
            List<OpportunityLineItemSchedule> unplanned_schedules = [SELECT Id, OpportunityLineItem.Id, Quantity FROM OpportunityLineItemSchedule WHERE OpportunityLineItem.Id = :setup_data.firstLineItem.Id AND Description =: OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT];
            System.assertEquals(1, unplanned_schedules.size());
            System.assertEquals(setup_data.firstLineItem.Quantity - setup_data.schedule.Quantity, unplanned_schedules.get(0).Quantity);
            OpportunityLineItem changed_item = [SELECT UnitPrice, Quantity FROM OpportunityLineItem WHERE id =: setup_data.firstLineItem.Id];
            System.assertEquals(setup_data.firstLineItem.UnitPrice ,changed_item.UnitPrice);
            System.assertEquals(setup_data.firstLineItem.Quantity ,changed_item.Quantity);
        }
    }

    @isTest static void testDeletingSchedulesInsertsUnplannedSchedule() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData();
            setup_data.createOpportunityLineItemsSchedule();
            setup_data.schedule.Quantity = 0;
            Test.startTest();
                update setup_data.schedule;
            Test.stopTest();
            List<OpportunityLineItemSchedule> unplanned_schedules = [SELECT Id, OpportunityLineItem.Id, Quantity FROM OpportunityLineItemSchedule WHERE OpportunityLineItem.Id = :setup_data.firstLineItem.Id AND Description =: OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT];
            System.assertEquals(1, unplanned_schedules.size());
            System.assertEquals(setup_data.firstLineItem.Quantity - setup_data.schedule.Quantity, unplanned_schedules.get(0).Quantity);
            OpportunityLineItem changed_item = [SELECT UnitPrice, Quantity FROM OpportunityLineItem WHERE id =: setup_data.firstLineItem.Id];
            System.assertEquals(setup_data.firstLineItem.UnitPrice ,changed_item.UnitPrice);
            System.assertEquals(setup_data.firstLineItem.Quantity ,changed_item.Quantity);
        }
    }

    @isTest static void testInsertintScheduleUpdatesItsDescription() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData();
            Test.startTest();
                setup_data.createOpportunityLineItemsSchedule();
            Test.stopTest();
            List<OpportunityLineItemSchedule> planned_schedules = [SELECT Id, OpportunityLineItem.Id, Quantity, Description FROM OpportunityLineItemSchedule WHERE OpportunityLineItem.Id = :setup_data.firstLineItem.Id AND Description !=: OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT];
            System.assertEquals(1, planned_schedules.size());
            System.assertEquals(setup_data.schedule.Quantity, Decimal.valueOf(planned_schedules.get(0).Description));
        }
    }

    @isTest static void testUpdatingScheduleUpdatesItsDescription() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData();
            setup_data.createOpportunityLineItemsSchedule();
            Decimal new_value = 0.1;
            setup_data.schedule.Quantity = new_value;
            Test.startTest();
                update setup_data.schedule;
            Test.stopTest();
            List<OpportunityLineItemSchedule> planned_schedules = [SELECT Id, OpportunityLineItem.Id, Quantity, Description FROM OpportunityLineItemSchedule WHERE OpportunityLineItem.Id = :setup_data.firstLineItem.Id AND Description !=: OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT];
            System.assertEquals(1, planned_schedules.size());
            System.assertEquals(setup_data.schedule.Quantity, Decimal.valueOf(planned_schedules.get(0).Description));
        }
    }

    private class SetupDataClass {
        public Account firstAccount;
        public Contact testContact;
        public Opportunity firstOpportunity;
        public OpportunityLineItem firstLineItem;
        public OpportunityLineItem anotherLineItem;
        public PricebookEntry testPricebookEntry;
        public Product2 testProduct;
        public OpportunityLineItemSchedule schedule;
        public User testUser;
        private final String DESIRED_PROFILE = 'System Administrator';

        public SetupDataClass() {
            this.testUser = UserUtility.createNewUser(DESIRED_PROFILE);
            insert testUser;
        }

        public void createTestData() {
            createAndInsertAccounts();
            createAndInsertContactForUser();
            createAndInsertOpportunities();
            createAndInsertProduct();
            createAndInsertPriceBookEntry();
            makeTheTestUserToBeOpportunityMember();
            createOpportunityLineItems();
        }

        private void createAndInsertAccounts(){
            this.firstAccount = new Account();
            this.firstAccount.Name = 'First company';
            insert new List<Sobject> {this.firstAccount};
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
            insert new List<Sobject> {this.firstOpportunity};
        }

        private void makeTheTestUserToBeOpportunityMember(){
            OpportunityTeamMember firstMember = new OpportunityTeamMember();
            firstMember.UserId = this.testUser.Id;
            firstMember.OpportunityId = this.firstOpportunity.Id;
            insert new List<Sobject> {firstMember};
        }

        private void createOpportunityLineItems(){
            this.firstLineItem = new OpportunityLineItem();
            this.firstLineItem.Contact__c = this.testContact.Id;
            this.firstLineItem.PricebookEntryId = this.testPricebookEntry.Id;
            this.firstLineItem.ServiceDate = Date.newInstance(2015, 1, 10);
            this.firstLineItem.UnitPrice = 1200;
            this.firstLineItem.Quantity = 10;
            this.firstLineItem.Unit__c = 'Manntag(e)';
            this.firstLineItem.OpportunityId = this.firstOpportunity.Id;
            this.firstOpportunity.Managed_by_PSO_Tool__c = true;
            insert new List<Sobject> {this.firstLineItem};
        }

        public void createOpportunityLineItemsSchedule(){
            schedule = new OpportunityLineItemSchedule();
            schedule.OpportunityLineItemId = this.firstLineItem.Id;
            schedule.ScheduleDate = Date.newInstance(2015, 1, 10);
            schedule.Quantity = 1;
            schedule.Type = 'Quantity';
            insert schedule;
        }
    }
}