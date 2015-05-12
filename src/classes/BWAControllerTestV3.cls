@isTest
public class BWAControllerTestV3 {
   static testmethod void bwaTest(){
        
        BWAControllerV3 testedPageController;
    	Chart_of_Accounts__c chAcc1, chAcc2; 
    	
    	Account testAcc = new Account(Name='Testaccount');
    	insert testAcc;
    	
    	Opportunity opp = new Opportunity(Name='Testopp',AccountId=testAcc.Id,CloseDate = System.today(),StageName = 'Lead');
    	insert opp;
    	
    	 opp = [Select Id, AccountId, account.name FROM Opportunity limit 1];
    	try {
    		chAcc1 = [select id from Chart_of_Accounts__c where Account__c =: opp.AccountId and Account_Type__c = 'Kreditoren'];
    	} catch (exception e) {
	    	chAcc1 = new Chart_of_Accounts__c(
				name = '99999',
				Account__c = opp.AccountId,
				Account_Description__c = opp.account.name,
				Account_Type__c = 'Kreditoren',
				Activation_date__c = Date.Today()
			);
			insert chAcc1;
    	}
    	try {
    		chAcc2 = [select id from Chart_of_Accounts__c where Account__c =: opp.AccountId and Account_Type__c = 'Debitoren'];
    	} catch (exception e) {
			chAcc2 = new Chart_of_Accounts__c(
				name = '99999',
				Account__c = opp.AccountId,
				Account_Description__c = opp.account.name,
				Account_Type__c = 'Debitoren',
				Activation_date__c = Date.Today()
			);
			insert chAcc2;
    	}

    	
    	Chart_of_Accounts__c chartAccount1 = new Chart_of_Accounts__c(
    			Name='11111',
    			Account_Description__c = 'Abziehbare Vorsteuer',
    			Account_Type__c = 'Finanzen'
    	);
    	insert chartAccount1;
    	
    	Chart_of_Accounts__c chartAccount2 = new Chart_of_Accounts__c(
    			Name='22222',
    			Account_Description__c = 'Abziehbare Vorsteuer 7%',
    			Account_Type__c = 'Finanzen'
    	);
    	insert chartAccount2;
    	
    	Chart_of_Accounts__c chartAccount3 = new Chart_of_Accounts__c(
    			Name='33333',
    			Account_Description__c = 'Abziehbare Vorsteuer 19%',
    			Account_Type__c = 'Finanzen'
    	);
    	insert chartAccount3;
    	
    	Chart_of_Accounts__c chartAccount4 = new Chart_of_Accounts__c(
    			Name='1000',
    			Account_Description__c = 'Kasse',
    			Account_Type__c = 'Finanzen'
    	);
    	insert chartAccount4;
   
    	/*Chart_of_Accounts__c chartAccount5 = new Chart_of_Accounts__c(
    			Name='55555',
    			Account_Description__c = 'Mastercard xx1000931',
    			Account_Type__c = 'Finanzen'
    	);
    	insert chartAccount5;
    	
    	Chart_of_Accounts__c chartAccount6 = new Chart_of_Accounts__c(
    			Name='666666',
    			Account_Description__c = 'Mastercard x20452043',
    			Account_Type__c = 'Finanzen'
    	);
    	insert chartAccount6;
    	
    	Chart_of_Accounts__c chartAccount7 = new Chart_of_Accounts__c(
    			Name='777777',
    			Account_Description__c = 'Mastercard xx9019208',
    			Account_Type__c = 'Finanzen'
    	);
    	insert chartAccount7;*/
    	
    	Chart_of_Accounts__c chartAccount8 = new Chart_of_Accounts__c(
    			Name='8888888',
    			Account_Description__c = 'Mastercard Lufthansa TCS *0330',
    			Account_Type__c = 'Finanzen'
    	);
    	insert chartAccount8;
    	
    	Chart_of_Accounts__c chartAccount9 = new Chart_of_Accounts__c(
    			Name='999999',
    			Account_Description__c = 'Mastercard TCS *8341',
    			Account_Type__c = 'Finanzen'
    	);
    	insert chartAccount9;
    	
    	Chart_of_Accounts__c chartAccount10 = new Chart_of_Accounts__c(
    			Name='1010101010',
    			Account_Description__c = 'Mastercard THK *8333',
    			Account_Type__c = 'Finanzen'
    	);
    	insert chartAccount10;
    	
    	Chart_of_Accounts__c chartAccount11 = new Chart_of_Accounts__c(
    			Name='1200',
    			Account_Description__c = 'Bank HVB *0343',
    			Account_Type__c = 'Finanzen'
    	);
    	insert chartAccount11;
    	
    	Chart_of_Accounts__c chartAccount12 = new Chart_of_Accounts__c(
    			Name='1740',
    			Account_Description__c = 'Bla',
    			Account_Type__c = 'Finanzen'
    	);
    	insert chartAccount12;
    	
    	Chart_of_Accounts__c chartAccount13 = new Chart_of_Accounts__c(
    			Name='1741',
    			Account_Description__c = 'Bla',
    			Account_Type__c = 'Finanzen'
    	);
    	insert chartAccount13;
    	
    	Chart_of_Accounts__c chartAccount14 = new Chart_of_Accounts__c(
    			Name='1742',
    			Account_Description__c = 'Bla',
    			Account_Type__c = 'Finanzen'
    	);
    	insert chartAccount14;
    	

    	
    	Debitoren_Rechnung__c ausgangRech = new Debitoren_Rechnung__c(Invoice_Amount_net__c = 10, Invoice_date__c = Date.valueof('2012-1-15'), Opportunity__c = opp.id);
    	ausgangRech.Invoice_Amount_YOUR_SL__c = 10;
        Kreditor__c eingangRech = new Kreditor__c(Invoice_amount__c = 10, Invoice_date__c = Date.valueof('2012-1-15'), name = '1234', Opportunity__c = opp.id, Invoice_due_on__c = date.today().addDays(30), Invoice_Number__c = '1', VAT_Type__c = '19%', Account__c = opp.AccountId);
    	eingangRech.Invoice_Amount_CCEAG__c = 10;

        
    	test.startTest();
    	insert ausgangRech;
    	insert eingangRech;
    	Chart_of_Accounts__c coaBuero = new Chart_of_Accounts__c(Name='0420',Account_Description__c = 'Büroeinrichtung',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Anlagen',Active__c=true);
    	insert coaBuero;
   
    	Chart_of_Accounts__c Kasse = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Kasse'];
    	Chart_of_Accounts__c chAcc3	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'Bank HVB *0343');
		Chart_of_Accounts__c chAcc4	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'Bank HVB *8380');
		Chart_of_Accounts__c chAcc5	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'Deutsche Bank *3200');
		Chart_of_Accounts__c chAcc6	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'MasterCard Lufthansa TCS *0330');
		Chart_of_Accounts__c chAcc7	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'MasterCard TCS *8341');
		Chart_of_Accounts__c chAcc8	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'MasterCard THK *8333');
		Chart_of_Accounts__c chAcc9	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'Bank HVB *9333');
		Chart_of_Accounts__c chAcc10= new Chart_of_Accounts__c (Name='71001', Account_Type__c = 'Kreditoren' , Account_Description__c = 'Köhler Thorsten,');
		Chart_of_Accounts__c chAcc11= new Chart_of_Accounts__c (Name='71001', Account_Type__c = 'Finanzen' , Account_Description__c = 'MasterCard Porsche TCS *0873');
		Chart_of_Accounts__c chAcc12= new Chart_of_Accounts__c (Name='1363', Account_Type__c = 'Finanzen' , Account_Description__c = 'MasterCard L.Sch. *8499');
		Chart_of_Accounts__c chAcc13= new Chart_of_Accounts__c (Name='71001', Account_Type__c = 'Kreditoren' , Account_Description__c = 'Scheuermann Torsten,');
		Chart_of_Accounts__c chAcc15 = new Chart_of_Accounts__c (Name='1202', Account_Type__c = 'Finanzen' , Account_Description__c = 'Bank HVB *9250 Sparkonto');
        Chart_of_Accounts__c chAcc16 = new Chart_of_Accounts__c (Name='1203', Account_Type__c = 'Finanzen' , Account_Description__c = 'Bank HVB *1982 USD');
        
        List<Chart_of_Accounts__c> accountToInsert = new List<Chart_of_Accounts__c>();
        accountToInsert.add(chAcc15);
        accountToInsert.add(chAcc16);
        accountToInsert.add(chAcc3);
        accountToInsert.add(chAcc4);
        accountToInsert.add(chAcc5);
        accountToInsert.add(chAcc6);
        accountToInsert.add(chAcc7);
        accountToInsert.add(chAcc8);
        accountToInsert.add(chAcc9);
        accountToInsert.add(chAcc10);
        accountToInsert.add(chAcc11);
        accountToInsert.add(chAcc12);
        accountToInsert.add(chAcc13);
        INSERT accountToInsert;
        
    	Kreditor_Invoice_Status__c einStatus = new Kreditor_Invoice_Status__c(Kreditor_Invoice__c = eingangRech.id, debit_account__c = coaBuero.Id, credit_account__c = Kasse.Id);
    	insert einStatus;
    	testedPageController = new BWAControllerV3();
    	testedPageController.oppStart.CloseDate = date.valueOf('2012-1-1');
    	testedPageController.oppEnd.CloseDate = date.valueOf('2012-1-31');
        testedPageController.bereichAuswahl = 'YOURSL';
        
        testedPageController.getBereiche();
    	testedPageController.runReport();
    	test.stopTest();
        
    }
}