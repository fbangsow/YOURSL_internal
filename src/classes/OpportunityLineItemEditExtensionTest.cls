@isTest
private class OpportunityLineItemEditExtensionTest {

    @isTest static void testConstructorSetsProperties() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData(true);
            Test.startTest();
                setup_data.initializeConstructor();
            Test.stopTest();
            System.assertEquals(setup_data.TestLineItem.Id, setup_data.ClassUnderTest.LineItem.Id);
            System.assertEquals(setup_data.TestLineItem.Quantity, setup_data.ClassUnderTest.SelectedQuantity);
            System.assertEquals(setup_data.TestLineItem.UnitPrice, setup_data.ClassUnderTest.SelectedPrice);
            System.assertEquals(true, setup_data.ClassUnderTest.ShowControls);
        }
    }

    @isTest static void testConstructorHidesControlsWhenOpportunityLineItemIsNotAllowedToBeProcessed() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData(false);
            Test.startTest();
                setup_data.initializeConstructor();
            Test.stopTest();
            System.assertEquals(setup_data.TestLineItem.Id, setup_data.ClassUnderTest.LineItem.Id);
            System.assertEquals(setup_data.TestLineItem.Quantity, setup_data.ClassUnderTest.SelectedQuantity);
            System.assertEquals(setup_data.TestLineItem.UnitPrice, setup_data.ClassUnderTest.SelectedPrice);
            System.assertEquals(false, setup_data.ClassUnderTest.ShowControls);
        }
    }

    @isTest static void testSaveChangesSalesPriceAndQuantity() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            FeatureSwitch.enable('PsoTool triggers');
            setup_data.createTestData(true);
            setup_data.initializeConstructor();
            setup_data.ClassUnderTest.SelectedQuantity = 20;
            setup_data.ClassUnderTest.SelectedPrice = 2000;
            Test.startTest();
                setup_data.ClassUnderTest.save();
            Test.stopTest();
            OpportunityLineItem line_item = [SELECT Quantity, UnitPrice FROM OpportunityLineItem WHERE id =: setup_data.TestLineItem.Id];
            System.assertEquals(setup_data.ClassUnderTest.SelectedQuantity, line_item.Quantity);
            System.assertEquals(setup_data.ClassUnderTest.SelectedPrice, line_item.UnitPrice);
            List<OpportunityLineItemSchedule> schedules = [SELECT Quantity, ScheduleDate FROM OpportunityLineItemSchedule WHERE OpportunityLineItem.Id = :setup_data.TestLineItem.Id AND Description !=: OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT];
            System.assertEquals(1, schedules.size());
            System.assertEquals(setup_data.Schedule.Quantity, schedules.get(0).Quantity);
            System.assertEquals(setup_data.Schedule.ScheduleDate, schedules.get(0).ScheduleDate);
        }
    }

    private class SetupDataClass {
        public OpportunityLineItemEditExtension ClassUnderTest;
        public Account TestAccount;
        public Contact TestContact;
        public Opportunity TestOpportunity;
        public OpportunityLineItem TestLineItem;
        public PricebookEntry TestPricebookEntry;
        public Product2 TestProduct;
        public OpportunityLineItemSchedule Schedule;
        public User TestUser;
        private final String DESIRED_PROFILE = 'System Administrator';

        public SetupDataClass() {
            this.TestUser = UserUtility.createNewUser(DESIRED_PROFILE);
            insert TestUser;
        }

        public void initializeConstructor(){
            ApexPages.Standardcontroller standard_controller = new ApexPages.StandardController(TestLineItem);
            ClassUnderTest = new OpportunityLineItemEditExtension(standard_controller);
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
            this.TestAccount = new Account();
            this.TestAccount.Name = 'First company';
            insert new List<Sobject> {this.TestAccount};
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

        private void createAndInsertOpportunities(Boolean enable_opportunity_for_processing){
            this.TestOpportunity = new Opportunity();
            this.TestOpportunity.Name = '° Roshen';
            this.TestOpportunity.StageName = '° Roshen';
            this.TestOpportunity.PriceBook2Id = Test.getStandardPricebookId();
            this.TestOpportunity.AccountId = this.TestAccount.Id;
            this.TestOpportunity.CloseDate = Date.newInstance(2015, 1, 1);
            this.TestOpportunity.Projektleiter_YOUR_SL__c = this.TestContact.Id;
            this.TestOpportunity.Managed_by_PSO_Tool__c = enable_opportunity_for_processing;
            insert new List<Sobject> {this.TestOpportunity};
        }

        private void makeTheTestUserToBeOpportunityMember(){
            OpportunityTeamMember firstMember = new OpportunityTeamMember();
            firstMember.UserId = this.testUser.Id;
            firstMember.OpportunityId = this.TestOpportunity.Id;
            insert new List<Sobject> {firstMember};
        }

        private void createOpportunityLineItems(){
            this.TestLineItem = new OpportunityLineItem();
            this.TestLineItem.Contact__c = this.TestContact.Id;
            this.TestLineItem.PricebookEntryId = this.TestPricebookEntry.Id;
            this.TestLineItem.ServiceDate = Date.newInstance(2015, 1, 10);
            this.TestLineItem.UnitPrice = 1200;
            this.TestLineItem.Quantity = 10;
            this.TestLineItem.Unit__c = 'Manntag(e)';
            this.TestLineItem.OpportunityId = this.TestOpportunity.Id;
            insert new List<Sobject> {this.TestLineItem};
            this.TestLineItem = [SELECT Managed_by_PSO_Tool__c, UnitPrice, Quantity FROM OpportunityLineItem WHERE Id =: this.TestLineItem.Id];
        }

        public void createOpportunityLineItemsSchedule(){
            Schedule = new OpportunityLineItemSchedule();
            Schedule.OpportunityLineItemId = this.TestLineItem.Id;
            Schedule.ScheduleDate = Date.newInstance(2015, 1, 10);
            Schedule.Quantity = 1;
            Schedule.Type = 'Quantity';
            insert Schedule;
        }
    }
}