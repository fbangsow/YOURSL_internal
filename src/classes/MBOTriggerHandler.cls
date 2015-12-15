/* **************************************************************
// Creater: Krishnakumar P Iyer
// Description: Handler class for Trigger to update the Owner for MBO from the selected Contact
// Testclass: MBOTriggerHandlerTest.cls
// Apex Class Access: no limitations
// Last modified by: Krishnakumar P Iyer
// Last modified date: 25.11.2015
// Latests changes: creation
// ************************************************************** */


public class MBOTriggerHandler {

    public void handleTrigger (List<Ziel__c> mbos) {
        
        List<ID> contacts = new List<ID>();
        Map<ID, User> userMap = new Map<ID, User>();
        
        //Getting Contacts for all the MBOs
        for (Ziel__c mbo : mbos) {
            if (mbo.Contact__c != null) {
                contacts.add(mbo.Contact__c);
            }
        }
        
        //Fetching Users for all the Contacts
        List<User> users = [ Select Id, Contact_ID__c from User where Contact_ID__c in :contacts ];
        for (User user : users) {
            userMap.put(user.Contact_ID__c, user); 
        }
        
        //Traverse through the MBOs and set the Owner from Contact
        for (Ziel__c mbo : mbos) {
            if (mbo.Contact__c != null && userMap.containsKey(mbo.Contact__c)) {
                mbo.OwnerID = userMap.get(mbo.Contact__c).Id;
            }
            //If no users mapped for the Contact
            else
            {
                mbo.addError('User Not Found');
            }
        }
    }
}