/* **************************************************************
// Creater: Krishnakumar P Iyer
// Description: Test class for Trigger to update the Owner for MBO from the selected Contact
// Trigger : MBOUpdateBefore.trigger
// Mainclass: MBOTriggerHandler.cls
// Apex Class Access: no limitations
// Last modified by: Krishnakumar P Iyer
// Last modified date: 25.11.2015
// Latests changes: creation
// ************************************************************** */


@isTest 
public class MBOTriggerHandlerTest {

	//test method for single user
    static testMethod void handleTriggerSingleUser() {
        
        //Getting the Profile for System Administrator
        Profile oProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        //Creating a test user
        User oUser = new User(Alias = 'standt', Email='standardusertest1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='TestingUser1', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = oProfile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standardusertest1@testorg.com');
        insert oUser;
        
        //Creating a test account
        Account oAccount = new Account();
        oAccount.name = 'Test';
        insert oAccount;
        
        //Creating a test contact and link with the test account
        Contact oContact = new Contact();
        oContact.FirstName = 'Test';
        oContact.LastName = 'Test';
        oContact.AccountId = oAccount.Id;
        insert oContact;
        
        //Update contact id of the user to the test contact created
        oUser.Contact_ID__c = oContact.Id;
        update oUser;
         
        //test case begins
        test.startTest();
        
        //creating test MBO object
        Ziel__c mbo = new Ziel__c();
        mbo.Contact__c = oContact.Id;
        mbo.MBO_1__c='Test';
        mbo.MBO_1_Beschreibung__c ='Test';
        mbo.MBO_1_Gewichtung_in_Prozent__c=50;
        insert mbo;
        
        //test case ends
        test.stopTest();
        
        //fetch the inserted MBO object and verify the Owner Id,  
        //whether it is mapped to the test user
        String mboId = mbo.Id;
		Ziel__c mboInserted = [ SELECT Id, OwnerID FROM Ziel__c WHERE Id =:mboId ]; 

        System.assertEquals(oUser.Id, mboInserted.OwnerID, 'User Not Found');
        
    }
    
    //test method for multiple users
    static testMethod void handleTriggerMultipleUser() {
        
        //Getting the Profile for System Administrator
        Profile oProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        List<User> users = new List<User>();
        List<Contact> contacts = new List<Contact>();
        List<Account> accounts = new List<Account>();
        List<Ziel__c> mbos = new List<Ziel__c>();
        
        //Creating test users 
        for (Integer i=0; i<10; i++ ) {
            User oUser = new User(Alias = 'standt', Email='standardusertest'+i+'@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='TestingUser'+i, LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = oProfile.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='standardusertest'+i+'@testorg.com');
            users.add(oUser);
        }
        insert users;
        
        //Creating test accounts 
        for (Integer i=0; i<10; i++ ) {    
            Account oAccount = new Account();
            oAccount.name = 'Test'+i;
            accounts.add(oAccount);
        }
        insert accounts;
         
        //Creating test contacts and links with test accounts
        for (Integer i=0; i<10; i++ ) {  
            Contact oContact = new Contact();
            Account oAccount = accounts.get(i);
            oContact.FirstName = 'Test'+i;
            oContact.LastName = 'Test'+i;
            oContact.AccountId = oAccount.Id;
            contacts.add(oContact);
        }
        insert contacts;
        
        //Update contact id of the users to the test contacts created
        for (Integer i=0; i<10; i++ ) {  
            User oUser = users.get(i);
            Contact oContact = contacts.get(i);
            oUser.Contact_ID__c = oContact.Id;
        }
        update users;
        
        //test case begins
        test.startTest();
        
        //creating test MBO objects
        for (Integer i=0; i<10; i++ ) {  
            Ziel__c mbo = new Ziel__c();
            Contact oContact = contacts.get(i);
            mbo.Contact__c = oContact.Id;
            mbo.MBO_1__c='Test'+i;
            mbo.MBO_1_Beschreibung__c ='Test'+i;
            mbo.MBO_1_Gewichtung_in_Prozent__c=50;
            mbos.add(mbo);
        }
        insert mbos;
        
        //test case ends
        test.stopTest();
        
        //fetch the inserted MBO objects and verify the Owner Id,  
        //whether it is mapped to the test user
        List<Ziel__c> mbosInserted = [ SELECT Id, OwnerID FROM Ziel__c WHERE Id in :mbos ]; 
        
        for (Integer i=0; i<10; i++ ) {
            User oUser = users.get(i);
            Ziel__c mbo = mbosInserted.get(i); 
        	System.assertEquals(oUser.Id, mbo.OwnerID, 'User Not Found');
        }
        
    }
    
    //test method for contact not mapped to any user
    static testMethod void handleTriggerWithOutUser() {
        
        //Creating a test account
        Account oAccount = new Account();
        oAccount.name = 'Test';
        insert oAccount;
        
        //Creating a test contact and link with the test account
        Contact oContact = new Contact();
        oContact.FirstName = 'Test';
        oContact.LastName = 'Test';
        oContact.AccountId = oAccount.Id;
        insert oContact;
         
        //test case begins
        test.startTest();
        
        //creating test MBO object
        Ziel__c mbo = new Ziel__c();
        mbo.Contact__c = oContact.Id;
        mbo.MBO_1__c='Test';
        mbo.MBO_1_Beschreibung__c ='Test';
        mbo.MBO_1_Gewichtung_in_Prozent__c=50;
        
        try
        {
        	insert mbo;
        }
        catch(Exception e)
        {
        	Boolean expectedExceptionThrown =  (e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') 
                || e.getMessage().contains('User Not Found'))
                ? true : false;
        	System.AssertEquals(expectedExceptionThrown, true);
        } 

        //test case ends
        test.stopTest();
    }
    
}