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
 *
 * Latest Change: 07.07.14 by Alexander Placidi.
 * Description: Just set some new fields to meet the validation rule.
 */
@isTest (SeeAllData=true)
private class CashFlow4_Test {

    static testMethod void CashFlow4_Test() {
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
        Opportunity test_opportunity = new Opportunity();
        test_opportunity.Name = 'YOUR SL GmbH';
        test_opportunity.StageName = 'YOUR SL GmbH';
        test_opportunity.PriceBook2Id = Test.getStandardPricebookId();
        test_opportunity.CloseDate = Date.newInstance(2015, 1, 1);
        test_opportunity.Managed_by_PSO_Tool__c = true;
        test_opportunity.Projektstatus__c = 'Terrible';
        insert test_opportunity;
        List<Account> lstAccounts = new List<Account>{};
		List<Campaign> lstCampaign = new List<Campaign>{};
		List<Opportunity> lstOpps = new List<Opportunity>{};
		List<Kreditor__c> lstkred = new List<Kreditor__c>();
		List<OpportunityLineItem> lstOppLI = new List<OpportunityLineItem>();

		Chart_of_Accounts__c Kasse = new Chart_of_Accounts__c(Name='1000',Account_Description__c = 'Kasse',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Finanzen',Active__c=true);
		Chart_of_Accounts__c KasseErloese = new Chart_of_Accounts__c(Name='81000',Account_Description__c = 'Kasse',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Erlöse',Active__c=true);
		Chart_of_Accounts__c coaTestAcc1 = new Chart_of_Accounts__c(Name='70305',Account_Description__c = 'coaTestAcc1',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Kreditoren',Active__c=true);

		Chart_of_Accounts__c coaTestAcc2 = new Chart_of_Accounts__c(Name='70805',Account_Description__c = 'coaTestAcc2',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Kreditoren',Active__c=true);
		Chart_of_Accounts__c coaTestAcc3 = new Chart_of_Accounts__c(Name='90703',Account_Description__c = 'coaTestAcc3',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Kreditoren',Active__c=true);

		//Chart_of_Accounts__c creditCard0Id 	= new Chart_of_Accounts__c (Name='1361', Account_Type__c = 'Finanzen' , Account_Description__c = 'Mastercard xx1000931');
		//Chart_of_Accounts__c creditCard1Id 	= new Chart_of_Accounts__c (Name='1365', Account_Type__c = 'Finanzen' , Account_Description__c = 'Mastercard x20452043');
		//Chart_of_Accounts__c creditCard2Id 	= new Chart_of_Accounts__c (Name='1362', Account_Type__c = 'Finanzen' , Account_Description__c = 'Mastercard xx9019208');


		insert coaTestAcc1; insert coaTestAcc2; insert coaTestAcc3;
        //insert creditCard0Id; insert creditCard1Id; insert creditCard2Id;


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
		Chart_of_Accounts__c KasseErloeseAcc = [SELECT Id, Name, Account_Type__c, Account_Description__c, Account__c FROM Chart_of_Accounts__c WHERE Name = '81000' LIMIT 1];

		String strKasseErloeseId = KasseErloeseAcc.Account__c;
		If (KasseErloeseAcc.Account__c != null) {
			Account KasseAcc = new Account(Name = 'Kasse', Type = 'Prospect');
			insert KasseAcc;
			KasseErloeseAcc.Account__c = KasseAcc.Id;
			update KasseErloeseAcc;
		}


		for(Integer i = 0; i < 2; i++){
			Account objAcc = new Account(Name = 'Test_Account' + i, Type = 'Prospect');
			lstAccounts.add(objAcc);
		}
		insert lstAccounts;


		for(Integer i = 0; i < 2; i++){
			Campaign objCam = new Campaign(Name = 'Test_Campaign' + i, Type = 'Weitere');
			objCam.Status = 'Läuft'; objCam.IsActive = true;
			objCam.StartDate = Date.newInstance(2011, 1, 1);
			objCam.EndDate = Date.newInstance(2030, 12, 31);
			lstCampaign.add(objCam);
		}
		insert lstCampaign;

		for(Integer i = 0; i < 2; i++){
			Opportunity objOpp = new Opportunity(Name = 'Test_Opp' + i, Account = lstAccounts[i] , CloseDate = Date.newInstance(2012, 10, 01),Type='Office Abrechnung', LeadSource='LeadSource', Campaign = lstCampaign[i], StageName = 'Won', Probability = 100, Compelling_Event__c = true);
			lstOpps.add(objOpp);
		}
		insert lstOpps;
		for(Integer i= 1; i<=31;i++){
			Date tempDate = date.newInstance(2012 ,8 ,i);
			Kreditor__c objKre = new Kreditor__c(Name = 'TestKreditor' +i, Invoice_Number__c = '2012-08-' +i, Invoice_date__c=tempDate.addDays(-1),Invoice_due_on__c=tempDate, Invoice_amount__c = 100.00+i,VAT_Type__c='19%' );
			objKre.Invoice_amount__c = 100;
            objKre.Invoice_Amount_YOUR_SL__c = 100; //fill out these fields to meet the validation rule
            objKre.Invoice_Amount_CCEAG__c = 0;
            objKre.Invoice_Amount_North__c = 0;
            objKre.Invoice_Amount_Telekom__c = 0;
            objKre.Invoice_Amount_South__c = 0;
            if(i/2==0){
				objKre.Opportunity__c=lstOpps[0].Id;
				objKre.Account__c=lstOpps[0].AccountId;
			}
			else{
				objKre.Opportunity__c = lstOpps[1].Id;
				objKre.Account__c = lstOpps[1].AccountId;
			}
			lstkred.add(objKre);
		}
		for(Integer i= 1; i<=14;i++){
			Date tempDate = date.newInstance(2012 ,9 ,i);
			Kreditor__c objKre = new Kreditor__c(Name = 'TestKreditor' +i, Invoice_Number__c = '2012-08-' +i, Invoice_date__c=tempDate.addDays(-1),Invoice_due_on__c=tempDate,VAT_Type__c='19%' );
			objKre.Invoice_amount__c = 100;
            objKre.Invoice_Amount_YOUR_SL__c = 100; //fill out these fields to meet the validation rule
            objKre.Invoice_Amount_CCEAG__c = 0;
            objKre.Invoice_Amount_North__c = 0;
            objKre.Invoice_Amount_Telekom__c = 0;
            objKre.Invoice_Amount_South__c = 0;
            if(i/2==0){
				objKre.Opportunity__c=lstOpps[0].Id;
				objKre.Account__c=lstOpps[0].AccountId;
			}
			else{
				objKre.Opportunity__c = lstOpps[1].Id;
				objKre.Account__c = lstOpps[1].AccountId;
			}
			lstkred.add(objKre);
		}
		insert lstkred;

		//______________________________________________________________________
		//Product2
		Product2 testProduct= new Product2( Name='TestProduct',IsActive=true);
		insert testProduct;
		testProduct =[SELECT Name, Id,IsActive FROM Product2 WHERE Name=:'TestProduct'];
		test.startTest();

		Pricebook2 temppb = [SELECT Id, Name, IsActive, IsStandard FROM Pricebook2 WHERE IsStandard = true limit 1];

		System.debug('xxxxxxxxxxxxxxxxxxxx DEBUG: Name'+temppb.Name+' IsActive '+temppb.IsActive+' ID '+temppb.Id + temppb.IsStandard);

		//pricebookEntry new
		PricebookEntry testpbe2= new PricebookEntry( Pricebook2Id=temppb.Id, Product2Id= testProduct.Id, UnitPrice=249.0, IsActive=true,UseStandardPrice=false);
		insert testpbe2;

		//OpportunityLineItem
		//OpportunityLineItem testOppLineItem1 = new OpportunityLineItem(OpportunityId=testOpp1.Id, PricebookEntryId=testpbe2.Id, UnitPrice=1.5, Quantity=32.00, Unit__c='Manntag(e)');
		//insert testOppLineItem1;

		for(Integer i= 1;i<=31;i++){
			Date tempDate = date.newInstance(2012 ,8 ,i);
			OpportunityLineItem testOppLineItem1 = new OpportunityLineItem( PricebookEntryId=testpbe2.Id, UnitPrice=500.00, Quantity=32.00, Unit__c='Manntag(e)',Startdatum__c = tempDate.addDays(-3),ServiceDate=tempDate);
			if(i/2==0){
			testOppLineItem1.OpportunityId = lstOpps[0].Id;
			}else{
				testOppLineItem1.OpportunityId = lstOpps[1].Id;
			}

			lstOppLI.add(testOppLineItem1);
		}
		for(Integer i= 1;i<=14;i++){
			Date tempDate = date.newInstance(2012 ,9 ,i);
			OpportunityLineItem testOppLineItem1 = new OpportunityLineItem( PricebookEntryId=testpbe2.Id, UnitPrice=500.00, Quantity=32.00, Unit__c='Manntag(e)',Startdatum__c = tempDate.addDays(-3),ServiceDate=tempDate);
			if(i/2==0){
			testOppLineItem1.OpportunityId = lstOpps[0].Id;
			}else{
				testOppLineItem1.OpportunityId = lstOpps[1].Id;
			}

			lstOppLI.add(testOppLineItem1);
		}
		insert lstOppLI;

		Debitoren_Rechnung__c ausgangRech = new Debitoren_Rechnung__c(Invoice_Amount_net__c = 10, Invoice_date__c = Date.valueof('2012-10-01'), Opportunity__c = lstOpps[0].id);
    	Kreditor__c eingangRech = new Kreditor__c(Invoice_amount__c = 10, Invoice_date__c = Date.valueof('2012-10-01'), name = '1234', Opportunity__c = lstOpps[0].id, Invoice_due_on__c = date.today().addDays(30), Invoice_Number__c = '1', VAT_Type__c = '19%', Account__c = lstOpps[0].AccountId);
    	ausgangRech.Invoice_Amount_North__c = 10;
        ausgangRech.Invoice_Amount_South__c = 0;
        ausgangRech.Invoice_Amount_CCEAG__c = 0;
        ausgangrech.Invoice_Amount_Telekom__c = 0;
        ausgangRech.Invoice_Amount_YOUR_SL__c = 0;
        insert ausgangRech;
        eingangRech.Invoice_Amount_North__c = 10;
        eingangRech.Invoice_Amount_South__c = 0;
        eingangRech.Invoice_Amount_CCEAG__c = 0;
        eingangRech.Invoice_Amount_Telekom__c = 0;
        eingangRech.Invoice_Amount_YOUR_SL__c = 0;
    	insert eingangRech;
    	//Chart_of_Accounts__c Kasse = new Chart_of_Accounts__c(Name='1000',Account_Description__c = 'Kasse',Activation_date__c=Date.newInstance(2011, 1, 1),Account_Type__c='Finanzen',Active__c=true);
    	//insert Kasse;
    	//Chart_of_Accounts__c Kasse = [select id from Chart_of_Accounts__c where Account_Type__c = 'Finanzen' and Account_Description__c = 'Kasse'];

    	DebListObj__c TestList = new DebListObj__c();
    	PageReference testedPage = Page.CashFlow4Plan;
    	Test.setCurrentPage(testedPage);
    	//DebListObj__c db = new DebListObj__c();
    	DebListObj__c db1 = new DebListObj__c(Opportunity__c = lstOpps[0].Id,debDueDate01__c = 0,debDueDate02__c = 0,debDueDate03__c = 0,debDueDate04__c = 0,debDueDate05__c = 0,debDueDate06__c = 0,debDueDate07__c = 0, debDueDate08__c = 0,
					debDueDate09__c = 0,debDueDate10__c = 0,debDueDate11__c = 0,debDueDate12__c = 0,debDueDate13__c = 0,debDueDate14__c = 0,debDueDate15__c = 0,debDueDate16__c = 0,
					debDueDate17__c = 0,debDueDate18__c = 0,debDueDate19__c = 0,debDueDate20__c = 0,debDueDate21__c = 0,debDueDate22__c = 0,debDueDate23__c = 0,debDueDate24__c = 0,
					debDueDate25__c = 0,debDueDate26__c = 0,debDueDate27__c = 0,debDueDate28__c = 0,debDueDate29__c = 0,debDueDate30__c = 0,debDueDate31__c = 0, debDueDate32__c = 0,debDueDate33__c = 0,debDueDate34__c = 0,debDueDate35__c = 0,debDueDate36__c = 0,debDueDate37__c = 0,debDueDate38__c = 0,debDueDate39__c = 0, debDueDate40__c = 0,
					debDueDate41__c = 0,debDueDate42__c = 0,debDueDate43__c = 0,debDueDate44__c = 0,debDueDate45__c = 0);
    	/*DebListObj__c db2 = new DebListObj__c(Opportunity__c = lstOpps[0].Id,debDueDate01__c = 0,debDueDate02__c = 0,debDueDate03__c = 0,debDueDate04__c = 0,debDueDate05__c = 0,debDueDate06__c = 0,debDueDate07__c = 0, debDueDate08__c = 0,
					debDueDate09__c = 0,debDueDate10__c = 0,debDueDate11__c = 0,debDueDate12__c = 0,debDueDate13__c = 0,debDueDate14__c = 0,debDueDate15__c = 0,debDueDate16__c = 0,
					debDueDate17__c = 0,debDueDate18__c = 0,debDueDate19__c = 0,debDueDate20__c = 0,debDueDate21__c = 0,debDueDate22__c = 0,debDueDate23__c = 0,debDueDate24__c = 0,
					debDueDate25__c = 0,debDueDate26__c = 0,debDueDate27__c = 0,debDueDate28__c = 0,debDueDate29__c = 0,debDueDate30__c = 0,debDueDate31__c = 0, debDueDate32__c = 0,debDueDate33__c = 0,debDueDate34__c = 0,debDueDate35__c = 0,debDueDate36__c = 0,debDueDate37__c = 0,debDueDate38__c = 0,debDueDate39__c = 0, debDueDate40__c = 0,
					debDueDate41__c = 0,debDueDate42__c = 0,debDueDate43__c = 0,debDueDate44__c = 0,debDueDate45__c = 0);
					*/

    	//ApexPages.StandardController controller = new ApexPages.StandardController(db1);
    	CashFlow4 clsExtCashFlow4 = new CashFlow4();

		test.stopTest();
    } // END CashFlow3_Test
}