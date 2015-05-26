@isTest
private class OpportunityLineItemScheduleTrackerTest {

    @isTest static void testGetInstanceReturnsTheSameObject() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Test.startTest();
                OpportunityLineItemScheduleTracker new_instance = OpportunityLineItemScheduleTracker.getInstance();
            Test.stopTest();
            System.assertEquals(OpportunityLineItemScheduleTracker.getInstance(), new_instance, 'Singleton should return the same instance');
        }
    }

    @isTest static void testPrepareDataForReflectingScheduleChangesCreatesCorrectDataToBeProcessed() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            OpportunityLineItemScheduleTracker new_instance = OpportunityLineItemScheduleTracker.getInstance();
            setup_data.createTestData(true);
            Map<Id, SObject> old_opportunity_line_items = new Map<Id, SObject>();
            old_opportunity_line_items.put(setup_data.firstLineItem.Id, setup_data.firstLineItem);
            OpportunityLineItemScheduleTracker.AlreadyProcessed = false;
            OpportunityLineItemScheduleTracker.AlreadyRun = false;
            Test.startTest();
                new_instance.prepareDataForReflectingScheduleChanges(old_opportunity_line_items);
            Test.stopTest();
            System.assertEquals(1, new_instance.OppLineIdToOpportunityLineItemScheduleWithId.keySet().size());
            System.assert(new_instance.OppLineIdToOpportunityLineItemScheduleWithId.containsKey(setup_data.firstLineItem.Id));
            System.assert(new_instance.OppLineIdToOpportunityLineItemScheduleWithId.get(setup_data.firstLineItem.Id).containsKey(setup_data.schedule.Id));
            System.assertEquals(setup_data.schedule.Id, new_instance.OppLineIdToOpportunityLineItemScheduleWithId.get(setup_data.firstLineItem.Id).get(setup_data.schedule.Id).Id);
            System.assertEquals(1, new_instance.OppLineItemIdToContactId.keySet().size());
            System.assert(new_instance.OppLineItemIdToContactId.containsKey(setup_data.firstLineItem.Id));
            System.assertEquals(setup_data.testContact.Id, new_instance.OppLineItemIdToContactId.get(setup_data.firstLineItem.Id));
            System.assert(OpportunityLineItemScheduleTracker.AlreadyRun);
            System.assert(!OpportunityLineItemScheduleTracker.AlreadyProcessed);
        }
    }

    @isTest static void testCreateResourceScheduleEntriesCreatesEntries() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            OpportunityLineItemScheduleTracker new_instance = OpportunityLineItemScheduleTracker.getInstance();
            setup_data.createTestData(true);
            Map<Id, SObject> old_opportunity_line_items = new Map<Id, SObject>();
            old_opportunity_line_items.put(setup_data.firstLineItem.Id, setup_data.firstLineItem);
            OpportunityLineItemScheduleTracker.AlreadyProcessed = false;
            OpportunityLineItemScheduleTracker.AlreadyRun = false;
            new_instance.prepareDataForReflectingScheduleChanges(old_opportunity_line_items);
            Decimal new_value = 0.5;
            new_instance.OppLineIdToOpportunityLineItemScheduleWithId.get(setup_data.firstLineItem.Id).get(setup_data.schedule.Id).Quantity = new_value;
            Test.startTest();
                new_instance.createResourceScheduleEntries();
            Test.stopTest();
            List<Resource_Schedule__c> related_resource_schedules = [SELECT ContactId__c, Event__c, Old_value__c, New_value__c, Scheduled_Date__c, OpportunityLineItemScheduleId__c
                                FROM Resource_Schedule__c WHERE OpportunityLineItemScheduleId__c =: setup_data.schedule.Id];
            System.assertEquals(1, related_resource_schedules.size());
            System.assertEquals(setup_data.testContact.Id, related_resource_schedules.get(0).ContactId__c);
            System.assertEquals(setup_data.schedule.Quantity, Decimal.valueOf(related_resource_schedules.get(0).Old_value__c));
            System.assertEquals(OpportunityLineItemScheduleTracker.UPDATE_EVENT_TYPE, related_resource_schedules.get(0).Event__c);
            System.assertEquals(setup_data.schedule.ScheduleDate, related_resource_schedules.get(0).Scheduled_Date__c);
            System.assertEquals(new_value, Decimal.valueOf(related_resource_schedules.get(0).New_value__c));
            System.assertEquals(setup_data.schedule.Id, related_resource_schedules.get(0).OpportunityLineItemScheduleId__c);
            System.assert(OpportunityLineItemScheduleTracker.AlreadyProcessed);
        }
    }

    @isTest static void testCreateResourceScheduleEntriesUpdatesExistingRecordIfItExists() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            OpportunityLineItemScheduleTracker new_instance = OpportunityLineItemScheduleTracker.getInstance();
            setup_data.createTestData(true);
            Map<Id, SObject> old_opportunity_line_items = new Map<Id, SObject>();
            old_opportunity_line_items.put(setup_data.firstLineItem.Id, setup_data.firstLineItem);
            OpportunityLineItemScheduleTracker.AlreadyProcessed = false;
            OpportunityLineItemScheduleTracker.AlreadyRun = false;
            new_instance.prepareDataForReflectingScheduleChanges(old_opportunity_line_items);
            new_instance.OppLineIdToOpportunityLineItemScheduleWithId.get(setup_data.firstLineItem.Id).get(setup_data.schedule.Id).Quantity = 0.5;
            new_instance.createResourceScheduleEntries();
            List<Resource_Schedule__c> related_resource_schedules = [SELECT ContactId__c, Event__c, Old_value__c, New_value__c, Scheduled_Date__c, OpportunityLineItemScheduleId__c
                                FROM Resource_Schedule__c WHERE OpportunityLineItemScheduleId__c =: setup_data.schedule.Id];
            OpportunityLineItemScheduleTracker.AlreadyProcessed = false;
            OpportunityLineItemScheduleTracker.AlreadyRun = false;
            Decimal new_value = 1.1;
            new_instance.OppLineIdToOpportunityLineItemScheduleWithId.get(setup_data.firstLineItem.Id).get(setup_data.schedule.Id).Quantity = new_value;
            Test.startTest();
                new_instance.createResourceScheduleEntries();
            Test.stopTest();
            List<Resource_Schedule__c> related_resource_schedules2 = [SELECT ContactId__c, Event__c, Old_value__c, New_value__c, Scheduled_Date__c, OpportunityLineItemScheduleId__c
                                FROM Resource_Schedule__c WHERE OpportunityLineItemScheduleId__c =: setup_data.schedule.Id];
            System.assertEquals(1, related_resource_schedules2.size());
            System.assertEquals(related_resource_schedules.get(0).Id, related_resource_schedules2.get(0).Id);
            System.assertEquals(setup_data.testContact.Id, related_resource_schedules2.get(0).ContactId__c);
            System.assertEquals(setup_data.schedule.Quantity, Decimal.valueOf(related_resource_schedules2.get(0).Old_value__c));
            System.assertEquals(OpportunityLineItemScheduleTracker.UPDATE_EVENT_TYPE, related_resource_schedules2.get(0).Event__c);
            System.assertEquals(setup_data.schedule.ScheduleDate, related_resource_schedules2.get(0).Scheduled_Date__c);
            System.assertEquals(new_value, Decimal.valueOf(related_resource_schedules2.get(0).New_value__c));
            System.assertEquals(setup_data.schedule.Id, related_resource_schedules2.get(0).OpportunityLineItemScheduleId__c);
            System.assert(OpportunityLineItemScheduleTracker.AlreadyProcessed);
        }
    }

    @isTest static void testGetOldValueReturnsZeroForNullDescription() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            OpportunityLineItemScheduleTracker new_instance = OpportunityLineItemScheduleTracker.getInstance();
            Test.startTest();
                String old_value = new_instance.getOldValue(null);
            Test.stopTest();
            System.assertEquals('0', old_value);
        }
    }

    @isTest static void testGetEventCreatesInsertEvent() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            OpportunityLineItemScheduleTracker new_instance = OpportunityLineItemScheduleTracker.getInstance();
            Test.startTest();
                String event = new_instance.getEvent(0, 1);
            Test.stopTest();
            System.assertEquals(OpportunityLineItemScheduleTracker.INSERT_EVENT_TYPE, event);
        }
    }

    @isTest static void testGetEventCreatesDeleteEvent() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            OpportunityLineItemScheduleTracker new_instance = OpportunityLineItemScheduleTracker.getInstance();
            Test.startTest();
                String event = new_instance.getEvent(1, 0);
            Test.stopTest();
            System.assertEquals(OpportunityLineItemScheduleTracker.DELETE_EVENT_TYPE, event);
        }
    }

    @isTest static void testGetEventCreatesUpdateEvent() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            OpportunityLineItemScheduleTracker new_instance = OpportunityLineItemScheduleTracker.getInstance();
            Test.startTest();
                String event = new_instance.getEvent(1, 0.5);
            Test.stopTest();
            System.assertEquals(OpportunityLineItemScheduleTracker.UPDATE_EVENT_TYPE, event);
        }
    }

    private class SetupDataClass {
        public Account firstAccount;
        public Contact testContact;
        public Opportunity firstOpportunity;
        public OpportunityLineItem firstLineItem;
        public PricebookEntry testPricebookEntry;
        public Product2 testProduct;
        public OpportunityLineItemSchedule schedule;
        public User testUser;
        private final String DESIRED_PROFILE = 'System Administrator';

        public SetupDataClass() {
            this.testUser = UserUtility.createNewUser(DESIRED_PROFILE);
            insert testUser;
        }

        public void createTestData(Boolean enable_opportunity_for_processing) {
            createAndInsertAccounts();
            createAndInsertContactForUser();
            createAndInsertOpportunities(enable_opportunity_for_processing);
            createAndInsertProduct();
            createAndInsertPriceBookEntry();
            makeTheTestUserToBeOpportunityMember();
            createOpportunityLineItems();
            createOpportunityLineItemsSchedule();
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

        private void createAndInsertOpportunities(Boolean enable_opportunity_for_processing){
            this.firstOpportunity = new Opportunity();
            this.firstOpportunity.Name = '° Roshen';
            this.firstOpportunity.StageName = '° Roshen';
            this.firstOpportunity.PriceBook2Id = Test.getStandardPricebookId();
            this.firstOpportunity.AccountId = this.firstAccount.Id;
            this.firstOpportunity.CloseDate = Date.newInstance(2015, 1, 1);
            this.firstOpportunity.Projektleiter_YOUR_SL__c = this.testContact.Id;
            this.firstOpportunity.Managed_by_PSO_Tool__c = enable_opportunity_for_processing;
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
            this.firstLineItem.Quantity = 1;
            this.firstLineItem.Unit__c = 'Manntag(e)';
            this.firstLineItem.OpportunityId = this.firstOpportunity.Id;
            insert new List<Sobject> {this.firstLineItem};
        }

        private void createOpportunityLineItemsSchedule(){
            schedule = new OpportunityLineItemSchedule();
            schedule.OpportunityLineItemId = this.firstLineItem.Id;
            schedule.ScheduleDate = Date.newInstance(2015, 1, 10);
            schedule.Quantity = 1;
            schedule.Type = 'Quantity';
            insert new List<Sobject> {schedule};
        }
    }
}