@isTest
private class TriggerFactoryTest
{
    static testMethod void testGetHandlerReturnsCorrectHandlerForOpportunityLineItem()
    {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser)
        {
            ITrigger trigger_handler;
            Test.startTest();
                trigger_handler = TriggerFactory.getHandler(OpportunityLineItem.SObjectType);
            Test.stopTest();
            System.assert(trigger_handler instanceof OpportunityLineItemHandler, 'The getHandler method returned wrong implementation of ITrigger');
        }
    }

    static testMethod void testGetHandlerReturnsNullForAnSobjectThatDontHaveHandler()
    {
        SetupDataClass setup_data = new SetupDataClass();
        System.runAs(setup_data.TestUser)
        {
            ITrigger trigger_handler;
            Test.startTest();
                trigger_handler = TriggerFactory.getHandler(Idea.SObjectType);
            Test.stopTest();
            System.assertEquals(null, trigger_handler, 'The getHandler method should have returned null');
        }
    }

    public class SetupDataClass
    {
        public User TestUser;
        public final String DESIRED_PROFILE = 'System Administrator';

        public SetupDataClass()
        {
            TestUser = UserUtility.createNewUser(DESIRED_PROFILE);
            insert TestUser;
        }
    }
}