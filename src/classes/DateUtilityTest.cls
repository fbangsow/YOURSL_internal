@isTest
private class DateUtilityTest {

    static testMethod void testDateUtilityWorksCorrectlyForEuropeanUser() {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser) {
            Test.startTest();
                Date firstDayOfWeek = DateUtility.getFirstDayForWeekNumberAndYear(2015, 2);
            Test.stopTest();
            System.assertEquals(Date.newInstance(2015, 1, 5), firstDayOfWeek);
        }
    }

    private class SetupDataClass {
        public User testUser;
        private final String DESIRED_PROFILE = 'System Administrator'; 

        public SetupDataClass() {
            this.testUser = UserUtility.createNewUser(DESIRED_PROFILE);
            insert testUser;
        }
    }
}