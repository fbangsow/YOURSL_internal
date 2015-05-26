@isTest
private class OpportunityLineItemsEditExtensionTest {

    @isTest static void testConstructorSetsProperties() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData(true);
            Test.startTest();
                setup_data.initializeConstructor();
            Test.stopTest();
            System.assertEquals(setup_data.TestOpportunity.Id, setup_data.ClassUnderTest.SelectedOpportunity.Id);
            System.assertEquals(2, setup_data.ClassUnderTest.LineItems.size());
            System.assert(setup_data.ClassUnderTest.LineItems.containsKey(setup_data.TestLineItem.Id));
            System.assertEquals(setup_data.TestLineItem.Id, setup_data.ClassUnderTest.LineItems.get(setup_data.TestLineItem.Id).LineItem.Id);
            System.assertEquals(setup_data.TestLineItem.Quantity, setup_data.ClassUnderTest.LineItems.get(setup_data.TestLineItem.Id).SelectedQuantity);
            System.assertEquals(setup_data.TestLineItem.Quantity - setup_data.Schedule.Quantity, setup_data.ClassUnderTest.LineItems.get(setup_data.TestLineItem.Id).UnplannedDays);
            System.assert(setup_data.ClassUnderTest.LineItems.containsKey(setup_data.AnotherLineItem.Id));
            System.assertEquals(setup_data.AnotherLineItem.Id, setup_data.ClassUnderTest.LineItems.get(setup_data.AnotherLineItem.Id).LineItem.Id);
            System.assertEquals(setup_data.AnotherLineItem.Quantity, setup_data.ClassUnderTest.LineItems.get(setup_data.AnotherLineItem.Id).SelectedQuantity);
            System.assertEquals(setup_data.AnotherLineItem.Quantity, setup_data.ClassUnderTest.LineItems.get(setup_data.AnotherLineItem.Id).UnplannedDays);
            System.assertEquals(true, setup_data.ClassUnderTest.ShowControls);
        }
    }

    @isTest static void testConstructorHidesControlsWhenOpportunityIsNotAllowedToBeProcessed() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData(false);
            Test.startTest();
                setup_data.initializeConstructor();
            Test.stopTest();
            System.assertEquals(false, setup_data.ClassUnderTest.ShowControls);
            List<Apexpages.Message> msgs = ApexPages.getMessages();
            Boolean message_added = false;
            String message_text = 'This opportunity is not allowed to be processed by the PSO Tool';
            for(Apexpages.Message msg:msgs)
                if (msg.getDetail().contains(message_text)) 
                    message_added = true;
            System.assert(message_added);
        }
    }

    @isTest static void testConstructorHidesControlsWhenOpportunityHasNoLineItems() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData(true);
            List<OpportunityLineItem> items_to_delete = [SELECT Id FROM OpportunityLineItem];
            delete items_to_delete;
            Test.startTest();
                setup_data.initializeConstructor();
            Test.stopTest();
            System.assertEquals(false, setup_data.ClassUnderTest.ShowControls);
            List<Apexpages.Message> msgs = ApexPages.getMessages();
            Boolean message_added = false;
            String message_text = 'This opportunity has no opportunity line items to edit';
            for(Apexpages.Message msg:msgs)
                if (msg.getDetail().contains(message_text)) 
                    message_added = true;
            System.assert(message_added);
        }
    }

    @isTest static void testSaveChangesSalesPriceAndQuantity() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData(true);
            setup_data.initializeConstructor();
            setup_data.ClassUnderTest.LineItems.get(setup_data.TestLineItem.Id).SelectedQuantity = 20;
            setup_data.ClassUnderTest.LineItems.get(setup_data.AnotherLineItem.Id).SelectedQuantity = 15;
            Test.startTest();
                setup_data.ClassUnderTest.save();
            Test.stopTest();
            OpportunityLineItem line_item = [SELECT Quantity, UnitPrice FROM OpportunityLineItem WHERE id =: setup_data.TestLineItem.Id];
            System.assertEquals(setup_data.ClassUnderTest.LineItems.get(setup_data.TestLineItem.Id).SelectedQuantity, line_item.Quantity);
            System.assertEquals(setup_data.TestLineItem.UnitPrice, line_item.UnitPrice);
            OpportunityLineItem another_line_item = [SELECT Quantity, UnitPrice FROM OpportunityLineItem WHERE id =: setup_data.AnotherLineItem.Id];
            System.assertEquals(setup_data.ClassUnderTest.LineItems.get(setup_data.AnotherLineItem.Id).SelectedQuantity, another_line_item.Quantity);
            System.assertEquals(setup_data.AnotherLineItem.UnitPrice, another_line_item.UnitPrice);
            List<OpportunityLineItemSchedule> schedules = [SELECT Quantity, ScheduleDate FROM OpportunityLineItemSchedule WHERE (OpportunityLineItem.Id = :setup_data.TestLineItem.Id OR OpportunityLineItem.Id = :setup_data.AnotherLineItem.Id)
                                                                            AND Description !=: OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT];
            System.assertEquals(1, schedules.size());
            System.assertEquals(setup_data.Schedule.Quantity, schedules.get(0).Quantity);
            System.assertEquals(setup_data.Schedule.ScheduleDate, schedules.get(0).ScheduleDate);
        }
    }

    @isTest static void testRedirectToOpportunityViewRedirectsToTheRightPage() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData(true);
            setup_data.initializeConstructor();
            Test.startTest();
                PageReference redirect = setup_data.ClassUnderTest.redirectToOpportunityView();
            Test.stopTest();
            PageReference expected_page = new ApexPages.StandardController(setup_data.TestOpportunity).view();
            System.assertEquals(expected_page.getUrl(), redirect.getUrl());
        }
    }

    private class SetupDataClass {
        public OpportunityLineItemsEditExtension ClassUnderTest;
        public Account TestAccount;
        public Contact TestContact;
        public Opportunity TestOpportunity;
        public OpportunityLineItem TestLineItem;
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

        public void initializeConstructor(){
            PageReference test_page = Page.OpportunityLineItemsEdit;
            Test.setCurrentPageReference(test_page);
            System.currentPageReference().getParameters().put('id', TestOpportunity.Id);
            ApexPages.Standardcontroller standard_controller = new ApexPages.StandardController(TestOpportunity);
            ClassUnderTest = new OpportunityLineItemsEditExtension(standard_controller);
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
            this.AnotherLineItem = new OpportunityLineItem();
            this.AnotherLineItem.Contact__c = this.TestContact.Id;
            this.AnotherLineItem.PricebookEntryId = this.TestPricebookEntry.Id;
            this.AnotherLineItem.ServiceDate = Date.newInstance(2015, 1, 10);
            this.AnotherLineItem.UnitPrice = 1200;
            this.AnotherLineItem.Quantity = 5;
            this.AnotherLineItem.Unit__c = 'Manntag(e)';
            this.AnotherLineItem.OpportunityId = this.TestOpportunity.Id;
            insert new List<Sobject> {this.TestLineItem, this.AnotherLineItem};
            this.TestLineItem = [SELECT Managed_by_PSO_Tool__c, UnitPrice, Quantity FROM OpportunityLineItem WHERE Id =: this.TestLineItem.Id];
            this.AnotherLineItem = [SELECT Managed_by_PSO_Tool__c, UnitPrice, Quantity FROM OpportunityLineItem WHERE Id =: this.AnotherLineItem.Id];
        }

        public void createOpportunityLineItemsSchedule(){
            Schedule = new OpportunityLineItemSchedule();
            Schedule.OpportunityLineItemId = this.TestLineItem.Id;
            Schedule.ScheduleDate = Date.newInstance(2015, 1, 10);
            Schedule.Quantity = 0.5;
            Schedule.Type = 'Quantity';
            insert new List<Sobject> {this.Schedule};
        }
    }
}