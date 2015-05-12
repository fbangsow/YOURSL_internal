/*
 * Latest Changes: 07.07.14 by Alexander Placidi. Set some new fields to meet the validation rule.
 */

@isTest
private class test_triggers {

	//tests Eingangsrechnung_BIBU, Ausgangsrechnung_BIBU, Kreditor_Invoice_Status_BIBU, Debitor_Invoice_Status_BIBU
    static testMethod void Rechnung_BIBU() {
    	Account acc = new Account(name = 'acc1');
    	insert acc;
    	Opportunity opp = new Opportunity(name = 'opp1', accountId = acc.id, StageName = 'Qualification', CloseDate = Date.Today()+4);
    	insert opp;
        
        Chart_of_Accounts__c coaVorSt19 = new Chart_of_Accounts__c(Name='1576',Account_Description__c = 'Abziehbare Vorsteuer 19%',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Finanzen',Active__c=true);
        Chart_of_Accounts__c coaVorSt7 = new Chart_of_Accounts__c(Name='1571',Account_Description__c = 'Abziehbare Vorsteuer 7%',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Finanzen',Active__c=true);
        Chart_of_Accounts__c coaVorSt0 = new Chart_of_Accounts__c(Name='1570',Account_Description__c = 'Abziehbare Vorsteuer',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Finanzen',Active__c=true);           
        Chart_of_Accounts__c Bank = new Chart_of_Accounts__c(Name='1200',Account_Description__c = 'Bank HVB *0343',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Finanzen',Active__c=true);
        Chart_of_Accounts__c Kasse = new Chart_of_Accounts__c(Name='1000',Account_Description__c = 'Kasse',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Finanzen',Active__c=true);
        Chart_of_Accounts__c chartOfAccount = new Chart_of_Accounts__c(Name = '1234', Account_Type__c = 'Kreditoren', Account_Description__c = 'Test Account');
        
        List<Chart_of_Accounts__c> chartOfAccounts = new List<Chart_of_Accounts__c>();
        chartOfAccounts.add(chartOfAccount);
        chartOfAccounts.add(coaVorSt19);
        chartOfAccounts.add(coaVorSt7);
        chartOfAccounts.add(coaVorSt0);
        chartOfAccounts.add(Bank);
        chartOfAccounts.add(Kasse);
        insert chartOfAccounts;
        
    	/*Chart_of_Accounts__c chAcc11 = new Chart_of_Accounts__c(Name = '7985417598143',Account_Type__c = 'Finanzen', Account_Description__c = 'Kasse');
    	insert chAcc11;*/
        Kreditor__c EingangsRech = new Kreditor__c(Invoice_due_on__c = Date.Today()+4, Invoice_amount__c = 1000, 
        		Invoice_date__c = Date.Today(), Invoice_Number__c = '123',
        		VAT_Type__c = '19%', Opportunity__c = opp.id, Kreditorennummer__c = chartOfAccount.id);
        EingangsRech.Invoice_Amount_North__c = 1000;
        eingangsrech.Invoice_Amount_South__c = 0;
        eingangsrech.Invoice_Amount_CCEAG__c = 0;
        eingangsrech.Invoice_Amount_Telekom__c = 0;
        eingangsrech.Invoice_Amount_YOUR_SL__c = 0;
        insert EingangsRech;
        Kreditor_Invoice_Status__c EingangsRechStatus = new Kreditor_Invoice_Status__c(Kreditor_Invoice__c = EingangsRech.id, 
        			Payment_Status__c = 'Paid', Payment_method__c = 'Überweisung für Bank HVB *0343');
        insert EingangsRechStatus;
        Debitoren_Rechnung__c AusgangsRech = new Debitoren_Rechnung__c(VAT_Type__c = '19%', Opportunity__c = opp.id, Debitorennummer__c = chartOfAccount.id);
        ausgangsrech.Invoice_Amount_net__c = 100;
        ausgangsrech.Invoice_Amount_North__c = 100;
        ausgangsrech.Invoice_Amount_South__c = 0;
        ausgangsrech.Invoice_Amount_Telekom__c = 0;
        ausgangsrech.Invoice_Amount_YOUR_SL__c = 0;
        ausgangsrech.Invoice_Amount_CCEAG__c = 0;
        insert AusgangsRech;
        Debitor_Invoice_Status__c AusgangsRechStatus = new Debitor_Invoice_Status__c(Debitor_Invoice__c = AusgangsRech.id, 
        			Payment_Status__c = 'Paid', Payment_method__c = 'Bank transfer');
        insert AusgangsRechStatus;
        Debitor_Invoice_Status__c AusgangsRechStatus1 = new Debitor_Invoice_Status__c(Debitor_Invoice__c = AusgangsRech.id, 
        			Payment_Status__c = 'Paid', Payment_method__c = 'Bank transfer');
        try {
        	insert AusgangsRechStatus1; //fails, only one AusgangsRechnungStatus allowed
        } catch(Exception e) {}
    }
    
    
}