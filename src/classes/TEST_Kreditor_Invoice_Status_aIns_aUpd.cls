@isTest
private class TEST_Kreditor_Invoice_Status_aIns_aUpd {

	static testMethod void test_trigger_Kreditor_Invoice_Status_aInsert_aUpdate() {

		List<Account> lstAccounts = new List<Account>{};
		List<Campaign> lstCampaign = new List<Campaign>{};
		List<Opportunity> lstOpps = new List<Opportunity>{};



		//		id bankTransferId = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Bank'].id;
		//		id directDebitId = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Bank'].id;
		//		id creditCard1Id = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Mastercard xx1000931'].id;
		//		id creditCard2Id = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Mastercard xx9019208'].id;
		//		id cashId = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Kasse'].id;
		/*Chart_of_Accounts__c Bank = new Chart_of_Accounts__c(Name='1200',Account_Description__c = 'Bank HVB *0343',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Finanzen',Active__c=true);
		Chart_of_Accounts__c Kasse = new Chart_of_Accounts__c(Name='1000',Account_Description__c = 'Kasse',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Finanzen',Active__c=true);
		Chart_of_Accounts__c KasseErloese = new Chart_of_Accounts__c(Name='81000',Account_Description__c = 'Kasse',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Erlöse',Active__c=true);
		Chart_of_Accounts__c coaBuero = new Chart_of_Accounts__c(Name='0420',Account_Description__c = 'Büroeinrichtung',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Anlagen',Active__c=true);		
		Chart_of_Accounts__c coaVorSt19 = new Chart_of_Accounts__c(Name='1576',Account_Description__c = 'Abziehbare Vorsteuer 19%',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Finanzen',Active__c=true);
		Chart_of_Accounts__c coaVorSt7 = new Chart_of_Accounts__c(Name='1571',Account_Description__c = 'Abziehbare Vorsteuer 7%',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Finanzen',Active__c=true);
		Chart_of_Accounts__c coaVorSt0 = new Chart_of_Accounts__c(Name='1570',Account_Description__c = 'Abziehbare Vorsteuer',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Finanzen',Active__c=true);

		Chart_of_Accounts__c coaTestAcc1 = new Chart_of_Accounts__c(Name='70305',Account_Description__c = 'coaTestAcc1',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Kreditoren',Active__c=true);
		Chart_of_Accounts__c coaTestAcc2 = new Chart_of_Accounts__c(Name='70805',Account_Description__c = 'coaTestAcc2',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Kreditoren',Active__c=true);
		Chart_of_Accounts__c coaTestAcc3 = new Chart_of_Accounts__c(Name='90703',Account_Description__c = 'coaTestAcc3',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Kreditoren',Active__c=true);

		//Chart_of_Accounts__c creditCard0Id 	= new Chart_of_Accounts__c (Name='1361', Account_Type__c = 'Finanzen' , Account_Description__c = 'Mastercard xx1000931');
		//Chart_of_Accounts__c creditCard1Id 	= new Chart_of_Accounts__c (Name='1365', Account_Type__c = 'Finanzen' , Account_Description__c = 'Mastercard x20452043');
		//Chart_of_Accounts__c creditCard2Id 	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'Mastercard xx9019208');
		
		Chart_of_Accounts__c chAcc1	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'Bank HVB *0343');
		Chart_of_Accounts__c chAcc2	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'Bank HVB *8380');
		Chart_of_Accounts__c chAcc3	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'Deutsche Bank *3200');
		Chart_of_Accounts__c chAcc4	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'MasterCard Lufthansa TCS *0330');
		Chart_of_Accounts__c chAcc5	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'MasterCard TCS *8341');
		Chart_of_Accounts__c chAcc6	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'MasterCard THK *8333');
		Chart_of_Accounts__c chAcc7	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'Bank HVB *9333');
        
        Chart_of_Accounts__c chAcc12	= new Chart_of_Accounts__c (Name='1202', Account_Type__c = 'Finanzen' , Account_Description__c = 'Bank HVB *9250 Sparkonto');
        Chart_of_Accounts__c chAcc13	= new Chart_of_Accounts__c (Name='1203', Account_Type__c = 'Finanzen' , Account_Description__c = 'Bank HVB *1982 USD');
		
        
        Chart_of_Accounts__c chAcc8	= new Chart_of_Accounts__c (Name='710001', Account_Type__c = 'Kreditoren' , Account_Description__c = 'Köhler Thorsten,');
		Chart_of_Accounts__c chAcc9	= new Chart_of_Accounts__c (Name='710002', Account_Type__c = 'Finanzen' , Account_Description__c = 'MasterCard Porsche TCS *0873');
		Chart_of_Accounts__c chAcc10	= new Chart_of_Accounts__c (Name='1363', Account_Type__c = 'Finanzen' , Account_Description__c = 'MasterCard L.Sch. *8499');
		Chart_of_Accounts__c chAcc11	= new Chart_of_Accounts__c (Name='71901', Account_Type__c = 'Kreditoren' , Account_Description__c = 'Scheuermann Torsten,');*/


        



		//insert coaTestAcc1; insert coaTestAcc2; insert coaTestAcc3; insert chAcc1;insert chAcc2;insert chAcc3;insert chAcc4;insert chAcc5;insert chAcc6;insert chAcc7;insert chAcc8;insert chAcc9;
		//insert chAcc10; insert chAcc11; insert chAcc12; insert chAcc13;
		

		/*if([SELECT Id, Name from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Name='Bank HVB *0343'].size() > 0){
			Bank = [SELECT Id, Name from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Name='1200' LIMIT 1];
		} else {
			insert Bank; 
		}


		if([SELECT Id, Name from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Name='Kasse'].size() > 0){
			Kasse = [SELECT Id, Name from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Name='1000' LIMIT 1];
		} else {
			insert Kasse; 
		}

		if([SELECT Id, Name from Chart_of_Accounts__c where Account_Type__c = 'Erlöse' and Name='Kasse'].size() > 0){
			KasseErloese = [SELECT Id, Name from Chart_of_Accounts__c where Account_Type__c = 'Erlöse' and Name='81000' LIMIT 1];
		} else {
			insert KasseErloese; 
		}
		Chart_of_Accounts__c KasseErloeseAcc = [SELECT Id, Name, Account_Type__c, Account_Description__c, Account__c FROM Chart_of_Accounts__c WHERE Name = '81000'];

		String strKasseErloeseId = KasseErloeseAcc.Account__c;
		If (KasseErloeseAcc.Account__c != null) {
			Account KasseAcc = new Account(Name = 'Kasse', Type = 'Prospect');
			insert KasseAcc;
			KasseErloeseAcc.Account__c = KasseAcc.Id;
			update KasseErloeseAcc;
		}


		if([SELECT Id, Name from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Name='Kasse'].size() > 0){
			coaBuero = [SELECT Id, Name from Chart_of_Accounts__c where Account_Type__c = 'Anlagen' and Name='0420' LIMIT 1];
		} else {
			insert coaBuero; 
		}

		if([SELECT Id, Name from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Name='1576'].size() > 0){
			coaVorSt19 = [SELECT Id, Name from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Name='1576' LIMIT 1];
		} else {
			insert coaVorSt19; 
		} 

		if([SELECT Id, Name from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Name='1571'].size() > 0){
			coaVorSt7 = [SELECT Id, Name from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Name='1571' LIMIT 1];
		} else {
			insert coaVorSt7; 
		} 

		if([SELECT Id, Name from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Name='1570'].size() > 0){
			coaVorSt0 = [SELECT Id, Name from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Name='1570' LIMIT 1];
		} else {
			insert coaVorSt0; 
		}*/



		for(Integer i = 0; i < 2; i++){
			Account objAcc = new Account(Name = 'Test_Account' + i, Type = 'Prospect');
			lstAccounts.add(objAcc);
		}
		insert lstAccounts;

		List<Chart_of_Accounts__c> chartOfAccounts = new List<Chart_of_Accounts__c>();
		Chart_of_Accounts__c chartOfAccount = new Chart_of_Accounts__c(Name = '1234', Account_Type__c = 'Kreditoren', Account_Description__c = 'Test Account');
		chartOfAccount.Account__c = lstAccounts.get(0).ID;

 		Chart_of_Accounts__c coaVorSt19 = new Chart_of_Accounts__c(Name='1576',Account_Description__c = 'Abziehbare Vorsteuer 19%',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Finanzen',Active__c=true);
		Chart_of_Accounts__c coaVorSt7 = new Chart_of_Accounts__c(Name='1571',Account_Description__c = 'Abziehbare Vorsteuer 7%',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Finanzen',Active__c=true);
		Chart_of_Accounts__c coaVorSt0 = new Chart_of_Accounts__c(Name='1570',Account_Description__c = 'Abziehbare Vorsteuer',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Finanzen',Active__c=true);       	
		Chart_of_Accounts__c Bank = new Chart_of_Accounts__c(Name='1200',Account_Description__c = 'Bank HVB *0343',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Finanzen',Active__c=true);
		Chart_of_Accounts__c Kasse = new Chart_of_Accounts__c(Name='1000',Account_Description__c = 'Kasse',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Finanzen',Active__c=true);

		chartOfAccounts.add(chartOfAccount);
		chartOfAccounts.add(coaVorSt19);
		chartOfAccounts.add(coaVorSt7);
		chartOfAccounts.add(coaVorSt0);
		chartOfAccounts.add(Bank);
		chartOfAccounts.add(Kasse);

		insert chartOfAccounts;

		for(Integer i = 0; i < 2; i++){
			Campaign objCam = new Campaign(Name = 'Test_Campaign' + i, Type = 'Weitere');
			objCam.Status = 'Läuft'; objCam.IsActive = true; 
			objCam.StartDate = Date.newInstance(2011, 1, 1); 
			objCam.EndDate = Date.newInstance(2030, 12, 31);
			lstCampaign.add(objCam);
		}
		insert lstCampaign;

		for(Integer i = 0; i < 2; i++){
			Opportunity objOpp = new Opportunity(Name = 'Test_Opp' + i, Account = lstAccounts[i] , CloseDate = Date.newInstance(2030, 12, 31),Type='Office Abrechnung', LeadSource='LeadSource', Campaign = lstCampaign[i], StageName = 'Geschlossene und gewonnene', Probability = 100, Compelling_Event__c = true);
			lstOpps.add(objOpp);
		}
		insert lstOpps;

		test.startTest();

		//Kreditor__c objKreditor = new Kreditor__c(Name = 'test_eingangsrechnung', Invoice_Number__c = '123456', Invoice_date__c = Date.newInstance(2011, 1, 1), Invoice_due_on__c = Date.newInstance(2099, 1, 1), Payment_Status__c = 'Unpaid', Invoice_amount__c = 100, VAT_Type__c = '19%', Opportunity__c = lstOpps[0].Id , Kreditorennummer__c = KasseErloese.Id, Account__c = lstAccounts[0].Id, VAT_Account_new__c=coaVorSt19.Id, Outgoing_Invoice__c = false);
		Kreditor__c objKreditor = new Kreditor__c(Name = 'test_eingangsrechnung', Invoice_Number__c = '123456', Invoice_date__c = System.today(), Invoice_due_on__c = System.today().addDays(30), Payment_Status__c = 'Unpaid', Invoice_amount__c = 100, VAT_Type__c = '19%', Opportunity__c = lstOpps[0].Id , Kreditorennummer__c = chartOfAccount.Id, Account__c = chartOfAccount.Account__c, Outgoing_Invoice__c = false);
		objKreditor.Invoice_Amount_North__c = 100;
        objKreditor.Invoice_Amount_South__c = 0;
        objKreditor.Invoice_Amount_CCEAG__c = 0;
        objKreditor.Invoice_Amount_Telekom__c = 0;
        objKreditor.Invoice_Amount_YOUR_SL__c = 0;    
        insert objKreditor;
		System.assertEquals(objKreditor.Outgoing_Invoice__c, false);
		
		objKreditor = [SELECT Id, Outgoing_Invoice__c FROM Kreditor__c WHERE Id =:  objKreditor.Id];

		Kreditor_Invoice_Status__c objKreditorStatus = new Kreditor_Invoice_Status__c(Kreditor_Invoice__c = objKreditor.Id, debit_account__c = chartOfAccount.Id, credit_account__c = chartOfAccount.Id, Payment_Status__c = 'Paid',Payment_method__c = 'Cash', Kreditorennummer__c = chartOfAccount.Id);
		
		//System.assertEquals(chartOfAccount.Name, '1000');
		//System.assertEquals(objKreditorStatus.debit_account__c, chartOfAccount.Id);
		insert objKreditorStatus;
		objKreditor = [SELECT Id, Outgoing_Invoice__c FROM Kreditor__c WHERE Id =:  objKreditor.Id];
		
		//System.assertEquals(objKreditor.Outgoing_Invoice__c, false);
		//System.assertEquals(coaTestAcc1.Name, '70305');
		//objKreditorStatus.debit_account__c = coaTestAcc1.Id;
		//update objKreditorStatus;
		//objKreditor = [SELECT Id, Outgoing_Invoice__c FROM Kreditor__c WHERE Id =:  objKreditor.Id];
		//System.assertEquals(objKreditor.Outgoing_Invoice__c, true);
		test.stopTest();

		/*// Further Testing 
		objKreditor.Kreditorennummer__c = null;
		update objKreditor;
		objKreditor.Kreditorennummer__c = KasseErloese.Id;
		update objKreditor;
		objKreditorStatus.Payment_Status__c = 'Unpaid';
		objKreditorStatus.Payment_method__c = null;
		
		update objKreditorStatus;*/
		

		
	} 
}