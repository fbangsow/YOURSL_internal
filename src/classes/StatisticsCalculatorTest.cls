@isTest
private class StatisticsCalculatorTest {
    @isTest static void getInstanceSetsVariables(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Test.startTest();
                setup_data.instantiateCalculator(Date.newInstance(2015, 1, 1), true);
            Test.stopTest();
            System.assertEquals(setup_data.IsPlanned, setup_data.ClassUnderTest.IsPlanned);
            System.assertEquals(setup_data.JobDate, setup_data.ClassUnderTest.JobDate);
        }
    }

    @isTest static void getDatesForCalculationCalculatesCorrectlyForARegularWeekForPlannedContext(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Test.startTest();
                setup_data.instantiateCalculator(Date.newInstance(2015, 6, 15), true);
            Test.stopTest();
            System.assertEquals(Date.newInstance(2015, 6, 15), setup_data.ClassUnderTest.WeekStart);
            System.assertEquals(Date.newInstance(2015, 6, 21), setup_data.ClassUnderTest.WeekEnd);
            System.assert(!setup_data.ClassUnderTest.ExtendedContext);
            System.assertEquals(null, setup_data.ClassUnderTest.MonthStart);
            System.assertEquals(null, setup_data.ClassUnderTest.MonthEnd);
        }
    }

    @isTest static void getDatesForCalculationCalculatesCorrectlyForARegularWeekForActualContext(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Test.startTest();
                setup_data.instantiateCalculator(Date.newInstance(2015, 6, 15), false);
            Test.stopTest();
            System.assertEquals(Date.newInstance(2015, 6, 8), setup_data.ClassUnderTest.WeekStart);
            System.assertEquals(Date.newInstance(2015, 6, 14), setup_data.ClassUnderTest.WeekEnd);
            System.assert(!setup_data.ClassUnderTest.ExtendedContext);
            System.assertEquals(null, setup_data.ClassUnderTest.MonthStart);
            System.assertEquals(null, setup_data.ClassUnderTest.MonthEnd);
        }
    }

    @isTest static void getDatesForCalculationCalculatesCorrectlyForASplitWeekForPlannedContext(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Test.startTest();
                setup_data.instantiateCalculator(Date.newInstance(2015, 6, 29), true);
            Test.stopTest();
            System.assertEquals(Date.newInstance(2015, 6, 29), setup_data.ClassUnderTest.WeekStart);
            System.assertEquals(Date.newInstance(2015, 6, 30), setup_data.ClassUnderTest.WeekEnd);
            System.assert(!setup_data.ClassUnderTest.ExtendedContext);
            System.assertEquals(null, setup_data.ClassUnderTest.MonthStart);
            System.assertEquals(null, setup_data.ClassUnderTest.MonthEnd);
        }
    }

    @isTest static void getDatesForCalculationCalculatesCorrectlyForASplitWeekForActualContext(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Test.startTest();
                setup_data.instantiateCalculator(Date.newInstance(2015, 7, 6), false);
            Test.stopTest();
            System.assertEquals(Date.newInstance(2015, 7, 1), setup_data.ClassUnderTest.WeekStart);
            System.assertEquals(Date.newInstance(2015, 7, 5), setup_data.ClassUnderTest.WeekEnd);
            System.assert(!setup_data.ClassUnderTest.ExtendedContext);
            System.assertEquals(null, setup_data.ClassUnderTest.MonthStart);
            System.assertEquals(null, setup_data.ClassUnderTest.MonthEnd);
        }
    }

    @isTest static void getDatesForCalculationCalculatesCorrectlyWhenMonthStartIsMondayForPlannedContext(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Test.startTest();
                setup_data.instantiateCalculator(Date.newInstance(2015, 6, 1), true);
            Test.stopTest();
            System.assertEquals(Date.newInstance(2015, 6, 1), setup_data.ClassUnderTest.WeekStart);
            System.assertEquals(Date.newInstance(2015, 6, 7), setup_data.ClassUnderTest.WeekEnd);
            System.assert(setup_data.ClassUnderTest.ExtendedContext);
            System.assertEquals(Date.newInstance(2015, 6, 1), setup_data.ClassUnderTest.MonthStart);
            System.assertEquals(Date.newInstance(2015, 6, 30), setup_data.ClassUnderTest.MonthEnd);
        }
    }

    @isTest static void getDatesForCalculationCalculatesCorrectlyWhenMonthStartIsMondayForActualContext(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Test.startTest();
                setup_data.instantiateCalculator(Date.newInstance(2015, 6, 1), false);
            Test.stopTest();
            System.assertEquals(Date.newInstance(2015, 5, 25), setup_data.ClassUnderTest.WeekStart);
            System.assertEquals(Date.newInstance(2015, 5, 31), setup_data.ClassUnderTest.WeekEnd);
            System.assert(setup_data.ClassUnderTest.ExtendedContext);
            System.assertEquals(Date.newInstance(2015, 5, 1), setup_data.ClassUnderTest.MonthStart);
            System.assertEquals(Date.newInstance(2015, 5, 31), setup_data.ClassUnderTest.MonthEnd);
        }
    }

    @isTest static void getDatesForCalculationCalculatesCorrectlyWhenMonthStartIsNotMondayForPlannedContext(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Test.startTest();
                setup_data.instantiateCalculator(Date.newInstance(2015, 7, 1), true);
            Test.stopTest();
            System.assertEquals(Date.newInstance(2015, 7, 1), setup_data.ClassUnderTest.WeekStart);
            System.assertEquals(Date.newInstance(2015, 7, 5), setup_data.ClassUnderTest.WeekEnd);
            System.assert(setup_data.ClassUnderTest.ExtendedContext);
            System.assertEquals(Date.newInstance(2015, 7, 1), setup_data.ClassUnderTest.MonthStart);
            System.assertEquals(Date.newInstance(2015, 7, 31), setup_data.ClassUnderTest.MonthEnd);
        }
    }

    @isTest static void getDatesForCalculationCalculatesCorrectlyWhenMonthStartIsNotMondayForActualContext(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Test.startTest();
                setup_data.instantiateCalculator(Date.newInstance(2015, 7, 1), false);
            Test.stopTest();
            System.assertEquals(Date.newInstance(2015, 6, 29), setup_data.ClassUnderTest.WeekStart);
            System.assertEquals(Date.newInstance(2015, 6, 30), setup_data.ClassUnderTest.WeekEnd);
            System.assert(setup_data.ClassUnderTest.ExtendedContext);
            System.assertEquals(Date.newInstance(2015, 6, 1), setup_data.ClassUnderTest.MonthStart);
            System.assertEquals(Date.newInstance(2015, 6, 30), setup_data.ClassUnderTest.MonthEnd);
        }
    }

    @isTest static void getDatesForCalculationCalculatesCorrectlyWhenMonthStartIsNotMondayForPlannedContextAdditional(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Test.startTest();
                setup_data.instantiateCalculator(Date.newInstance(2015, 9, 1), true);
            Test.stopTest();
            System.assertEquals(Date.newInstance(2015, 9, 1), setup_data.ClassUnderTest.WeekStart);
            System.assertEquals(Date.newInstance(2015, 9, 6), setup_data.ClassUnderTest.WeekEnd);
            System.assert(setup_data.ClassUnderTest.ExtendedContext);
            System.assertEquals(Date.newInstance(2015, 9, 1), setup_data.ClassUnderTest.MonthStart);
            System.assertEquals(Date.newInstance(2015, 9, 30), setup_data.ClassUnderTest.MonthEnd);
        }
    }

    @isTest static void getDatesForCalculationCalculatesCorrectlyWhenMonthStartIsNotMondayForActualContextAdditional(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Test.startTest();
                setup_data.instantiateCalculator(Date.newInstance(2015, 9, 1), false);
            Test.stopTest();
            System.assertEquals(Date.newInstance(2015, 8, 31), setup_data.ClassUnderTest.WeekStart);
            System.assertEquals(Date.newInstance(2015, 8, 31), setup_data.ClassUnderTest.WeekEnd);
            System.assert(setup_data.ClassUnderTest.ExtendedContext);
            System.assertEquals(Date.newInstance(2015, 8, 1), setup_data.ClassUnderTest.MonthStart);
            System.assertEquals(Date.newInstance(2015, 8, 31), setup_data.ClassUnderTest.MonthEnd);
        }
    }

    @isTest static void getDatesForCalculationThrowsAnExceptionWhenDateIsNotMondayOrMonthStart(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Boolean exception_is_caught = false;
            Test.startTest();
                try{
                    setup_data.instantiateCalculator(Date.newInstance(2015, 6, 17), false);
                } catch(StatisticsCalculator.InvalidDateException e){
                    exception_is_caught = true;
                }
            Test.stopTest();
            System.assert(exception_is_caught);
        }
    }

    @isTest static void getStatisticalDataGathersStatisticsProperly(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.instantiateCalculator(Date.newInstance(2015, 9, 1), false);
            setup_data.createTestData();
            Test.startTest();
                List<StatisticsCalculator.RawStatistics> stats = setup_data.ClassUnderTest.getStatisticalData(Date.newInstance(2015, 1, 1), Date.newInstance(2015, 1, 20), StatisticsCalculator.WEEK_TIME_TYPE, StatisticsCalculator.PLANNED_DATA_TYPE);
            Test.stopTest();
            System.assertEquals(2, stats.size());
        }
    }

    @isTest static void getStatisticalDataGathersStatisticsAndSetsAllProperties(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.instantiateCalculator(Date.newInstance(2015, 9, 1), false);
            Date start_date = Date.newInstance(2015, 1, 6);
            Date end_date = Date.newInstance(2015, 1, 20);
            setup_data.createTestData();
            Test.startTest();
                List<StatisticsCalculator.RawStatistics> stats = setup_data.ClassUnderTest.getStatisticalData(start_date, end_date, StatisticsCalculator.WEEK_TIME_TYPE, StatisticsCalculator.PLANNED_DATA_TYPE);
            Test.stopTest();
            System.assertEquals(1, stats.size());
            System.assertEquals(setup_data.TestContact.Id, stats.get(0).ContactId);
            System.assertEquals(setup_data.SecondSchedule.Quantity + setup_data.ThirdSchedule.Quantity, stats.get(0).Days);
            System.assertEquals(setup_data.SecondLineItem.UnitPrice, stats.get(0).SalesPrice);
            System.assertEquals(StatisticsCalculator.WEEK_TIME_TYPE, stats.get(0).TimeType);
            System.assertEquals(StatisticsCalculator.PLANNED_DATA_TYPE, stats.get(0).DataType);
            System.assertEquals(setup_data.SecondLineItem.Id, stats.get(0).OpportunityLineItemId);
            System.assertEquals(Date.newInstance(2015, 8, 31), stats.get(0).StartDate);
            System.assertEquals(Date.newInstance(2015, 8, 31), stats.get(0).EndDate);
        }
    }

    @isTest static void createStatisticsAndDeletePreviouslyCreatedCreatesNewRecords(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.instantiateCalculator(Date.newInstance(2015, 1, 12), false);
            setup_data.createTestData();
            Test.startTest();
                setup_data.ClassUnderTest.createStatistics();
            Test.stopTest();
            List<Planning_Statistics__c> stats = [SELECT Contact__c, Data_Type__c, Time_Type__c, Days__c, Start_Date__c, End_Date__c, OpportunityLineItemId__c, Revenue__c FROM Planning_Statistics__c];
            System.assertEquals(1, stats.size());
            System.assertEquals(setup_data.TestContact.Id, stats.get(0).Contact__c);
            System.assertEquals(setup_data.SecondSchedule.Quantity + setup_data.ThirdSchedule.Quantity, stats.get(0).Days__c);
            System.assertEquals(setup_data.SecondLineItem.UnitPrice*(setup_data.SecondSchedule.Quantity + setup_data.ThirdSchedule.Quantity), stats.get(0).Revenue__c);
            System.assertEquals(StatisticsCalculator.WEEK_TIME_TYPE, stats.get(0).Time_Type__c);
            System.assertEquals(StatisticsCalculator.ACTUAL_DATA_TYPE, stats.get(0).Data_Type__c);
            System.assertEquals(setup_data.SecondLineItem.Id, stats.get(0).OpportunityLineItemId__c);
            System.assertEquals(Date.newInstance(2015, 1, 5), stats.get(0).Start_Date__c);
            System.assertEquals(Date.newInstance(2015, 1, 11), stats.get(0).End_Date__c);
        }
    }

    @isTest static void createStatisticsAndDeletePreviouslyCreatedCreatesNewRecordsForPlannedCase(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.instantiateCalculator(Date.newInstance(2015, 1, 5), true);
            setup_data.createTestData();
            Test.startTest();
                setup_data.ClassUnderTest.createStatistics();
            Test.stopTest();
            List<Planning_Statistics__c> stats = [SELECT Contact__c, Data_Type__c, Time_Type__c, Days__c, Start_Date__c, End_Date__c, OpportunityLineItemId__c, Revenue__c FROM Planning_Statistics__c];
            System.assertEquals(1, stats.size());
            System.assertEquals(setup_data.TestContact.Id, stats.get(0).Contact__c);
            System.assertEquals(setup_data.SecondSchedule.Quantity + setup_data.ThirdSchedule.Quantity, stats.get(0).Days__c);
            System.assertEquals(setup_data.SecondLineItem.UnitPrice*(setup_data.SecondSchedule.Quantity + setup_data.ThirdSchedule.Quantity), stats.get(0).Revenue__c);
            System.assertEquals(StatisticsCalculator.WEEK_TIME_TYPE, stats.get(0).Time_Type__c);
            System.assertEquals(StatisticsCalculator.PLANNED_DATA_TYPE, stats.get(0).Data_Type__c);
            System.assertEquals(setup_data.SecondLineItem.Id, stats.get(0).OpportunityLineItemId__c);
            System.assertEquals(Date.newInstance(2015, 1, 5), stats.get(0).Start_Date__c);
            System.assertEquals(Date.newInstance(2015, 1, 11), stats.get(0).End_Date__c);
        }
    }

    @isTest static void createStatisticsAndDeletePreviouslyCreatedDeletesPreviouslyCreatedDuplicates(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.instantiateCalculator(Date.newInstance(2015, 2, 1), false);
            setup_data.createTestData();
            setup_data.ClassUnderTest.createStatistics();
            Test.startTest();
                setup_data.ClassUnderTest.createStatistics();
            Test.stopTest();
            List<Planning_Statistics__c> stats = [SELECT Contact__c, Data_Type__c, Time_Type__c, Days__c, Start_Date__c, End_Date__c, OpportunityLineItemId__c, Revenue__c FROM Planning_Statistics__c];
            System.assertEquals(3, stats.size());
        }
    }

    @isTest static void getDatesToBeDisplayedFillsOutDatesForWeeklyJob(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.instantiateCalculator(Date.newInstance(2015, 6, 22), false);
            Test.startTest();
                StatisticsCalculator.DatesToBeDisplayed dates = setup_data.ClassUnderTest.getDatesToBeDisplayed();
            Test.stopTest();
            System.assertEquals(Date.newInstance(2015, 6, 22), Date.parse(dates.PlannedWeekStart));
            System.assertEquals(Date.newInstance(2015, 6, 28), Date.parse(dates.PlannedWeekEnd));
            System.assertEquals(null, dates.PlannedMonthStart);
            System.assertEquals(null, dates.PlannedMonthEnd);
            System.assertEquals(Date.newInstance(2015, 6, 15), Date.parse(dates.ActualWeekStart));
            System.assertEquals(Date.newInstance(2015, 6, 21), Date.parse(dates.ActualWeekEnd));
            System.assertEquals(null, dates.ActualMonthStart);
            System.assertEquals(null, dates.ActualMonthEnd);
        }
    }

    @isTest static void getDatesToBeDisplayedFillsOutDatesForMonthlyJob(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.instantiateCalculator(Date.newInstance(2015, 7, 1), false);
            Test.startTest();
                StatisticsCalculator.DatesToBeDisplayed dates = setup_data.ClassUnderTest.getDatesToBeDisplayed();
            Test.stopTest();
            System.assertEquals(Date.newInstance(2015, 7, 1), Date.parse(dates.PlannedWeekStart));
            System.assertEquals(Date.newInstance(2015, 7, 5), Date.parse(dates.PlannedWeekEnd));
            System.assertEquals(Date.newInstance(2015, 7, 1), Date.parse(dates.PlannedMonthStart));
            System.assertEquals(Date.newInstance(2015, 7, 31), Date.parse(dates.PlannedMonthEnd));
            System.assertEquals(Date.newInstance(2015, 6, 29), Date.parse(dates.ActualWeekStart));
            System.assertEquals(Date.newInstance(2015, 6, 30), Date.parse(dates.ActualWeekEnd));
            System.assertEquals(Date.newInstance(2015, 6, 1), Date.parse(dates.ActualMonthStart));
            System.assertEquals(Date.newInstance(2015, 6, 30), Date.parse(dates.ActualMonthEnd));
        }
    }

    @isTest static void getDatesToBeDisplayedReturnsJSON(){
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.instantiateCalculator(Date.newInstance(2015, 7, 1), false);
            Test.startTest();
                String json = setup_data.ClassUnderTest.getDatesToBeDisplayed().JSON();
            Test.stopTest();
            System.assertNotEquals(null, json);
        }
    }

    private class SetupDataClass{
        private StatisticsCalculator ClassUnderTest;
        private Date JobDate;
        private Boolean IsPlanned;
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
        public OpportunityLineItemSchedule ForthSchedule;
        public OpportunityLineItemSchedule FifthSchedule;

        public SetupDataClass() {
            this.TestUser = UserUtility.createNewUser(DesiredProfile);
            insert TestUser;
        }

        public void instantiateCalculator(Date job_date, Boolean is_planned){
            JobDate = job_date;
            IsPlanned = is_planned;
            ClassUnderTest = StatisticsCalculator.getInstance(JobDate, IsPlanned);
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
            FirstSchedule.ScheduleDate = Date.newInstance(2015, 1, 4);
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
            ForthSchedule = new OpportunityLineItemSchedule();
            ForthSchedule.OpportunityLineItemId = this.SecondLineItem.Id;
            ForthSchedule.ScheduleDate = Date.newInstance(2015, 4, 11);
            ForthSchedule.Quantity = 0.4;
            ForthSchedule.Type = 'Quantity';
            FifthSchedule = new OpportunityLineItemSchedule();
            FifthSchedule.OpportunityLineItemId = this.SecondLineItem.Id;
            FifthSchedule.ScheduleDate = Date.newInstance(2015, 1, 29);
            FifthSchedule.Quantity = 0.2;
            FifthSchedule.Type = 'Quantity';
            insert new List<Sobject> {FirstSchedule, SecondSchedule, ThirdSchedule, ForthSchedule, FifthSchedule};
        }
    }
}