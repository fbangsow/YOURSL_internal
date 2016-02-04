@isTest
private class MBOViewExtensionTest {
    @isTest static void testConstructorFindsMBOs() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData();
            Test.startTest();
                setup_data.initializeClass();
            Test.stopTest();
            System.assertNotEquals(null, setup_data.ClassUnderTest.CurrentGoals);
            System.assertEquals(4, setup_data.ClassUnderTest.CurrentGoals.MBOs.size());
            System.assertEquals(setup_data.MBOs.MBO_1__c, setup_data.ClassUnderTest.CurrentGoals.MBOs.get(0).ShortDescription);
            System.assertEquals(setup_data.MBOs.MBO_1_Beschreibung__c, setup_data.ClassUnderTest.CurrentGoals.MBOs.get(0).LongDescription);
            System.assertEquals(setup_data.MBOs.MBO_1_Gewichtung_in_Prozent__c, setup_data.ClassUnderTest.CurrentGoals.MBOs.get(0).WeightOfMBO);
            System.assertEquals(setup_data.MBOs.MBO_1_Ergebnis__c, setup_data.ClassUnderTest.CurrentGoals.MBOs.get(0).PercentsAchieved);
            System.assertEquals(setup_data.MBOs.MBO_2_Kurzbeschreibung__c, setup_data.ClassUnderTest.CurrentGoals.MBOs.get(1).ShortDescription);
            System.assertEquals(setup_data.MBOs.MBO_2_Langbeschreibung__c, setup_data.ClassUnderTest.CurrentGoals.MBOs.get(1).LongDescription);
            System.assertEquals(setup_data.MBOs.MBO_2_Wichtung_in_Prozent__c, setup_data.ClassUnderTest.CurrentGoals.MBOs.get(1).WeightOfMBO);
            System.assertEquals(setup_data.MBOs.MBO_2_Ergebnis__c, setup_data.ClassUnderTest.CurrentGoals.MBOs.get(1).PercentsAchieved);
            System.assertEquals(setup_data.MBOs.MBO_3_Kurzbeschreibung__c, setup_data.ClassUnderTest.CurrentGoals.MBOs.get(2).ShortDescription);
            System.assertEquals(setup_data.MBOs.MBO_3_Beschreibung__c, setup_data.ClassUnderTest.CurrentGoals.MBOs.get(2).LongDescription);
            System.assertEquals(setup_data.MBOs.MBO_3_Gewichtung__c, setup_data.ClassUnderTest.CurrentGoals.MBOs.get(2).WeightOfMBO);
            System.assertEquals(setup_data.MBOs.MBO_3_Ergebnis__c, setup_data.ClassUnderTest.CurrentGoals.MBOs.get(2).PercentsAchieved);
            System.assertEquals(setup_data.MBOs.MBO_4_Kurzbeschreibung__c, setup_data.ClassUnderTest.CurrentGoals.MBOs.get(3).ShortDescription);
            System.assertEquals(setup_data.MBOs.MBO_4_Beschreibung__c, setup_data.ClassUnderTest.CurrentGoals.MBOs.get(3).LongDescription);
            System.assertEquals(setup_data.MBOs.MBO_4_Gewichtung_in_Prozent__c, setup_data.ClassUnderTest.CurrentGoals.MBOs.get(3).WeightOfMBO);
            System.assertEquals(setup_data.MBOs.MBO_4_Ergebnis__c, setup_data.ClassUnderTest.CurrentGoals.MBOs.get(3).PercentsAchieved);
        }
    }

    @isTest static void testConstructorFindsNoMBOs() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestDataWithoutMBOs();
            Test.startTest();
                setup_data.initializeClass();
            Test.stopTest();
            System.assertNotEquals(null, setup_data.ClassUnderTest.CurrentGoals);
            System.assertEquals(0, setup_data.ClassUnderTest.CurrentGoals.MBOs.size());
        }
    }

    private class SetupDataClass {
        public User TestUser;
        public Ziel__c MBOs;
        public Contact UserContact;
        private String DesiredProfile = 'System Administrator';
        public MBOViewExtension ClassUnderTest;


        public SetupDataClass() {
            this.TestUser = UserUtility.createNewUser(DesiredProfile);
            insert TestUser;
        }

        public SetupDataClass(String desired_profile){
            this.DesiredProfile = desired_profile;
            this.TestUser = UserUtility.createNewUser(DesiredProfile);
            insert TestUser;
        }

        public void createTestData() {
            createContact();
            updateUser();
            createMBO();
        }

        public void createTestDataWithoutMBOs() {
            createContact();
            updateUser();
        }

        private void createMBO(){
            MBOs = new Ziel__c();
            Datetime start_quater = Datetime.now().addMonths(-2);
            Datetime end_quater = Datetime.now().addMonths(4);
            MBOs.MBO_Quartal__c = String.valueOf(Date.today().Year()) + ' Q3 (' + start_quater.format('dd.MM.yy') + ' - ' + end_quater.format('dd.MM.yy') + ')';
            MBOs.MBO_1__c = 'Certification';
            MBOs.MBO_1_Beschreibung__c = 'Get the App Platform certification';
            MBOs.MBO_1_Gewichtung_in_Prozent__c = 25;
            MBOs.MBO_1_Ergebnis__c = 33;
            MBOs.MBO_2_Kurzbeschreibung__c = 'Certification';
            MBOs.MBO_2_Langbeschreibung__c = 'Get the App Platform certification';
            MBOs.MBO_2_Wichtung_in_Prozent__c = 25;
            MBOs.MBO_2_Ergebnis__c = 33;
            MBOs.MBO_3_Kurzbeschreibung__c = 'Certification';
            MBOs.MBO_3_Beschreibung__c = 'Get the App Platform certification';
            MBOs.MBO_3_Gewichtung__c = 25;
            MBOs.MBO_3_Ergebnis__c = 33;
            MBOs.MBO_4_Kurzbeschreibung__c = 'Certification';
            MBOs.MBO_4_Beschreibung__c = 'Get the App Platform certification';
            MBOs.MBO_4_Gewichtung_in_Prozent__c = 25;
            MBOs.MBO_4_Ergebnis__c = 33;
            MBOs.Contact__c = UserContact.Id;
            insert MBOs;
        }

        private void createContact(){
            UserContact = new Contact();
            UserContact.FirstName = 'Arni';
            UserContact.LastName = 'Schwarzenegger';
            insert UserContact;
        }

        private void updateUser(){
            TestUser.Contact_ID__c = UserContact.Id;
            update TestUser;
        }

        private void initializeClass(){
            ApexPages.currentPage().getParameters().put('sfdc.userId',TestUser.id);
            ApexPages.StandardController standard_user_controller= new ApexPages.StandardController(TestUser);
            ClassUnderTest = new MBOViewExtension(standard_user_controller);
        }
    }
}