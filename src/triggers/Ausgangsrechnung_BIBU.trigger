trigger Ausgangsrechnung_BIBU on Debitoren_Rechnung__c (before insert, before update) {
	
	//getting the ids of the VAT accounts
	id vat0 = [SELECT id FROM Chart_of_Accounts__c 
				WHERE Account_Description__c = 'Abziehbare Vorsteuer' 
				AND Account_Type__c = 'Finanzen' limit 1].id;
	id vat7 = [SELECT id FROM Chart_of_Accounts__c 
				WHERE Account_Description__c = 'Abziehbare Vorsteuer 7%' 
				AND Account_Type__c = 'Finanzen' limit 1].id;
	id vat19 = [SELECT id FROM Chart_of_Accounts__c 
				WHERE Account_Description__c = 'Abziehbare Vorsteuer 19%' AND Account_Type__c = 'Finanzen' limit 1].id;
	list<id> oppIds = new list<id>();
	list<Opportunity> opps = new list<Opportunity>();
	list<id> accIds = new list<id>();
	map<id,id> oppIdToAccId = new map<id,id>();
	list<Account> accs = new list<Account>();
	list<Chart_of_Accounts__c> chAccs = new list<Chart_of_Accounts__c>();
	map<id, id> accIdToChartId = new map<id, id>();
	
	//setting the ids of the VAT Accounts, getting the ids of all accounts (in order to set Debitorennummer__c)			
	for(Debitoren_Rechnung__c invoice : trigger.new) {
		if(invoice.VAT_Type__c == '0') {invoice.VAT_Account__c = vat0;}
		if(invoice.VAT_Type__c == '7%') {invoice.VAT_Account__c = vat7;}
		if(invoice.VAT_Type__c == '19%') {invoice.VAT_Account__c = vat19;}
		oppIds.add(invoice.Opportunity__c);
	}
	opps = new list<Opportunity>([Select id, accountid FROM Opportunity Where Id IN: oppIds]);
	for(Opportunity opp: opps) {
		accIds.add(opp.accountid);
		oppIdToAccId.put(opp.id, opp.accountid);
	}
	
	//set Debitorennummer__c of all accounts that are already in Chart_of_Accounts__c
	chAccs = new list<Chart_of_Accounts__c>([SELECT Account__c, id FROM Chart_of_Accounts__c
				WHERE Account__c IN: accIds AND Account_Type__c = 'Debitoren']);
	//chAccs = new list<Chart_of_Accounts__c>([SELECT Account__c, id FROM Chart_of_Accounts__c
	//			WHERE Account__c IN: accIds]);
	for(Chart_of_Accounts__c chAcc : chAccs) {
		accIdToChartId.put(chAcc.Account__c, chAcc.id);
	}
	accIds = new list<id>();
	for(Debitoren_Rechnung__c invoice : trigger.new) {
		id accid = oppIdToAccId.get(invoice.opportunity__c);
		if(accIdToChartId.containsKey(accid)) {
			invoice.Debitorennummer__c = accIdToChartId.get(accid);
		} else {
			/* Debitorennummer__c remains blank */
			//accIds.add(accid);
		}

	}
	
	/*
	
	*/
	
	/*
	//create chart of account records for accounts that are not there
	accs = new list<Account>([Select id, name FROM Account Where Id IN: accIds]);
	
	integer[] nums = new integer[]{};
	chAccs = [SELECT name FROM Chart_of_Accounts__c 
				WHERE name like '10%' 
				OR name like '20%'
				OR name like '30%'];
	integer maxNum;
	if(chAccs.size() > 0) {
		for(Chart_of_Accounts__c chAcc : chAccs) {
			nums.add(integer.valueof(chAcc.name));
		}
		nums.sort();
		maxNum = nums[nums.size() - 1];
	} else {
		maxNum = 9999;
	}
	chAccs = new list<Chart_of_Accounts__c>();
	for(Account acc : accs) {
		maxNum++;
		Chart_of_Accounts__c chAcc = new Chart_of_Accounts__c(
			name = string.valueof(maxNum),
			Account__c = acc.id,
			Account_Description__c = acc.name,
			Account_Type__c = 'Debitoren',
			Activation_date__c = Date.Today()
		);
		chAccs.add(chAcc);
	}
	insert chAccs;
	
	//set Debitorennummer__c of all accounts that were now inserted into Chart_of_Accounts__c
	accIdToChartId = new map<id, id>();
	for(Chart_of_Accounts__c chAcc : chAccs) {
		accIdToChartId.put(chAcc.Account__c, chAcc.id);
	}
	accIds = new list<id>();
	for(Debitoren_Rechnung__c invoice : trigger.new) {
		id accid = oppIdToAccId.get(invoice.opportunity__c);
		if(invoice.Debitorennummer__c == null) {
			invoice.Debitorennummer__c = accIdToChartId.get(accid);
		}
	}
	*/
}