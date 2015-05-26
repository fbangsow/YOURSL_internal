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
            setup_data.createTestData(true);
            Test.startTest();
                new_instance.addIdToSet(setup_data.firstLineItem);
            Test.stopTest();
            System.assertEquals(1, new_instance.UpdatedOpportunityLineItemIds.size());
            System.assert(new_instance.UpdatedOpportunityLineItemIds.contains(setup_data.firstLineItem.Id));
        }
    }

    @isTest static void testAddIdToSetDoesntAddIdToSetWhenOpportunityIsNotAllowedToBeProcessed() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            OpportunityLineItemScheduleDescrHandler new_instance = OpportunityLineItemScheduleDescrHandler.getInstance();
            setup_data.createTestData(false);
            Test.startTest();
                new_instance.addIdToSet(setup_data.firstLineItem);
            Test.stopTest();
            System.assertEquals(0, new_instance.UpdatedOpportunityLineItemIds.size());
            System.assert(!new_instance.UpdatedOpportunityLineItemIds.contains(setup_data.firstLineItem.Id));
        }
    }


    @isTest static void testUpdateCommentsToHaveCurrentValueUpdatesComment() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            OpportunityLineItemScheduleDescrHandler new_instance = OpportunityLineItemScheduleDescrHandler.getInstance();
            setup_data.createTestData(true);
            OpportunityLineItemSchedule original_schedule = [SELECT Quantity, Description FROM OpportunityLineItemSchedule WHERE Id =: setup_data.schedule.Id];
            original_schedule.Quantity = 10;
            Test.startTest();
                update original_schedule;
            Test.stopTest();
            OpportunityLineItemSchedule result_schedule = [SELECT Quantity, Description FROM OpportunityLineItemSchedule WHERE Id =: setup_data.schedule.Id];
            System.assertEquals(result_schedule.Quantity, Decimal.valueOf(result_schedule.Description));
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
            this.firstLineItem.Quantity = 1;
            this.firstLineItem.Unit__c = 'Manntag(e)';
            this.firstLineItem.OpportunityId = this.firstOpportunity.Id;
            insert new List<Sobject> {this.firstLineItem};
            this.firstLineItem = [SELECT Managed_by_PSO_Tool__c, UnitPrice, Quantity,Change_Parameters__c FROM OpportunityLineItem WHERE Id =: this.firstLineItem.Id];
        }

        private void createOpportunityLineItemsSchedule(){
            schedule = new OpportunityLineItemSchedule();
            schedule.OpportunityLineItemId = this.firstLineItem.Id;
            schedule.ScheduleDate = Date.newInstance(2015, 1, 10);
            schedule.Quantity = 1;
            schedule.Type = 'Quantity';
            insert schedule;
        }
    }
}