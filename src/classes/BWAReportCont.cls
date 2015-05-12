public with sharing class BWAReportCont {
	
	public boolean showReport{get; set;}
	
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
	
	public BWAReportCont() {
		oppStart = new Opportunity();
		oppEnd = new Opportunity();
		showReport = false;
	}
	
	public pageReference runReport() {
		AggregateResult[] groupedResults;
		string query;
		map<id, string> kontorahmenIdToName = new map<id, string>();
		
		if(oppStart.CloseDate >  oppEnd.CloseDate) {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Start date cannot be later than end date'));
			return null;
		}
		
		startDateStr = string.valueof(oppStart.CloseDate.year()) + '-' + padIntegerWithZero(oppStart.CloseDate.month()) + '-' + padIntegerWithZero(oppStart.CloseDate.day());
		endDateStr = string.valueof(oppEnd.CloseDate.year()) + '-' + padIntegerWithZero(oppEnd.CloseDate.month()) + '-' + padIntegerWithZero(oppEnd.CloseDate.day());
		
		//total Ausgangsrechnungs netto (Umsatzerlöse)
		/*query = 'SELECT sum(Invoice_Amount_net__c)' +
				' FROM Debitoren_Rechnung__c' + 
				' WHERE Invoice_date__c >= ' + startDateStr + 
	          	' AND Invoice_date__c <= ' + endDateStr;*/
	    query = 'SELECT sum(Debitor_Invoice__r.Invoice_amount_net__c)' +
				' FROM Debitor_Invoice_Status__c' + 
				' WHERE Debitor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
	          	' AND Debitor_Invoice__r.Invoice_date__c <= ' + endDateStr +
	          	' AND (debit_account__r.name = \'8601\''+ 
	          	' OR debit_account__r.name = \'8640\''+ 
	          	' OR debit_account__r.name = \'8611\''+
	          	' OR debit_account__r.name = \'8400\''+
	          	' OR debit_account__r.name = \'8338\''+
	          	')';      	
	          	
	          	
		groupedResults = Database.query(query);
		totalUmsatzErloese = double.valueOf(groupedResults[0].get('expr0'));
		if(totalUmsatzErloese == null) {totalUmsatzErloese = 0;}
		totalUmsatzErloeseStr = ((double)math.round((decimal)(totalUmsatzErloese*100))/100).format();
		totalUmsatzErloesePerc = 100.0;
		totalUmsatzErloesePercStr = ((double)math.round((decimal)(totalUmsatzErloesePerc*100))/100).format()+'%';
		
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
	          	' AND (debit_account__r.name = \'3100\' OR debit_account__r.name = \'3400\')';      	
	          	
		groupedResults = Database.query(query);
		totalFremdLeistung = double.valueOf(groupedResults[0].get('expr0'));
		if(totalFremdLeistung == null) {totalFremdLeistung = 0;}
		totalFremdLeistungStr = ((double)math.round((decimal)(totalFremdLeistung*100))/100).format();
		
		totalRohertrag = totalUmsatzErloese-totalFremdLeistung;
		totalRohertragStr = ((double)math.round((decimal)(totalRohertrag*100))/100).format();
		
		//total Kostenarten from Eingangsrechnungeen (Aufwendungen)
		query = 'SELECT id, sum(Kreditor_Invoice__r.Invoice_amount__c), debit_account__c' +
				' FROM Kreditor_Invoice_Status__c' + 
				' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
	          	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
	          	' AND debit_account__r.name != \'3100\'' + 
	          	' Group by debit_account__c, id'; 
		groupedResults = Database.query(query);
		//totalTelefon = 0;
		//totalMiete = 0;
		totalKostenart = 0;
		for (AggregateResult ar : groupedResults) {
			if(ar.get('expr0') != null && ar.get('debit_account__c') != null) {
				totalKostenart += double.valueOf(ar.get('expr0'));
				/*if(kontorahmenIdToName.get(String.valueOf(ar.get('debit_account__c'))) == '4920') {
					totalTelefon += double.valueOf(ar.get('expr0'));
					totalKostenart += double.valueOf(ar.get('expr0'));
				}
				if(kontorahmenIdToName.get(String.valueOf(ar.get('debit_account__c'))) == '4210') {
					totalMiete += double.valueOf(ar.get('expr0'));
					totalKostenart += double.valueOf(ar.get('expr0'));
				}*/
				
			}
		}
		totalKostenartStr = ((double)math.round((decimal)(totalKostenart*100))/100).format();
		betriebsErgebnis = totalUmsatzErloese - totalFremdLeistung - totalKostenart;
		betriebsErgebnisStr = ((double)math.round((decimal)(betriebsErgebnis*100))/100).format();
		
		if(totalUmsatzErloese != 0) {
			totalFremdLeistungPerc = (totalFremdLeistung/totalUmsatzErloese)*100;
			totalFremdLeistungPercStr = ((double)math.round((decimal)(totalFremdLeistungPerc*100))/100).format() + '%';
			totalRohertragPerc = (totalRohertrag/totalUmsatzErloese)*100;
			totalRohertragPercStr = ((double)math.round((decimal)(totalRohertragPerc*100))/100).format() + '%';
			totalKostenartPerc = (totalKostenart/totalUmsatzErloese)*100;
			totalKostenartPercStr = ((double)math.round((decimal)(totalKostenartPerc*100))/100).format() + '%';
			betriebsErgebnisPerc = (betriebsErgebnis/totalUmsatzErloese)*100;
			betriebsErgebnisPercStr = ((double)math.round((decimal)(betriebsErgebnisPerc*100))/100).format() + '%';
		} else {
			totalUmsatzErloesePercStr = 'N/A';
			totalFremdLeistungPercStr = 'N/A';
			totalRohertragPercStr = 'N/A';
			totalKostenartPercStr = 'N/A';
			betriebsErgebnisPercStr = 'N/A';
		}
		
		showReport = true;
		
		return null;
	}
	
	string padIntegerWithZero(integer i) {
		if(i < 10) {return '0' + string.valueof(i);}
		else {return string.valueof(i);}
	}
}