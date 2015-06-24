@isTest
private class EmailUtilityTest {
    public static testMethod void testSendMail() {
        Test.startTest();
            EmailUtility.getInstance().setSendTo('test@test.com')
                                    .setCcTo('test2@test.com')
                                    .setReplyTo('no_reply@yoursl.de')
                                    .setSenderDisplayName('EmailUtility')
                                    .setSubject('EmailUtility Test')
                                    .setHtmlBody('Im body')
                                    .send();
        Test.stopTest();
    }
}