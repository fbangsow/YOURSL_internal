@isTest
private class PlannedSchedulesEraserTest{
    static testmethod void ConstructorSetsProperties() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Date start_date = Date.newInstance(2015, 1, 5);
            Date end_date = Date.newInstance(2015, 1, 20);
            Date job_date = Date.newInstance(2015, 1, 12);
            setup_data.createTestData();
            Test.startTest();
                PlannedSchedulesEraser batch = new PlannedSchedulesEraser(start_date,end_date, job_date);
            Test.stopTest();
            System.assertEquals(start_date, batch.StartDate);
            System.assertEquals(end_date, batch.EndDate);
            System.assertEquals(job_date, batch.JobDate);
        }
    }

    static testmethod void ExecuteBatchDeletesSchedulesWithingDateRange() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Date start_date = Date.newInstance(2015, 1, 9);
            Date end_date = Date.newInstance(2015, 1, 12);
            Date job_date = Date.newInstance(2015, 1, 12);
            setup_data.createTestData();
            PlannedSchedulesEraser batch = new PlannedSchedulesEraser(start_date,end_date, job_date);
            Test.startTest();
                Database.executeBatch(batch);
            Test.stopTest();
            List<OpportunityLineItemSchedule> schedules = [SELECT Id, Quantity, ScheduleDate FROM OpportunityLineItemSchedule WHERE Description != :OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT];
            System.assertEquals(1, schedules.size());
            System.assertEquals(setup_data.FirstSchedule.Id, schedules.get(0).Id);
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
        public OpportunityLineItemSchedule FirstSchedule;
        public OpportunityLineItemSchedule SecondSchedule;
        public OpportunityLineItemSchedule ThirdSchedule;

        public SetupDataClass() {
            this.TestUser = UserUtility.createNewUser(DesiredProfile);
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
            createOpportunityLineItemsSchedule();
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

        private void createOpportunityLineItemsSchedule(){
            FirstSchedule = new OpportunityLineItemSchedule();
            FirstSchedule.OpportunityLineItemId = this.FirstLineItem.Id;
            FirstSchedule.ScheduleDate = Date.newInstance(2015, 1, 5);
            FirstSchedule.Quantity = 1;
            FirstSchedule.Type = 'Quantity';
            SecondSchedule = new OpportunityLineItemSchedule();
            SecondSchedule.OpportunityLineItemId = this.SecondLineItem.Id;
            SecondSchedule.ScheduleDate = Date.newInstance(2015, 1, 10);
            SecondSchedule.Quantity = 1;
            SecondSchedule.Type = 'Quantity';
            ThirdSchedule = new OpportunityLineItemSchedule();
            ThirdSchedule.OpportunityLineItemId = this.SecondLineItem.Id;
            ThirdSchedule.ScheduleDate = Date.newInstance(2015, 1, 11);
            ThirdSchedule.Quantity = 0.5;
            ThirdSchedule.Type = 'Quantity';
            insert new List<Sobject> {FirstSchedule, SecondSchedule, ThirdSchedule};
        }
    }
}