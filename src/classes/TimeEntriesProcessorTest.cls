@isTest
private class TimeEntriesProcessorTest {
    static testmethod void ConstructorSetsProperties() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Date start_date = Date.newInstance(2015, 1, 5);
            Date end_date = Date.newInstance(2015, 1, 20);
            Date job_date = Date.newInstance(2015, 1, 12);
            Test.startTest();
                TimeEntriesProcessor batch = new TimeEntriesProcessor(start_date,end_date, job_date);
            Test.stopTest();
            System.assertEquals(start_date, batch.StartDate);
            System.assertEquals(end_date, batch.EndDate);
            System.assertEquals(job_date, batch.JobDate);
        }
    }

    static testmethod void executeProcessesTimeEntriesAndCreatesSchedules() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Date start_date = Date.newInstance(2015, 1, 5);
            Date end_date = Date.newInstance(2015, 1, 20);
            Date job_date = Date.newInstance(2015, 1, 12);
            setup_data.createTestData();
            TimeEntriesProcessor batch = new TimeEntriesProcessor(start_date,end_date, job_date);
            Test.startTest();
                Database.executeBatch(batch);
            Test.stopTest();
            List<OpportunityLineItemSchedule> schedules = [SELECT Quantity, ScheduleDate FROM OpportunityLineItemSchedule WHERE Description != :OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT];
            System.assertEquals(2, schedules.size());
        }
    }

    static testmethod void executeProcessesTimeEntriesAndCreatesScheduleWithRightParameters() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Date start_date = Date.newInstance(2015, 1, 5);
            Date end_date = Date.newInstance(2015, 1, 7);
            Date job_date = Date.newInstance(2015, 1, 12);
            setup_data.createTestData();
            TimeEntriesProcessor batch = new TimeEntriesProcessor(start_date,end_date, job_date);
            Test.startTest();
                Database.executeBatch(batch);
            Test.stopTest();
            List<OpportunityLineItemSchedule> schedules = [SELECT Quantity, ScheduleDate, OpportunityLineItemId, Type FROM OpportunityLineItemSchedule WHERE Description != :OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT];
            System.assertEquals(1, schedules.size());
            System.assertEquals(setup_data.FirstLineItem.Id, schedules.get(0).OpportunityLineItemId);
            System.assertEquals((setup_data.FirstTimeEntry.Time__c + setup_data.SecondTimeEntry.Time__c)/8, schedules.get(0).Quantity);
            System.assertEquals(setup_data.FirstTimeEntry.Date__c, schedules.get(0).ScheduleDate);
            System.assertEquals(OpportunityLineItemScheduleChangeHandler.DEFAULT_TYPE, schedules.get(0).Type);
        }
    }

    static testmethod void executeProcessesTimeEntriesAndUpdatesExistingScheduleWithRightParameters() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Date start_date = Date.newInstance(2015, 1, 5);
            Date end_date = Date.newInstance(2015, 1, 7);
            Date job_date = Date.newInstance(2015, 1, 12);
            setup_data.createTestData();
            setup_data.createExistingSchedule();
            TimeEntriesProcessor batch = new TimeEntriesProcessor(start_date,end_date, job_date);
            Test.startTest();
                Database.executeBatch(batch);
            Test.stopTest();
            List<OpportunityLineItemSchedule> schedules = [SELECT Quantity, ScheduleDate, OpportunityLineItemId, Type FROM OpportunityLineItemSchedule WHERE Description != :OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT];
            System.assertEquals(1, schedules.size());
            System.assertEquals(setup_data.FirstLineItem.Id, schedules.get(0).OpportunityLineItemId);
            System.assertEquals(((setup_data.FirstTimeEntry.Time__c + setup_data.SecondTimeEntry.Time__c)/8) + setup_data.Schedule.Quantity, schedules.get(0).Quantity);
            System.assertEquals(setup_data.FirstTimeEntry.Date__c, schedules.get(0).ScheduleDate);
            System.assertEquals(OpportunityLineItemScheduleChangeHandler.DEFAULT_TYPE, schedules.get(0).Type);
        }
    }

     private class SetupDataClass{
        private Date StartDate;
        private Date EndDate;
        public User TestUser;
        private String DesiredProfile = 'System Administrator';
        public Account FirstAccount;
        public Contact TestContact;
        public Opportunity FirstOpportunity;
        public OpportunityLineItem FirstLineItem;
        public OpportunityLineItem SecondLineItem;
        public PricebookEntry TestPricebookEntry;
        public Product2 TestProduct;
        public TimeEntry__c FirstTimeEntry;
        public TimeEntry__c SecondTimeEntry;
        public TimeEntry__c ThirdTimeEntry;
        public TimeEntry__c ForthTimeEntry;
        public OpportunityLineItemSchedule Schedule;

        public SetupDataClass() {
            this.TestUser = UserUtility.createNewUser(DesiredProfile);
            this.TestUser.Can_rebook_timesheets__c = true;
            insert TestUser;
        }

        public void createTestData() {
            createAndInsertAccount();
            createAndInsertContactForUser();
            createAndInsertOpportunities();
            createAndInsertProduct();
            createAndInsertPriceBookEntry();
            makeTheTestUserToBeOpportunityMember();
            createOpportunityLineItems();
            createTimeEntries();
        }

        private void createAndInsertAccount(){
            this.FirstAccount = new Account();
            this.FirstAccount.Name = 'First company';
            insert new List<Sobject> {this.FirstAccount};
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

        private void createAndInsertOpportunities(){
            this.FirstOpportunity = new Opportunity();
            this.FirstOpportunity.Name = '° Roshen';
            this.FirstOpportunity.StageName = '° Roshen';
            this.FirstOpportunity.PriceBook2Id = Test.getStandardPricebookId();
            this.FirstOpportunity.AccountId = this.FirstAccount.Id;
            this.FirstOpportunity.CloseDate = Date.newInstance(2015, 1, 1);
            this.FirstOpportunity.Projektleiter_YOUR_SL__c = this.TestContact.Id;
            this.FirstOpportunity.Managed_by_PSO_Tool__c = true;
            this.FirstOpportunity.Projektstatus__c = 'Terrible';
            insert new List<Sobject> {this.FirstOpportunity};
        }

        private void makeTheTestUserToBeOpportunityMember(){
            OpportunityTeamMember first_member = new OpportunityTeamMember();
            first_member.UserId = this.testUser.Id;
            first_member.OpportunityId = this.FirstOpportunity.Id;
            insert new List<Sobject> {first_member};
        }

        private void createOpportunityLineItems(){
            this.FirstLineItem = new OpportunityLineItem();
            this.FirstLineItem.Contact__c = this.TestContact.Id;
            this.FirstLineItem.PricebookEntryId = this.TestPricebookEntry.Id;
            this.FirstLineItem.ServiceDate = Date.newInstance(2015, 1, 5);
            this.FirstLineItem.UnitPrice = 1200;
            this.FirstLineItem.Quantity = 1;
            this.FirstLineItem.Unit__c = 'Manntag(e)';
            this.FirstLineItem.OpportunityId = this.FirstOpportunity.Id;
            this.SecondLineItem = new OpportunityLineItem();
            this.SecondLineItem.Contact__c = this.TestContact.Id;
            this.SecondLineItem.PricebookEntryId = this.TestPricebookEntry.Id;
            this.SecondLineItem.ServiceDate = Date.newInstance(2015, 1, 10);
            this.SecondLineItem.UnitPrice = 1200;
            this.SecondLineItem.Quantity = 1.5;
            this.SecondLineItem.Unit__c = 'Manntag(e)';
            this.SecondLineItem.OpportunityId = this.FirstOpportunity.Id;
            insert new List<Sobject> {this.FirstLineItem, this.SecondLineItem};
        }

        private void createTimeEntries(){
            this.FirstTimeEntry = new TimeEntry__c();
            this.FirstTimeEntry.Billable__c = true;
            this.FirstTimeEntry.Opportunity_Product_ID__c = this.FirstLineItem.Id;
            this.FirstTimeEntry.Date__c = Date.newInstance(2015, 1, 6);
            this.FirstTimeEntry.Time__c = 4;
            this.FirstTimeEntry.Opportunity__c = this.FirstOpportunity.Id;
            this.SecondTimeEntry = new TimeEntry__c();
            this.SecondTimeEntry.Billable__c = true;
            this.SecondTimeEntry.Opportunity_Product_ID__c = this.FirstLineItem.Id;
            this.SecondTimeEntry.Date__c = Date.newInstance(2015, 1, 6);
            this.SecondTimeEntry.Time__c = 2;
            this.SecondTimeEntry.Opportunity__c = this.FirstOpportunity.Id;
            this.ThirdTimeEntry = new TimeEntry__c();
            this.ThirdTimeEntry.Billable__c = true;
            this.ThirdTimeEntry.Opportunity_Product_ID__c = this.SecondLineItem.Id;
            this.ThirdTimeEntry.Date__c = Date.newInstance(2015, 1, 10);
            this.ThirdTimeEntry.Time__c = 4;
            this.ThirdTimeEntry.Opportunity__c = this.FirstOpportunity.Id;
            this.ForthTimeEntry = new TimeEntry__c();
            this.ForthTimeEntry.Billable__c = true;
            this.ForthTimeEntry.Opportunity_Product_ID__c = this.SecondLineItem.Id;
            this.ForthTimeEntry.Date__c = Date.newInstance(2015, 1, 3);
            this.ForthTimeEntry.Time__c = 4;
            this.ForthTimeEntry.Opportunity__c = this.FirstOpportunity.Id;
            insert new List<Sobject> {this.FirstTimeEntry, this.SecondTimeEntry, this.ThirdTimeEntry, this.ForthTimeEntry};
        }

        public void createExistingSchedule(){
            Schedule = new OpportunityLineItemSchedule();
            Schedule.OpportunityLineItemId = this.FirstLineItem.Id;
            Schedule.ScheduleDate = Date.newInstance(2015, 1, 6);
            Schedule.Quantity = 1;
            Schedule.Type = 'Quantity';
            insert Schedule;
        }
    }
}