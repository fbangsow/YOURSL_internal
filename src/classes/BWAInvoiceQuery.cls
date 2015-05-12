public class BWAInvoiceQuery {
	
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
    
    public List<ChartDataWrapper> getBWAReport(String bereich, Opportunity oppStart, Opportunity oppEnd){
        
        String bereichInvoiceAmount_Eingangsrech = '';
        String bereichInvoiceAmount_Ausgangsrech = '';
        Double fixAmount_Erloese = 0;
        Double fixAmount_Gehalt = 0;
        if(bereich == 'North'){
            bereichInvoiceAmount_Eingangsrech = 'Invoice_Amount_North__c';
            bereichInvoiceAmount_Ausgangsrech = 'Invoice_Amount_North__c';
        }else if(bereich == 'South'){
            bereichInvoiceAmount_Eingangsrech = 'Invoice_Amount_South__c';
            bereichInvoiceAmount_Ausgangsrech = 'Invoice_Amount_South__c';
        }else if(bereich == 'CCEAG'){
            bereichInvoiceAmount_Eingangsrech = 'Invoice_Amount_CCEAG__c';
            bereichInvoiceAmount_Ausgangsrech = 'Invoice_Amount_CCEAG__c';
        }else if(bereich == 'Telekom'){
            bereichInvoiceAmount_Eingangsrech = 'Invoice_Amount_Telekom__c';
            bereichInvoiceAmount_Ausgangsrech = 'Invoice_Amount_Telekom__c';
            fixAmount_Erloese = 806.06;
            fixAmount_Gehalt = 904.00;
        }else if(bereich == 'YOURSL'){
            bereichInvoiceAmount_Eingangsrech = 'Invoice_Amount_YOUR_SL__c';
            bereichInvoiceAmount_Ausgangsrech = 'Invoice_Amount_YOUR_SL__c';
            fixAmount_Erloese = 806.06;
            fixAmount_Gehalt = 1014.42;
        } else if(bereich == 'Alle'){
            bereichInvoiceAmount_Eingangsrech = 'Invoice_Amount__c';
            bereichInvoiceAmount_Ausgangsrech = 'Invoice_Amount_net__c';
            fixAmount_Erloese = 1612.12;
            fixAmount_Gehalt = 1918.42;
        }
        
        AggregateResult[] groupedResults;
		string query;
		map<id, string> kontorahmenIdToName = new map<id, string>();
		
		if(oppStart.CloseDate >  oppEnd.CloseDate) {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Start date cannot be later than end date'));
			return null;
        }
        
		Integer numberMonth =  (oppEnd.CloseDate.month() - oppStart.CloseDate.month())+1;
		List<ChartDataWrapper> listChartData = new List<ChartDataWrapper>();
        
		String startDateStr = string.valueof(oppStart.CloseDate.year()) + '-' + padIntegerWithZero(oppStart.CloseDate.month()) + '-' + padIntegerWithZero(oppStart.CloseDate.day());
		String endDateStr = string.valueof(oppEnd.CloseDate.year()) + '-' + padIntegerWithZero(oppEnd.CloseDate.month()) + '-' + padIntegerWithZero(oppEnd.CloseDate.day());
		
		//startDateStr = '2012-10-01';
		//endDateStr = '2012-10-31';
		
		//total Ausgangsrechnungs netto (Umsatzerlöse)
		/*query = 'SELECT sum(Invoice_Amount_net__c)' +
				' FROM Debitoren_Rechnung__c' + 
				' WHERE Invoice_date__c >= ' + startDateStr + 
	          	' AND Invoice_date__c <= ' + endDateStr;*/
	    query = 'SELECT sum(Debitor_Invoice__r.' + bereichInvoiceAmount_AusgangsRech + ')' +
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
		query = 'SELECT sum(Debitor_Invoice__r.' + bereichInvoiceAmount_AusgangsRech + ')' +
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
		totalSonBetrErloese += (fixAmount_Erloese * numberMonth);
		
		
		
		
		
		//total Fremdleistung (Eingangsrechnung, soll=3100)
		/*query = 'SELECT sum(Kreditor_Invoice__r.Invoice_amount__c)' +
				' FROM Kreditor_Invoice_Status__c' + 
				' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
	          	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
	          	' AND debit_account__r.name = \'3100\'';*/
	    query = 'SELECT sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + ')' +
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
		query = 'SELECT id,sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech +'),debit_account__c' +
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
		totalGehaltskosten += (fixAmount_Gehalt* numberMonth);
		// end Gehaltskosten
		
		//Fremdarbeit
		query = 'SELECT id,sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + '),debit_account__c' +
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
		query = 'SELECT id,sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + '),debit_account__c' +
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
		
		query = 'SELECT id,sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + '),debit_account__c' +
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
		query = 'SELECT id,sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + '),debit_account__c' +
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
		query = 'SELECT id,sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + '),debit_account__c' +
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
		query = 'SELECT id,sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + '),debit_account__c' +
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
		
		query = 'SELECT id,sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + '),debit_account__c' +
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
		query = 'SELECT id,sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + '),debit_account__c' +
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
		query = 'SELECT id,sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + '),debit_account__c' +
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
		
		query = 'SELECT id,sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + '),debit_account__c' +
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
		
		query = 'SELECT id,sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + '),debit_account__c' +
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
		
		query = 'SELECT id,sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + '),debit_account__c' +
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
		query = 'SELECT id,sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + '),debit_account__c' +
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
		query = 'SELECT id,sum(Kreditor_Invoice__r.'+ bereichInvoiceAmount_EingangsRech + '),debit_account__c' +
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
		query = 'SELECT id,sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + '),debit_account__c' +
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
		query = 'SELECT id,sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + '),debit_account__c' +
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
 
    return listChartData;
    }
    

    
    private string padIntegerWithZero(integer i) {
		if(i < 10) {return '0' + string.valueof(i);}
		else {return string.valueof(i);}
	}
    
    
}