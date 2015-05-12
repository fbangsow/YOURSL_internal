trigger Eingangsrechnung_BIBU on Kreditor__c (before insert, before update) {
	
	//getting the ids of the VAT accounts
	id vat0 = [SELECT id FROM Chart_of_Accounts__c 
				WHERE Account_Description__c = 'Abziehbare Vorsteuer' 
				AND Account_Type__c = 'Finanzen' limit 1].id;
	id vat7 = [SELECT id FROM Chart_of_Accounts__c 
				WHERE Account_Description__c = 'Abziehbare Vorsteuer 7%' 
				AND Account_Type__c = 'Finanzen' limit 1].id;
	id vat19 = [SELECT id FROM Chart_of_Accounts__c 
				WHERE Account_Description__c = 'Abziehbare Vorsteuer 19%' AND Account_Type__c = 'Finanzen' limit 1].id;
	list<id> accIds = new list<id>();
	list<Account> accs = new list<Account>();
	list<Chart_of_Accounts__c> chAccs = new list<Chart_of_Accounts__c>();
	map<id, id> accIdToChartId = new map<id, id>();
	
	//setting the ids of the VAT Accounts, getting the ids of all accounts (in order to set Kreditorennummer__c)			
	for(Kreditor__c invoice : trigger.new) {
		if(invoice.VAT_Type__c == '0') {invoice.VAT_Account_new__c = vat0;}
		if(invoice.VAT_Type__c == '7%') {invoice.VAT_Account_new__c = vat7;}
		if(invoice.VAT_Type__c == '19%') {invoice.VAT_Account_new__c = vat19;}
		accIds.add(invoice.Account__c);
	}
	
	//set Kreditorennummer__c of all accounts that are already in Chart_of_Accounts__c
	chAccs = new list<Chart_of_Accounts__c>([SELECT Account__c, id FROM Chart_of_Accounts__c
				WHERE Account__c IN: accIds AND Account_Type__c = 'Kreditoren']);
	for(Chart_of_Accounts__c chAcc : chAccs) {
		accIdToChartId.put(chAcc.Account__c, chAcc.id);
	}
	accIds = new list<id>();
	for(Kreditor__c invoice : trigger.new) {
		if(invoice.Account__c != null) {
			if(accIdToChartId.containsKey(invoice.Account__c)) {
				invoice.Kreditorennummer__c = accIdToChartId.get(invoice.Account__c);
			} else {
				/* Kreditorennummer__c remains blank */
				//accIds.add(invoice.Account__c);
			}
		}
	}
	
	/*
	//create chart of account records for accounts that are not there
	accs = new list<Account>([Select id, name FROM Account Where Id IN: accIds]);
	
	integer[] nums = new integer[]{};
	chAccs = [SELECT name FROM Chart_of_Accounts__c 
				WHERE name like '70%' 
				OR name like '80%'
				OR name like '90%'];
	if(chAccs.size() > 0) {
		for(Chart_of_Accounts__c chAcc : chAccs) {
			nums.add(integer.valueof(chAcc.name));
		}
	}
	nums.sort();
	integer maxNum = nums[nums.size() - 1];
	chAccs = new list<Chart_of_Accounts__c>();
	for(Account acc : accs) {
		maxNum++;
		Chart_of_Accounts__c chAcc = new Chart_of_Accounts__c(
			name = string.valueof(maxNum),
			Account__c = acc.id,
			Account_Description__c = acc.name,
			Account_Type__c = 'Kreditoren',
			Activation_date__c = Date.Today()
		);
		chAccs.add(chAcc);
	}
	insert chAccs;
	
	//set Kreditorennummer__c of all accounts that were now inserted into Chart_of_Accounts__c
	accIdToChartId = new map<id, id>();
	for(Chart_of_Accounts__c chAcc : chAccs) {
		accIdToChartId.put(chAcc.Account__c, chAcc.id);
	}
	accIds = new list<id>();
	for(Kreditor__c invoice : trigger.new) {
		if(invoice.Account__c != null && invoice.Kreditorennummer__c == null) {
			invoice.Kreditorennummer__c = accIdToChartId.get(invoice.Account__c);
		}
	}
	*/
}