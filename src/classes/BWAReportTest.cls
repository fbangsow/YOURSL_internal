/*
 * Latest changes: 07.07.14 by Alexander Placidi. Set some new fields to meet the validation rule.
 */
@isTest
private class BWAReportTest {

    /*static testMethod void testBWA() {
    	BWAReportCont testedPageController;
    	Chart_of_Accounts__c chAcc1, chAcc2;

    	Opportunity opp = [Select Id, AccountId, account.name FROM Opportunity limit 1];
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
    	Debitoren_Rechnung__c ausgangRech = new Debitoren_Rechnung__c(Invoice_Amount_net__c = 10, Invoice_date__c = Date.valueof('2012-1-15'), Opportunity__c = opp.id);
    	Kreditor__c eingangRech = new Kreditor__c(Invoice_amount__c = 10, Invoice_date__c = Date.valueof('2012-1-15'), name = '1234', Opportunity__c = opp.id, Invoice_due_on__c = date.today().addDays(30), Invoice_Number__c = '1', VAT_Type__c = '19%', Account__c = opp.AccountId);

    	test.startTest();
    	insert ausgangRech;
    	insert eingangRech;
    	Chart_of_Accounts__c coaBuero = new Chart_of_Accounts__c(Name='0420',Account_Description__c = 'Büroeinrichtung',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Anlagen',Active__c=true);
    	insert coaBuero;
    	/*Chart_of_Accounts__c Kasse = new Chart_of_Accounts__c(Name='1000',Account_Description__c = 'Kasse',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Finanzen',Active__c=true);
    	insert Kasse;
    	Chart_of_Accounts__c Kasse = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Kasse'];
    	Chart_of_Accounts__c chAcc3	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'Bank HVB *0343');
		Chart_of_Accounts__c chAcc4	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'Bank HVB *8380');
		Chart_of_Accounts__c chAcc5	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'Deutsche Bank *3200');
		Chart_of_Accounts__c chAcc6	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'MasterCard Lufthansa TCS *0330');
		Chart_of_Accounts__c chAcc7	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'MasterCard TCS *8341');
		Chart_of_Accounts__c chAcc8	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'MasterCard THK *8333');
		Chart_of_Accounts__c chAcc9	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'Bank HVB *9333');
		insert chAcc3;insert chAcc4;insert chAcc5;insert chAcc6;insert chAcc7;insert chAcc8;insert chAcc9;
    	Kreditor_Invoice_Status__c einStatus = new Kreditor_Invoice_Status__c(Kreditor_Invoice__c = eingangRech.id, debit_account__c = coaBuero.Id, credit_account__c = Kasse.Id);
    	insert einStatus;
    	testedPageController = new BWAReportCont();
    	testedPageController.oppStart.CloseDate = date.valueOf('2012-1-1');
    	testedPageController.oppEnd.CloseDate = date.valueOf('2012-1-31');
    	testedPageController.runReport();
    	test.stopTest();
    }*/

    static testMethod void testBalance() {
        Chart_of_Accounts__c vat0 = new Chart_of_Accounts__c();
        vat0.Account_Description__c = 'Abziehbare Vorsteuer';
        vat0.Account_Type__c = 'Finanzen';
        vat0.Name = '0';
        Chart_of_Accounts__c vat7 = new Chart_of_Accounts__c();
        vat7.Account_Description__c = 'Abziehbare Vorsteuer 7%';
        vat7.Account_Type__c = 'Finanzen';
        vat7.Name = '7';
        Chart_of_Accounts__c vat19 = new Chart_of_Accounts__c();
        vat19.Account_Description__c = 'Abziehbare Vorsteuer 19%';
        vat19.Account_Type__c = 'Finanzen';
        vat19.Name = '19';
        Chart_of_Accounts__c test_kasse = new Chart_of_Accounts__c();
        test_kasse.Account_Description__c = 'Kasse';
        test_kasse.Account_Type__c = 'Finanzen';
        test_kasse.Name = '1000';
        Chart_of_Accounts__c bank = new Chart_of_Accounts__c();
        bank.Account_Description__c = 'Bank';
        bank.Account_Type__c = 'Finanzen';
        bank.Name = '1200';
        insert new List<Sobject> {vat0, vat7, vat19, test_kasse, bank};
    	test.startTest();
    	BalanceController testedPageController;
    	Chart_of_Accounts__c chAcc1, chAcc2;
    	list<Debitoren_Rechnung__c> listAusgRechs = new list<Debitoren_Rechnung__c>();
    	list<Debitor_Invoice_Status__c> listAusgRechStatus = new list<Debitor_Invoice_Status__c>();
    	Opportunity test_opportunity = new Opportunity();
        test_opportunity.Name = 'YOUR SL GmbH';
        test_opportunity.StageName = 'YOUR SL GmbH';
        test_opportunity.PriceBook2Id = Test.getStandardPricebookId();
        test_opportunity.CloseDate = Date.newInstance(2015, 1, 1);
        test_opportunity.Managed_by_PSO_Tool__c = true;
        test_opportunity.Projektstatus__c = 'Terrible';
        insert test_opportunity;

    	Opportunity opp = [Select Id, AccountId, account.name FROM Opportunity limit 1];
    	try {
    		chAcc1 = [select id from Chart_of_Accounts__c where Account__c =: opp.AccountId and Account_Type__c = 'Kreditoren' LIMIT 1];
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
    	/*try {
    		chAcc2 = [select id from Chart_of_Accounts__c where Account__c =: opp.AccountId and Account_Type__c = 'Debitoren'];
    	} catch (exception e) {*/
			chAcc2 = new Chart_of_Accounts__c(
				name = '8400',
				Account__c = opp.AccountId,
				Account_Description__c = opp.account.name,
				Account_Type__c = 'Debitoren',
				Activation_date__c = Date.Today()
			);
			insert chAcc2;
    	//}

    	Debitoren_Rechnung__c ausgangRech = new Debitoren_Rechnung__c(Invoice_Amount_net__c = 10, Invoice_date__c = Date.valueof('2012-1-15'), Opportunity__c = opp.id);
    	Debitoren_Rechnung__c ausgangRech2 = new Debitoren_Rechnung__c(Invoice_Amount_net__c = 10, Invoice_date__c = Date.valueof('2012-2-15'), Opportunity__c = opp.id);
    	Debitoren_Rechnung__c ausgangRech3 = new Debitoren_Rechnung__c(Invoice_Amount_net__c = 10, Invoice_date__c = Date.valueof('2012-3-15'), Opportunity__c = opp.id);
    	Kreditor__c eingangRech = new Kreditor__c(Invoice_amount__c = 10, Invoice_date__c = Date.valueof('2012-1-15'), name = '1234', Opportunity__c = opp.id, Invoice_due_on__c = date.today().addDays(30), Invoice_Number__c = '1', VAT_Type__c = '19%', Account__c = opp.AccountId);
    	ausgangRech.Invoice_Amount_North__c = 10;
        ausgangrech.Invoice_Amount_South__c = 0;
        ausgangrech.Invoice_Amount_CCEAG__c = 0;
        ausgangrech.Invoice_Amount_Telekom__c = 0;
        ausgangrech.Invoice_Amount_YOUR_SL__c = 0;

        ausgangRech2.Invoice_Amount_North__c = 10;
        ausgangrech2.Invoice_Amount_South__c = 0;
        ausgangrech2.Invoice_Amount_CCEAG__c = 0;
        ausgangrech2.Invoice_Amount_Telekom__c = 0;
        ausgangrech2.Invoice_Amount_YOUR_SL__c = 0;

        ausgangRech3.Invoice_Amount_North__c = 10;
        ausgangrech3.Invoice_Amount_South__c = 0;
        ausgangrech3.Invoice_Amount_CCEAG__c = 0;
        ausgangrech3.Invoice_Amount_Telekom__c = 0;
        ausgangrech3.Invoice_Amount_YOUR_SL__c = 0;

        eingangRech.Invoice_Amount_North__c = 10;
        eingangRech.Invoice_Amount_South__c = 0;
        eingangRech.Invoice_Amount_CCEAG__c = 0;
        eingangRech.Invoice_Amount_Telekom__c = 0;
        eingangRech.Invoice_Amount_YOUR_SL__c = 0;

    	listAusgRechs.add(ausgangRech);
    	listAusgRechs.add(ausgangRech2);
    	listAusgRechs.add(ausgangRech3);
    	insert listAusgRechs;
    	insert eingangRech;
    	Chart_of_Accounts__c coaBuero = new Chart_of_Accounts__c(Name='0420',Account_Description__c = 'Büroeinrichtung',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Anlagen',Active__c=true);
    	insert coaBuero;
    	/*Chart_of_Accounts__c Kasse = new Chart_of_Accounts__c(Name='1000',Account_Description__c = 'Kasse',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Finanzen',Active__c=true);
    	insert Kasse;*/
    	Chart_of_Accounts__c Kasse = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Kasse' LIMIT 1];
    	Chart_of_Accounts__c chAcc3	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'Bank HVB *0343');
		Chart_of_Accounts__c chAcc4	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'Bank HVB *8380');
		Chart_of_Accounts__c chAcc5	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'Deutsche Bank *3200');
		Chart_of_Accounts__c chAcc6	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'MasterCard Lufthansa TCS *0330');
		Chart_of_Accounts__c chAcc7	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'MasterCard TCS *8341');
		Chart_of_Accounts__c chAcc8	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'MasterCard THK *8333');
		Chart_of_Accounts__c chAcc9	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'Bank HVB *9333');
		Chart_of_Accounts__c chAcc10 = new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'MasterCard Porsche TCS *0873');
        Chart_of_Accounts__c chAcc11	= new Chart_of_Accounts__c (Name='1202', Account_Type__c = 'Finanzen' , Account_Description__c = 'Bank HVB *9250 Sparkonto');
        Chart_of_Accounts__c chAcc12	= new Chart_of_Accounts__c (Name='1203', Account_Type__c = 'Finanzen' , Account_Description__c = 'Bank HVB *1982 USD');

		insert chAcc3;insert chAcc4;insert chAcc5;insert chAcc6;insert chAcc7;insert chAcc8;insert chAcc9;insert chAcc10; insert chAcc11; insert chAcc12;



    	Kreditor_Invoice_Status__c einStatus = new Kreditor_Invoice_Status__c(Kreditor_Invoice__c = eingangRech.id, debit_account__c = coaBuero.Id, credit_account__c = Kasse.Id);
    	Debitor_Invoice_Status__c ausStatus = new Debitor_Invoice_Status__c(Debitor_Invoice__c = ausgangRech.Id,debit_account__c = chAcc2.Id,credit_account__c = Kasse.Id);
    	Debitor_Invoice_Status__c ausStatus2 = new Debitor_Invoice_Status__c(Debitor_Invoice__c = ausgangRech2.Id,debit_account__c = chAcc2.Id,credit_account__c = Kasse.Id);
    	Debitor_Invoice_Status__c ausStatus3 = new Debitor_Invoice_Status__c(Debitor_Invoice__c = ausgangRech3.Id,debit_account__c = chAcc2.Id,credit_account__c = Kasse.Id);

    	listAusgRechStatus.add(ausStatus);
    	listAusgRechStatus.add(ausStatus2);
    	listAusgRechStatus.add(ausStatus3);

    	insert einStatus;

    	insert listAusgRechStatus;


    	BalanceController myBalanceController = new BalanceController();
    	myBalanceController.oppStart.CloseDate = date.valueOf('2012-1-1');
    	myBalanceController.oppEnd.CloseDate = date.valueOf('2012-12-31');
    	myBalanceController.runReport();
    	test.stopTest();
    }

}