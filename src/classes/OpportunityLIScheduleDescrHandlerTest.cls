@isTest
private class OpportunityLIScheduleDescrHandlerTest {

    @isTest static void testGetInstanceReturnsTheSameObject() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Test.startTest();
                OpportunityLineItemScheduleDescrHandler new_instance = OpportunityLineItemScheduleDescrHandler.getInstance();
            Test.stopTest();
            System.assertEquals(OpportunityLineItemScheduleDescrHandler.getInstance(), new_instance, 'Singleton should return the same instance');
        }
    }

    @isTest static void testAddIdToSetAddsIdToSet() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            OpportunityLineItemScheduleDescrHandler new_instance = OpportunityLineItemScheduleDescrHandler.getInstance();
            setup_data.createTestData(true, true);
            Test.startTest();
                new_instance.addIdToSet(setup_data.FirstLineItem);
            Test.stopTest();
            System.assertEquals(1, new_instance.UpdatedOpportunityLineItemIds.size());
            System.assert(new_instance.UpdatedOpportunityLineItemIds.contains(setup_data.FirstLineItem.Id));
        }
    }

    @isTest static void testAddIdToSetDoesntAddIdToSetWhenOpportunityIsNotAllowedToBeProcessed() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            OpportunityLineItemScheduleDescrHandler new_instance = OpportunityLineItemScheduleDescrHandler.getInstance();
            setup_data.createTestData(false, true);
            Test.startTest();
                new_instance.addIdToSet(setup_data.FirstLineItem);
            Test.stopTest();
            System.assertEquals(0, new_instance.UpdatedOpportunityLineItemIds.size());
            System.assert(!new_instance.UpdatedOpportunityLineItemIds.contains(setup_data.FirstLineItem.Id));
        }
    }


    @isTest static void testUpdateCommentsToHaveCurrentValueUpdatesComment() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            OpportunityLineItemScheduleDescrHandler new_instance = OpportunityLineItemScheduleDescrHandler.getInstance();
            setup_data.createTestData(true, true);
            OpportunityLineItemSchedule original_Schedule = [SELECT Quantity, Description FROM OpportunityLineItemSchedule WHERE Id =: setup_data.Schedule.Id];
            original_Schedule.Quantity = 10;
            Test.startTest();
                update original_Schedule;
            Test.stopTest();
            OpportunityLineItemSchedule result_Schedule = [SELECT Quantity, Description FROM OpportunityLineItemSchedule WHERE Id =: setup_data.Schedule.Id];
            System.assertEquals(result_Schedule.Quantity, Decimal.valueOf(result_Schedule.Description));
        }
    }

    @isTest static void testAddIdToSetDoesntAddIdToSetWhenUnitIsNotMentage() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            OpportunityLineItemScheduleDescrHandler new_instance = OpportunityLineItemScheduleDescrHandler.getInstance();
            setup_data.createTestData(true, false);
            Test.startTest();
                new_instance.addIdToSet(setup_data.FirstLineItem);
            Test.stopTest();
            System.assertEquals(0, new_instance.UpdatedOpportunityLineItemIds.size());
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
            this.testProduct = new Product2();
            this.testProduct.Name = 'Salesforce Developer';
            this.testProduct.isActive = true;
            this.testProduct.CanUseQuantitySchedule = true;
            insert this.testProduct;
        }

        private void createAndInsertPriceBookEntry(){
            this.TestPricebookEntry = new PricebookEntry();
            this.TestPricebookEntry.Pricebook2Id = Test.getStandardPricebookId();
            this.TestPricebookEntry.Product2Id = this.testProduct.Id;
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
            OpportunityTeamMember firstMember = new OpportunityTeamMember();
            firstMember.UserId = this.TestUser.Id;
            firstMember.OpportunityId = this.FirstOpportunity.Id;
            insert new List<Sobject> {firstMember};
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
            this.FirstLineItem = [SELECT Managed_by_PSO_Tool__c, UnitPrice, Quantity, Change_Parameters__c, Unit__c FROM OpportunityLineItem WHERE Id =: this.FirstLineItem.Id];
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
            this.FirstLineItem = [SELECT Managed_by_PSO_Tool__c, UnitPrice, Quantity, Change_Parameters__c, Unit__c FROM OpportunityLineItem WHERE Id =: this.FirstLineItem.Id];
        }

        private void createOpportunityLineItemsSchedule(){
            Schedule = new OpportunityLineItemSchedule();
            Schedule.OpportunityLineItemId = this.FirstLineItem.Id;
            Schedule.ScheduleDate = Date.newInstance(2015, 1, 10);
            Schedule.Quantity = 1;
            Schedule.Type = 'Quantity';
            insert Schedule;
        }
    }
}