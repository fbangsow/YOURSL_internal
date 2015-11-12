@isTest
private class CertificationsViewExtensionTest {
    @isTest static void testConstructorQueriesCertifications() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createTestData();
            Test.startTest();
                setup_data.initializeClass();
            Test.stopTest();
            System.assertEquals(1, setup_data.ClassUnderTest.Certifications.size(), 'It should contain one test certification');
            System.assertEquals(setup_data.AdminCertification.Id, setup_data.ClassUnderTest.Certifications.get(0).Id, 'It should be exactly the certification we created in tests');
        }
    }

    private class SetupDataClass {
        public User TestUser;
        public Certification_Type__c Admin;
        public Contact UserContact;
        public Certification__c AdminCertification;
        private String DesiredProfile = 'System Administrator';
        public CertificationsViewExtension ClassUnderTest;


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
            createCertificationType();
            createCertification();
        }

        private void createCertificationType(){
            Admin = new Certification_Type__c();
            Admin.Name = 'Admin';
            Admin.Badge__c = 'Picture of Arnold Schwarzenegger';
            insert Admin;
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

        private void createCertification(){
            AdminCertification = new Certification__c();
            AdminCertification.Name = 'Name';
            AdminCertification.Certification_Type__c = Admin.Id;
            AdminCertification.Contact__c = UserContact.Id;
            AdminCertification.Status__c = 'Passed';
            insert AdminCertification;
        }

        private void initializeClass(){
            ApexPages.currentPage().getParameters().put('sfdc.userId',TestUser.id);
            ApexPages.StandardController standard_user_controller= new ApexPages.StandardController(TestUser);
            ClassUnderTest = new CertificationsViewExtension(standard_user_controller);
        }
    }
}