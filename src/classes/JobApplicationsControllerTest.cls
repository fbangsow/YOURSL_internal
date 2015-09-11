@isTest
private class JobApplicationsControllerTest {

    @isTest static void testControllerQueriesPositionsAndSetsVariables() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData();
            Test.startTest();
                setup_data.initializeController();
            Test.stopTest();
            System.assert(setup_data.ClassUnderTest.IdToOpenPositions.containsKey(setup_data.TestPosition.Id));
            System.assertEquals(null, setup_data.ClassUnderTest.SelectedPosition);
        }
    }

    @isTest static void testGetAvailablePositionsReturnsExpectedList() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData();
            setup_data.initializeController();
            Test.startTest();
                List<SelectOption> options = setup_data.ClassUnderTest.getAvailablePositions();
            Test.stopTest();
            System.assertEquals(2, options.size());
        }
    }

    @isTest static void testGetSelectedPositionObjectReturnsExpectedObject() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData();
            setup_data.initializeController();
            setup_data.ClassUnderTest.SelectedPosition = setup_data.TestPosition.Id;
            Test.startTest();
                Position__c received_position = setup_data.ClassUnderTest.getSelectedPositionObject();
            Test.stopTest();
            System.assertEquals(setup_data.TestPosition.Id, received_position.Id);
        }
    }

    @isTest static void testApplyRedirectsToTheRightPage() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData();
            setup_data.initializeController();
            setup_data.ClassUnderTest.SelectedPosition = setup_data.TestPosition.Id;
            Test.startTest();
                PageReference result_page = setup_data.ClassUnderTest.apply();
            Test.stopTest();
            PageReference expected_page = Page.ApplyForJob;
            expected_page.getParameters().put('SelectedPosition', setup_data.TestPosition.Id);
            System.assertEquals(expected_page.getUrl(), result_page.getUrl());
        }
    }

    @isTest static void testSubmitSavesApplication() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData();
            setup_data.initializeController();
            setup_data.fillOutForm();
            Test.startTest();
                PageReference result_page = setup_data.ClassUnderTest.submit();
            Test.stopTest();
            List<Apexpages.Message> messages = ApexPages.getMessages();
            System.assertEquals(2, messages.size());
        }
    }

    @isTest static void testInsertApplicationInsertsIt() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData();
            setup_data.initializeController();
            setup_data.fillOutForm();
            Test.startTest();
                setup_data.ClassUnderTest.insertApplication();
            Test.stopTest();
            List<Job_Application__c> inserted_applications = [SELECT First_Name__c, Last_Name__c, Email__c, Phone__c, Skype__c, LinkedIn__c, XING__c
                                                        FROM Job_Application__c WHERE Email__c = 'ali@muhhamed.com'];
            System.assertEquals(1, inserted_applications.size());
        }
    }

    @isTest static void testGetEnglishConfirmationTextReturnsText() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.initializeController();
            Test.startTest();
                String confirmation_text = setup_data.ClassUnderTest.getEnglishConfirmationText();
            Test.stopTest();
            System.assertNotEquals(null, confirmation_text);
        }
    }

    @isTest static void testGetAcknowledgeCheckboxText() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.initializeController();
            Test.startTest();
                String acknowledge_checkbox_text = setup_data.ClassUnderTest.getAcknowledgeCheckboxText();
            Test.stopTest();
            System.assertNotEquals(null, acknowledge_checkbox_text);
        }
    }

    @isTest static void testGetAcknowledgeText() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.initializeController();
            Test.startTest();
                String acknowledge_text = setup_data.ClassUnderTest.getAcknowledgeText();
            Test.stopTest();
            System.assertNotEquals(null, acknowledge_text);
        }
    }

    @isTest static void testGetCandidateSourceOptions() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.initializeController();
            Test.startTest();
                List<SelectOption> select_options = setup_data.ClassUnderTest.getCandidateSourceOptions();
            Test.stopTest();
            System.assertNotEquals(0, select_options.size());
        }
    }

    private class SetupDataClass {
        public JobApplicationsController ClassUnderTest;
        public Position__c TestPosition;
        public User TestUser;
        private String DesiredProfile = 'System Administrator';

        public SetupDataClass() {
            this.TestUser = UserUtility.createNewUser(DesiredProfile);
            insert TestUser;
        }

        public SetupDataClass(String desired_profile){
            this.DesiredProfile = desired_profile;
            this.TestUser = UserUtility.createNewUser(DesiredProfile);
            insert TestUser;
        }

        public void createTestData(){
            TestPosition = new Position__c();
            TestPosition.Functional_Area__c = 'SalesDepartment';
            TestPosition.Job_Title__c = 'Developer';
            TestPosition.Job_Description__c = 'Boring';
            TestPosition.Responsibilities__c = 'Be sober at work';
            TestPosition.Approval_Status__c = 'Approved';
            TestPosition.Status__c = 'Hiring';
            insert TestPosition;
        }

        public void initializeController(){
            ClassUnderTest = new JobApplicationsController();
        }

        public void fillOutForm(){
            ClassUnderTest.SelectedPosition = TestPosition.Id;
            ClassUnderTest.Application.First_Name__c = 'Muhammed';
            ClassUnderTest.Application.Last_Name__c = 'Ali';
            ClassUnderTest.Application.Email__c = 'ali@muhhamed.com';
            ClassUnderTest.Application.Phone__c = '1234566';
            ClassUnderTest.Application.Start_Date__c = Date.today();
            ClassUnderTest.Application.Skype__c = 'jonny';
            ClassUnderTest.Application.LinkedIn__c = 'jonny';
            ClassUnderTest.Application.XING__c = 'jonny';
        }
    }
}