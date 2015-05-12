/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Cls_Test_ReviewUpdateRating_Trigger {

    static testMethod void myUnitTest() {
        
        Candidate__c cand = new Candidate__c();
        cand.First_Name__c = 'TestFirstName';
        cand.Last_Name__c = 'TestLastName';
        cand.Email__c = 'Test@mailinator.com';
        cand.Current_Employer__c = 'TestCompany';
        cand.Currently_Employed__c = TRUE;
        insert cand;
        
        Id rtId = [select Id,name from RecordType where  SObjectType='Position__c' limit 1].Id;
        
        Position__c posi = new Position__c();
        //posi.Name = 'TestPosition';
        posi.Min_Pay__c = 1;
        posi.Max_Pay__c = 50000;
        posi.RecordTypeId = rtId;
        insert posi;
        
        Id jaId = [select Id,name from RecordType where  SObjectType='Job_Application__c' limit 1].Id;
        Job_Application__c joba = new Job_Application__c();
        joba.Candidate__c = cand.Id;
        joba.Position__c = posi.Id;
        joba.RecordTypeId = jaId;
        insert joba;
        
        Review__c myrev = new Review__c();

        myrev.Assessment__c = 'myrev Asssessment';
        myrev.Job_Application__c = joba.Id;
        insert myrev;
        myrev.Comments_Plus_Points__c = 'myrev.Comments_Plus_Points__c'; 
        myrev.Rating__c = 5.0;
        myrev.Rating__c = 0;
        myrev.Rating_Scale_01__c = '5';
        myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_01__c);
        System.assertEquals(myrev.Rating__c, 5);
        
        myrev.Rating_Scale_02__c = '5';
        myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_02__c);
        System.assertEquals(myrev.Rating__c, 10);
        
        myrev.Rating_Scale_03__c = '5';
        myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_03__c);
        System.assertEquals(myrev.Rating__c, 15);
        
        myrev.Rating_Scale_04__c = '5';
        myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_04__c);
        System.assertEquals(myrev.Rating__c, 20);   
        
        myrev.Rating_Scale_05__c = '5';
        myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_05__c);
        System.assertEquals(myrev.Rating__c, 25);   
        
        myrev.Rating_Scale_06__c = '5';
        myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_06__c);
        System.assertEquals(myrev.Rating__c, 30);   
        
        myrev.Rating_Scale_07__c = '5';
        myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_07__c);
        System.assertEquals(myrev.Rating__c, 35);   
        
        myrev.Rating_Scale_08__c = '5';
        myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_08__c);
        System.assertEquals(myrev.Rating__c, 40);   
        
        myrev.Rating_Scale_09__c = '5';
        myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_09__c);
        System.assertEquals(myrev.Rating__c, 45);   
        
        myrev.Rating_Scale_10__c = '5';
        myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_10__c);
        System.assertEquals(myrev.Rating__c, 50);   
        
        myrev.Rating_Scale_11__c = '5';
        myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_11__c);
        System.assertEquals(myrev.Rating__c, 55);   
        
        myrev.Rating_Scale_12__c = '5';
        myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_12__c);
        System.assertEquals(myrev.Rating__c, 60);   
        
        myrev.Rating_Scale_13__c = '5';
        myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_13__c);
        System.assertEquals(myrev.Rating__c, 65);   
        
        myrev.Rating_Scale_14__c = '5';
        myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_14__c);
        System.assertEquals(myrev.Rating__c, 70);   
        
        myrev.Rating_Scale_15__c = '5';
        myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_15__c);
        System.assertEquals(myrev.Rating__c, 75);   
        
        myrev.Rating_Scale_16__c = '5';
        myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_16__c);
        System.assertEquals(myrev.Rating__c, 80);
        
        update myrev;
        System.assertEquals(myrev.Rating__c, 80);

    }
}