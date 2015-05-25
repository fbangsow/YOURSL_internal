@isTest
private class OpportunityLIScheduleChangeHandlerTest {
    @isTest static void testGetInstanceReturnsTheSameObject() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Test.startTest();
                OpportunityLineItemScheduleChangeHandler new_instance = OpportunityLineItemScheduleChangeHandler.getInstance();
            Test.stopTest();
            System.assertEquals(OpportunityLineItemScheduleChangeHandler.getInstance(), new_instance, 'Singleton should return the same instance');
        }
    }

    @isTest static void testAddOpportunityLineItemAddsItToMap() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData(true);
            setup_data.createAnotherLineItem();
            OpportunityLineItemScheduleChangeHandler new_instance = OpportunityLineItemScheduleChangeHandler.getInstance();
            Test.startTest();
                new_instance.addOpportunityLineItem(setup_data.firstLineItem, setup_data.anotherLineItem);
            Test.stopTest();
            System.assertEquals(1, new_instance.OpportunityLineItemIdToDifferenceInNumberOfDays.size());
            System.assert(new_instance.OpportunityLineItemIdToDifferenceInNumberOfDays.containsKey(setup_data.anotherLineItem.Id));
            System.assertEquals(setup_data.firstLineItem.Quantity - setup_data.anotherLineItem.Quantity,
                    new_instance.OpportunityLineItemIdToDifferenceInNumberOfDays.get(setup_data.anotherLineItem.Id));
        }
    }

    @isTest static void testAddOpportunityLineItemDoesntAddLineItemToMapWhenTheOpportunityIsNotAvailableForProcessing() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData(false);
            setup_data.createAnotherLineItem();
            OpportunityLineItemScheduleChangeHandler new_instance = OpportunityLineItemScheduleChangeHandler.getInstance();
            Test.startTest();
                new_instance.addOpportunityLineItem(setup_data.firstLineItem, setup_data.anotherLineItem);
            Test.stopTest();
            System.assertEquals(0, new_instance.OpportunityLineItemIdToDifferenceInNumberOfDays.size());
        }
    }

    @isTest static void testUpsertUnplannedSchedulesInsertsSchedules() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData(true);
            setup_data.createAnotherLineItem();
            OpportunityLineItemScheduleChangeHandler new_instance = OpportunityLineItemScheduleChangeHandler.getInstance();
            List<OpportunityLineItemSchedule> unplanned_schedules_before_test = [SELECT Id, OpportunityLineItem.Id, Quantity FROM OpportunityLineItemSchedule WHERE OpportunityLineItem.Id = :setup_data.firstLineItem.Id AND Description =: OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT];
            delete unplanned_schedules_before_test;
            Decimal difference = 5;
            new_instance.OpportunityLineItemIdToDifferenceInNumberOfDays.put(setup_data.anotherLineItem.Id, difference);
            Test.startTest();
                new_instance.upsertUnplannedSchedules();
            Test.stopTest();
            List<OpportunityLineItemSchedule> unplanned_schedules = [SELECT Id, OpportunityLineItem.Id, Quantity FROM OpportunityLineItemSchedule WHERE OpportunityLineItem.Id = :setup_data.anotherLineItem.Id AND Description =: OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT];
            System.assertEquals(1, unplanned_schedules.size());
            System.assertEquals(difference, unplanned_schedules.get(0).Quantity);
            System.assert(!new_instance.hasRunAlready(setup_data.anotherLineItem.Id));
        }
    }

    @isTest static void testUpsertUnplannedSchedulesUpdatesExistingSchedules() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData(true);
            List<OpportunityLineItemSchedule> unplanned_schedules2 = [SELECT Id, OpportunityLineItem.Id, Quantity FROM OpportunityLineItemSchedule WHERE OpportunityLineItem.Id = :setup_data.firstLineItem.Id];
            OpportunityLineItemScheduleChangeHandler new_instance = OpportunityLineItemScheduleChangeHandler.getInstance();
            Decimal difference = 5;
            new_instance.OpportunityLineItemIdToDifferenceInNumberOfDays.put(setup_data.firstLineItem.Id, difference);
            Test.startTest();
                new_instance.upsertUnplannedSchedules();
            Test.stopTest();
            List<OpportunityLineItemSchedule> unplanned_schedules = [SELECT Id, OpportunityLineItem.Id, Quantity FROM OpportunityLineItemSchedule WHERE OpportunityLineItem.Id = :setup_data.firstLineItem.Id AND Description =: OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT];
            System.assertEquals(1, unplanned_schedules.size());
            System.assertEquals(setup_data.firstLineItem.Quantity + difference - setup_data.schedule.Quantity, unplanned_schedules.get(0).Quantity);
            System.assert(!new_instance.hasRunAlready(setup_data.firstLineItem.Id));
        }
    }

    @isTest static void testAddOpportunityLineItemDoesntDoesntAddItIfChangeParametersIsSet() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData(true);
            setup_data.createAnotherLineItem();
            setup_data.firstLineItem.Change_Parameters__c = true;
            setup_data.anotherLineItem.Change_Parameters__c = true;
            OpportunityLineItemScheduleChangeHandler new_instance = OpportunityLineItemScheduleChangeHandler.getInstance();
            Test.startTest();
                new_instance.addOpportunityLineItem(setup_data.firstLineItem, setup_data.anotherLineItem);
            Test.stopTest();
            System.assertEquals(0, new_instance.OpportunityLineItemIdToDifferenceInNumberOfDays.size());
            System.assert(!setup_data.anotherLineItem.Change_Parameters__c);
        }
    }

    @isTest static void testGetUnplannedOpportunityLineItemScheduleSetsFieldsCorrectly() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData(true);
            OpportunityLineItemScheduleChangeHandler new_instance = OpportunityLineItemScheduleChangeHandler.getInstance();
            Decimal difference = 5;
            Date today = Date.today();
            Test.startTest();
                OpportunityLineItemSchedule schedule = new_instance.getUnplannedOpportunityLineItemSchedule(difference, setup_data.firstLineItem.Id, today);
            Test.stopTest();
            System.assertEquals(OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT, schedule.Description);
            System.assertEquals(difference, schedule.Quantity);
            System.assertEquals(OpportunityLineItemScheduleChangeHandler.DEFAULT_TYPE, schedule.Type);
            System.assertEquals(setup_data.firstLineItem.Id, schedule.OpportunityLineItemId);
            System.assertEquals(today, schedule.ScheduleDate);
        }
    }

    @isTest static void testUpsertUnplannedSchedulesThrowsExceptionWhenServiceDateIsNotSet() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData(true);
            setup_data.createAnotherLineItem();
            OpportunityLineItemScheduleChangeHandler new_instance = OpportunityLineItemScheduleChangeHandler.getInstance();
            List<OpportunityLineItemSchedule> unplanned_schedules_before_test = [SELECT Id, OpportunityLineItem.Id, Quantity FROM OpportunityLineItemSchedule WHERE OpportunityLineItem.Id = :setup_data.firstLineItem.Id AND Description =: OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT];
            delete unplanned_schedules_before_test;
            Decimal difference = 5;
            setup_data.anotherLineItem.ServiceDate = null;
            update setup_data.anotherLineItem;
            new_instance.OpportunityLineItemIdToDifferenceInNumberOfDays.put(setup_data.anotherLineItem.Id, difference);
            Boolean exception_is_caught = false;
            Test.startTest();
                try{
                    new_instance.upsertUnplannedSchedules();
                } catch(OpportunityLineItemScheduleChangeHandler.ServiceDateIsNotSetException e){
                    exception_is_caught = true;
                }
            Test.stopTest();
            System.assert(exception_is_caught);
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
            this.firstLineItem.Quantity = 10;
            this.firstLineItem.Unit__c = 'Manntag(e)';
            this.firstLineItem.OpportunityId = this.firstOpportunity.Id;
            insert new List<Sobject> {this.firstLineItem};
        }

        private void createAnotherLineItem(){
            this.anotherLineItem = new OpportunityLineItem();
            this.anotherLineItem.Contact__c = this.testContact.Id;
            this.anotherLineItem.PricebookEntryId = this.testPricebookEntry.Id;
            this.anotherLineItem.ServiceDate = Date.newInstance(2015, 1, 10);
            this.anotherLineItem.UnitPrice = 1200;
            this.anotherLineItem.Quantity = 0.5;
            this.anotherLineItem.Unit__c = 'Manntag(e)';
            this.anotherLineItem.OpportunityId = this.firstOpportunity.Id;
            insert new List<Sobject> {this.anotherLineItem};
            this.anotherLineItem = [SELECT Managed_by_PSO_Tool__c, UnitPrice, Quantity,Change_Parameters__c FROM OpportunityLineItem WHERE Id =: this.anotherLineItem.Id];
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