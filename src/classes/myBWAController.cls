/* **************************************************************
// Creater: Alexander Faust
// Description: retrieves and sums up all information for BWA Report
// Testclass: testmethod within class
// Apex Class Access: no limitation
// Last modified by: Chris Sandra Schautt
// Last modified date: 18.06.2014
// Latest changes: 	CSS:18.06.2014: add konto 2150 and 4946 to Sonstige Kosten and 
//									konto 2660 to Sonstige Betriebliche Erlöse
//					CSS:06.05.2013:add konto 8336 to Umsatzerloese
//					multiply the totalGehaltskosten and totalSonBetrErloese with number of the Month +1
//					30.04.2013 bei Gehalt konto 4140 hinzugefuegt, bei den Raumkosten konto 4280 hinzugefuegt
//					bei Versicherung  konto 4380 hinzugefuegt und beim Zinsertrag Konten 1322, 1323 hinzugefuegt
					AF:22.07.2013: added 3125 to "Fremdleistung";added 4550 to "KFZ Kosten"; added 2310 to "Zinsaufwand";added 2315 to "Zinsertrag"
					Alexander Placidi 07.07.2014. Test method: Set some new fields to meet the validation rule. 
																No further impact.  
// ************************************************************** */
public with sharing class myBWAController {
	public boolean showReport{get; set;}

	public Integer numberMonth{get; set;}
	
	public double totalUmsatzErloese;
	public double totalFremdLeistung;
	public double totalKostenart;
	public double betriebsErgebnis;
	public double totalRohertrag;
	public double totalUmsatzErloesePerc;
	public double totalFremdLeistungPerc;
	public double totalKostenartPerc;
	public double betriebsErgebnisPerc;
	public double totalRohertragPerc;
	public double totalGehaltskosten;
	public double totalGehaltskostenPerc;
	public double totalFremdarbeiten;
	public double totalFortbildungskosten;
	public double totalFortbildungskostenPerc;
	public double totalFremdarbeitenPerc;
	public double totalReisekosten;
	public double totalReisekostenPerc;
	public double totalTilgung;
	public double totalTilgungPerc;
	public double totalInternet;
	public double totalInternetPerc;
	public double totalZinsen;
	public double totalZinsenPerc;
	public double totalWerbekosten;
	public double totalWerbekostenPerc;
	public double totalAndereKosten;
	public double totalAndereKostenPerc;
	public double totalSonBetrErloese;
	public double totalSonBetrErloesePerc;
	public double totalBetrRohertrag;
	public double totalBetrRohertragPerc;
	public double totalZinsaufwand;
	public double totalZinsaufwandPerc;
	public double totalZinsertrag;
	public double totalZinsertragPerc;
	public double totalSteuernEinkErtr;
	public double totalSteuernEinkErtrPerc;
	public double totalErgebnisVorSteuern;
	public double totalErgebnisVorSteuernPerc;
	public double totalVorlaeufigesErgebnis;
	public double totalVorlaeufigesErgebnisPerc;
	public double totalAbschreibungen;
	public double totalAbschreibungenPerc;
	public double totalRaumkosten;
	public double totalRaumkostenPerc;
	public double totalBetrSteuern;
	public double totalBetrSteuernPerc;
	public double totalVersichBeitr;
	public double totalVersichBeitrPerc;
	public double totalKFZKosten;
	public double totalKFZKostenPerc;
	public double totalReparaturKosten;
	public double totalReparaturKostenPerc;
	
	public string totalUmsatzErloeseStr{get; set;}
	public string totalFremdLeistungStr{get; set;}
	public string totalKostenartStr{get; set;}
	public string betriebsErgebnisStr{get; set;}
	public string totalRohertragStr{get; set;}
	public string totalUmsatzErloesePercStr{get; set;}
	public string totalFremdLeistungPercStr{get; set;}
	public string totalKostenartPercStr{get; set;}
	public string betriebsErgebnisPercStr{get; set;}
	public string totalRohertragPercStr{get; set;}
	public string totalGehaltskostenStr{get;set;}
	public string totalGehaltskostenPercStr{get;set;}
	public string totalFremdarbeitenStr{get;set;}
	public string totalFremdarbeitenPercStr{get;set;}
	public string totalReisekostenStr{get;set;}
	public string totalReisekostenPercStr{get;set;}
	public string totalTilgungStr{get;set;}
	public string totalTilgungPercStr{get;set;}
	public string totalInternetStr{get;set;}
	public string totalInternetPercStr{get;set;}
	public string totalZinsenStr{get;set;}
	public string totalZinsenPercStr{get;set;}
	public string totalWerbekostenStr{get;set;}
	public string totalWerbekostenPercStr{get;set;}
	public string totalAndereKostenStr{get;set;}
	public string totalAndereKostenPercStr{get;set;}
	public string totalFortbildungskostenStr{get;set;}
	public string totalFortbildungskostenPercStr{get;set;}
	public string totalSonBetrErloeseStr{get;set;}
	public string totalSonBetrErloesePercStr{get;set;}
	public string totalBetrRohertragStr{get;set;}
	public string totalBetrRohertragPercStr{get;set;}
	public string totalZinsaufwandStr{get;set;}
	public string totalZinsaufwandPercStr{get;set;}
	public string totalZinsertragStr{get;set;}
	public string totalZinsertragPercStr{get;set;}
	public string totalSteuernEinkErtrStr{get;set;}
	public string totalSteuernEinkErtrPercStr{get;set;}
	public string totalErgebnisVorSteuernStr{get;set;}
	public string totalErgebnisVorSteuernPercStr{get;set;}
	public string totalVorlaeufigesErgebnisStr{get;set;}
	public string totalVorlaeufigesErgebnisPercStr{get;set;}
	public string totalAbschreibungenStr{get;set;}
	public string totalAbschreibungenPercStr{get;set;}
	public string totalRaumkostenStr{get;set;}
	public string totalRaumkostenPercStr{get;set;}
	public string totalBetrSteuernStr{get;set;}
	public string totalBetrSteuernPercStr{get;set;}
	public string totalVersichBeitrStr{get;set;}
	public string totalVersichBeitrPercStr{get;set;}
	public string totalKFZKostenStr{get;set;}
	public string totalKFZKostenPercStr{get;set;}
	public string totalReparaturKostenStr{get;set;}
	public string totalReparaturKostenPercStr{get;set;}
	
	/*
	public double totalTelefon{get; set;}
	public double totalTelefonPerc{get; set;}
	public double totalMiete{get; set;}
	public double totalMietePerc{get; set;}
	*/
	public opportunity oppStart{get;set;} //used because it has a date field
	public opportunity oppEnd{get;set;} //used because it has a date field
	public string startDateStr{get; set;}
	public string endDateStr{get; set;}
	public List<ChartDataWrapper> listChartData{get;set;}
	
	public myBWAController() {
		oppStart = new Opportunity();
		oppEnd = new Opportunity();
		showReport = false;
		numberMonth=0;
		
		listChartData = new List<ChartDataWrapper>();
		//runReport();
	}
	
	public pageReference runReport() {
		AggregateResult[] groupedResults;
		string query;
		map<id, string> kontorahmenIdToName = new map<id, string>();
		
		if(oppStart.CloseDate >  oppEnd.CloseDate) {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Start date cannot be later than end date'));
			return null;
		}
		numberMonth =  (oppEnd.CloseDate.month() - oppStart.CloseDate.month())+1;
		listChartData.clear();
		startDateStr = string.valueof(oppStart.CloseDate.year()) + '-' + padIntegerWithZero(oppStart.CloseDate.month()) + '-' + padIntegerWithZero(oppStart.CloseDate.day());
		endDateStr = string.valueof(oppEnd.CloseDate.year()) + '-' + padIntegerWithZero(oppEnd.CloseDate.month()) + '-' + padIntegerWithZero(oppEnd.CloseDate.day());
		
		//startDateStr = '2012-10-01';
		//endDateStr = '2012-10-31';
		
		//total Ausgangsrechnungs netto (Umsatzerlöse)
		/*query = 'SELECT sum(Invoice_Amount_net__c)' +
				' FROM Debitoren_Rechnung__c' + 
				' WHERE Invoice_date__c >= ' + startDateStr + 
	          	' AND Invoice_date__c <= ' + endDateStr;*/
	    query = 'SELECT sum(Debitor_Invoice__r.Invoice_amount_net__c)' +
				' FROM Debitor_Invoice_Status__c' + 
				' WHERE Debitor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
	          	' AND Debitor_Invoice__r.Invoice_date__c <= ' + endDateStr +
	          	' AND (debit_account__r.name = \'8400\''+            	
	          	' OR debit_account__r.name = \'8338\''+
	          	' OR debit_account__r.name = \'8336\''+
				' OR debit_account__r.name = \'8736\''+
	          	')';      	
	          	
	          	//So. betr. Erlöse
	          	//debit_account__r.name = \'8601\''+
	          	//OR debit_account__r.name = \'8611\''+ fester Betrag 1612,12€
	          	//debit_account__r.name = \'8640\''+
	          	//debit_account__r.name = \'2660\''
	          	
	          	
		groupedResults = Database.query(query);
		totalUmsatzErloese = double.valueOf(groupedResults[0].get('expr0'));
		if(totalUmsatzErloese == null) {totalUmsatzErloese = 0;}
		totalUmsatzErloeseStr = ((double)math.round((decimal)(totalUmsatzErloese*100))/100).format();
		totalUmsatzErloesePerc = 100.0;
		totalUmsatzErloesePercStr = ((double)math.round((decimal)(totalUmsatzErloesePerc*100))/100).format()+'%';
		
		//So. betr. Erlöse
		query = 'SELECT sum(Debitor_Invoice__r.Invoice_amount_net__c)' +
				' FROM Debitor_Invoice_Status__c' + 
				' WHERE Debitor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
	          	' AND Debitor_Invoice__r.Invoice_date__c <= ' + endDateStr +
	          	' AND (debit_account__r.name = \'8601\''+            	
	          	' OR debit_account__r.name = \'8640\''+
	          	' OR debit_account__r.name = \'2660\''+
	          	')';      	
		//+ fester Betrag 1612,12€
		groupedResults = Database.query(query);
		
		totalSonBetrErloese = double.valueOf(groupedResults[0].get('expr0'));
		//totalSonBetrErloese = double.valueOf(groupedResults[0].get('expr0'));
		if(totalSonBetrErloese == null) {totalSonBetrErloese = 0;}
		totalSonBetrErloese += (1612.12 * numberMonth);
		
		
		
		
		
		//total Fremdleistung (Eingangsrechnung, soll=3100)
		/*query = 'SELECT sum(Kreditor_Invoice__r.Invoice_amount__c)' +
				' FROM Kreditor_Invoice_Status__c' + 
				' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
	          	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
	          	' AND debit_account__r.name = \'3100\'';*/
	    query = 'SELECT sum(Kreditor_Invoice__r.Invoice_amount__c)' +
				' FROM Kreditor_Invoice_Status__c' + 
				' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
	          	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
	          	' AND (debit_account__r.name = \'3100\' OR debit_account__r.name = \'3400\' OR debit_account__r.name = \'3125\')';      	
	          	
		groupedResults = Database.query(query);
		totalFremdLeistung = double.valueOf(groupedResults[0].get('expr0'));
		if(totalFremdLeistung == null) {totalFremdLeistung = 0;}
		totalFremdLeistungStr = ((double)math.round((decimal)(totalFremdLeistung*100))/100).format();
		
		totalRohertrag = totalUmsatzErloese-totalFremdLeistung;
		totalRohertragStr = ((double)math.round((decimal)(totalRohertrag*100))/100).format();
		
		totalBetrRohertrag = totalRohertrag + totalSonBetrErloese;
		/*
		//total Kostenarten from Eingangsrechnungeen (Aufwendungen)
		query = 'SELECT id, sum(Kreditor_Invoice__r.Invoice_amount__c), debit_account__c' +
				' FROM Kreditor_Invoice_Status__c' + 
				' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
	          	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
	          	' AND debit_account__r.name != \'3100\'' +
	          	' AND debit_account__r.name != \'1000\'' +  
	          	' AND debit_account__r.name != \'1789\'' +
	          	' AND debit_account__r.name != \'1369\'' +
	          	' AND debit_account__r.name != \'2110\'' +
	          	' AND debit_account__r.name != \'2120\'' +
	          	' AND debit_account__r.name != \'2650\'' +
	          	' AND debit_account__r.name != \'2749\'' +
	          	' AND debit_account__r.name != \'2213\'' +
	          	' AND debit_account__r.name != \'2116\'' +
	          	//new accounts below
	          	' AND debit_account__r.name != \'1590\'' +
	          	' AND debit_account__r.name != \'1591\'' +
	          	' AND debit_account__r.name != \'1592\'' +
	          	' AND debit_account__r.name != \'0480\'' +
	          	' AND debit_account__r.name != \'0420\'' +
	          	' AND debit_account__r.name != \'0490\'' +
	          	' AND debit_account__r.name != \'0640\'' +
	          	' AND debit_account__r.name != \'0641\'' +
	          	' AND debit_account__r.name != \'0642\'' +
	          	' AND debit_account__r.name != \'71001\'' +
	          	' AND debit_account__r.name != \'71901\'' +
	          	' Group by debit_account__c, id'; 
		groupedResults = Database.query(query);
		//totalTelefon = 0;
		//totalMiete = 0;
		totalKostenart = 0;
		for (AggregateResult ar : groupedResults) {
			if(ar.get('expr0') != null && ar.get('debit_account__c') != null) {
				totalKostenart += double.valueOf(ar.get('expr0'));
				
				
			}
		}*/
		
		
		//Gehaltskosten
		query = 'SELECT id,sum(Kreditor_Invoice__r.Invoice_amount__c),debit_account__c' +
		' FROM Kreditor_Invoice_Status__c' + 
		' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
      	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
      	' AND '+
      	'(debit_account__r.name = \'1740\'' +
      	' OR debit_account__r.name = \'1741\''+ 
      	' OR debit_account__r.name = \'1742\''+
      	' OR debit_account__r.name = \'1750\''+
      	' OR debit_account__r.name = \'4152\''+
      	' OR debit_account__r.name = \'4140\''+
      	' OR debit_account__r.name = \'4141\''+
		' OR debit_account__r.name = \'4165\''+
		' OR debit_account__r.name = \'1748\''+
      	//' OR debit_account__r.name = \'2749\''+
      	' ) Group by debit_account__c, id';
		groupedResults = Database.query(query);
		totalGehaltskosten = 0;
		
		//totalGehaltskosten = double.valueOf(groupedResults[0].get('expr0'));
		for (AggregateResult ar : groupedResults) {
			if(ar.get('expr0') != null && ar.get('debit_account__c') != null) {
				totalGehaltskosten += double.valueOf(ar.get('expr0'));
			}
		}
		//totalGehaltskosten += (224.0 * numberMonth);
		totalGehaltskosten += (1918.42* numberMonth);
		// end Gehaltskosten
		
		//Fremdarbeit
		query = 'SELECT id,sum(Kreditor_Invoice__r.Invoice_amount__c),debit_account__c' +
		' FROM Kreditor_Invoice_Status__c' + 
		' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
      	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
      	' AND '+
      	'(debit_account__r.name = \'4780\'' +
      	' OR debit_account__r.name = \'4781\''+ 
      	' OR debit_account__r.name = \'4782\''+
      	' OR debit_account__r.name = \'4783\''+
      	' OR debit_account__r.name = \'4785\''+

      	' OR debit_account__r.name = \'4786\''+
      	' ) Group by debit_account__c, id';
		groupedResults = Database.query(query);
		totalFremdarbeiten = 0;
		
		
		for (AggregateResult ar : groupedResults) {
			if(ar.get('expr0') != null && ar.get('debit_account__c') != null) {
				totalFremdarbeiten += double.valueOf(ar.get('expr0'));		
			}
		}
		// end Fremdarbeit
		
		
		//Raumkosten
		query = 'SELECT id,sum(Kreditor_Invoice__r.Invoice_amount__c),debit_account__c' +
		' FROM Kreditor_Invoice_Status__c' + 
		' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
      	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
      	' AND '+
      	'(debit_account__r.name = \'4210\'' +
      	' OR debit_account__r.name = \'4240\''+ 
      	' OR debit_account__r.name = \'4250\''+
      	' OR debit_account__r.name = \'4260\''+
      	' OR debit_account__r.name = \'4280\''+
      	' ) Group by debit_account__c, id';
		groupedResults = Database.query(query);
		totalRaumkosten = 0;
		
		
		for (AggregateResult ar : groupedResults) {
			if(ar.get('expr0') != null && ar.get('debit_account__c') != null) {
				totalRaumkosten += double.valueOf(ar.get('expr0'));		
			}
		}
		//END Raumkosten
		
		//Betriebl. Steuern / KfZ Steuern
		
		query = 'SELECT id,sum(Kreditor_Invoice__r.Invoice_amount__c),debit_account__c' +
		' FROM Kreditor_Invoice_Status__c' + 
		' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
      	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
      	' AND '+
      	' (debit_account__r.name = \'4510\' OR debit_account__r.name = \'4550\')' +
      	' Group by debit_account__c, id';
		groupedResults = Database.query(query);
		totalBetrSteuern = 0;
		
		
		for (AggregateResult ar : groupedResults) {
			if(ar.get('expr0') != null && ar.get('debit_account__c') != null) {
				totalBetrSteuern += double.valueOf(ar.get('expr0'));		
			}
		}
		
		
		// END Betriebl. Steuern / KfZ Steuern
		
		//Versich./Beiträge
		query = 'SELECT id,sum(Kreditor_Invoice__r.Invoice_amount__c),debit_account__c' +
		' FROM Kreditor_Invoice_Status__c' + 
		' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
      	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
      	' AND '+
      	'(debit_account__r.name = \'4360\'' +
      	' OR debit_account__r.name = \'4390\''+ 
      	' OR debit_account__r.name = \'4380\''+
      	' ) Group by debit_account__c, id';
		groupedResults = Database.query(query);
		totalVersichBeitr = 0;
		
		
		for (AggregateResult ar : groupedResults) {
			if(ar.get('expr0') != null && ar.get('debit_account__c') != null) {
				totalVersichBeitr += double.valueOf(ar.get('expr0'));		
			}
		}
		
		//END Versich./Beiträge
		
		//KFZ Kosten
		query = 'SELECT id,sum(Kreditor_Invoice__r.Invoice_amount__c),debit_account__c' +
		' FROM Kreditor_Invoice_Status__c' + 
		' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
      	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
      	' AND '+
      	'(debit_account__r.name = \'4530\'' +
      	' OR debit_account__r.name = \'4540\''+ 
      	' OR debit_account__r.name = \'4580\''+
      	' OR debit_account__r.name = \'4595\''+
		' OR debit_account__r.name = \'4520\''+
		' OR debit_account__r.name = \'4532\''+
		' OR debit_account__r.name = \'4570\''+
      	' ) Group by debit_account__c, id';
		groupedResults = Database.query(query);
		totalKFZKosten = 0;
		
		
		for (AggregateResult ar : groupedResults) {
			if(ar.get('expr0') != null && ar.get('debit_account__c') != null) {
				totalKFZKosten += double.valueOf(ar.get('expr0'));		
			}
		}
		//END KFZ Kosten
		
		//Werbe- /Reisekosten
		query = 'SELECT id,sum(Kreditor_Invoice__r.Invoice_amount__c),debit_account__c' +
		' FROM Kreditor_Invoice_Status__c' + 
		' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
      	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
      	' AND '+
      	'(debit_account__r.name = \'4600\'' +
      	' OR debit_account__r.name = \'4630\''+ 
      	' OR debit_account__r.name = \'4640\''+
      	' OR debit_account__r.name = \'4650\''+
      	' OR debit_account__r.name = \'4654\''+
      	' OR debit_account__r.name = \'4660\''+
      	' OR debit_account__r.name = \'4663\''+
      	' OR debit_account__r.name = \'4664\''+
      	' OR debit_account__r.name = \'4666\''+
		' OR debit_account__r.name = \'4662\''+
      	' ) Group by debit_account__c, id';
		groupedResults = Database.query(query);
		totalWerbekosten = 0;
		
		
		for (AggregateResult ar : groupedResults) {
			if(ar.get('expr0') != null && ar.get('debit_account__c') != null) {
				totalWerbekosten += double.valueOf(ar.get('expr0'));		
			}
		}
		
		//END Werbe-/Reisekosten
		

		//Abschreibungen
		
		query = 'SELECT id,sum(Kreditor_Invoice__r.Invoice_amount__c),debit_account__c' +
		' FROM Kreditor_Invoice_Status__c' + 
		' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
      	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
      	' AND '+
      	'(debit_account__r.name = \'4822\'' +
      	' OR debit_account__r.name = \'4830\''+
      	' OR debit_account__r.name = \'4832\''+
      	' OR debit_account__r.name = \'4855\''+
      	' OR debit_account__r.name = \'4862\''+
      	' OR debit_account__r.name = \'4877\''+
      	' ) Group by debit_account__c, id';
		groupedResults = Database.query(query);
		totalAbschreibungen = 0;
		
		
		for (AggregateResult ar : groupedResults) {
			if(ar.get('expr0') != null && ar.get('debit_account__c') != null) {
				totalAbschreibungen += double.valueOf(ar.get('expr0'));		
			}
		}
		
		//END Abschreibungen
		
		
		//Reparaturkosten
		query = 'SELECT id,sum(Kreditor_Invoice__r.Invoice_amount__c),debit_account__c' +
		' FROM Kreditor_Invoice_Status__c' + 
		' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
      	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
      	' AND '+
      	'(debit_account__r.name = \'4805\'' +
      	' OR debit_account__r.name = \'4806\''+ 
      	' ) Group by debit_account__c, id';
		groupedResults = Database.query(query);
		totalReparaturkosten = 0;
		
		
		for (AggregateResult ar : groupedResults) {
			if(ar.get('expr0') != null && ar.get('debit_account__c') != null) {
				totalReparaturkosten += double.valueOf(ar.get('expr0'));		
			}
		}
		//END Reparaturkosten
		
		//Sonstige Kosten
		query = 'SELECT id,sum(Kreditor_Invoice__r.Invoice_amount__c),debit_account__c' +
		' FROM Kreditor_Invoice_Status__c' + 
		' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
      	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
      	' AND '+      	
      	'(debit_account__r.name = \'4910\''+
      	' OR debit_account__r.name = \'4920\''+
      	' OR debit_account__r.name = \'4921\''+
      	' OR debit_account__r.name = \'4925\''+
      	' OR debit_account__r.name = \'4930\''+
      	' OR debit_account__r.name = \'4940\''+
      	' OR debit_account__r.name = \'4945\''+
      	' OR debit_account__r.name = \'4950\''+
      	' OR debit_account__r.name = \'4955\''+
      	' OR debit_account__r.name = \'4957\''+
      	' OR debit_account__r.name = \'4960\''+
      	' OR debit_account__r.name = \'4970\''+
      	' OR debit_account__r.name = \'4980\''+
      	' OR debit_account__r.name = \'4985\''+
      	' OR debit_account__r.name = \'2150\''+ 
      	' OR debit_account__r.name = \'4946\''+       	
      	')  Group by debit_account__c, id';
		groupedResults = Database.query(query);
		totalAndereKosten = 0;
		
		
		for (AggregateResult ar : groupedResults) {
			if(ar.get('expr0') != null && ar.get('debit_account__c') != null) {
				System.debug('*********debit_account__c  '+ar.get('debit_account__c')+'Amount : '+ar.get('expr0'));
				totalAndereKosten += double.valueOf(ar.get('expr0'));		
			}
		}
		//End Sonstige Kosten
		
		//Zinsaufwand
		
		query = 'SELECT id,sum(Kreditor_Invoice__r.Invoice_amount__c),debit_account__c' +
		' FROM Kreditor_Invoice_Status__c' + 
		' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
      	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
      	' AND '+
      	'(debit_account__r.name = \'2110\'' +
      	' OR debit_account__r.name = \'2120\''+
      	' OR debit_account__r.name = \'2020\''+
      	' OR debit_account__r.name = \'2493\''+
      	' OR debit_account__r.name = \'2310\''+
      	' OR debit_account__r.name = \'2382\''+
      	' ) Group by debit_account__c, id';
		groupedResults = Database.query(query);
		totalZinsaufwand = 0;
		
		for (AggregateResult ar : groupedResults) {
			if(ar.get('expr0') != null && ar.get('debit_account__c') != null) {
				totalZinsaufwand += double.valueOf(ar.get('expr0'));		
			}
		}
		
		//end Zinsaufwand
		
		//Zinsertrag
		
		query = 'SELECT id,sum(Kreditor_Invoice__r.Invoice_amount__c),debit_account__c' +
		' FROM Kreditor_Invoice_Status__c' + 
		' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
      	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
      	' AND '+
      	'(debit_account__r.name = \'2650\'' +
      	' OR debit_account__r.name = \'2749\''+
      	' OR debit_account__r.name = \'2501\''+
      	' OR debit_account__r.name = \'1322\''+
      	' OR debit_account__r.name = \'1323\''+
      	' OR debit_account__r.name = \'2742\''+
      	' OR debit_account__r.name = \'2315\''+
      	' ) Group by debit_account__c, id';
		groupedResults = Database.query(query);
		totalZinsertrag = 0;
		
		for (AggregateResult ar : groupedResults) {
			if(ar.get('expr0') != null && ar.get('debit_account__c') != null) {
				System.debug('@@@@MyDebug: Id'+ar.get('Id')+' amount:'+ar.get('expr0'));
				totalZinsertrag += double.valueOf(ar.get('expr0'));		
			}
		}
		if (totalZinsertrag < 0){totalZinsertrag = totalZinsertrag * -1;}
		//end Zinsertrag
		
		//Steuern Einkauf Ertrag
		
		query = 'SELECT id,sum(Kreditor_Invoice__r.Invoice_amount__c),debit_account__c' +
		' FROM Kreditor_Invoice_Status__c' + 
		' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
      	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
      	' AND '+
      	'(debit_account__r.name = \'2213\'' +
      	' OR debit_account__r.name = \'2216\''+
      	' ) Group by debit_account__c, id';
		groupedResults = Database.query(query);
		totalSteuernEinkErtr = 0;
		
		for (AggregateResult ar : groupedResults) {
			if(ar.get('expr0') != null && ar.get('debit_account__c') != null) {
				totalSteuernEinkErtr  += double.valueOf(ar.get('expr0'));		
			}
		}
		
		//End Steuern Einkauf Ertrag
		//------------------------------------------------------wird nich benutzt -----------------------------------
		//Reisekosten
		query = 'SELECT id,sum(Kreditor_Invoice__r.Invoice_amount__c),debit_account__c' +
		' FROM Kreditor_Invoice_Status__c' + 
		' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
      	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
      	' AND '+
      	'(debit_account__r.name = \'4640\'' +
      	' OR debit_account__r.name = \'4650\''+
      	' OR debit_account__r.name = \'4660\''+
      	' OR debit_account__r.name = \'4662\''+  
      	' OR debit_account__r.name = \'4663\''+
      	' OR debit_account__r.name = \'4664\''+
      	' OR debit_account__r.name = \'4666\''+
      	' OR debit_account__r.name = \'4600\''+
      	' ) Group by debit_account__c, id';
		groupedResults = Database.query(query);
		totalReisekosten = 0;
		
		
		for (AggregateResult ar : groupedResults) {
			if(ar.get('expr0') != null && ar.get('debit_account__c') != null) {
				totalReisekosten += double.valueOf(ar.get('expr0'));		
			}
		}
		// End Reisekosten
		
		
		// Tilgung
		query = 'SELECT id,sum(Kreditor_Invoice__r.Invoice_amount__c),debit_account__c' +
		' FROM Kreditor_Invoice_Status__c' + 
		' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
      	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
      	' AND '+
      	'(debit_account__r.name = \'0640\'' +
      	' OR debit_account__r.name = \'0641\''+ 
      	' ) Group by debit_account__c, id';
		groupedResults = Database.query(query);
		totalTilgung = 0;
		
		
		for (AggregateResult ar : groupedResults) {
			if(ar.get('expr0') != null && ar.get('debit_account__c') != null) {
				totalTilgung += double.valueOf(ar.get('expr0'));		
			}
		}
		// End Tilgung
		
		// Internet
		query = 'SELECT id,sum(Kreditor_Invoice__r.Invoice_amount__c),debit_account__c' +
		' FROM Kreditor_Invoice_Status__c' + 
		' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
      	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
      	' AND '+
      	'(debit_account__r.name = \'4920\'' +
      	' OR debit_account__r.name = \'4921\''+
      	' OR debit_account__r.name = \'4925\''+  
      	' ) Group by debit_account__c, id';
		groupedResults = Database.query(query);
		totalInternet = 0;
		
		
		for (AggregateResult ar : groupedResults) {
			if(ar.get('expr0') != null && ar.get('debit_account__c') != null) {
				totalInternet += double.valueOf(ar.get('expr0'));		
			}
		}
		// End Internet
		
		
		/*query = 'SELECT id,sum(Kreditor_Invoice__r.Invoice_amount__c),debit_account__c' +
		' FROM Kreditor_Invoice_Status__c' + 
		' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
      	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
      	' AND '+
      	'(debit_account__r.name = \'2110\'' +
      	' OR debit_account__r.name = \'2120\''+
      	' OR debit_account__r.name = \'2493\''+
      	' OR debit_account__r.name = \'2650\''+  
      	' ) Group by debit_account__c, id';
		groupedResults = Database.query(query);
		totalZinsen = 0;
		
		
		for (AggregateResult ar : groupedResults) {
			if(ar.get('expr0') != null && ar.get('debit_account__c') != null) {
				totalZinsen += double.valueOf(ar.get('expr0'));		
			}
		}*/
		
		/*query = 'SELECT id,sum(Kreditor_Invoice__r.Invoice_amount__c),debit_account__c' +
		' FROM Kreditor_Invoice_Status__c' + 
		' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
      	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
      	' AND '+
      	'debit_account__r.name = \'4600\'' +
      	' Group by debit_account__c, id';
		groupedResults = Database.query(query);
		totalWerbekosten = 0;
		
		
		for (AggregateResult ar : groupedResults) {
			if(ar.get('expr0') != null && ar.get('debit_account__c') != null) {
				totalWerbekosten += double.valueOf(ar.get('expr0'));		
			}
		}*/
		//------------------------------
		//Fortbildung
		query = 'SELECT id,sum(Kreditor_Invoice__r.Invoice_amount__c),debit_account__c' +
		' FROM Kreditor_Invoice_Status__c' + 
		' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
      	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
      	' AND '+
      	'debit_account__r.name = \'4945\'' +
      	' Group by debit_account__c, id';
		groupedResults = Database.query(query);
		totalFortbildungskosten = 0;
		
		
		for (AggregateResult ar : groupedResults) {
			if(ar.get('expr0') != null && ar.get('debit_account__c') != null) {
				totalFortbildungskosten += double.valueOf(ar.get('expr0'));		
			}
		}
		// End Fortbildung
		//______________________________ ende wird nicht benutzt -------------------------------------------------------------------------------------------------
		
		
		
		
		totalKostenart = 0.0;
		System.debug('MY DEBUG: '+totalGehaltskosten);
		System.debug('MY DEBUG: '+totalFremdarbeiten);
		System.debug('MY DEBUG: '+totalRaumkosten);
		System.debug('MY DEBUG: '+totalBetrSteuern);
		System.debug('MY DEBUG: '+totalVersichBeitr);
		System.debug('MY DEBUG: '+totalKFZKosten);
		System.debug('MY DEBUG: '+totalWerbekosten);
		System.debug('MY DEBUG: '+totalAbschreibungen);
		System.debug('MY DEBUG: '+totalReparaturKosten);
		System.debug('MY DEBUG: '+totalAndereKosten);
		
		
		totalKostenart = totalGehaltskosten + totalFremdarbeiten + totalRaumkosten + totalBetrSteuern + totalVersichBeitr + totalKFZKosten + totalWerbekosten + totalAbschreibungen + totalReparaturKosten + totalAndereKosten;
				
		totalKostenartStr = ((double)math.round((decimal)(totalKostenart*100))/100).format();
		betriebsErgebnis = totalUmsatzErloese - totalFremdLeistung - totalKostenart + totalSonBetrErloese;
		betriebsErgebnisStr = ((double)math.round((decimal)(betriebsErgebnis*100))/100).format();
		
		totalErgebnisVorSteuern = (betriebsErgebnis - totalZinsaufwand) + totalZinsertrag; 
		
		totalGehaltskostenStr = ((double)math.round((decimal)(totalGehaltskosten*100))/100).format();
		totalFremdarbeitenStr = ((double)math.round((decimal)(totalFremdarbeiten*100))/100).format();
		totalReisekostenStr = ((double)math.round((decimal)(totalReisekosten*100))/100).format();
		totalTilgungStr = ((double)math.round((decimal)(totalTilgung*100))/100).format();
		totalInternetStr = ((double)math.round((decimal)(totalInternet*100))/100).format();
		totalZinsaufwandStr = ((double)math.round((decimal)(totalZinsaufwand*100))/100).format();
		totalZinsertragStr = ((double)math.round((decimal)(totalZinsertrag*100))/100).format();
		//totalZinsenStr = ((double)math.round((decimal)(totalZinsen*100))/100).format();
		//totalWerbekostenStr = ((double)math.round((decimal)(totalWerbekosten*100))/100).format();
		totalAndereKostenStr = ((double)math.round((decimal)(totalAndereKosten*100))/100).format();
		totalFortbildungskostenStr = ((double)math.round((decimal)(totalFortbildungskosten*100))/100).format();
		totalSonBetrErloeseStr = ((double)math.round((decimal)(totalSonBetrErloese*100))/100).format();
		totalBetrRohertragStr = ((double)math.round((decimal)(totalBetrRohertrag*100))/100).format();
		totalSteuernEinkErtrStr = ((double)math.round((decimal)(totalSteuernEinkErtr*100))/100).format();
		totalErgebnisVorSteuernStr = ((double)math.round((decimal)(totalErgebnisVorSteuern*100))/100).format();
		totalAbschreibungenStr = ((double)math.round((decimal)(totalAbschreibungen*100))/100).format();
		
		totalVorlaeufigesErgebnis = totalErgebnisVorSteuern - totalSteuernEinkErtr;
		
		totalVorlaeufigesErgebnisStr = ((double)math.round((decimal)(totalVorlaeufigesErgebnis*100))/100).format();
		
		//neue Werte....
		totalRaumkostenStr = ((double)math.round((decimal)(totalRaumkosten*100))/100).format();
		totalBetrSteuernStr = ((double)math.round((decimal)(totalBetrSteuern*100))/100).format();
		totalVersichBeitrStr = ((double)math.round((decimal)(totalVersichBeitr*100))/100).format();
		totalKFZKostenStr = ((double)math.round((decimal)(totalKFZKosten*100))/100).format();
		totalWerbekostenStr = ((double)math.round((decimal)(totalWerbekosten*100))/100).format();
		totalReparaturKostenStr = ((double)math.round((decimal)(totalReparaturKosten*100))/100).format();
		
		
		if(totalUmsatzErloese != 0) {
			totalFremdLeistungPerc = (totalFremdLeistung/totalUmsatzErloese)*100;
			totalFremdLeistungPercStr = ((double)math.round((decimal)(totalFremdLeistungPerc*100))/100).format() + '%';
			totalRohertragPerc = (totalRohertrag/totalUmsatzErloese)*100;
			totalRohertragPercStr = ((double)math.round((decimal)(totalRohertragPerc*100))/100).format() + '%';
			totalBetrRohertragPerc = (totalBetrRohertrag/totalUmsatzErloese)*100;
			totalBetrRohertragPercStr = ((double)math.round((decimal)(totalBetrRohertragPerc*100))/100).format() + '%';
			totalKostenartPerc = (totalKostenart/totalUmsatzErloese)*100;
			totalKostenartPercStr = ((double)math.round((decimal)(totalKostenartPerc*100))/100).format() + '%';
			betriebsErgebnisPerc = (betriebsErgebnis/totalUmsatzErloese)*100;
			betriebsErgebnisPercStr = ((double)math.round((decimal)(betriebsErgebnisPerc*100))/100).format() + '%';
			
			totalGehaltskostenPerc = (totalGehaltskosten/totalUmsatzErloese)*100;
			totalGehaltskostenPercStr = ((double)math.round((decimal)(totalGehaltskostenPerc*100))/100).format() + '%';
			totalFremdarbeitenPerc = (totalFremdarbeiten/totalUmsatzErloese)*100;
			totalFremdarbeitenPercStr = ((double)math.round((decimal)(totalFremdarbeitenPerc*100))/100).format() + '%';
			totalReisekostenPerc = (totalReisekosten/totalUmsatzErloese)*100;
			totalReisekostenPercStr = ((double)math.round((decimal)(totalReisekostenPerc*100))/100).format() + '%';
			totalTilgungPerc = (totalTilgung/totalUmsatzErloese)*100;
			totalTilgungPercStr = ((double)math.round((decimal)(totalTilgungPerc*100))/100).format() + '%';
			totalInternetPerc = (totalInternet/totalUmsatzErloese)*100;
			totalInternetPercStr = ((double)math.round((decimal)(totalInternetPerc*100))/100).format() + '%';
			totalZinsaufwandPerc = (totalZinsaufwand/totalUmsatzErloese)*100;
			totalZinsaufwandPercStr = ((double)math.round((decimal)(totalZinsaufwandPerc*100))/100).format() + '%';
			totalZinsertragPerc = (totalZinsertrag/totalUmsatzErloese)*100;
			totalZinsertragPercStr = ((double)math.round((decimal)(totalZinsertragPerc*100))/100).format() + '%';
			//totalZinsenPerc = (totalZinsen/totalUmsatzErloese)*100;
			//totalZinsenPercStr = ((double)math.round((decimal)(totalZinsenPerc*100))/100).format() + '%';
			//totalWerbekostenPerc = (totalWerbekosten/totalUmsatzErloese)*100;
			//totalWerbekostenPercStr = ((double)math.round((decimal)(totalWerbekostenPerc*100))/100).format() + '%';
			totalFortbildungskostenPerc = (totalFortbildungskosten/totalUmsatzErloese)*100;
			totalFortbildungskostenPercStr = ((double)math.round((decimal)(totalFortbildungskostenPerc*100))/100).format() + '%';
			
			
			
			//neue Werte....
			totalAbschreibungenPerc =  (totalAbschreibungen/totalUmsatzErloese)*100;
			totalAbschreibungenPercStr = ((double)math.round((decimal)(totalAbschreibungenPerc*100))/100).format() + '%';
			totalAndereKostenPerc = (totalAndereKosten/totalUmsatzErloese)*100;
			totalAndereKostenPercStr = ((double)math.round((decimal)(totalAndereKostenPerc*100))/100).format() + '%';
			totalSonBetrErloesePerc = (totalSonBetrErloese/totalUmsatzErloese)*100;
			totalSonBetrErloesePercStr = ((double)math.round((decimal)(totalSonBetrErloesePerc*100))/100).format() + '%';
			totalSteuernEinkErtrPerc = (totalSteuernEinkErtr/totalUmsatzErloese)*100;
			totalSteuernEinkErtrPercStr = ((double)math.round((decimal)(totalSteuernEinkErtrPerc*100))/100).format() + '%';
			totalErgebnisVorSteuernPerc = (totalErgebnisVorSteuern/totalUmsatzErloese)*100;
			totalErgebnisVorSteuernPercStr = ((double)math.round((decimal)(totalErgebnisVorSteuernPerc*100))/100).format() + '%';
			totalVorlaeufigesErgebnisPerc = (totalVorlaeufigesErgebnis/totalUmsatzErloese)*100;
			totalVorlaeufigesErgebnisPercStr = ((double)math.round((decimal)(totalVorlaeufigesErgebnisPerc*100))/100).format() + '%';
			
			totalRaumkostenPerc = (totalRaumkosten/totalUmsatzErloese)*100;
			totalRaumkostenPercStr = ((double)math.round((decimal)(totalRaumkostenPerc*100))/100).format() + '%';
			totalBetrSteuernPerc = (totalBetrSteuern/totalUmsatzErloese)*100;
			totalBetrSteuernPercStr = ((double)math.round((decimal)(totalBetrSteuernPerc*100))/100).format() + '%';
			totalVersichBeitrPerc = (totalVersichBeitr/totalUmsatzErloese)*100;
			totalVersichBeitrPercStr = ((double)math.round((decimal)(totalVersichBeitrPerc*100))/100).format() + '%';						
			totalKFZKostenPerc = (totalKFZKosten/totalUmsatzErloese)*100;
			totalKFZKostenPercStr = ((double)math.round((decimal)(totalKFZKostenPerc*100))/100).format() + '%';	
			totalWerbekostenPerc = (totalWerbekosten/totalUmsatzErloese)*100;
			totalWerbekostenPercStr = ((double)math.round((decimal)(totalWerbekostenPerc*100))/100).format() + '%';		
			totalReparaturKostenPerc = (totalReparaturKosten/totalUmsatzErloese)*100;
			totalReparaturKostenPercStr = ((double)math.round((decimal)(totalReparaturKostenPerc*100))/100).format() + '%';
					
		} else {
			totalUmsatzErloesePercStr = 'N/A';
			totalFremdLeistungPercStr = 'N/A';
			totalRohertragPercStr = 'N/A';
			totalKostenartPercStr = 'N/A';
			betriebsErgebnisPercStr = 'N/A';
			
			totalGehaltskostenPercStr = 'N/A';
			totalFremdarbeitenPercStr = 'N/A';
			totalReisekostenPercStr = 'N/A';
			totalTilgungPercStr = 'N/A';
			totalInternetPercStr = 'N/A';
			//totalZinsenPercStr = 'N/A';
			totalZinsaufwandPercStr = 'N/A';
			totalZinsertragPercStr = 'N/A';
			//totalWerbekostenPercStr = 'N/A';
			totalAndereKostenPercStr = 'N/A';
			totalFortbildungskostenPercStr = 'N/A';
			totalSonBetrErloesePercStr = 'N/A';
			totalBetrRohertragPercStr = 'N/A';
			totalSteuernEinkErtrPercStr = 'N/A';
			totalErgebnisVorSteuernPercStr = 'N/A';
			totalVorlaeufigesErgebnisPercStr = 'N/A';
			totalAbschreibungenPercStr = 'N/A';
			
			//neue Werte
			totalRaumkostenPercStr = 'N/A';
			totalBetrSteuernPercStr = 'N/A';
			totalVersichBeitrPercStr = 'N/A';
			totalKFZKostenPercStr = 'N/A';
			totalWerbekostenPercStr = 'N/A';
		}
		
		showReport = true;
		
		ChartDataWrapper chartDataUmsatzerloese = new ChartDataWrapper('Umsatzerlöse',totalUmsatzErloeseStr,totalUmsatzErloesePercStr);
		ChartDataWrapper chartDataFremdleistung = new ChartDataWrapper('Fremdleistung',totalFremdLeistungStr,totalFremdLeistungPercStr);
		ChartDataWrapper chartDataRohertrag = new ChartDataWrapper('Rohertrag',totalRohertragStr,totalRohertragPercStr);
		ChartDataWrapper chartDataGesamtkosten = new ChartDataWrapper('Gesamtkosten',totalKostenartStr,totalKostenartPercStr);
		
		ChartDataWrapper chartDataGehaltskosten = new ChartDataWrapper('---Gehalt, Soz. Abgaben, Lohnsteuer',totalGehaltskostenStr,totalGehaltskostenPercStr);
		ChartDataWrapper chartDataFremdarbeiten = new ChartDataWrapper('---Fremdarbeiten nicht Projektb.',totalFremdarbeitenStr,totalFremdarbeitenPercStr);
		ChartDataWrapper chartDataReisekosten = new ChartDataWrapper('---Werbe-/Reisekosten (Bewirtung)',totalReisekostenStr,totalReisekostenPercStr);
		ChartDataWrapper chartDataTilgung = new ChartDataWrapper('---Tilgung (Autos)',totalTilgungStr,totalTilgungPercStr);
		ChartDataWrapper chartDataInternet = new ChartDataWrapper('---Internet und Telefonkosten',totalInternetStr,totalInternetPercStr);
		//ChartDataWrapper chartDataZinsen = new ChartDataWrapper('---Zinsen',totalZinsenStr,totalZinsenPercStr);
		ChartDataWrapper chartDataZinsaufwand = new ChartDataWrapper('Zinsaufwand',totalZinsaufwandStr,totalZinsaufwandPercStr);
		ChartDataWrapper chartDataZinsertrag = new ChartDataWrapper('Zinsertrag',totalZinsertragStr,totalZinsertragPercStr);
		//ChartDataWrapper chartDataWerbekosten = new ChartDataWrapper('---Werbekosten',totalWerbekostenStr,totalWerbekostenPercStr);
		ChartDataWrapper chartDataFortbildungskosten = new ChartDataWrapper('---Fortbildungskosten',totalFortbildungskostenStr,totalFortbildungskostenPercStr);
		ChartDataWrapper chartDataAndereKosten = new ChartDataWrapper('---SonstigeKosten',totalAndereKostenStr,totalAndereKostenPercStr);
		
		ChartDataWrapper chartDataBetriebsergebnis = new ChartDataWrapper('Betriebsergebnis/EBITDA',betriebsErgebnisStr,betriebsErgebnisPercStr);
		ChartDataWrapper chartDataSonBetrErloese = new ChartDataWrapper('Son.betr.Erlöse',totalSonBetrErloeseStr,totalSonBetrErloesePercStr);
		
		ChartDataWrapper chartDataBetrRohertrag = new ChartDataWrapper('Betriebl. Rohertrag',totalBetrRohertragStr,totalBetrRohertragPercStr);
		ChartDataWrapper chartDataSteuernEinkErtr = new ChartDataWrapper('Steuern Eink.u.Ertr.',totalSteuernEinkErtrStr,totalSteuernEinkErtrPercStr);
		ChartDataWrapper chartDataErgebnisVorSteuern = new ChartDataWrapper('Ergebnis vor Steuern',totalErgebnisVorSteuernStr,totalErgebnisVorSteuernPercStr);
		ChartDataWrapper chartDataVorlaeufigesErgebnis = new ChartDataWrapper('Vorläufiges Ergebnis',totalVorlaeufigesErgebnisStr,totalVorlaeufigesErgebnisPercStr);
		ChartDataWrapper chartDataAbschreibungen = new ChartDataWrapper('Abschreibungen',totalAbschreibungenStr,totalAbschreibungenPercStr);
		//neue Werte
		ChartDataWrapper chartDataRaumkosten = new ChartDataWrapper('---Raumkosten',totalRaumkostenStr,totalRaumkostenPercStr);
		ChartDataWrapper chartDataBetrSteuern = new ChartDataWrapper('---Betriebl. Steuern / KfZ-Steuern',totalBetrSteuernStr,totalBetrSteuernPercStr);
		ChartDataWrapper chartDataVersichBeitr = new ChartDataWrapper('---Versich./Beiträge',totalVersichBeitrStr,totalVersichBeitrPercStr);
		ChartDataWrapper chartDataKFZKosten = new ChartDataWrapper('---KfZ-Kosten (o. St.)',totalKFZKostenStr,totalKFZKostenPercStr);
		ChartDataWrapper chartDataWerbekosten = new ChartDataWrapper('---Werbekosten',totalWerbekostenStr,totalWerbekostenPercStr);
		ChartDataWrapper chartDataReparaturkosten = new ChartDataWrapper('---Reparatur/Instandh.',totalReparaturKostenStr,totalReparaturKostenPercStr);
		
		
		listChartData.add(chartDataUmsatzerloese);
		listChartData.add(chartDataFremdleistung);
		listChartData.add(chartDataRohertrag);
		listChartData.add(chartDataSonBetrErloese);
		listChartData.add(chartDataBetrRohertrag);
		listChartData.add(chartDataGesamtkosten);
		listChartData.add(chartDataGehaltskosten);
		listChartData.add(chartDataFremdarbeiten);
		listChartData.add(chartDataRaumkosten);
		listChartData.add(chartDataBetrSteuern);
		listChartData.add(chartDataVersichBeitr);
		listChartData.add(chartDataKFZKosten);
		listChartData.add(chartDataWerbekosten);
		//listChartData.add(chartDataReisekosten);
		//listChartData.add(chartDataFortbildungskosten);
		//listChartData.add(chartDataTilgung);
		//listChartData.add(chartDataInternet);
		listChartData.add(chartDataReparaturkosten);
		listChartData.add(chartDataAndereKosten);
		listChartData.add(chartDataAbschreibungen);
		//listChartData.add(chartDataZinsen);
		//listChartData.add(chartDataWerbekosten);
		listChartData.add(chartDataBetriebsergebnis);
		listChartData.add(chartDataZinsaufwand);
		listChartData.add(chartDataZinsertrag);
		listChartData.add(chartDataErgebnisVorSteuern);
		listChartData.add(chartDataSteuernEinkErtr);
		listChartData.add(chartDataVorlaeufigesErgebnis);
		//chartDataVorlaeufigesErgebnis
		return null;
		//return null;
	}
	
	string padIntegerWithZero(integer i) {
		if(i < 10) {return '0' + string.valueof(i);}
		else {return string.valueof(i);}
	}
	
	private class chartDataWrapper{
		public string rowName{get; set;}
		public string totalValue{get; set;}
		public string totalPercStr{get; set;}

		public chartDataWrapper(
				String rowName,
				String totalValue,
				String totalPercStr
		){
			this.rowName = rowName;
			this.totalValue = totalValue;
			this.totalPercStr = totalPercStr;
		}
	}

 static testMethod void testBWA() {
 
 	
 		/*myBWAController testedPageController;
 		testedPageController = new myBWAController();
    	testedPageController.oppStart.CloseDate = date.valueOf('2012-1-1');
    	testedPageController.oppEnd.CloseDate = date.valueOf('2012-1-31');
    	testedPageController.runReport();*/
 	
    	myBWAController testedPageController;
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
   
    	Chart_of_Accounts__c chartAccount5 = new Chart_of_Accounts__c(
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
    	insert chartAccount7;
    	
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
    	ausgangrech.Invoice_Amount_North__c = 10;
     	ausgangrech.Invoice_Amount_South__c = 0;
     	ausgangrech.Invoice_Amount_Telekom__c = 0;
     	ausgangrech.Invoice_Amount_CCEAG__c = 0;
     	ausgangRech.Invoice_Amount_YOUR_SL__c = 0;
     
     	Kreditor__c eingangRech = new Kreditor__c(Invoice_amount__c = 10, Invoice_date__c = Date.valueof('2012-1-15'), name = '1234', Opportunity__c = opp.id, Invoice_due_on__c = date.today().addDays(30), Invoice_Number__c = '1', VAT_Type__c = '19%', Account__c = opp.AccountId);
		eingangRech.Invoice_Amount_North__c = 10;
     	eingangRech.Invoice_Amount_South__c = 0;
     	eingangRech.Invoice_Amount_Telekom__c = 0;
     	eingangRech.Invoice_Amount_CCEAG__c = 0;
     	eingangRech.Invoice_Amount_YOUR_SL__c = 0;		
     
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
        insert chAcc15;
        insert chAcc16;     
     
		
		insert chAcc3;insert chAcc4;insert chAcc5;insert chAcc6;insert chAcc7;insert chAcc8;insert chAcc9;insert chAcc10;insert chAcc11;
    	insert chAcc12; insert chAcc13;
    	Kreditor_Invoice_Status__c einStatus = new Kreditor_Invoice_Status__c(Kreditor_Invoice__c = eingangRech.id, debit_account__c = coaBuero.Id, credit_account__c = Kasse.Id);
    	insert einStatus;
    	testedPageController = new myBWAController();
    	testedPageController.oppStart.CloseDate = date.valueOf('2012-1-1');
    	testedPageController.oppEnd.CloseDate = date.valueOf('2012-1-31');
    	testedPageController.runReport();
    	test.stopTest();
    }
}