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
            setup_data.createTestData(true, true);
            setup_data.createAnotherLineItem();
            OpportunityLineItemScheduleChangeHandler new_instance = OpportunityLineItemScheduleChangeHandler.getInstance();
            Test.startTest();
                new_instance.addOpportunityLineItem(setup_data.FirstLineItem, setup_data.AnotherLineItem);
            Test.stopTest();
            System.assertEquals(1, new_instance.OpportunityLineItemIdToDifferenceInNumberOfDays.size());
            System.assert(new_instance.OpportunityLineItemIdToDifferenceInNumberOfDays.containsKey(setup_data.AnotherLineItem.Id));
            System.assertEquals(setup_data.FirstLineItem.Quantity - setup_data.AnotherLineItem.Quantity,
                    new_instance.OpportunityLineItemIdToDifferenceInNumberOfDays.get(setup_data.AnotherLineItem.Id));
        }
    }

    @isTest static void testAddOpportunityLineItemDoesntAddLineItemToMapWhenTheOpportunityIsNotAvailableForProcessing() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData(false, true);
            setup_data.createAnotherLineItem();
            OpportunityLineItemScheduleChangeHandler new_instance = OpportunityLineItemScheduleChangeHandler.getInstance();
            Test.startTest();
                new_instance.addOpportunityLineItem(setup_data.FirstLineItem, setup_data.AnotherLineItem);
            Test.stopTest();
            System.assertEquals(0, new_instance.OpportunityLineItemIdToDifferenceInNumberOfDays.size());
        }
    }

    @isTest static void testUpsertUnplannedSchedulesInsertsSchedules() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData(true, true);
            setup_data.createAnotherLineItem();
            OpportunityLineItemScheduleChangeHandler new_instance = OpportunityLineItemScheduleChangeHandler.getInstance();
            List<OpportunityLineItemSchedule> unplanned_schedules_before_test = [SELECT Id, OpportunityLineItem.Id, Quantity FROM OpportunityLineItemSchedule WHERE OpportunityLineItem.Id = :setup_data.FirstLineItem.Id AND Description =: OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT];
            delete unplanned_schedules_before_test;
            Decimal difference = 5;
            new_instance.OpportunityLineItemIdToDifferenceInNumberOfDays.put(setup_data.AnotherLineItem.Id, difference);
            Test.startTest();
                new_instance.upsertUnplannedSchedules();
            Test.stopTest();
            List<OpportunityLineItemSchedule> unplanned_schedules = [SELECT Id, OpportunityLineItem.Id, Quantity FROM OpportunityLineItemSchedule WHERE OpportunityLineItem.Id = :setup_data.AnotherLineItem.Id AND Description =: OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT];
            System.assertEquals(1, unplanned_schedules.size());
            System.assertEquals(difference, unplanned_schedules.get(0).Quantity);
            System.assert(!new_instance.hasRunAlready(setup_data.AnotherLineItem.Id));
        }
    }

    @isTest static void testUpsertUnplannedSchedulesUpdatesExistingSchedules() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData(true, true);
            List<OpportunityLineItemSchedule> unplanned_schedules2 = [SELECT Id, OpportunityLineItem.Id, Quantity FROM OpportunityLineItemSchedule WHERE OpportunityLineItem.Id = :setup_data.FirstLineItem.Id];
            OpportunityLineItemScheduleChangeHandler new_instance = OpportunityLineItemScheduleChangeHandler.getInstance();
            Decimal difference = 5;
            new_instance.OpportunityLineItemIdToDifferenceInNumberOfDays.put(setup_data.FirstLineItem.Id, difference);
            Test.startTest();
                new_instance.upsertUnplannedSchedules();
            Test.stopTest();
            List<OpportunityLineItemSchedule> unplanned_schedules = [SELECT Id, OpportunityLineItem.Id, Quantity FROM OpportunityLineItemSchedule WHERE OpportunityLineItem.Id = :setup_data.FirstLineItem.Id AND Description =: OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT];
            System.assertEquals(1, unplanned_schedules.size());
            System.assertEquals(setup_data.FirstLineItem.Quantity + difference - setup_data.schedule.Quantity, unplanned_schedules.get(0).Quantity);
            System.assert(!new_instance.hasRunAlready(setup_data.FirstLineItem.Id));
        }
    }

    @isTest static void testAddOpportunityLineItemDoesntDoesntAddItIfChangeParametersIsSet() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData(true, true);
            setup_data.createAnotherLineItem();
            setup_data.FirstLineItem.Change_Parameters__c = true;
            setup_data.AnotherLineItem.Change_Parameters__c = true;
            OpportunityLineItemScheduleChangeHandler new_instance = OpportunityLineItemScheduleChangeHandler.getInstance();
            Test.startTest();
                new_instance.addOpportunityLineItem(setup_data.FirstLineItem, setup_data.AnotherLineItem);
            Test.stopTest();
            System.assertEquals(0, new_instance.OpportunityLineItemIdToDifferenceInNumberOfDays.size());
            System.assert(!setup_data.AnotherLineItem.Change_Parameters__c);
        }
    }

    @isTest static void testGetUnplannedOpportunityLineItemScheduleSetsFieldsCorrectly() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData(true, true);
            OpportunityLineItemScheduleChangeHandler new_instance = OpportunityLineItemScheduleChangeHandler.getInstance();
            Decimal difference = 5;
            Date today = Date.today();
            Test.startTest();
                OpportunityLineItemSchedule schedule = new_instance.getUnplannedOpportunityLineItemSchedule(difference, setup_data.FirstLineItem.Id, today);
            Test.stopTest();
            System.assertEquals(OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT, schedule.Description);
            System.assertEquals(difference, schedule.Quantity);
            System.assertEquals(OpportunityLineItemScheduleChangeHandler.DEFAULT_TYPE, schedule.Type);
            System.assertEquals(setup_data.FirstLineItem.Id, schedule.OpportunityLineItemId);
            System.assertEquals(today, schedule.ScheduleDate);
        }
    }

    @isTest static void testUpsertUnplannedSchedulesWithNonMantageUnitDoesntGetAddedToTheList() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData(true, false);
            setup_data.createAnotherLineItem();
            OpportunityLineItemScheduleChangeHandler new_instance = OpportunityLineItemScheduleChangeHandler.getInstance();
            Test.startTest();
                new_instance.addOpportunityLineItem(setup_data.AnotherLineItem, setup_data.FirstLineItem);
            Test.stopTest();
            System.assertEquals(0, new_instance.OpportunityLineItemIdToDifferenceInNumberOfDays.size());
        }
    }

    private class SetupDataClass {
        public Account FirstAccount;
        public Contact TestContact;
        public Opportunity FirstOpportunity;
        public OpportunityLineItem FirstLineItem;
        public OpportunityLineItem AnotherLineItem;
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
            this.firstOpportunity = new Opportunity();
            this.firstOpportunity.Name = '° Roshen';
            this.firstOpportunity.StageName = '° Roshen';
            this.firstOpportunity.PriceBook2Id = Test.getStandardPricebookId();
            this.firstOpportunity.AccountId = this.FirstAccount.Id;
            this.firstOpportunity.CloseDate = Date.newInstance(2015, 1, 1);
            this.firstOpportunity.Projektleiter_YOUR_SL__c = this.TestContact.Id;
            this.firstOpportunity.Managed_by_PSO_Tool__c = enable_opportunity_for_processing;
            insert new List<Sobject> {this.firstOpportunity};
        }

        private void makeTheTestUserToBeOpportunityMember(){
            OpportunityTeamMember firstMember = new OpportunityTeamMember();
            firstMember.UserId = this.TestUser.Id;
            firstMember.OpportunityId = this.firstOpportunity.Id;
            insert new List<Sobject> {firstMember};
        }

        private void createOpportunityLineItem(){
            this.FirstLineItem = new OpportunityLineItem();
            this.FirstLineItem.Contact__c = this.TestContact.Id;
            this.FirstLineItem.PricebookEntryId = this.TestPricebookEntry.Id;
            this.FirstLineItem.ServiceDate = Date.newInstance(2015, 1, 10);
            this.FirstLineItem.UnitPrice = 1200;
            this.FirstLineItem.Quantity = 10;
            this.FirstLineItem.Unit__c = 'Manntag(e)';
            this.FirstLineItem.OpportunityId = this.firstOpportunity.Id;
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

        private void createAnotherLineItem(){
            this.AnotherLineItem = new OpportunityLineItem();
            this.AnotherLineItem.Contact__c = this.TestContact.Id;
            this.AnotherLineItem.PricebookEntryId = this.TestPricebookEntry.Id;
            this.AnotherLineItem.ServiceDate = Date.newInstance(2015, 1, 10);
            this.AnotherLineItem.UnitPrice = 1200;
            this.AnotherLineItem.Quantity = 0.5;
            this.AnotherLineItem.Unit__c = 'Manntag(e)';
            this.AnotherLineItem.OpportunityId = this.firstOpportunity.Id;
            insert new List<Sobject> {this.AnotherLineItem};
            this.AnotherLineItem = [SELECT Managed_by_PSO_Tool__c, UnitPrice, Quantity,Change_Parameters__c, Unit__c FROM OpportunityLineItem WHERE Id =: this.AnotherLineItem.Id];
        }

        public void createOpportunityLineItemsSchedule(){
            Schedule = new OpportunityLineItemSchedule();
            Schedule.OpportunityLineItemId = this.FirstLineItem.Id;
            Schedule.ScheduleDate = Date.newInstance(2015, 1, 10);
            Schedule.Quantity = 1;
            Schedule.Type = 'Quantity';
            insert Schedule;
        }
    }
}