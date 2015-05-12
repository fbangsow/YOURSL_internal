@isTest
private class ClsOffTimeRequestProcessorTest {

    static testMethod void testClsOffTimeRequestProcessorCreatesNewOpportunityLineItems() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createAndInsertOpportunityAndAccountAndContactAndProductAndPriceBookAndPriceBookAndPricebookEntry(true);
            Integer numberOfRequestsToProcess = 1;
            List<Time_Off_Request__c> listOfRequestsToBeProcessed = setup_data.getListOfTimeOffRequests(numberOfRequestsToProcess, false);
            Test.startTest();
                new ClsOffTimeRequestProcessor(listOfRequestsToBeProcessed);
            Test.stopTest();
            List<OpportunityLineItem> newOpportunityLineItems = [SELECT PricebookEntryId, OpportunityId, Quantity, TotalPrice, ServiceDate, Description, Contact__c, Unit__c, Sub_Unternehmen__c FROM OpportunityLineItem ORDER BY ServiceDate ASC];
            System.assertEquals(numberOfRequestsToProcess * 5, newOpportunityLineItems.size(), 'Number of created line items should match to the mumber of days off in the created request');
            OpportunityLineItem singleOpportunityLineItem = newOpportunityLineItems.get(0);
            System.assertEquals(setup_data.testPricebookEntry.Id, singleOpportunityLineItem.PricebookEntryId, 'Created line item\'s PricebookEntryId should match to the one created in tests');
            System.assertEquals(setup_data.testOpportunity.Id, singleOpportunityLineItem.OpportunityId, 'Created line item\'s OpportunityId should match to the one created in tests');
            System.assertEquals(1, singleOpportunityLineItem.Quantity, 'Created line item\'s Quantity should be equal to the one set in controller');
            System.assertEquals(0, singleOpportunityLineItem.TotalPrice, 'Created line item\'s TotalPrice should be equal to the one set in controller');
            System.assertEquals(Date.newInstance(2015, 1, 5), singleOpportunityLineItem.ServiceDate, 'Created line item\'s ServiceDate should be on the second monday of 2015, which is the 5th of January');
            System.assertEquals(ClsOffTimeRequestProcessor.mapRequestTypeToRequestDescription.get(setup_data.REQUEST_TYPE), singleOpportunityLineItem.Description, 'Created line item\'s Description should be mapped correctly');
            System.assertEquals(setup_data.testContact.Id, singleOpportunityLineItem.Contact__c, 'Created line item\'s relation to Contact should be linked to the one created in the tests');
            System.assertEquals(ClsOffTimeRequestProcessor.DEFAULT_UNIT_VALUE, singleOpportunityLineItem.Unit__c, 'Created line item\'s Unit value should be equal to the one hardcoded in the controller');
            System.assertEquals(setup_data.testAccount.Id, singleOpportunityLineItem.Sub_Unternehmen__c, 'Created line item\'s AccountId value should be equal to the one created in the tests');
        }
    }

    static testMethod void testClsOffTimeRequestProcessorDoesntCreateOpportunityLineItemsWhenOpportunityDoesnExistForSelectedYear() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            List<OpportunityLineItem> newOpportunityLineItems2 = [SELECT Id FROM OpportunityLineItem ORDER BY ServiceDate ASC];
            setup_data.createAndInsertOpportunityAndAccountAndContactAndProductAndPriceBookAndPriceBookAndPricebookEntry(false);
            Integer numberOfRequestsToProcess = 1;
            List<Time_Off_Request__c> listOfRequestsToBeProcessed = setup_data.getListOfTimeOffRequests(numberOfRequestsToProcess, false);
            List<OpportunityLineItem> newOpportunityLineItems3 = [SELECT Id FROM OpportunityLineItem ORDER BY ServiceDate ASC];
            Test.startTest();
                new ClsOffTimeRequestProcessor(listOfRequestsToBeProcessed);
            Test.stopTest();
            List<OpportunityLineItem> newOpportunityLineItems = [SELECT Id FROM OpportunityLineItem ORDER BY ServiceDate ASC];
            System.assertEquals(0, newOpportunityLineItems.size(), 'There shouldn\'t be any line items for this scenario');
        }
    }

    static testMethod void testClsOffTimeRequestProcessorCreatesRightNumberOfNewOpportunityLineItems() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createAndInsertOpportunityAndAccountAndContactAndProductAndPriceBookAndPriceBookAndPricebookEntry(true);
            Integer numberOfRequestsToProcess = 20;
            List<Time_Off_Request__c> listOfRequestsToBeProcessed = setup_data.getListOfTimeOffRequests(numberOfRequestsToProcess, false);
            Test.startTest();
                new ClsOffTimeRequestProcessor(listOfRequestsToBeProcessed);
            Test.stopTest();
            List<OpportunityLineItem> newOpportunityLineItems = [SELECT Id FROM OpportunityLineItem];
            System.assertEquals(numberOfRequestsToProcess*5, newOpportunityLineItems.size(), 'Number of created line items should match to the mumber of days in all requests');
        }
    }

    private class SetupDataClass {
        public Opportunity testOpportunity;
        public PriceBook2 priceBook;
        public PricebookEntry testPricebookEntry;
        public Product2 testProduct;
        public User testUser;
        public Contact testContact;
        public Account testAccount;
        private final String DESIRED_PROFILE = 'System Administrator'; 
        private final String REQUEST_TYPE = 'Holiday Request/Urlaubsantrag';

        public SetupDataClass() {
            this.testUser = UserUtility.createNewUser(DESIRED_PROFILE);
            insert testUser;
        }

        public void createAndInsertOpportunityAndAccountAndContactAndProductAndPriceBookAndPriceBookAndPricebookEntry(Boolean opportunityCloseDateMatchesSelectedYear) {
            createAndInsertAccount();
            createAndInsertContactForUser();
            createAndInsertProduct();
            createAndInsertOpportunity(opportunityCloseDateMatchesSelectedYear);
            createAndInsertPriceBookEntry();
        }

        private void createAndInsertAccount(){
            this.testAccount = new Account();
            this.testAccount.Name = 'YOUR SL GmbH';
            insert this.testAccount;
        }

        private void createAndInsertContactForUser() {
            this.testContact = new Contact();
            this.testContact.FirstName = testUser.FirstName;
            this.testContact.LastName = testUser.LastName;
            this.testContact.AccountId = this.testAccount.Id;
            insert this.testContact;
        }

        private void createAndInsertProduct() {
            this.testProduct = new Product2();
            this.testProduct.Name = ClsOffTimeRequestProcessor.mapRequestTypeToProduct.get(REQUEST_TYPE);
            this.testProduct.isActive = true;
            insert this.testProduct; 
        }

        private void createAndInsertOpportunity(Boolean opportunityCloseDateMatchesSelectedYear){
            this.testOpportunity = new Opportunity();
            this.testOpportunity.OwnerId = this.testUser.Id;
            this.testOpportunity.Name = '° Roshen';
            this.testOpportunity.StageName = '° Roshen';
            this.testOpportunity.PriceBook2Id = Test.getStandardPricebookId();
            if(opportunityCloseDateMatchesSelectedYear)
                this.testOpportunity.CloseDate = Date.newInstance(2015, 1, 1);
            else
                this.testOpportunity.CloseDate = Date.newInstance(2014, 1, 1);
            insert this.testOpportunity;
        }

        private void createAndInsertPriceBookEntry() {
            this.testPricebookEntry = new PriceBookEntry();
            this.testPricebookEntry.Product2Id = this.testProduct.Id;
            this.testPricebookEntry.UnitPrice = 100;
            this.testPricebookEntry.UseStandardPrice = false;
            this.testPricebookEntry.Pricebook2Id = Test.getStandardPricebookId();
            this.testPricebookEntry.IsActive = true;
            insert this.testPricebookEntry;

        }

        public List<Time_Off_Request__c> getListOfTimeOffRequests(Integer numberOfRequests, Boolean isApproved) {
            List<Time_Off_Request__c> listOfTimeOffRequests = new List<Time_Off_Request__c> ();
            while(numberOfRequests > 0){
                Time_Off_Request__c timeOffRequest = new Time_Off_Request__c();
                timeOffRequest.Employee__c = this.testContact.Id;
                timeOffRequest.Type__c = REQUEST_TYPE;
                timeOffRequest.Monday__c = '1';
                timeOffRequest.Tuesday__c = '1';
                timeOffRequest.Wednesday__c = '1';
                timeOffRequest.Thursday__c = '1';
                timeOffRequest.Friday__c = '1'; 
                timeOffRequest.Calendar_Week__c = '2';
                timeOffRequest.Year__c = '2015';
                if(isApproved)
                    timeOffRequest.Approval_Status__c = 'Approved';
                listOfTimeOffRequests.add(timeOffRequest);
                numberOfRequests--;
            }
            return listOfTimeOffRequests;
        }
    }
}