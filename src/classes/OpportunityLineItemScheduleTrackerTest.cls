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
            setup_data.createTestData(true, true);
            Map<Id, SObject> old_opportunity_line_items = new Map<Id, SObject>();
            old_opportunity_line_items.put(setup_data.FirstLineItem.Id, setup_data.FirstLineItem);
            OpportunityLineItemScheduleTracker.AlreadyProcessed = false;
            OpportunityLineItemScheduleTracker.AlreadyRun = false;
            Test.startTest();
                new_instance.prepareDataForReflectingScheduleChanges(old_opportunity_line_items);
            Test.stopTest();
            System.assertEquals(1, new_instance.OppLineIdToOpportunityLineItemScheduleWithId.keySet().size());
            System.assert(new_instance.OppLineIdToOpportunityLineItemScheduleWithId.containsKey(setup_data.FirstLineItem.Id));
            System.assert(new_instance.OppLineIdToOpportunityLineItemScheduleWithId.get(setup_data.FirstLineItem.Id).containsKey(setup_data.schedule.Id));
            System.assertEquals(setup_data.schedule.Id, new_instance.OppLineIdToOpportunityLineItemScheduleWithId.get(setup_data.FirstLineItem.Id).get(setup_data.schedule.Id).Id);
            System.assertEquals(1, new_instance.OppLineItemIdToContactId.keySet().size());
            System.assert(new_instance.OppLineItemIdToContactId.containsKey(setup_data.FirstLineItem.Id));
            System.assertEquals(setup_data.TestContact.Id, new_instance.OppLineItemIdToContactId.get(setup_data.FirstLineItem.Id));
            System.assert(OpportunityLineItemScheduleTracker.AlreadyRun);
            System.assert(!OpportunityLineItemScheduleTracker.AlreadyProcessed);
        }
    }

    @isTest static void testCreateResourceScheduleEntriesCreatesEntries() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            OpportunityLineItemScheduleTracker new_instance = OpportunityLineItemScheduleTracker.getInstance();
            setup_data.createTestData(true, true);
            Map<Id, SObject> old_opportunity_line_items = new Map<Id, SObject>();
            old_opportunity_line_items.put(setup_data.FirstLineItem.Id, setup_data.FirstLineItem);
            OpportunityLineItemScheduleTracker.AlreadyProcessed = false;
            OpportunityLineItemScheduleTracker.AlreadyRun = false;
            new_instance.prepareDataForReflectingScheduleChanges(old_opportunity_line_items);
            Decimal new_value = 0.5;
            new_instance.OppLineIdToOpportunityLineItemScheduleWithId.get(setup_data.FirstLineItem.Id).get(setup_data.schedule.Id).Quantity = new_value;
            Test.startTest();
                new_instance.createResourceScheduleEntries();
            Test.stopTest();
            List<Resource_Schedule__c> related_resource_schedules = [SELECT ContactId__c, Event__c, Old_value__c, New_value__c, Scheduled_Date__c, OpportunityLineItemScheduleId__c
                                FROM Resource_Schedule__c WHERE OpportunityLineItemScheduleId__c =: setup_data.schedule.Id];
            System.assertEquals(1, related_resource_schedules.size());
            System.assertEquals(setup_data.TestContact.Id, related_resource_schedules.get(0).ContactId__c);
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
            setup_data.createTestData(true, true);
            Map<Id, SObject> old_opportunity_line_items = new Map<Id, SObject>();
            old_opportunity_line_items.put(setup_data.FirstLineItem.Id, setup_data.FirstLineItem);
            OpportunityLineItemScheduleTracker.AlreadyProcessed = false;
            OpportunityLineItemScheduleTracker.AlreadyRun = false;
            new_instance.prepareDataForReflectingScheduleChanges(old_opportunity_line_items);
            new_instance.OppLineIdToOpportunityLineItemScheduleWithId.get(setup_data.FirstLineItem.Id).get(setup_data.schedule.Id).Quantity = 0.5;
            new_instance.createResourceScheduleEntries();
            List<Resource_Schedule__c> related_resource_schedules = [SELECT ContactId__c, Event__c, Old_value__c, New_value__c, Scheduled_Date__c, OpportunityLineItemScheduleId__c
                                FROM Resource_Schedule__c WHERE OpportunityLineItemScheduleId__c =: setup_data.schedule.Id];
            OpportunityLineItemScheduleTracker.AlreadyProcessed = false;
            OpportunityLineItemScheduleTracker.AlreadyRun = false;
            Decimal new_value = 1.1;
            new_instance.OppLineIdToOpportunityLineItemScheduleWithId.get(setup_data.FirstLineItem.Id).get(setup_data.schedule.Id).Quantity = new_value;
            Test.startTest();
                new_instance.createResourceScheduleEntries();
            Test.stopTest();
            List<Resource_Schedule__c> related_resource_schedules2 = [SELECT ContactId__c, Event__c, Old_value__c, New_value__c, Scheduled_Date__c, OpportunityLineItemScheduleId__c
                                FROM Resource_Schedule__c WHERE OpportunityLineItemScheduleId__c =: setup_data.schedule.Id];
            System.assertEquals(1, related_resource_schedules2.size());
            System.assertEquals(related_resource_schedules.get(0).Id, related_resource_schedules2.get(0).Id);
            System.assertEquals(setup_data.TestContact.Id, related_resource_schedules2.get(0).ContactId__c);
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

    @isTest static void testCreatingTestSchedulesDoesntCreateResourseSchedules() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            OpportunityLineItemScheduleTracker new_instance = OpportunityLineItemScheduleTracker.getInstance();
            Test.startTest();
                setup_data.createTestData(true, false);
            Test.stopTest();
            List<Resource_Schedule__c> related_resource_schedules = [SELECT ContactId__c, Event__c, Old_value__c, New_value__c, Scheduled_Date__c, OpportunityLineItemScheduleId__c
                                FROM Resource_Schedule__c];
            System.assertEquals(0, related_resource_schedules.size());
        }
    }

    private class SetupDataClass {
        public Account FirstAccount;
        public Contact TestContact;
        public Opportunity FirstOpportunity;
        public OpportunityLineItem FirstLineItem;
        public PricebookEntry TestPricebookEntry;
        public Product2 TestProduct;
        public OpportunityLineItemSchedule Schedule;
        public User TestUser;
        private final String DESIRED_PROFILE = 'System Administrator';

        public SetupDataClass() {
            this.TestUser = UserUtility.createNewUser(DESIRED_PROFILE);
            insert TestUser;
        }

        public void createTestData(Boolean enable_opportunity_for_processing, Boolean create_item_with_regular_unit) {
            createAndInsertAccounts();
            createAndInsertContactForUser();
            createAndInsertOpportunities(enable_opportunity_for_processing);
            createAndInsertProduct();
            createAndInsertPriceBookEntry();
            makeTheTestUserToBeOpportunityMember();
            if(create_item_with_regular_unit)
                createOpportunityLineItem();
            else
                createOpportunityLineItemWithOtherUnit();
            createOpportunityLineItemsSchedule();
        }

        private void createAndInsertAccounts(){
            this.FirstAccount = new Account();
            this.FirstAccount.Name = 'First company';
            insert new List<Sobject> {this.FirstAccount};
        }

        private void createAndInsertContactForUser() {
            this.TestContact = new Contact();
            this.TestContact.FirstName = TestUser.FirstName;
            this.TestContact.LastName = TestUser.LastName;
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

        private void createAndInsertOpportunities(Boolean enable_opportunity_for_processing){
            this.FirstOpportunity = new Opportunity();
            this.FirstOpportunity.Name = '° Roshen';
            this.FirstOpportunity.StageName = '° Roshen';
            this.FirstOpportunity.PriceBook2Id = Test.getStandardPricebookId();
            this.FirstOpportunity.AccountId = this.FirstAccount.Id;
            this.FirstOpportunity.CloseDate = Date.newInstance(2015, 1, 1);
            this.FirstOpportunity.Projektleiter_YOUR_SL__c = this.TestContact.Id;
            this.FirstOpportunity.Managed_by_PSO_Tool__c = enable_opportunity_for_processing;
            insert new List<Sobject> {this.FirstOpportunity};
        }

        private void makeTheTestUserToBeOpportunityMember(){
            OpportunityTeamMember first_member = new OpportunityTeamMember();
            first_member.UserId = this.TestUser.Id;
            first_member.OpportunityId = this.FirstOpportunity.Id;
            insert new List<Sobject> {first_member};
        }

        private void createOpportunityLineItem(){
            this.FirstLineItem = new OpportunityLineItem();
            this.FirstLineItem.Contact__c = this.TestContact.Id;
            this.FirstLineItem.PricebookEntryId = this.TestPricebookEntry.Id;
            this.FirstLineItem.ServiceDate = Date.newInstance(2015, 1, 10);
            this.FirstLineItem.UnitPrice = 1200;
            this.FirstLineItem.Quantity = 1;
            this.FirstLineItem.Unit__c = 'Manntag(e)';
            this.FirstLineItem.OpportunityId = this.FirstOpportunity.Id;
            insert new List<Sobject> {this.FirstLineItem};
        }

        public void createOpportunityLineItemWithOtherUnit(){
            this.FirstLineItem = new OpportunityLineItem();
            this.FirstLineItem.Contact__c = this.TestContact.Id;
            this.FirstLineItem.PricebookEntryId = this.TestPricebookEntry.Id;
            this.FirstLineItem.ServiceDate = Date.newInstance(2015, 1, 10);
            this.FirstLineItem.UnitPrice = 1200;
            this.FirstLineItem.Quantity = 1;
            this.FirstLineItem.Unit__c = 'Other unit';
            this.FirstLineItem.OpportunityId = this.FirstOpportunity.Id;
            insert new List<Sobject> {this.FirstLineItem};
        }

        private void createOpportunityLineItemsSchedule(){
            Schedule = new OpportunityLineItemSchedule();
            Schedule.OpportunityLineItemId = this.FirstLineItem.Id;
            Schedule.ScheduleDate = Date.newInstance(2015, 1, 10);
            Schedule.Quantity = 1;
            Schedule.Type = 'Quantity';
            insert new List<Sobject> {Schedule};
        }
    }
}