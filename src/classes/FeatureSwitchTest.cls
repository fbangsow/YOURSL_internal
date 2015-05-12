@isTest
private class FeatureSwitchTest {

    @isTest static void testGetSwitchReturnsExtectedResult() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createFeatureSwitch(true);
            Test.startTest();
                Boolean is_enabled = FeatureSwitch.getSwitch(setup_data.TestFeatureSwitch.Name);
            Test.stopTest();
            System.assertEquals(setup_data.TestFeatureSwitch.Is_Enabled__c, is_enabled);
        }
    }

    @isTest static void testEnableReturnsTrue() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createFeatureSwitch(false);
            FeatureSwitch.enable(setup_data.TestFeatureSwitch.Name);
            Test.startTest();
                Boolean is_enabled = FeatureSwitch.getSwitch(setup_data.TestFeatureSwitch.Name);
            Test.stopTest();
            System.assertEquals(true, is_enabled);
        }
    }

    @isTest static void testDisableReturnsFalse() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            setup_data.createFeatureSwitch(false);
            FeatureSwitch.disable(setup_data.TestFeatureSwitch.Name);
            Test.startTest();
                Boolean is_enabled = FeatureSwitch.getSwitch(setup_data.TestFeatureSwitch.Name);
            Test.stopTest();
            System.assertEquals(false, is_enabled);
        }
    }


    @isTest static void testDefaultValueForUnsetFeatureIsFalse() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Test.startTest();
                Boolean is_enabled = FeatureSwitch.getSwitch('Screen Sharing');
            Test.stopTest();
            System.assertEquals(false, is_enabled);
        }
    }

    private class SetupDataClass {
        public User TestUser;
        public Feature_Switch__c TestFeatureSwitch;
        private final String DESIRED_PROFILE = 'System Administrator';

        public SetupDataClass() {
            this.TestUser = UserUtility.createNewUser(DESIRED_PROFILE);
            insert TestUser;
        }

        public void createFeatureSwitch(Boolean is_enabled){
            TestFeatureSwitch = new Feature_Switch__c();
            TestFeatureSwitch.Name = 'TestFeature';
            TestFeatureSwitch.Is_Enabled__c = is_enabled;
            insert TestFeatureSwitch;
        }
    }
}