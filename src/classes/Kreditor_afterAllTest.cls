/* **************************************************************
// Creater: Alexander Faust
// Description: Testclass of Kreditor_afterAll.trigger
// Apex Class Access: no limitations
// Last modified by: Alexander Faust	
// Last modified date: 05.12.2012
// Latests changes: 07.07.2014 by Alexander Placidi. Just set some new fields to meet a validation rule. 
// ************************************************************** */


@isTest
private class Kreditor_afterAllTest {

    static testMethod void myUnitTest() {
        //-*-*-*-*-*-*-*-*-*-
        // A C C O U N T
        //-*-*-*-*-*-*-*-*-*-
        Account acc = new Account(name='test');
        insert acc;
        

        //-*-*-*-*-*-*-*-*-*-
        // C O N T A C T
        //-*-*-*-*-*-*-*-*-*-
        Contact c = new Contact(LastName='test',AccountId=acc.Id);
        insert c;
        /*
         //-*-*-*-*-*-*-*-*-*-
        // P R O D U C T
        //-*-*-*-*-*-*-*-*-*-                
        Product2 p = new product2(name='x');
        insert p;
        
        //-*-*-*-*-*-*-*-*-*-
        // P R I C E B O O K
        //-*-*-*-*-*-*-*-*-*-
        Pricebook2 stdPb = [select Id from Pricebook2 where isStandard=true limit 1];
        insert new PricebookEntry(pricebook2id = stdPb.id, product2id = p.id,unitprice=1.0, isActive=true);

        Pricebook2 pb = new pricebook2(name='test');
        insert pb;
        
        PricebookEntry pbe = new PricebookEntry(pricebook2id=pb.id, product2id=p.id, unitprice=1.0, isActive=true);
        insert pbe;
        
        //getting the ids of the VAT accounts
	id vat0 = [SELECT id FROM Chart_of_Accounts__c 
				WHERE Account_Description__c = 'Abziehbare Vorsteuer' 
				AND Account_Type__c = 'Finanzen' limit 1].id;
	id vat7 = [SELECT id FROM Chart_of_Accounts__c 
				WHERE Account_Description__c = 'Abziehbare Vorsteuer 7%' 
				AND Account_Type__c = 'Finanzen' limit 1].id;
	id vat19 = [SELECT id FROM Chart_of_Accounts__c 
				WHERE Account_Description__c = 'Abziehbare Vorsteuer 19%
 */
 
 		Chart_of_Accounts__c chart1 = new Chart_of_Accounts__c(
 			Name = '1',
 			Account_Description__c = 'Abziehbare Vorsteuer',
 			Account_Type__c = 'Finanzen'
 		);
 		insert chart1;
 		
 		Chart_of_Accounts__c chart2 = new Chart_of_Accounts__c(
 			Name = '2',
 			Account_Description__c = 'Abziehbare Vorsteuer 7%',
 			Account_Type__c = 'Finanzen'
 		);
 		insert chart2;
 		
 		Chart_of_Accounts__c chart3 = new Chart_of_Accounts__c(
 			Name = '3',
 			Account_Description__c = 'Abziehbare Vorsteuer 19%',
 			Account_Type__c = 'Finanzen'
 		);
 		insert chart3;
 
 
        //-*-*-*-*-*-*-*-*-*-
        // O P P O R T U N I T Y
        //-*-*-*-*-*-*-*-*-*-
        //Opportunity o = new Opportunity(AccountId=acc.Id,name='test', pricebook2id=pb.id,stageName='Open', CloseDate=Date.newInstance(2006,10,10));
        Opportunity o = new Opportunity(AccountId=acc.Id,name='test', stageName='Open', CloseDate=Date.newInstance(2006,10,10));
        insert o;
        
        
        
        List<Kreditor__c> listK2Insert = new List<Kreditor__c>();
        
        for(Integer i = 0;i<30;i++){
        	Kreditor__c k = new Kreditor__c(
	        	Name = 'TestRechnung',
	        	Invoice_Number__c = '1234'+i,
	        	Invoice_date__c = System.today(),
	        	Invoice_due_on__c = System.today(),
	        	Invoice_amount__c = 100.00,
	        	VAT_Type__c = '0',
	        	Opportunity__c = o.Id,
	        	Account__c = acc.Id
        	);
            k.Invoice_Amount_North__c = 100.00; //fill out these fields to meet the validation rule.
            k.Invoice_Amount_South__c = 0;
            k.Invoice_Amount_CCEAG__c = 0;
            k.Invoice_Amount_Telekom__c = 0;
            k.Invoice_Amount_YOUR_SL__c = 0;
        	listK2Insert.add(k);
        }
        
        insert listK2Insert;
        Double result = [SELECT Total_amount_credit_invoices__c FROM Opportunity WHERE Opportunity.Id =: o.Id].Total_amount_credit_invoices__c;
        System.assertEquals(result,3000);
        
        delete listK2Insert;
        
        
    }
}