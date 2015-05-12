/* **************************************************************
// Creater: Alexander Faust
// Description: retrieves and sums up all information for Balance Report,including a dynamic visualforce table creation.
				runReport() returns table
// Testclass: BWAReportTest
// Apex Class Access: no limitation
// Last modified by: Chris Sandra Schautt
// Last modified date: 18.06.2014
// Latest changes: 	CSS:18.06.2014: add konto 2150 and 4946 to Sonstige Kosten and 
//									konto 2660 to Sonstige Betriebliche Erlöse
//					AF:22.07.2013: added 3125 to "Fremdleistung";added 4550 to "KFZ Kosten"; added 2310 to "Zinsaufwand";added 2315 to "Zinsertrag"
					07.05.2013 listOfMonth to check if the Month is selected or not if yes, the for this month add fixprice 1612.12
//							for Sonstige betriebliche Erlöse  and add fixprice 224 and 1918,42 for Gehalt.
//					06.05.2013 bei Gehalt Konto 4140 hinzugefuegt,bei Umsatzerloese Konto 8336 hinzugefuegt, bei den Raumkosten Konto 4280 hinzugefuegt
//					bei Versicherung  konto 4380 hinzugefuegt und beim Zinsertrag Konten 1322, 1323 hinzugefuegt
//					22.04.2013 Chris Sandra Schautt multiply Sonstige betriebliche Erlöse with a Fixprice 1612.12
//					12.02.2013 Alexander Faust :streamlined to same accounts/positions as BWA report		
// ************************************************************** */
public with sharing class BalanceController {
    
    public boolean showReport{get; set;}
    
    public class infos {
    	public string rowNameStr{get;set;}
        public string numStr1{get; set;}
        public string percStr1{get; set;}
        public string numStr2{get; set;}
        public string percStr2{get; set;}
        public string numStr3{get; set;}
        public string percStr3{get; set;}
        public string numStr4{get; set;}
        public string percStr4{get; set;}
        public string numStr5{get; set;}
        public string percStr5{get; set;}
        public string numStr6{get; set;}
        public string percStr6{get; set;}
        public string numStr7{get; set;}
        public string percStr7{get; set;}
        public string numStr8{get; set;}
        public string percStr8{get; set;}
        public string numStr9{get; set;}
        public string percStr9{get; set;}
        public string numStr10{get; set;}
        public string percStr10{get; set;}
        public string numStr11{get; set;}
        public string percStr11{get; set;}
        public string numStr12{get; set;}
        public string percStr12{get; set;}
        
        public double num1{get; set;}
        public double perc1{get; set;}
        public double num2{get; set;}
        public double perc2{get; set;}
        public double num3{get; set;}
        public double perc3{get; set;}
        public double num4{get; set;}
        public double perc4{get; set;}
        public double num5{get; set;}
        public double perc5{get; set;}
        public double num6{get; set;}
        public double perc6{get; set;}
        public double num7{get; set;}
        public double perc7{get; set;}
        public double num8{get; set;}
        public double perc8{get; set;}
        public double num9{get; set;}
        public double perc9{get; set;}
        public double num10{get; set;}
        public double perc10{get; set;}
        public double num11{get; set;}
        public double perc11{get; set;}
        public double num12{get; set;}
        public double perc12{get; set;}
        
        public double sumNums{get; set;} 
        public double sumPerc{get; set;}
        public string sumNumsStr{get; set;} 
        public string sumPercStr{get; set;}
        
        public infos() {
        	rowNameStr = '';
            num1 = 0;
            num2 = 0;
            num3 = 0;
            num4 = 0;
            num5 = 0;
            num6 = 0;
            num7 = 0;
            num8 = 0;
            num9 = 0;
            num10 = 0;
            num11 = 0;
            num12 = 0;
            sumNums = 0;
            
            perc1 = 0;
            perc2 = 0;
            perc3 = 0;
            perc4 = 0;
            perc5 = 0;
            perc6 = 0;
            perc7 = 0;
            perc8 = 0;
            perc9 = 0;
            perc10 = 0;
            perc11 = 0;
            perc12 = 0;
            sumPerc = 0;
            
            /*numStr1 = '0';
            numStr2 = '0';
            numStr3 = '0';
            numStr4 = '0';
            numStr5 = '0';
            numStr6 = '0';
            numStr7 = '0';
            numStr8 = '0';
            numStr9 = '0';
            numStr10 = '0';
            numStr11 = '0';
            numStr12 = '0';*/
            
            percStr1 = 'NA';
            percStr2 = 'NA';
            percStr3 = 'NA';
            percStr4 = 'NA';
            percStr5 = 'NA';
            percStr6 = 'NA';
            percStr7 = 'NA';
            percStr8 = 'NA';
            percStr9 = 'NA';
            percStr10 = 'NA';
            percStr11 = 'NA';
            percStr12 = 'NA';
        }
        
        public void updateFields(infos hunderdPerc) {
        	numStr1 = ((double)math.round((decimal)(num1*100))/100).format();
            numStr2 = ((double)math.round((decimal)(num2*100))/100).format();
            numStr3 = ((double)math.round((decimal)(num3*100))/100).format();
            numStr4 = ((double)math.round((decimal)(num4*100))/100).format();
            numStr5 = ((double)math.round((decimal)(num5*100))/100).format();
            numStr6 = ((double)math.round((decimal)(num6*100))/100).format();
            numStr7 = ((double)math.round((decimal)(num7*100))/100).format();
            numStr8 = ((double)math.round((decimal)(num8*100))/100).format();
            numStr9 = ((double)math.round((decimal)(num9*100))/100).format();
            numStr10 = ((double)math.round((decimal)(num10*100))/100).format();
            numStr11 = ((double)math.round((decimal)(num11*100))/100).format();
            numStr12 = ((double)math.round((decimal)(num12*100))/100).format();
            
            sumNums = num1 + num2 + num3 + num4 + num5 + num6 + num7 + num8 + num9 + num10 + num11 + num12; 
            sumNumsStr = ((double)math.round((decimal)(sumNums*100))/100).format();  
            
            if(hunderdPerc.num1 > 0) {this.perc1 = (this.num1/hunderdPerc.num1)*100;}
            if(hunderdPerc.num2 > 0) {this.perc2 = (this.num2/hunderdPerc.num2)*100;}
            if(hunderdPerc.num3 > 0) {this.perc3 = (this.num3/hunderdPerc.num3)*100;}
            if(hunderdPerc.num4 > 0) {this.perc4 = (this.num4/hunderdPerc.num4)*100;}
            if(hunderdPerc.num5 > 0) {this.perc5 = (this.num5/hunderdPerc.num5)*100;}
            if(hunderdPerc.num6 > 0) {this.perc6 = (this.num6/hunderdPerc.num6)*100;}
            if(hunderdPerc.num7 > 0) {this.perc7 = (this.num7/hunderdPerc.num7)*100;}
            if(hunderdPerc.num8 > 0) {this.perc8 = (this.num8/hunderdPerc.num8)*100;}
            if(hunderdPerc.num9 > 0) {this.perc9 = (this.num9/hunderdPerc.num9)*100;}
            if(hunderdPerc.num10 > 0) {this.perc10 = (this.num10/hunderdPerc.num10)*100;}
            if(hunderdPerc.num11 > 0) {this.perc11 = (this.num11/hunderdPerc.num11)*100;}
            if(hunderdPerc.num12 > 0) {this.perc12 = (this.num12/hunderdPerc.num12)*100;}
            
            if(perc1 != 0) {percStr1 = ((double)math.round((decimal)(perc1*100))/100).format() + '%';}
            if(perc2 != 0) {percStr2 = ((double)math.round((decimal)(perc2*100))/100).format() + '%';}
            if(perc3 != 0) {percStr3 = ((double)math.round((decimal)(perc3*100))/100).format() + '%';}
            if(perc4 != 0) {percStr4 = ((double)math.round((decimal)(perc4*100))/100).format() + '%';}
            if(perc5 != 0) {percStr5 = ((double)math.round((decimal)(perc5*100))/100).format() + '%';}
            if(perc6 != 0) {percStr6 = ((double)math.round((decimal)(perc6*100))/100).format() + '%';}
            if(perc7 != 0) {percStr7 = ((double)math.round((decimal)(perc7*100))/100).format() + '%';}
            if(perc8 != 0) {percStr8 = ((double)math.round((decimal)(perc8*100))/100).format() + '%';}
            if(perc9 != 0) {percStr9 = ((double)math.round((decimal)(perc9*100))/100).format() + '%';}
            if(perc10 != 0) {percStr10 = ((double)math.round((decimal)(perc10*100))/100).format() + '%';}
            if(perc11 != 0) {percStr11 = ((double)math.round((decimal)(perc11*100))/100).format() + '%';}
            if(perc12 != 0) {percStr12 = ((double)math.round((decimal)(perc12*100))/100).format() + '%';}
            
            if(hunderdPerc.sumNums > 0) {this.sumPerc = (this.sumNums/hunderdPerc.sumNums)*100;}
            if(sumPerc != 0) {sumPercStr = ((double)math.round((decimal)(sumPerc*100))/100).format() + '%';}
            
        }// end methode updateField
    }// End class info
    
    public infos infoRevenue{get; set;}
    public infos infoThirdParty{get; set;}
    public infos infoMargin{get; set;}
    public infos infoCost{get; set;}
    public infos infoEBITDA{get; set;}
    public infos infoGehaltskosten{get;set;}
    public infos infoFremdarbeiten{get;set;}
    public infos infoReisekosten{get;set;}
    public infos infoTilgung{get;set;}
    public infos infoInternet{get;set;}
    public infos infoZinsen{get;set;}
    public infos infoWerbekosten{get;set;}
    public infos infoAndereKosten{get;set;}
    public infos infoFortbildungskosten{get;set;}
    public infos infoSonBetrErloese{get;set;}
    public infos infoRaumkosten{get;set;}
    public infos infoBetrSteuern{get;set;}
    public infos infoVersichBeitr{get;set;}
    public infos infoKFZKosten{get;set;}
    public infos infoReparaturkosten{get;set;}
    public infos infoAbschreibungen{get;set;}
    public infos infoZinsaufwand{get;set;}
    public infos infoZinsertrag{get;set;}
    public infos infoErgebnisVorSteuern{get;set;}
    public infos infoSteuernEinkErtr{get;set;}
    public infos infoBetrRohertrag{get;set;}
    public infos infoVorlaeufigesErgebnis{get;set;}
    
    public list<infos> infosList{get; set;}

    public opportunity oppStart{get;set;} //used because it has a date field
    public opportunity oppEnd{get;set;} //used because it has a date field
    string startDateStr;
    string endDateStr;
    public List<String> dummyList{get;set;}
    public transient Component.Apex.PageBlockTable table{get;set;}
    
    public BalanceController() {
        oppStart = new Opportunity();
        oppEnd = new Opportunity();
        //oppStart.closeDate = date.valueof('2011-7-1');
        //oppEnd.closeDate = date.valueof('2012-6-30');
        infosList = new List<infos>();
        showReport = false;
        dummyList = new List<String>();
        dummyList.add('bla');
    }
    
    public static Set<integer> getSelectedMonths(Date daStart,Date daEnd){
    	Set<integer> setResult = new Set<Integer>();
    	
    	Integer iMonthsBetweenDates = daStart.monthsBetween(daEnd);
    	
    	for(integer i = daStart.month();i<=daStart.month()+iMonthsBetweenDates;i++){
    		setResult.add(i);
    	}
    	
    	return setResult;
    }
    
    public pageReference runReport() {
        //list<Debitoren_Rechnung__c> ausgangRechs;
        list<Debitor_Invoice_Status__c> ausgangRechs;
        list<Kreditor_Invoice_Status__c> eingangRechStatuses;
        string query;
        list<Kreditor_Invoice_Status__c> listGehaltskosten;
        list<Kreditor_Invoice_Status__c> listFremdarbeiten;
        list<Kreditor_Invoice_Status__c> listReisekosten;
        list<Kreditor_Invoice_Status__c> listTilgung;
        list<Kreditor_Invoice_Status__c> listInternet;
        list<Kreditor_Invoice_Status__c> listZinsen;
        list<Kreditor_Invoice_Status__c> listWerbekosten;
        list<Kreditor_Invoice_Status__c> listAndereKosten;
        list<Kreditor_Invoice_Status__c> listFortbildungskosten;
        
        list<Debitor_Invoice_Status__c> listSonBetrErloese;
        list<Kreditor_Invoice_Status__c> listRaumkosten;
        list<Kreditor_Invoice_Status__c> listBetrSteuern;
        list<Kreditor_Invoice_Status__c> listVersichBeitr;
        list<Kreditor_Invoice_Status__c> listKFZKosten;
        list<Kreditor_Invoice_Status__c> listReparaturkosten;
        list<Kreditor_Invoice_Status__c> listAbschreibungen;
        list<Kreditor_Invoice_Status__c> listZinsaufwand;
        list<Kreditor_Invoice_Status__c> listZinsertrag;
        list<Kreditor_Invoice_Status__c> listErgebnisVorSteuern;
        list<Kreditor_Invoice_Status__c> listSteuernEinkErtr;
        
        
        
        //map<id, string> kontorahmenIdToName = new map<id, string>();
        //list<Chart_of_Accounts__c> kontoRahmens;
        infosList.clear();
        if(oppStart.CloseDate >  oppEnd.CloseDate) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Start date cannot be later than end date'));
            return null;
        }
        
        startDateStr = string.valueof(oppStart.CloseDate.year()) + '-' + padIntegerWithZero(oppStart.CloseDate.month()) + '-' + padIntegerWithZero(oppStart.CloseDate.day());
        endDateStr = string.valueof(oppEnd.CloseDate.year()) + '-' + padIntegerWithZero(oppEnd.CloseDate.month()) + '-' + padIntegerWithZero(oppEnd.CloseDate.day());
        
        /*
            query = 'SELECT Debitor_Invoice__r.Invoice_amount_net__c' +
				' FROM Debitor_Invoice_Status__c' + 
				' WHERE Debitor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
	          	' AND Debitor_Invoice__r.Invoice_date__c <= ' + endDateStr +
	          	' AND (debit_account__r.name = \'8601\''+ 
	          	' OR debit_account__r.name = \'8640\''+ 
	          	' OR debit_account__r.name = \'8611\''+
	          	' OR debit_account__r.name = \'8400\''+
	          	' OR debit_account__r.name = \'8338\''+
	          	');  
	     */
        
        
        /* revenue */
        /*query = 'SELECT Id, Invoice_Amount_net__c, Invoice_date__c ' +
                ' FROM Debitoren_Rechnung__c' + 
                ' WHERE Invoice_date__c >= ' + startDateStr + 
                ' AND Invoice_date__c <= ' + endDateStr;*/
                
        // query Umsatzerloese
        query = 'SELECT Debitor_Invoice__r.Invoice_amount_net__c, Debitor_Invoice__r.Invoice_date__c' +
			' FROM Debitor_Invoice_Status__c' + 
			' WHERE Debitor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
          	' AND Debitor_Invoice__r.Invoice_date__c <= ' + endDateStr +
          	' AND (debit_account__r.name = \'8400\''+
          	' OR debit_account__r.name = \'8338\''+
          	' OR debit_account__r.name = \'8336\''+
			' OR debit_account__r.name = \'8736\''+
          	')';  
	           
                    	
        ausgangRechs = Database.query(query);
        System.debug('My Debug****************** RevenueListSize '+ausgangRechs.size());
        infoRevenue = new infos();
        infoRevenue.rowNameStr = 'Umsatzerlöse';
        //for(Debitoren_Rechnung__c ausgangRech : ausgangRechs) 
        if(ausgangRechs.size()> 0){
        	for(Debitor_Invoice_Status__c ausgangRech : ausgangRechs) {
	            if(ausgangRech.Debitor_Invoice__r.Invoice_date__c.Month() == 1) {
	                infoRevenue.num1 += ausgangRech.Debitor_Invoice__r.Invoice_amount_net__c;
	                infoRevenue.perc1 = 100;
	            }
	            if(ausgangRech.Debitor_Invoice__r.Invoice_date__c.Month() == 2) {
	                infoRevenue.num2 += ausgangRech.Debitor_Invoice__r.Invoice_amount_net__c;
	                infoRevenue.perc2 = 100;
	            }
	            if(ausgangRech.Debitor_Invoice__r.Invoice_date__c.Month() == 3) {
	                infoRevenue.num3 += ausgangRech.Debitor_Invoice__r.Invoice_amount_net__c;
	                infoRevenue.perc3 = 100;
	            }
	            if(ausgangRech.Debitor_Invoice__r.Invoice_date__c.Month() == 4) {
	                infoRevenue.num4 += ausgangRech.Debitor_Invoice__r.Invoice_amount_net__c;
	                infoRevenue.perc4 = 100;
	            }
	            if(ausgangRech.Debitor_Invoice__r.Invoice_date__c.Month() == 5) {
	                infoRevenue.num5 += ausgangRech.Debitor_Invoice__r.Invoice_amount_net__c;
	                infoRevenue.perc5 = 100;
	            }
	            if(ausgangRech.Debitor_Invoice__r.Invoice_date__c.Month() == 6) {
	                infoRevenue.num6 += ausgangRech.Debitor_Invoice__r.Invoice_amount_net__c;
	                infoRevenue.perc6 = 100;
	            }
	            if(ausgangRech.Debitor_Invoice__r.Invoice_date__c.Month() == 7) {
	                infoRevenue.num7 += ausgangRech.Debitor_Invoice__r.Invoice_amount_net__c;
	                infoRevenue.perc7 = 100;
	            }
	            if(ausgangRech.Debitor_Invoice__r.Invoice_date__c.Month() == 8) {
	                infoRevenue.num8 += ausgangRech.Debitor_Invoice__r.Invoice_amount_net__c;
	                infoRevenue.perc8 = 100;
	            }
	            if(ausgangRech.Debitor_Invoice__r.Invoice_date__c.Month() == 9) {
	                infoRevenue.num9 += ausgangRech.Debitor_Invoice__r.Invoice_amount_net__c;
	                infoRevenue.perc9 = 100;
	            }
	            if(ausgangRech.Debitor_Invoice__r.Invoice_date__c.Month() == 10) {
	                infoRevenue.num10 += ausgangRech.Debitor_Invoice__r.Invoice_amount_net__c;
	                infoRevenue.perc10 = 100;
	            }
	            if(ausgangRech.Debitor_Invoice__r.Invoice_date__c.Month() == 11) {
	                infoRevenue.num11 += ausgangRech.Debitor_Invoice__r.Invoice_amount_net__c;
	                infoRevenue.perc11 = 100;
	            }
	            if(ausgangRech.Debitor_Invoice__r.Invoice_date__c.Month() == 12) {
	                infoRevenue.num12 += ausgangRech.Debitor_Invoice__r.Invoice_amount_net__c;
	                infoRevenue.perc12 = 100;
	            }
        	}
        	infoRevenue.updateFields(infoRevenue);
        }//END if(ausgangRechs.size()> 0)
  
         /*End Umsatzerloese */
         
         
        /* Third party service cost */
        // Fremdleistung
        query = 'SELECT id, Kreditor_Invoice__r.Invoice_amount__c, Kreditor_Invoice__r.Invoice_date__c ' +
                ' FROM Kreditor_Invoice_Status__c' + 
                ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
                ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
                ' AND (debit_account__r.name = \'3100\' OR debit_account__r.name = \'3400\' OR debit_account__r.name = \'3125\')';
        eingangRechStatuses = Database.query(query);
        infoThirdParty = new infos();
        infoThirdParty.rowNameStr = 'Fremdleistung';   
        for(Kreditor_Invoice_Status__c eingangRechStatus : eingangRechStatuses) {
            if(eingangRechStatus.Kreditor_Invoice__r.Invoice_date__c.Month() == 1) {
                infoThirdParty.num1 += eingangRechStatus.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(eingangRechStatus.Kreditor_Invoice__r.Invoice_date__c.Month() == 2) {
                infoThirdParty.num2 += eingangRechStatus.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(eingangRechStatus.Kreditor_Invoice__r.Invoice_date__c.Month() == 3) {
                infoThirdParty.num3 += eingangRechStatus.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(eingangRechStatus.Kreditor_Invoice__r.Invoice_date__c.Month() == 4) {
                infoThirdParty.num4 += eingangRechStatus.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(eingangRechStatus.Kreditor_Invoice__r.Invoice_date__c.Month() == 5) {
                infoThirdParty.num5 += eingangRechStatus.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(eingangRechStatus.Kreditor_Invoice__r.Invoice_date__c.Month() == 6) {
                infoThirdParty.num6 += eingangRechStatus.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(eingangRechStatus.Kreditor_Invoice__r.Invoice_date__c.Month() == 7) {
                infoThirdParty.num7 += eingangRechStatus.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(eingangRechStatus.Kreditor_Invoice__r.Invoice_date__c.Month() == 8) {
                infoThirdParty.num8 += eingangRechStatus.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(eingangRechStatus.Kreditor_Invoice__r.Invoice_date__c.Month() == 9) {
                infoThirdParty.num9 += eingangRechStatus.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(eingangRechStatus.Kreditor_Invoice__r.Invoice_date__c.Month() == 10) {
                infoThirdParty.num10 += eingangRechStatus.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(eingangRechStatus.Kreditor_Invoice__r.Invoice_date__c.Month() == 11) {
                infoThirdParty.num11 += eingangRechStatus.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(eingangRechStatus.Kreditor_Invoice__r.Invoice_date__c.Month() == 12) {
                infoThirdParty.num12 += eingangRechStatus.Kreditor_Invoice__r.Invoice_amount__c;
            }
        }
        infoThirdParty.updateFields(infoRevenue);
        //End Fremdleistung
        
        /* margin */
        infoMargin = new infos();
        infoMargin.rowNameStr = 'Rohertrag';   
        infoMargin.num1 = infoRevenue.num1 - infoThirdParty.num1;
        infoMargin.num2 = infoRevenue.num2 - infoThirdParty.num2;
        infoMargin.num3 = infoRevenue.num3 - infoThirdParty.num3;
        infoMargin.num4 = infoRevenue.num4 - infoThirdParty.num4;
        infoMargin.num5 = infoRevenue.num5 - infoThirdParty.num5;
        infoMargin.num6 = infoRevenue.num6 - infoThirdParty.num6;
        infoMargin.num7 = infoRevenue.num7 - infoThirdParty.num7;
        infoMargin.num8 = infoRevenue.num8 - infoThirdParty.num8;
        infoMargin.num9 = infoRevenue.num9 - infoThirdParty.num9;
        infoMargin.num10 = infoRevenue.num10 - infoThirdParty.num10;
        infoMargin.num11 = infoRevenue.num11 - infoThirdParty.num11;
        infoMargin.num12 = infoRevenue.num12 - infoThirdParty.num12;
        infoMargin.updateFields(infoRevenue);
        
        /* costs */
        query = 'SELECT id, Kreditor_Invoice__r.Invoice_amount__c, Kreditor_Invoice__r.Invoice_date__c' +
                ' FROM Kreditor_Invoice_Status__c' + 
                ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
                ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
                ' AND debit_account__r.name != \'3100\'' +
                ' AND debit_account__c != null'+
                ' AND debit_account__r.name != \'1369\''+
                ' AND debit_account__r.name != \'1789\'' +
                ' AND debit_account__r.name != \'1000\'';
                
        eingangRechStatuses = Database.query(query);
        
        /*infoCost = new infos();
        infoCost.rowNameStr = 'Gesamtkosten / Cost';
        for(Kreditor_Invoice_Status__c eingangRechStatus : eingangRechStatuses) {
            if(eingangRechStatus.Kreditor_Invoice__r.Invoice_date__c.Month() == 1) {
                infoCost.num1 += eingangRechStatus.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(eingangRechStatus.Kreditor_Invoice__r.Invoice_date__c.Month() == 2) {
                infoCost.num2 += eingangRechStatus.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(eingangRechStatus.Kreditor_Invoice__r.Invoice_date__c.Month() == 3) {
                infoCost.num3 += eingangRechStatus.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(eingangRechStatus.Kreditor_Invoice__r.Invoice_date__c.Month() == 4) {
                infoCost.num4 += eingangRechStatus.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(eingangRechStatus.Kreditor_Invoice__r.Invoice_date__c.Month() == 5) {
                infoCost.num5 += eingangRechStatus.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(eingangRechStatus.Kreditor_Invoice__r.Invoice_date__c.Month() == 6) {
                infoCost.num6 += eingangRechStatus.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(eingangRechStatus.Kreditor_Invoice__r.Invoice_date__c.Month() == 7) {
                infoCost.num7 += eingangRechStatus.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(eingangRechStatus.Kreditor_Invoice__r.Invoice_date__c.Month() == 8) {
                infoCost.num8 += eingangRechStatus.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(eingangRechStatus.Kreditor_Invoice__r.Invoice_date__c.Month() == 9) {
                infoCost.num9 += eingangRechStatus.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(eingangRechStatus.Kreditor_Invoice__r.Invoice_date__c.Month() == 10) {
                infoCost.num10 += eingangRechStatus.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(eingangRechStatus.Kreditor_Invoice__r.Invoice_date__c.Month() == 11) {
                infoCost.num11 += eingangRechStatus.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(eingangRechStatus.Kreditor_Invoice__r.Invoice_date__c.Month() == 12) {
                infoCost.num12 += eingangRechStatus.Kreditor_Invoice__r.Invoice_amount__c;
            }
        }
        infoCost.updateFields(infoRevenue);*/
        
        /*Gehaltskosten*/
                     
        query = 'SELECT id,Kreditor_Invoice__r.Invoice_amount__c,debit_account__c,Kreditor_Invoice__r.Invoice_date__c' +
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
      	' ) ';
		listGehaltskosten = Database.query(query);
		//double totalGehaltskosten = 0;
		
		 
		infoGehaltskosten = new infos();
		infoGehaltskosten.rowNameStr = '---Gehalt, Soz. Abgaben, Lohnsteuer';
		//totalGehaltskosten = double.valueOf(groupedResults[0].get('expr0'));
		for(Kreditor_Invoice_Status__c gehaltskosten : listGehaltskosten) {
            if(gehaltskosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 1) {
                infoGehaltskosten.num1 += gehaltskosten.Kreditor_Invoice__r.Invoice_amount__c;

            }
            if(gehaltskosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 2) {
                infoGehaltskosten.num2 += gehaltskosten.Kreditor_Invoice__r.Invoice_amount__c;

            }
            if(gehaltskosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 3) {
                infoGehaltskosten.num3 += gehaltskosten.Kreditor_Invoice__r.Invoice_amount__c;

            }
            if(gehaltskosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 4) {
                infoGehaltskosten.num4 += gehaltskosten.Kreditor_Invoice__r.Invoice_amount__c;

            }
            if(gehaltskosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 5) {
                infoGehaltskosten.num5 += gehaltskosten.Kreditor_Invoice__r.Invoice_amount__c;

            }
            if(gehaltskosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 6) {
                infoGehaltskosten.num6 += gehaltskosten.Kreditor_Invoice__r.Invoice_amount__c;

            }
            if(gehaltskosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 7) {
                infoGehaltskosten.num7 += gehaltskosten.Kreditor_Invoice__r.Invoice_amount__c;

            }
            if(gehaltskosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 8) {
                infoGehaltskosten.num8 += gehaltskosten.Kreditor_Invoice__r.Invoice_amount__c;
               
            }
            if(gehaltskosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 9) {
                infoGehaltskosten.num9 += gehaltskosten.Kreditor_Invoice__r.Invoice_amount__c;

            }
            if(gehaltskosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 10) {
                infoGehaltskosten.num10 += gehaltskosten.Kreditor_Invoice__r.Invoice_amount__c;
                
            }
            if(gehaltskosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 11) {
                infoGehaltskosten.num11 += gehaltskosten.Kreditor_Invoice__r.Invoice_amount__c;
                
            }
            if(gehaltskosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 12) {
                infoGehaltskosten.num12 += gehaltskosten.Kreditor_Invoice__r.Invoice_amount__c;
                
            }
        }
        
        
      //  ------------------------------------------------------------------------------------------------------------
		List<Integer> listOfMonth = new List<integer>();
		for(Integer i = oppStart.CloseDate.month(); i<=oppEnd.CloseDate.month();i++){
				listOfMonth.add(i);
		}
		for(Integer i = 0; i<listOfMonth.size(); i++){
		      if(listOfMonth[i]==1){
		        
		        infoGehaltskosten.num1 += 1918.42;
		      }// end if(listOfMonth[i]==1)
		      else if(listOfMonth[i]==2){
		        
		        infoGehaltskosten.num2 += 1918.42;
		      }// end if(listOfMonth[i]==2)
		      else if(listOfMonth[i]==3){
		        
		        infoGehaltskosten.num3 += 1918.42;
		      }// end if(listOfMonth[i]==3)
		      else if(listOfMonth[i]==4){
		        
		        infoGehaltskosten.num4 += 1918.42;
		      }// end if(listOfMonth[i]==4)
		      else if(listOfMonth[i]==5){
		        
		        infoGehaltskosten.num5 += 1918.42;
		      }// end if(listOfMonth[i]==5)
		      else if(listOfMonth[i]==6){
		       
		        infoGehaltskosten.num6 += 1918.42;
		      }// end if(listOfMonth[i]==6)
		      else if(listOfMonth[i]==7){
		       
		        infoGehaltskosten.num7 += 1918.42;
		      }// end if(listOfMonth[i]==7)
		      else if(listOfMonth[i]==8){
		       
		        infoGehaltskosten.num8 += 1918.42;
		      }// end if(listOfMonth[i]==8)
		      else if(listOfMonth[i]==9){
		        
		        infoGehaltskosten.num9 += 1918.42;
		      }// end if(listOfMonth[i]==9)
		      else if(listOfMonth[i]==10){
		        infoGehaltskosten.num10 += 224.0;
		        infoGehaltskosten.num10 += 1918.42;
		      }// end if(listOfMonth[i]==10)
		      else if(listOfMonth[i]==11){
		        
		        infoGehaltskosten.num11 += 1918.42;
		      }// end if(listOfMonth[i]==11)
		      else if(listOfMonth[i]==12){
		       
		        infoGehaltskosten.num12 += 1918.42;
		      }// end if(listOfMonth[i]==12)
		}// End for(Integer i = 0; i<listOfMonth.size(); i++)
        infoGehaltskosten.updateFields(infoRevenue);
        // End Gehaltskosten
        
        /*Fremdarbeiten*/
        query = 'SELECT id,Kreditor_Invoice__r.Invoice_amount__c,debit_account__c,Kreditor_Invoice__r.Invoice_date__c' +
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
      	' )';
      	
		listFremdarbeiten = Database.query(query);
        
        infoFremdarbeiten = new infos();
		infoFremdarbeiten.rowNameStr = '---Fremdarbeiten nicht Projektb.';
		
		for(Kreditor_Invoice_Status__c fremdarbeiten : listFremdarbeiten) {
            if(fremdarbeiten.Kreditor_Invoice__r.Invoice_date__c.Month() == 1) {
                infoFremdarbeiten.num1 += fremdarbeiten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(fremdarbeiten.Kreditor_Invoice__r.Invoice_date__c.Month() == 2) {
                infoFremdarbeiten.num2 += fremdarbeiten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(fremdarbeiten.Kreditor_Invoice__r.Invoice_date__c.Month() == 3) {
                infoFremdarbeiten.num3 += fremdarbeiten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(fremdarbeiten.Kreditor_Invoice__r.Invoice_date__c.Month() == 4) {
                infoFremdarbeiten.num4 += fremdarbeiten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(fremdarbeiten.Kreditor_Invoice__r.Invoice_date__c.Month() == 5) {
                infoFremdarbeiten.num5 += fremdarbeiten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(fremdarbeiten.Kreditor_Invoice__r.Invoice_date__c.Month() == 6) {
                infoFremdarbeiten.num6 += fremdarbeiten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(fremdarbeiten.Kreditor_Invoice__r.Invoice_date__c.Month() == 7) {
                infoFremdarbeiten.num7 += fremdarbeiten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(fremdarbeiten.Kreditor_Invoice__r.Invoice_date__c.Month() == 8) {
                infoFremdarbeiten.num8 += fremdarbeiten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(fremdarbeiten.Kreditor_Invoice__r.Invoice_date__c.Month() == 9) {
                infoFremdarbeiten.num9 += fremdarbeiten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(fremdarbeiten.Kreditor_Invoice__r.Invoice_date__c.Month() == 10) {
                infoFremdarbeiten.num10 += fremdarbeiten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(fremdarbeiten.Kreditor_Invoice__r.Invoice_date__c.Month() == 11) {
                infoFremdarbeiten.num11 += fremdarbeiten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(fremdarbeiten.Kreditor_Invoice__r.Invoice_date__c.Month() == 12) {
                infoFremdarbeiten.num12 += fremdarbeiten.Kreditor_Invoice__r.Invoice_amount__c;
            }
        }
        infoFremdarbeiten.updateFields(infoRevenue);
        // End Fremdarbeit
        /*Reisekosten
        query = 'SELECT id,Kreditor_Invoice__r.Invoice_amount__c,debit_account__c,Kreditor_Invoice__r.Invoice_date__c' +
		' FROM Kreditor_Invoice_Status__c' + 
		' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
      	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
      	' AND '+
      	'(debit_account__r.name = \'4640\'' +
      	' OR debit_account__r.name = \'4660\''+
      	' OR debit_account__r.name = \'4662\''+  
      	' OR debit_account__r.name = \'4663\''+
      	' OR debit_account__r.name = \'4664\''+
      	' OR debit_account__r.name = \'4650\''+
      	' OR debit_account__r.name = \'4666\''+
      	' )';
		listReisekosten = Database.query(query);
		
		infoReisekosten = new infos();
		infoReisekosten.rowNameStr = '---Reisekosten';
		
		for(Kreditor_Invoice_Status__c reisekosten : listReisekosten) {
            if(reisekosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 1) {
                infoReisekosten.num1 += reisekosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(reisekosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 2) {
                infoReisekosten.num2 += reisekosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(reisekosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 3) {
                infoReisekosten.num3 += reisekosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(reisekosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 4) {
                infoReisekosten.num4 += reisekosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(reisekosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 5) {
                infoReisekosten.num5 += reisekosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(reisekosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 6) {
                infoReisekosten.num6 += reisekosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(reisekosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 7) {
                infoReisekosten.num7 += reisekosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(reisekosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 8) {
                infoReisekosten.num8 += reisekosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(reisekosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 9) {
                infoReisekosten.num9 += reisekosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(reisekosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 10) {
                infoReisekosten.num10 += reisekosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(reisekosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 11) {
                infoReisekosten.num11 += reisekosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(reisekosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 12) {
                infoReisekosten.num12 += reisekosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
        }
        infoReisekosten.updateFields(infoRevenue);*/
        
        /*Tilgung
        query = 'SELECT id,Kreditor_Invoice__r.Invoice_amount__c,debit_account__c,Kreditor_Invoice__r.Invoice_date__c' +
		' FROM Kreditor_Invoice_Status__c' + 
		' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
      	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
      	' AND '+
      	'(debit_account__r.name = \'0640\'' +
      	' OR debit_account__r.name = \'0641\''+ 
      	' )';
		listTilgung = Database.query(query);
		
        infoTilgung = new infos();
		infoTilgung.rowNameStr = '---Tilgung';
		
		for(Kreditor_Invoice_Status__c tilgung : listTilgung) {
            if(tilgung.Kreditor_Invoice__r.Invoice_date__c.Month() == 1) {
                infoTilgung.num1 += tilgung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(tilgung.Kreditor_Invoice__r.Invoice_date__c.Month() == 2) {
                infoTilgung.num2 += tilgung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(tilgung.Kreditor_Invoice__r.Invoice_date__c.Month() == 3) {
                infoTilgung.num3 += tilgung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(tilgung.Kreditor_Invoice__r.Invoice_date__c.Month() == 4) {
                infoTilgung.num4 += tilgung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(tilgung.Kreditor_Invoice__r.Invoice_date__c.Month() == 5) {
                infoTilgung.num5 += tilgung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(tilgung.Kreditor_Invoice__r.Invoice_date__c.Month() == 6) {
                infoTilgung.num6 += tilgung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(tilgung.Kreditor_Invoice__r.Invoice_date__c.Month() == 7) {
                infoTilgung.num7 += tilgung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(tilgung.Kreditor_Invoice__r.Invoice_date__c.Month() == 8) {
                infoTilgung.num8 += tilgung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(tilgung.Kreditor_Invoice__r.Invoice_date__c.Month() == 9) {
                infoTilgung.num9 += tilgung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(tilgung.Kreditor_Invoice__r.Invoice_date__c.Month() == 10) {
                infoTilgung.num10 += tilgung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(tilgung.Kreditor_Invoice__r.Invoice_date__c.Month() == 11) {
                infoTilgung.num11 += tilgung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(tilgung.Kreditor_Invoice__r.Invoice_date__c.Month() == 12) {
                infoTilgung.num12 += tilgung.Kreditor_Invoice__r.Invoice_amount__c;
            }
        }
        infoTilgung.updateFields(infoRevenue);*/
        /*Fortbildungskosten
        
        
        query = 'SELECT id,Kreditor_Invoice__r.Invoice_amount__c,debit_account__c,Kreditor_Invoice__r.Invoice_date__c' +
		' FROM Kreditor_Invoice_Status__c' + 
		' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
      	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
      	' AND '+
      	' debit_account__r.name = \'4945\'' +
      	'';
		listFortbildungskosten = Database.query(query);
        
        infoFortbildungskosten = new infos();
		infoFortbildungskosten.rowNameStr = '---Fortbildungskosten';
		
		for(Kreditor_Invoice_Status__c fortbildung : listFortbildungskosten) {
            if(fortbildung.Kreditor_Invoice__r.Invoice_date__c.Month() == 1) {
                infoFortbildungskosten.num1 += fortbildung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(fortbildung.Kreditor_Invoice__r.Invoice_date__c.Month() == 2) {
                infoFortbildungskosten.num2 += fortbildung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(fortbildung.Kreditor_Invoice__r.Invoice_date__c.Month() == 3) {
                infoFortbildungskosten.num3 += fortbildung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(fortbildung.Kreditor_Invoice__r.Invoice_date__c.Month() == 4) {
                infoFortbildungskosten.num4 += fortbildung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(fortbildung.Kreditor_Invoice__r.Invoice_date__c.Month() == 5) {
                infoFortbildungskosten.num5 += fortbildung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(fortbildung.Kreditor_Invoice__r.Invoice_date__c.Month() == 6) {
                infoFortbildungskosten.num6 += fortbildung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(fortbildung.Kreditor_Invoice__r.Invoice_date__c.Month() == 7) {
                infoFortbildungskosten.num7 += fortbildung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(fortbildung.Kreditor_Invoice__r.Invoice_date__c.Month() == 8) {
                infoFortbildungskosten.num8 += fortbildung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(fortbildung.Kreditor_Invoice__r.Invoice_date__c.Month() == 9) {
                infoFortbildungskosten.num9 += fortbildung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(fortbildung.Kreditor_Invoice__r.Invoice_date__c.Month() == 10) {
                infoFortbildungskosten.num10 += fortbildung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(fortbildung.Kreditor_Invoice__r.Invoice_date__c.Month() == 11) {
                infoFortbildungskosten.num11 += fortbildung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(fortbildung.Kreditor_Invoice__r.Invoice_date__c.Month() == 12) {
                infoFortbildungskosten.num12 += fortbildung.Kreditor_Invoice__r.Invoice_amount__c;
            }
        }
        infoFortbildungskosten.updateFields(infoRevenue);*/
        
        /*Internet
        query = 'SELECT id,Kreditor_Invoice__r.Invoice_amount__c,debit_account__c,Kreditor_Invoice__r.Invoice_date__c' +
		' FROM Kreditor_Invoice_Status__c' + 
		' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
      	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
      	' AND '+
      	'(debit_account__r.name = \'4920\'' +
      	' OR debit_account__r.name = \'4921\''+
      	' OR debit_account__r.name = \'4925\''+  
      	' )';
		listInternet = Database.query(query);
        
        infoInternet = new infos();
		infoInternet.rowNameStr = '---Internet';
		
		for(Kreditor_Invoice_Status__c internet : listInternet) {
            if(internet.Kreditor_Invoice__r.Invoice_date__c.Month() == 1) {
                infoInternet.num1 += internet.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(internet.Kreditor_Invoice__r.Invoice_date__c.Month() == 2) {
                infoInternet.num2 += internet.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(internet.Kreditor_Invoice__r.Invoice_date__c.Month() == 3) {
                infoInternet.num3 += internet.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(internet.Kreditor_Invoice__r.Invoice_date__c.Month() == 4) {
                infoInternet.num4 += internet.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(internet.Kreditor_Invoice__r.Invoice_date__c.Month() == 5) {
                infoInternet.num5 += internet.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(internet.Kreditor_Invoice__r.Invoice_date__c.Month() == 6) {
                infoInternet.num6 += internet.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(internet.Kreditor_Invoice__r.Invoice_date__c.Month() == 7) {
                infoInternet.num7 += internet.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(internet.Kreditor_Invoice__r.Invoice_date__c.Month() == 8) {
                infoInternet.num8 += internet.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(internet.Kreditor_Invoice__r.Invoice_date__c.Month() == 9) {
                infoInternet.num9 += internet.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(internet.Kreditor_Invoice__r.Invoice_date__c.Month() == 10) {
                infoInternet.num10 += internet.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(internet.Kreditor_Invoice__r.Invoice_date__c.Month() == 11) {
                infoInternet.num11 += internet.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(internet.Kreditor_Invoice__r.Invoice_date__c.Month() == 12) {
                infoInternet.num12 += internet.Kreditor_Invoice__r.Invoice_amount__c;
            }
        }
        infoInternet.updateFields(infoRevenue);*/
        
        
        /*Zinsen
        query = 'SELECT id,Kreditor_Invoice__r.Invoice_amount__c,debit_account__c,Kreditor_Invoice__r.Invoice_date__c' +
		' FROM Kreditor_Invoice_Status__c' + 
		' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
      	' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
      	' AND '+
      	'(debit_account__r.name = \'2110\'' +
      	' OR debit_account__r.name = \'2120\''+
      	' OR debit_account__r.name = \'2493\''+
      	' OR debit_account__r.name = \'2650\''+    
      	' )';
		listZinsen = Database.query(query);
        
        infoZinsen = new infos();
		infoZinsen.rowNameStr = '---Zinsen';
		
		for(Kreditor_Invoice_Status__c zinsen : listZinsen) {
            if(zinsen.Kreditor_Invoice__r.Invoice_date__c.Month() == 1) {
                infoZinsen.num1 += zinsen.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(zinsen.Kreditor_Invoice__r.Invoice_date__c.Month() == 2) {
                infoZinsen.num2 += zinsen.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(zinsen.Kreditor_Invoice__r.Invoice_date__c.Month() == 3) {
                infoZinsen.num3 += zinsen.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(zinsen.Kreditor_Invoice__r.Invoice_date__c.Month() == 4) {
                infoZinsen.num4 += zinsen.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(zinsen.Kreditor_Invoice__r.Invoice_date__c.Month() == 5) {
                infoZinsen.num5 += zinsen.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(zinsen.Kreditor_Invoice__r.Invoice_date__c.Month() == 6) {
                infoZinsen.num6 += zinsen.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(zinsen.Kreditor_Invoice__r.Invoice_date__c.Month() == 7) {
                infoZinsen.num7 += zinsen.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(zinsen.Kreditor_Invoice__r.Invoice_date__c.Month() == 8) {
                infoZinsen.num8 += zinsen.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(zinsen.Kreditor_Invoice__r.Invoice_date__c.Month() == 9) {
                infoZinsen.num9 += zinsen.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(zinsen.Kreditor_Invoice__r.Invoice_date__c.Month() == 10) {
                infoZinsen.num10 += zinsen.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(zinsen.Kreditor_Invoice__r.Invoice_date__c.Month() == 11) {
                infoZinsen.num11 += zinsen.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(zinsen.Kreditor_Invoice__r.Invoice_date__c.Month() == 12) {
                infoZinsen.num12 += zinsen.Kreditor_Invoice__r.Invoice_amount__c;
            }
        }
        infoZinsen.updateFields(infoRevenue);*/
        
        
        /*Werbekosten-/Reisekosten*/
        query = 'SELECT id,Kreditor_Invoice__r.Invoice_amount__c,debit_account__c,Kreditor_Invoice__r.Invoice_date__c' +
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
      	')';
      	
		listWerbekosten = Database.query(query);
        
        infoWerbekosten = new infos();
		infoWerbekosten.rowNameStr = '---Werbekosten';
		
		for(Kreditor_Invoice_Status__c werbekosten : listWerbekosten) {
            if(werbekosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 1) {
                infoWerbekosten.num1 += werbekosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(werbekosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 2) {
                infoWerbekosten.num2 += werbekosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(werbekosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 3) {
                infoWerbekosten.num3 += werbekosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(werbekosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 4) {
                infoWerbekosten.num4 += werbekosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(werbekosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 5) {
                infoWerbekosten.num5 += werbekosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(werbekosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 6) {
                infoWerbekosten.num6 += werbekosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(werbekosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 7) {
                infoWerbekosten.num7 += werbekosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(werbekosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 8) {
                infoWerbekosten.num8 += werbekosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(werbekosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 9) {
                infoWerbekosten.num9 += werbekosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(werbekosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 10) {
                infoWerbekosten.num10 += werbekosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(werbekosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 11) {
                infoWerbekosten.num11 += werbekosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(werbekosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 12) {
                infoWerbekosten.num12 += werbekosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
        }
        infoWerbekosten.updateFields(infoRevenue);
        /* End Werbekosten-/Reisekosten*/
        
        /*Sonstige Betriebliche Erlöse*/
        
        query = 'SELECT Debitor_Invoice__r.Invoice_amount_net__c, Debitor_Invoice__r.Invoice_date__c' +
				' FROM Debitor_Invoice_Status__c' + + 
				' WHERE Debitor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
	          	' AND Debitor_Invoice__r.Invoice_date__c <= ' + endDateStr +
	          	' AND (debit_account__r.name = \'8601\''+            	
	          	' OR debit_account__r.name = \'8640\''+
	          	' OR debit_account__r.name = \'2660\''+
	          	')';      	
		listSonBetrErloese = Database.query(query);
        
        infoSonBetrErloese = new infos();
		infoSonBetrErloese.rowNameStr = 'Sonstige betriebliche Erlöse';
		
		for(Debitor_Invoice_Status__c sonBetrErloese : listSonBetrErloese) {
            if(sonBetrErloese.Debitor_Invoice__r.Invoice_date__c.Month() == 1) {
                infoSonBetrErloese.num1 += sonBetrErloese.Debitor_Invoice__r.Invoice_amount_net__c;
            }
            if(sonBetrErloese.Debitor_Invoice__r.Invoice_date__c.Month() == 2) {
                infoSonBetrErloese.num2 += sonBetrErloese.Debitor_Invoice__r.Invoice_amount_net__c;
            }
            if(sonBetrErloese.Debitor_Invoice__r.Invoice_date__c.Month() == 3) {
                infoSonBetrErloese.num3 += sonBetrErloese.Debitor_Invoice__r.Invoice_amount_net__c;
            }
            if(sonBetrErloese.Debitor_Invoice__r.Invoice_date__c.Month() == 4) {
                infoSonBetrErloese.num4 += sonBetrErloese.Debitor_Invoice__r.Invoice_amount_net__c;
            }
            if(sonBetrErloese.Debitor_Invoice__r.Invoice_date__c.Month() == 5) {
                infoSonBetrErloese.num5 += sonBetrErloese.Debitor_Invoice__r.Invoice_amount_net__c;
            }
            if(sonBetrErloese.Debitor_Invoice__r.Invoice_date__c.Month() == 6) {
                infoSonBetrErloese.num6 += sonBetrErloese.Debitor_Invoice__r.Invoice_amount_net__c;
            }
            if(sonBetrErloese.Debitor_Invoice__r.Invoice_date__c.Month() == 7) {
                infoSonBetrErloese.num7 += sonBetrErloese.Debitor_Invoice__r.Invoice_amount_net__c;
            }
            if(sonBetrErloese.Debitor_Invoice__r.Invoice_date__c.Month() == 8) {
                infoSonBetrErloese.num8 += sonBetrErloese.Debitor_Invoice__r.Invoice_amount_net__c;
            }
            if(sonBetrErloese.Debitor_Invoice__r.Invoice_date__c.Month() == 9) {
                infoSonBetrErloese.num9 += sonBetrErloese.Debitor_Invoice__r.Invoice_amount_net__c;
            }
            if(sonBetrErloese.Debitor_Invoice__r.Invoice_date__c.Month() == 10) {
                infoSonBetrErloese.num10 += sonBetrErloese.Debitor_Invoice__r.Invoice_amount_net__c;
            }
            if(sonBetrErloese.Debitor_Invoice__r.Invoice_date__c.Month() == 11) {
                infoSonBetrErloese.num11 += sonBetrErloese.Debitor_Invoice__r.Invoice_amount_net__c;
            }
            if(sonBetrErloese.Debitor_Invoice__r.Invoice_date__c.Month() == 12) {
                infoSonBetrErloese.num12 += sonBetrErloese.Debitor_Invoice__r.Invoice_amount_net__c;
            }
        }
        
        //+ fester Betrag 1612,12€
        for(Integer i = 0; i<listOfMonth.size(); i++){
		        if(listOfMonth[i]==1){
		        	infoSonBetrErloese.num1 += 1612.12;
		        }// end if(listOfMonth[i]==1)
		        else if(listOfMonth[i]==2){
		        	infoSonBetrErloese.num2 += 1612.12;
		        }// end  else if(listOfMonth[i]==2)
		        else if(listOfMonth[i]==3){
		        	infoSonBetrErloese.num3 += 1612.12;
		        }// end else if(listOfMonth[i]==3)
		         else if(listOfMonth[i]==4){
		        	infoSonBetrErloese.num4 += 1612.12;
		        }// end  else if(listOfMonth[i]==4)
		         else if(listOfMonth[i]==5){
		        	infoSonBetrErloese.num5 += 1612.12;
		        }// end  else if(listOfMonth[i]==1)
		         else if(listOfMonth[i]==6){
		        	infoSonBetrErloese.num6 += 1612.12;
		        }// end  else if(listOfMonth[i]==6)
		         else if(listOfMonth[i]==7){
		        	infoSonBetrErloese.num7 += 1612.12;
		        }// end  else if(listOfMonth[i]==7)
		         else if(listOfMonth[i]==8){
		        	infoSonBetrErloese.num8 += 1612.12;
		        }// end  else if(listOfMonth[i]==8)
		         else if(listOfMonth[i]==9){
		        	infoSonBetrErloese.num9 += 1612.12;
		        }// end  else if(listOfMonth[i]==9)
		         else if(listOfMonth[i]==10){
		        	infoSonBetrErloese.num10 += 1612.12;
		        }// end  else if(listOfMonth[i]==10)
		         else if(listOfMonth[i]==11){
		        	infoSonBetrErloese.num11 += 1612.12;
		        }// end  else if(listOfMonth[i]==11)
		         else if(listOfMonth[i]==12){
		        	infoSonBetrErloese.num12 += 1612.12;
		        }// end  else if(listOfMonth[i]==1)
        }// End for(Integer i = 0; i<listOfMonth.size(); i++)
        infoSonBetrErloese.updateFields(infoRevenue);
        
        
        /*END Sonstige Betriebliche Erlöse*/
        
        
 
        /*Raumkosten*/
        query = 'SELECT id, Kreditor_Invoice__r.Invoice_amount__c, Kreditor_Invoice__r.Invoice_date__c ' +
                ' FROM Kreditor_Invoice_Status__c' + 
                ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
                ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
                ' AND (debit_account__r.name = \'4210\''+
                ' OR debit_account__r.name = \'4240\''+
                ' OR debit_account__r.name = \'4250\''+
                ' OR debit_account__r.name = \'4260\''+
                ' OR debit_account__r.name = \'4280\''+
                ')';
                
        listRaumkosten = Database.query(query);
        infoRaumkosten = new infos();
        infoRaumkosten.rowNameStr = '---Raumkosten';   
        for(Kreditor_Invoice_Status__c raumkosten : listRaumkosten) {
            if(raumkosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 1) {
                infoRaumkosten.num1 += raumkosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(raumkosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 2) {
                infoRaumkosten.num2 += raumkosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(raumkosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 3) {
                infoRaumkosten.num3 += raumkosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(raumkosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 4) {
                infoRaumkosten.num4 += raumkosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(raumkosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 5) {
                infoRaumkosten.num5 += raumkosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(raumkosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 6) {
                infoRaumkosten.num6 += raumkosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(raumkosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 7) {
                infoRaumkosten.num7 += raumkosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(raumkosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 8) {
                infoRaumkosten.num8 += raumkosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(raumkosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 9) {
                infoRaumkosten.num9 += raumkosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(raumkosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 10) {
                infoRaumkosten.num10 += raumkosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(raumkosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 11) {
                infoRaumkosten.num11 += raumkosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(raumkosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 12) {
                infoRaumkosten.num12 += raumkosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
        }
        infoRaumkosten.updateFields(infoRevenue);
        /*END Raumkosten*/
        
        /*Betriebliche Steuern*/
        
        query = 'SELECT id, Kreditor_Invoice__r.Invoice_amount__c, Kreditor_Invoice__r.Invoice_date__c ' +
                ' FROM Kreditor_Invoice_Status__c' + 
                ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
                ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
                ' AND (debit_account__r.name = \'4510\' OR debit_account__r.name = \'4550\')';
                
        listBetrSteuern = Database.query(query);
        infoBetrSteuern = new infos();
        infoBetrSteuern.rowNameStr = '---Betriebliche Steuern / KfZ Steuern';   
        for(Kreditor_Invoice_Status__c betrSteuern : listBetrSteuern) {
            if(betrSteuern.Kreditor_Invoice__r.Invoice_date__c.Month() == 1) {
                infoBetrSteuern.num1 += betrSteuern.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(betrSteuern.Kreditor_Invoice__r.Invoice_date__c.Month() == 2) {
                infoBetrSteuern.num2 += betrSteuern.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(betrSteuern.Kreditor_Invoice__r.Invoice_date__c.Month() == 3) {
                infoBetrSteuern.num3 += betrSteuern.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(betrSteuern.Kreditor_Invoice__r.Invoice_date__c.Month() == 4) {
                infoBetrSteuern.num4 += betrSteuern.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(betrSteuern.Kreditor_Invoice__r.Invoice_date__c.Month() == 5) {
                infoBetrSteuern.num5 += betrSteuern.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(betrSteuern.Kreditor_Invoice__r.Invoice_date__c.Month() == 6) {
                infoBetrSteuern.num6 += betrSteuern.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(betrSteuern.Kreditor_Invoice__r.Invoice_date__c.Month() == 7) {
                infoBetrSteuern.num7 += betrSteuern.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(betrSteuern.Kreditor_Invoice__r.Invoice_date__c.Month() == 8) {
                infoBetrSteuern.num8 += betrSteuern.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(betrSteuern.Kreditor_Invoice__r.Invoice_date__c.Month() == 9) {
                infoBetrSteuern.num9 += betrSteuern.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(betrSteuern.Kreditor_Invoice__r.Invoice_date__c.Month() == 10) {
                infoBetrSteuern.num10 += betrSteuern.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(betrSteuern.Kreditor_Invoice__r.Invoice_date__c.Month() == 11) {
                infoBetrSteuern.num11 += betrSteuern.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(betrSteuern.Kreditor_Invoice__r.Invoice_date__c.Month() == 12) {
                infoBetrSteuern.num12 += betrSteuern.Kreditor_Invoice__r.Invoice_amount__c;
            }
        }
        infoBetrSteuern.updateFields(infoRevenue);
        
        /*END Betriebliche Steuern*/
        
        /*Versicherungs Beiträge*/
        
        query = 'SELECT id, Kreditor_Invoice__r.Invoice_amount__c, Kreditor_Invoice__r.Invoice_date__c ' +
                ' FROM Kreditor_Invoice_Status__c' + 
                ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
                ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
                ' AND (debit_account__r.name = \'4360\'' +
      			' OR debit_account__r.name = \'4380\''+ 
      			' OR debit_account__r.name = \'4390\''+
      			' )';
                
        listVersichBeitr = Database.query(query);
        infoVersichBeitr = new infos();
        infoVersichBeitr.rowNameStr = '---Versich./Beiträge';   
        for(Kreditor_Invoice_Status__c versichBeitr : listVersichBeitr) {
            if(versichBeitr.Kreditor_Invoice__r.Invoice_date__c.Month() == 1) {
                infoversichBeitr.num1 += versichBeitr.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(versichBeitr.Kreditor_Invoice__r.Invoice_date__c.Month() == 2) {
                infoversichBeitr.num2 += versichBeitr.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(versichBeitr.Kreditor_Invoice__r.Invoice_date__c.Month() == 3) {
                infoversichBeitr.num3 += versichBeitr.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(versichBeitr.Kreditor_Invoice__r.Invoice_date__c.Month() == 4) {
                infoversichBeitr.num4 += versichBeitr.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(versichBeitr.Kreditor_Invoice__r.Invoice_date__c.Month() == 5) {
                infoversichBeitr.num5 += versichBeitr.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(versichBeitr.Kreditor_Invoice__r.Invoice_date__c.Month() == 6) {
                infoversichBeitr.num6 += versichBeitr.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(versichBeitr.Kreditor_Invoice__r.Invoice_date__c.Month() == 7) {
                infoversichBeitr.num7 += versichBeitr.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(versichBeitr.Kreditor_Invoice__r.Invoice_date__c.Month() == 8) {
                infoversichBeitr.num8 += versichBeitr.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(versichBeitr.Kreditor_Invoice__r.Invoice_date__c.Month() == 9) {
                infoversichBeitr.num9 += versichBeitr.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(versichBeitr.Kreditor_Invoice__r.Invoice_date__c.Month() == 10) {
                infoversichBeitr.num10 += versichBeitr.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(versichBeitr.Kreditor_Invoice__r.Invoice_date__c.Month() == 11) {
                infoversichBeitr.num11 += versichBeitr.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(versichBeitr.Kreditor_Invoice__r.Invoice_date__c.Month() == 12) {
                infoversichBeitr.num12 += versichBeitr.Kreditor_Invoice__r.Invoice_amount__c;
            }
        }
        infoversichBeitr.updateFields(infoRevenue);
        
        /*END Versicherungs Beiträge*/
        
        /* KFZ Kosten*/
        
        query = 'SELECT id, Kreditor_Invoice__r.Invoice_amount__c, Kreditor_Invoice__r.Invoice_date__c ' +
                ' FROM Kreditor_Invoice_Status__c' + 
                ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
                ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
                ' AND (debit_account__r.name = \'4530\'' +
      			' OR debit_account__r.name = \'4540\''+ 
      			' OR debit_account__r.name = \'4580\''+
      			' OR debit_account__r.name = \'4595\''+
				' OR debit_account__r.name = \'4520\''+
				' OR debit_account__r.name = \'4532\''+
				' OR debit_account__r.name = \'4570\''+
      			' )';
      	
        listKFZKosten = Database.query(query);
        infoKFZKosten = new infos();
        infoKFZKosten.rowNameStr = '---KfZ-Kosten (o. St.)';   
        for(Kreditor_Invoice_Status__c KFZKosten : listKFZKosten) {
            if(KFZKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 1) {
                infoKFZKosten.num1 += KFZKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(KFZKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 2) {
                infoKFZKosten.num2 += KFZKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(KFZKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 3) {
                infoKFZKosten.num3 += KFZKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(KFZKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 4) {
                infoKFZKosten.num4 += KFZKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(KFZKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 5) {
                infoKFZKosten.num5 += KFZKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(KFZKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 6) {
                infoKFZKosten.num6 += KFZKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(KFZKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 7) {
                infoKFZKosten.num7 += KFZKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(KFZKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 8) {
                infoKFZKosten.num8 += KFZKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(KFZKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 9) {
                infoKFZKosten.num9 += KFZKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(KFZKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 10) {
                infoKFZKosten.num10 += KFZKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(KFZKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 11) {
                infoKFZKosten.num11 += KFZKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(KFZKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 12) {
                infoKFZKosten.num12 += KFZKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
        }
        infoKFZKosten.updateFields(infoRevenue);
        
        /* END KFZ Kosten*/
        
        /*Reparaturkosten*/
        
        query = 'SELECT id, Kreditor_Invoice__r.Invoice_amount__c, Kreditor_Invoice__r.Invoice_date__c ' +
                ' FROM Kreditor_Invoice_Status__c' + 
                ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
                ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
                ' AND (debit_account__r.name = \'4805\'' +
      			' OR debit_account__r.name = \'4806\''+ 
      			' )';
           	
        listReparaturkosten = Database.query(query);
        infoReparaturkosten = new infos();
        infoReparaturkosten.rowNameStr = '---Reparatur/Instandh.';   
        for(Kreditor_Invoice_Status__c ReparaturKosten : listReparaturkosten) {
            if(ReparaturKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 1) {
                infoReparaturKosten.num1 += ReparaturKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(ReparaturKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 2) {
                infoReparaturKosten.num2 += ReparaturKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(ReparaturKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 3) {
                infoReparaturKosten.num3 += ReparaturKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(ReparaturKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 4) {
                infoReparaturKosten.num4 += ReparaturKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(ReparaturKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 5) {
                infoReparaturKosten.num5 += ReparaturKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(ReparaturKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 6) {
                infoReparaturKosten.num6 += ReparaturKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(ReparaturKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 7) {
                infoReparaturKosten.num7 += ReparaturKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(ReparaturKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 8) {
                infoReparaturKosten.num8 += ReparaturKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(ReparaturKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 9) {
                infoReparaturKosten.num9 += ReparaturKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(ReparaturKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 10) {
                infoReparaturKosten.num10 += ReparaturKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(ReparaturKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 11) {
                infoReparaturKosten.num11 += ReparaturKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(ReparaturKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 12) {
                infoReparaturKosten.num12 += ReparaturKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
        }
        infoReparaturKosten.updateFields(infoRevenue);
        
        /*END Reparaturkosten*/
        /*Abschreibungen*/
        
        query = 'SELECT id, Kreditor_Invoice__r.Invoice_amount__c, Kreditor_Invoice__r.Invoice_date__c ' +
                ' FROM Kreditor_Invoice_Status__c' + 
                ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
                ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
                ' AND (debit_account__r.name = \'4822\'' +
      			' OR debit_account__r.name = \'4830\''+ 
      			' OR debit_account__r.name = \'4832\''+
      			' OR debit_account__r.name = \'4855\''+
      			' OR debit_account__r.name = \'4862\''+
      			' OR debit_account__r.name = \'4877\''+
      			' )';
           	
        listAbschreibungen = Database.query(query);
        infoAbschreibungen = new infos();
        infoAbschreibungen.rowNameStr = 'Abschreibungen';   
        for(Kreditor_Invoice_Status__c Abschreibung : listAbschreibungen) {
            if(Abschreibung.Kreditor_Invoice__r.Invoice_date__c.Month() == 1) {
                infoAbschreibungen.num1 += Abschreibung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(Abschreibung.Kreditor_Invoice__r.Invoice_date__c.Month() == 2) {
                infoAbschreibungen.num2 += Abschreibung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(Abschreibung.Kreditor_Invoice__r.Invoice_date__c.Month() == 3) {
                infoAbschreibungen.num3 += Abschreibung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(Abschreibung.Kreditor_Invoice__r.Invoice_date__c.Month() == 4) {
                infoAbschreibungen.num4 += Abschreibung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(Abschreibung.Kreditor_Invoice__r.Invoice_date__c.Month() == 5) {
                infoAbschreibungen.num5 += Abschreibung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(Abschreibung.Kreditor_Invoice__r.Invoice_date__c.Month() == 6) {
                infoAbschreibungen.num6 += Abschreibung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(Abschreibung.Kreditor_Invoice__r.Invoice_date__c.Month() == 7) {
                infoAbschreibungen.num7 += Abschreibung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(Abschreibung.Kreditor_Invoice__r.Invoice_date__c.Month() == 8) {
                infoAbschreibungen.num8 += Abschreibung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(Abschreibung.Kreditor_Invoice__r.Invoice_date__c.Month() == 9) {
                infoAbschreibungen.num9 += Abschreibung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(Abschreibung.Kreditor_Invoice__r.Invoice_date__c.Month() == 10) {
                infoAbschreibungen.num10 += Abschreibung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(Abschreibung.Kreditor_Invoice__r.Invoice_date__c.Month() == 11) {
                infoAbschreibungen.num11 += Abschreibung.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(Abschreibung.Kreditor_Invoice__r.Invoice_date__c.Month() == 12) {
                infoAbschreibungen.num12 += Abschreibung.Kreditor_Invoice__r.Invoice_amount__c;
            }
        }
        infoAbschreibungen.updateFields(infoRevenue);
        
        /* END Abschreibungen */
        
        /* Zinsaufwand */
        
        query = 'SELECT id, Kreditor_Invoice__r.Invoice_amount__c, Kreditor_Invoice__r.Invoice_date__c ' +
                ' FROM Kreditor_Invoice_Status__c' + 
                ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
                ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
                ' AND (debit_account__r.name = \'2110\'' +
      			' OR debit_account__r.name = \'2120\''+ 
      			' OR debit_account__r.name = \'2020\''+
      			' OR debit_account__r.name = \'2493\''+
      			' OR debit_account__r.name = \'2382\''+       		
      			' OR debit_account__r.name = \'2310\''+
      			' )';
           	
        listZinsaufwand = Database.query(query);
        infoZinsaufwand = new infos();
        infoZinsaufwand.rowNameStr = 'Zinsaufwand';   
        for(Kreditor_Invoice_Status__c Zinsaufwand : listZinsaufwand) {
            if(Zinsaufwand.Kreditor_Invoice__r.Invoice_date__c.Month() == 1) {
                infoZinsaufwand.num1 += Zinsaufwand.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(Zinsaufwand.Kreditor_Invoice__r.Invoice_date__c.Month() == 2) {
                infoZinsaufwand.num2 += Zinsaufwand.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(Zinsaufwand.Kreditor_Invoice__r.Invoice_date__c.Month() == 3) {
                infoZinsaufwand.num3 += Zinsaufwand.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(Zinsaufwand.Kreditor_Invoice__r.Invoice_date__c.Month() == 4) {
                infoZinsaufwand.num4 += Zinsaufwand.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(Zinsaufwand.Kreditor_Invoice__r.Invoice_date__c.Month() == 5) {
                infoZinsaufwand.num5 += Zinsaufwand.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(Zinsaufwand.Kreditor_Invoice__r.Invoice_date__c.Month() == 6) {
                infoZinsaufwand.num6 += Zinsaufwand.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(Zinsaufwand.Kreditor_Invoice__r.Invoice_date__c.Month() == 7) {
                infoZinsaufwand.num7 += Zinsaufwand.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(Zinsaufwand.Kreditor_Invoice__r.Invoice_date__c.Month() == 8) {
                infoZinsaufwand.num8 += Zinsaufwand.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(Zinsaufwand.Kreditor_Invoice__r.Invoice_date__c.Month() == 9) {
                infoZinsaufwand.num9 += Zinsaufwand.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(Zinsaufwand.Kreditor_Invoice__r.Invoice_date__c.Month() == 10) {
                infoZinsaufwand.num10 += Zinsaufwand.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(Zinsaufwand.Kreditor_Invoice__r.Invoice_date__c.Month() == 11) {
                infoZinsaufwand.num11 += Zinsaufwand.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(Zinsaufwand.Kreditor_Invoice__r.Invoice_date__c.Month() == 12) {
                infoZinsaufwand.num12 += Zinsaufwand.Kreditor_Invoice__r.Invoice_amount__c;
            }
        }
        infoZinsaufwand.updateFields(infoRevenue);
        
        /* END Zinsaufwand */
        
        /*Zinsertrag*/
        
        
        query = 'SELECT id, Kreditor_Invoice__r.Invoice_amount__c, Kreditor_Invoice__r.Invoice_date__c ' +
                ' FROM Kreditor_Invoice_Status__c' + 
                ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
                ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
                ' AND (debit_account__r.name = \'2650\'' +
      			' OR debit_account__r.name = \'2749\''+ 
      			' OR debit_account__r.name = \'2501\''+
      			' OR debit_account__r.name = \'1322\''+ 
      			' OR debit_account__r.name = \'1323\''+  
      			' OR debit_account__r.name = \'2742\''+      		
      			' OR debit_account__r.name = \'2315\''+
      			' )';
      			
           	
        listZinsertrag = Database.query(query);
        infoZinsertrag = new infos();
        infoZinsertrag.rowNameStr = 'Zinsertrag'; 
        
        for(Kreditor_Invoice_Status__c Zinsertrag : listZinsertrag) {
            if(Zinsertrag.Kreditor_Invoice__r.Invoice_date__c.Month() == 1) {
                infoZinsertrag.num1 += Zinsertrag.Kreditor_Invoice__r.Invoice_amount__c; 
            }
            if(Zinsertrag.Kreditor_Invoice__r.Invoice_date__c.Month() == 2) {
                infoZinsertrag.num2 += Zinsertrag.Kreditor_Invoice__r.Invoice_amount__c; 
            }
            if(Zinsertrag.Kreditor_Invoice__r.Invoice_date__c.Month() == 3) {
                infoZinsertrag.num3 += Zinsertrag.Kreditor_Invoice__r.Invoice_amount__c; 
            }
            if(Zinsertrag.Kreditor_Invoice__r.Invoice_date__c.Month() == 4) {
                infoZinsertrag.num4 += Zinsertrag.Kreditor_Invoice__r.Invoice_amount__c; 
            }
            if(Zinsertrag.Kreditor_Invoice__r.Invoice_date__c.Month() == 5) {
                infoZinsertrag.num5 += Zinsertrag.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(Zinsertrag.Kreditor_Invoice__r.Invoice_date__c.Month() == 6) {
                infoZinsertrag.num6 += Zinsertrag.Kreditor_Invoice__r.Invoice_amount__c; 
            }
            if(Zinsertrag.Kreditor_Invoice__r.Invoice_date__c.Month() == 7) {
                infoZinsertrag.num7 += Zinsertrag.Kreditor_Invoice__r.Invoice_amount__c; 
            }
            if(Zinsertrag.Kreditor_Invoice__r.Invoice_date__c.Month() == 8) {
                infoZinsertrag.num8 += Zinsertrag.Kreditor_Invoice__r.Invoice_amount__c; 
            }
            if(Zinsertrag.Kreditor_Invoice__r.Invoice_date__c.Month() == 9) {
                infoZinsertrag.num9 += Zinsertrag.Kreditor_Invoice__r.Invoice_amount__c; 
            }
            if(Zinsertrag.Kreditor_Invoice__r.Invoice_date__c.Month() == 10) {
                infoZinsertrag.num10 += Zinsertrag.Kreditor_Invoice__r.Invoice_amount__c; 
            }
            if(Zinsertrag.Kreditor_Invoice__r.Invoice_date__c.Month() == 11) {
                infoZinsertrag.num11 += Zinsertrag.Kreditor_Invoice__r.Invoice_amount__c; 
            }
            if(Zinsertrag.Kreditor_Invoice__r.Invoice_date__c.Month() == 12) {
                infoZinsertrag.num12 += Zinsertrag.Kreditor_Invoice__r.Invoice_amount__c; 
            }
        }
        
        if(infoZinsertrag.num1 < 0){
        	infoZinsertrag.num1 = (-1)* infoZinsertrag.num1;
        }
        if(infoZinsertrag.num2 < 0){
        	infoZinsertrag.num2 = (-1)* infoZinsertrag.num2;
        }
        if(infoZinsertrag.num3 < 0){
        	infoZinsertrag.num3 = (-1)* infoZinsertrag.num3;
        }
        if(infoZinsertrag.num4 < 0){
        	infoZinsertrag.num4 = (-1)* infoZinsertrag.num4;
        }
        if(infoZinsertrag.num5 < 0){
        	infoZinsertrag.num5 = (-1)* infoZinsertrag.num5;
        }
        if(infoZinsertrag.num6 < 0){
        	infoZinsertrag.num6 = (-1)* infoZinsertrag.num6;
        }
        if(infoZinsertrag.num7 < 0){
        	infoZinsertrag.num7 = (-1)* infoZinsertrag.num7;
        }
        if(infoZinsertrag.num8 < 0){
        	infoZinsertrag.num8 = (-1)* infoZinsertrag.num8;
        }
        if(infoZinsertrag.num9 < 0){
        	infoZinsertrag.num9 = (-1)* infoZinsertrag.num9;
        }
        if(infoZinsertrag.num10 < 0){
        	infoZinsertrag.num10 = (-1)* infoZinsertrag.num10;
        }
        if(infoZinsertrag.num11 < 0){
        	infoZinsertrag.num11 = (-1)* infoZinsertrag.num11;
        }
        if(infoZinsertrag.num12 < 0){
        	infoZinsertrag.num12 = (-1)* infoZinsertrag.num12;
        }
        
        infoZinsertrag.updateFields(infoRevenue);
        
        
        /* END Zinsertrag*/
        
        /* SteuernEinkErtr */
        
        query = 'SELECT id, Kreditor_Invoice__r.Invoice_amount__c, Kreditor_Invoice__r.Invoice_date__c ' +
                ' FROM Kreditor_Invoice_Status__c' + 
                ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
                ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
                ' AND (debit_account__r.name = \'2213\'' +
      			' OR debit_account__r.name = \'2216\''+       			    		
      			' )';
           	
        listSteuernEinkErtr = Database.query(query);
        infoSteuernEinkErtr = new infos();
        infoSteuernEinkErtr.rowNameStr = 'Steuern Eink.u.Ertr.';   
        for(Kreditor_Invoice_Status__c  SteuernEinkErtr: listSteuernEinkErtr) {
            if(SteuernEinkErtr.Kreditor_Invoice__r.Invoice_date__c.Month() == 1) {
                infoSteuernEinkErtr.num1 += SteuernEinkErtr.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(SteuernEinkErtr.Kreditor_Invoice__r.Invoice_date__c.Month() == 2) {
                infoSteuernEinkErtr.num2 += SteuernEinkErtr.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(SteuernEinkErtr.Kreditor_Invoice__r.Invoice_date__c.Month() == 3) {
                infoSteuernEinkErtr.num3 += SteuernEinkErtr.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(SteuernEinkErtr.Kreditor_Invoice__r.Invoice_date__c.Month() == 4) {
                infoSteuernEinkErtr.num4 += SteuernEinkErtr.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(SteuernEinkErtr.Kreditor_Invoice__r.Invoice_date__c.Month() == 5) {
                infoSteuernEinkErtr.num5 += SteuernEinkErtr.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(SteuernEinkErtr.Kreditor_Invoice__r.Invoice_date__c.Month() == 6) {
                infoSteuernEinkErtr.num6 += SteuernEinkErtr.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(SteuernEinkErtr.Kreditor_Invoice__r.Invoice_date__c.Month() == 7) {
                infoSteuernEinkErtr.num7 += SteuernEinkErtr.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(SteuernEinkErtr.Kreditor_Invoice__r.Invoice_date__c.Month() == 8) {
                infoSteuernEinkErtr.num8 += SteuernEinkErtr.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(SteuernEinkErtr.Kreditor_Invoice__r.Invoice_date__c.Month() == 9) {
                infoSteuernEinkErtr.num9 += SteuernEinkErtr.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(SteuernEinkErtr.Kreditor_Invoice__r.Invoice_date__c.Month() == 10) {
                infoSteuernEinkErtr.num10 += SteuernEinkErtr.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(SteuernEinkErtr.Kreditor_Invoice__r.Invoice_date__c.Month() == 11) {
                infoSteuernEinkErtr.num11 += SteuernEinkErtr.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(SteuernEinkErtr.Kreditor_Invoice__r.Invoice_date__c.Month() == 12) {
                infoSteuernEinkErtr.num12 += SteuernEinkErtr.Kreditor_Invoice__r.Invoice_amount__c;
            }
        }
        infoSteuernEinkErtr.updateFields(infoRevenue);
        
        
        /* END SteuernEinkErtr */
  
        /*Andere Kosten, (Sonstige Kosten)*/
        query = 'SELECT id,Kreditor_Invoice__r.Invoice_amount__c,debit_account__c,Kreditor_Invoice__r.Invoice_date__c' +
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
      	')';
		listAndereKosten = Database.query(query);
        
        
        infoAndereKosten = new infos();
		infoAndereKosten.rowNameStr = '---Andere Kosten';
		
		for(Kreditor_Invoice_Status__c andereKosten : listAndereKosten) {
            if(andereKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 1) {
                infoAndereKosten.num1 += andereKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(andereKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 2) {
                infoAndereKosten.num2 += andereKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(andereKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 3) {
                infoAndereKosten.num3 += andereKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(andereKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 4) {
                infoAndereKosten.num4 += andereKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(andereKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 5) {
                infoAndereKosten.num5 += andereKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(andereKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 6) {
                infoAndereKosten.num6 += andereKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(andereKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 7) {
                infoAndereKosten.num7 += andereKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(andereKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 8) {
                infoAndereKosten.num8 += andereKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(andereKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 9) {
                infoAndereKosten.num9 += andereKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(andereKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 10) {
                infoAndereKosten.num10 += andereKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(andereKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 11) {
                infoAndereKosten.num11 += andereKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
            if(andereKosten.Kreditor_Invoice__r.Invoice_date__c.Month() == 12) {
                infoAndereKosten.num12 += andereKosten.Kreditor_Invoice__r.Invoice_amount__c;
            }
        }
        infoAndereKosten.updateFields(infoRevenue);
        
        /*Gesamtkosten*/
        //totalKostenart = totalGehaltskosten + totalFremdarbeiten + totalRaumkosten + totalBetrSteuern + totalVersichBeitr + totalKFZKosten + totalWerbekosten + totalAbschreibungen + totalReparaturKosten + totalAndereKosten;
        infoCost = new infos();
        infoCost.rowNameStr = 'Gesamtkosten';
        infoCost.num1 = infoGehaltskosten.num1 + infoFremdarbeiten.num1 + infoRaumkosten.num1 + infoBetrSteuern.num1 + infoVersichBeitr.num1 + infoKFZKosten.num1 + infoWerbekosten.num1 + infoReparaturKosten.num1 + infoAndereKosten.num1;
        infoCost.num2 = infoGehaltskosten.num2 + infoFremdarbeiten.num2 + infoRaumkosten.num2 + infoBetrSteuern.num2 + infoVersichBeitr.num2 + infoKFZKosten.num2 + infoWerbekosten.num2 + infoReparaturKosten.num2 + infoAndereKosten.num2;
        infoCost.num3 = infoGehaltskosten.num3 + infoFremdarbeiten.num3 + infoRaumkosten.num3 + infoBetrSteuern.num3 + infoVersichBeitr.num3 + infoKFZKosten.num3 + infoWerbekosten.num3 + infoReparaturKosten.num3 + infoAndereKosten.num3;
        infoCost.num4 = infoGehaltskosten.num4 + infoFremdarbeiten.num4 + infoRaumkosten.num4 + infoBetrSteuern.num4 + infoVersichBeitr.num4 + infoKFZKosten.num4 + infoWerbekosten.num4 + infoReparaturKosten.num4 + infoAndereKosten.num4;
        infoCost.num5 = infoGehaltskosten.num5 + infoFremdarbeiten.num5 + infoRaumkosten.num5 + infoBetrSteuern.num5 + infoVersichBeitr.num5 + infoKFZKosten.num5 + infoWerbekosten.num5 + infoReparaturKosten.num5 + infoAndereKosten.num5;
        infoCost.num6 = infoGehaltskosten.num6 + infoFremdarbeiten.num6 + infoRaumkosten.num6 + infoBetrSteuern.num6 + infoVersichBeitr.num6 + infoKFZKosten.num6 + infoWerbekosten.num6 + infoReparaturKosten.num6 + infoAndereKosten.num6;
        infoCost.num7 = infoGehaltskosten.num7 + infoFremdarbeiten.num7 + infoRaumkosten.num7 + infoBetrSteuern.num7 + infoVersichBeitr.num7 + infoKFZKosten.num7 + infoWerbekosten.num7 + infoReparaturKosten.num7 + infoAndereKosten.num7;
        infoCost.num8 = infoGehaltskosten.num8 + infoFremdarbeiten.num8 + infoRaumkosten.num8 + infoBetrSteuern.num8 + infoVersichBeitr.num8 + infoKFZKosten.num8 + infoWerbekosten.num8 + infoReparaturKosten.num8 + infoAndereKosten.num8;
        infoCost.num9 = infoGehaltskosten.num9 + infoFremdarbeiten.num9 + infoRaumkosten.num9 + infoBetrSteuern.num9 + infoVersichBeitr.num9 + infoKFZKosten.num9 + infoWerbekosten.num9 + infoReparaturKosten.num9 + infoAndereKosten.num9;
        infoCost.num10 = infoGehaltskosten.num10 + infoFremdarbeiten.num10 + infoRaumkosten.num10 + infoBetrSteuern.num10 + infoVersichBeitr.num10 + infoKFZKosten.num10 + infoWerbekosten.num10 + infoReparaturKosten.num10 + infoAndereKosten.num10;
        infoCost.num11 = infoGehaltskosten.num11 + infoFremdarbeiten.num11 + infoRaumkosten.num11 + infoBetrSteuern.num11 + infoVersichBeitr.num11 + infoKFZKosten.num11 + infoWerbekosten.num11 + infoReparaturKosten.num11 + infoAndereKosten.num11;
        infoCost.num12 = infoGehaltskosten.num12 + infoFremdarbeiten.num12 + infoRaumkosten.num12 + infoBetrSteuern.num12 + infoVersichBeitr.num12 + infoKFZKosten.num12 + infoWerbekosten.num12 + infoReparaturKosten.num12 + infoAndereKosten.num12;
        infoCost.updateFields(infoRevenue);
        
        /*END Gesamtkosten*/
    
        
        /* EBITDA */
        infoEBITDA = new infos();
        infoEBITDA.rowNameStr = 'Betriebsergebnis / EBITDA';
        infoEBITDA.num1 = infoRevenue.num1 - infoThirdParty.num1 - infoCost.num1 + infoSonBetrErloese.num1;
        infoEBITDA.num2 = infoRevenue.num2 - infoThirdParty.num2 - infoCost.num2 + infoSonBetrErloese.num2;
        infoEBITDA.num3 = infoRevenue.num3 - infoThirdParty.num3 - infoCost.num3 + infoSonBetrErloese.num3;
        infoEBITDA.num4 = infoRevenue.num4 - infoThirdParty.num4 - infoCost.num4 + infoSonBetrErloese.num4;
        infoEBITDA.num5 = infoRevenue.num5 - infoThirdParty.num5 - infoCost.num5 + infoSonBetrErloese.num5;
        infoEBITDA.num6 = infoRevenue.num6 - infoThirdParty.num6 - infoCost.num6 + infoSonBetrErloese.num6;
        infoEBITDA.num7 = infoRevenue.num7 - infoThirdParty.num7 - infoCost.num7 + infoSonBetrErloese.num7;
        infoEBITDA.num8 = infoRevenue.num8 - infoThirdParty.num8 - infoCost.num8 + infoSonBetrErloese.num8;
        infoEBITDA.num9 = infoRevenue.num9 - infoThirdParty.num9 - infoCost.num9 + infoSonBetrErloese.num9;
        infoEBITDA.num10 = infoRevenue.num10 - infoThirdParty.num10 - infoCost.num10 + infoSonBetrErloese.num10;
        infoEBITDA.num11 = infoRevenue.num11 - infoThirdParty.num11 - infoCost.num11 + infoSonBetrErloese.num11;
        infoEBITDA.num12 = infoRevenue.num12 - infoThirdParty.num12 - infoCost.num12 + infoSonBetrErloese.num12;
        infoEBITDA.updateFields(infoRevenue);
        
        /* Betr Rohertrag */
        
        infoBetrRohertrag = new infos();
        infoBetrRohertrag.rowNameStr = 'Betriebl. Rohertrag';
        infoBetrRohertrag.num1 = infoMargin.num1 + infoSonBetrErloese.num1;
        infoBetrRohertrag.num2 = infoMargin.num2 + infoSonBetrErloese.num2;
        infoBetrRohertrag.num3 = infoMargin.num3 + infoSonBetrErloese.num3;
        infoBetrRohertrag.num4 = infoMargin.num4 + infoSonBetrErloese.num4;
        infoBetrRohertrag.num5 = infoMargin.num5 + infoSonBetrErloese.num5;
        infoBetrRohertrag.num6 = infoMargin.num6 + infoSonBetrErloese.num6;
        infoBetrRohertrag.num7 = infoMargin.num7 + infoSonBetrErloese.num7;
        infoBetrRohertrag.num8 = infoMargin.num8 + infoSonBetrErloese.num8;
        infoBetrRohertrag.num9 = infoMargin.num9 + infoSonBetrErloese.num9;
        infoBetrRohertrag.num10 = infoMargin.num10 + infoSonBetrErloese.num10;
        infoBetrRohertrag.num11 = infoMargin.num11 + infoSonBetrErloese.num11;
        infoBetrRohertrag.num12 = infoMargin.num12 + infoSonBetrErloese.num12;
        infoBetrRohertrag.updateFields(infoRevenue);
        
        /* END Betr Rohertrag */
        
        /* Ergebnis vor steuern */
        
        infoErgebnisVorSteuern = new infos();
        infoErgebnisVorSteuern.rowNameStr = 'Ergebnis vor Steuern';
        infoErgebnisVorSteuern.num1 = (infoEBITDA.num1 - infoZinsaufwand.num1)+infoZinsertrag.num1;
        infoErgebnisVorSteuern.num2 = (infoEBITDA.num2 - infoZinsaufwand.num2)+infoZinsertrag.num2;
        infoErgebnisVorSteuern.num3 = (infoEBITDA.num3 - infoZinsaufwand.num3)+infoZinsertrag.num3;
        infoErgebnisVorSteuern.num4 = (infoEBITDA.num4 - infoZinsaufwand.num4)+infoZinsertrag.num4;
        infoErgebnisVorSteuern.num5 = (infoEBITDA.num5 - infoZinsaufwand.num5)+infoZinsertrag.num5;
        infoErgebnisVorSteuern.num6 = (infoEBITDA.num6 - infoZinsaufwand.num6)+infoZinsertrag.num6;
        infoErgebnisVorSteuern.num7 = (infoEBITDA.num7 - infoZinsaufwand.num7)+infoZinsertrag.num7;
        infoErgebnisVorSteuern.num8 = (infoEBITDA.num8 - infoZinsaufwand.num8)+infoZinsertrag.num8;
        infoErgebnisVorSteuern.num9 = (infoEBITDA.num9 - infoZinsaufwand.num9)+infoZinsertrag.num9;
        infoErgebnisVorSteuern.num10 = (infoEBITDA.num10 - infoZinsaufwand.num10)+infoZinsertrag.num10;
        infoErgebnisVorSteuern.num11 = (infoEBITDA.num11 - infoZinsaufwand.num11)+infoZinsertrag.num11;
        infoErgebnisVorSteuern.num12 = (infoEBITDA.num12 - infoZinsaufwand.num12)+infoZinsertrag.num12;
        infoErgebnisVorSteuern.updateFields(infoRevenue);
        
        /* END Ergebnis vor steuern */
        
        /*Vorläufiges Ergebnis */
        
        infoVorlaeufigesErgebnis = new infos();
        infoVorlaeufigesErgebnis.rowNameStr = 'Vorläufiges Ergebnis';
        infoVorlaeufigesErgebnis.num1 = infoErgebnisVorSteuern.num1 - infoSteuernEinkErtr.num1;
        infoVorlaeufigesErgebnis.num2 = infoErgebnisVorSteuern.num2 - infoSteuernEinkErtr.num2;
        infoVorlaeufigesErgebnis.num3 = infoErgebnisVorSteuern.num3 - infoSteuernEinkErtr.num3;
        infoVorlaeufigesErgebnis.num4 = infoErgebnisVorSteuern.num4 - infoSteuernEinkErtr.num4;
        infoVorlaeufigesErgebnis.num5 = infoErgebnisVorSteuern.num5 - infoSteuernEinkErtr.num5;
        infoVorlaeufigesErgebnis.num6 = infoErgebnisVorSteuern.num6 - infoSteuernEinkErtr.num6;
        infoVorlaeufigesErgebnis.num7 = infoErgebnisVorSteuern.num7 - infoSteuernEinkErtr.num7;
        infoVorlaeufigesErgebnis.num8 = infoErgebnisVorSteuern.num8 - infoSteuernEinkErtr.num8;
        infoVorlaeufigesErgebnis.num9 = infoErgebnisVorSteuern.num9 - infoSteuernEinkErtr.num9;
        infoVorlaeufigesErgebnis.num10 = infoErgebnisVorSteuern.num10 - infoSteuernEinkErtr.num10;
        infoVorlaeufigesErgebnis.num11 = infoErgebnisVorSteuern.num11 - infoSteuernEinkErtr.num11;
        infoVorlaeufigesErgebnis.num12 = infoErgebnisVorSteuern.num12 - infoSteuernEinkErtr.num12;
        infoVorlaeufigesErgebnis.updateFields(infoRevenue);
        
        /*END Vorläufiges Ergebnis */
        
        infosList.add(infoRevenue);
        infosList.add(infoThirdParty);
        infosList.add(infoMargin);
        infosList.add(infoSonBetrErloese);
        infosList.add(infoBetrRohertrag);
        infosList.add(infoCost);        
        infosList.add(infoGehaltskosten);
        infosList.add(infoFremdarbeiten);
        infosList.add(infoRaumkosten);
        infosList.add(infoBetrSteuern);
        infosList.add(infoVersichBeitr);
        infosList.add(infoKFZKosten);
        infosList.add(infoWerbekosten);
        infosList.add(infoReparaturkosten);       
        infosList.add(infoAndereKosten);
        infosList.add(infoAbschreibungen);
        infosList.add(infoEBITDA);
        infosList.add(infoZinsaufwand);
        infosList.add(infoZinsertrag);
        infosList.add(infoErgebnisVorSteuern);
        infosList.add(infoSteuernEinkErtr);
        infosList.add(infoVorlaeufigesErgebnis);
        
        
        
        /*infosList.add(infoReisekosten);
        infosList.add(infoFortbildungskosten);
        infosList.add(infoTilgung);
        infosList.add(infoInternet);
        infosList.add(infoZinsen);
        infosList.add(infoRaumkosten);
        */
        
        
        
        
        
        
        
        
        
        
        showReport = true;
        
        Set<integer> setSelectedMonths = getSelectedMonths(oppStart.CloseDate, oppEnd.CloseDate);
        
        //dynmaic pageblocktable vodooo
        table = new Component.Apex.PageBlockTable(var='item');
        table.expressions.value='{!infosList}';
        
       	Component.Apex.Column columnName = new Component.Apex.Column(
										headerValue='Bezeichnung'
    								  );
    	columnName.expressions.value='{!item.rowNameStr}';
		table.childComponents.add(columnName);        
		
        if(setSelectedMonths.contains(1)){
			Component.Apex.Column columnAmountJan = new Component.Apex.Column(
										headerValue='Jan: Sum in € '
    								  );
    		columnAmountJan.expressions.value= '{!item.numStr1}';
    								  
			Component.Apex.Column columnPercJan = new Component.Apex.Column(
										headerValue='Jan: % of revenue '
    								  );
    		columnPercJan.expressions.value = '{!item.percStr1}';
    					  
    		table.childComponents.add(columnAmountJan);
    		table.childComponents.add(columnPercJan);
        } 
        if(setSelectedMonths.contains(2)){
			Component.Apex.Column columnAmountFeb = new Component.Apex.Column(
										headerValue='Feb: Sum in € '
    								  );
    		columnAmountFeb.expressions.value = '{!item.numStr2}';
    		
			Component.Apex.Column columnPercFeb = new Component.Apex.Column(
										headerValue='Feb: % of revenue '										
    								  );
			columnPercFeb.expressions.value = '{!item.percStr2}';  
    								  
    		table.childComponents.add(columnAmountFeb);
    		table.childComponents.add(columnPercFeb);
        }
        if(setSelectedMonths.contains(3)){
			Component.Apex.Column columnAmountMar = new Component.Apex.Column(
										headerValue='Mar: Sum in € '
    								  );
			columnAmountMar.expressions.value = '{!item.numStr3}';    								  
    								  
			Component.Apex.Column columnPercMar = new Component.Apex.Column(
										headerValue='Mar: % of revenue '
    								  );
			columnPercMar.expressions.value = '{!item.percStr3}';  
    								  
    		table.childComponents.add(columnAmountMar);
    		table.childComponents.add(columnPercMar);
        }
        if(setSelectedMonths.contains(4)){
			Component.Apex.Column columnAmountApr = new Component.Apex.Column(
										headerValue='Apr: Sum in € '
    								  );
    		columnAmountApr.expressions.value = '{!item.numStr4}';
    								  
			Component.Apex.Column columnPercApr = new Component.Apex.Column(
										headerValue='Apr: % of revenue '
    								  );
			columnPercApr.expressions.value = '{!item.percStr4}';  
    								  
    		table.childComponents.add(columnAmountApr);
    		table.childComponents.add(columnPercApr);
        }
        if(setSelectedMonths.contains(5)){
			Component.Apex.Column columnAmountMay = new Component.Apex.Column(
										headerValue='May: Sum in € '
    								  );
    		columnAmountMay.expressions.value = '{!item.numStr5}';						  
    								  
			Component.Apex.Column columnPercMay = new Component.Apex.Column(
										headerValue='May: % of revenue '
    								  );
    		columnPercMay.expressions.value = '{!item.percStr5}';
    								  
    		table.childComponents.add(columnAmountMay);
    		table.childComponents.add(columnPercMay);
        }
        if(setSelectedMonths.contains(6)){
			Component.Apex.Column columnAmountJune = new Component.Apex.Column(
										headerValue='Jun: Sum in € '
    								  );
    		columnAmountJune.expressions.value = '{!item.numStr6}';
    								  
			Component.Apex.Column columnPercJune = new Component.Apex.Column(
										headerValue='Jun: % of revenue '
    								  );
    		columnPercJune.expressions.value = '{!item.percStr6}';
    								  
    		table.childComponents.add(columnAmountJune);
    		table.childComponents.add(columnPercJune);
        }
        if(setSelectedMonths.contains(7)){
			Component.Apex.Column columnAmountJuly = new Component.Apex.Column(
										headerValue='Jul: Sum in € '
    								  );
    		columnAmountJuly.expressions.value = '{!item.numStr7}';
    								  
			Component.Apex.Column columnPercJuly = new Component.Apex.Column(
										headerValue='Jul: % of revenue '
    								  );
    		columnPercJuly.expressions.value = '{!item.percStr7}';					  
    								  
    		table.childComponents.add(columnAmountJuly);
    		table.childComponents.add(columnPercJuly);
        }
        if(setSelectedMonths.contains(8)){
			Component.Apex.Column columnAmountAug = new Component.Apex.Column(
										headerValue='Aug: Sum in € '
    								  );
    		columnAmountAug.expressions.value = '{!item.numStr8}';
    								  
			Component.Apex.Column columnPercAug = new Component.Apex.Column(
										headerValue='Aug: % of revenue '
    								  );
    		columnPercAug.expressions.value = '{!item.percStr8}';					  
    								  
    		table.childComponents.add(columnAmountAug);
    		table.childComponents.add(columnPercAug);
        }
        if(setSelectedMonths.contains(9)){
			Component.Apex.Column columnAmountSep = new Component.Apex.Column(
										headerValue='Sep: Sum in € '
    								  );
    		columnAmountSep.expressions.value = '{!item.numStr9}';
    						  
			Component.Apex.Column columnPercSep = new Component.Apex.Column(
										headerValue='Sep: % of revenue '
    								  );
    		columnPercSep.expressions.value = '{!item.percStr9}';
    								  
    		table.childComponents.add(columnAmountSep);
    		table.childComponents.add(columnPercSep);
        }
        if(setSelectedMonths.contains(10)){
			Component.Apex.Column columnAmountOct = new Component.Apex.Column(
										headerValue='Oct: Sum in € '
    								  );
			columnAmountOct.expressions.value = '{!item.numStr10}';								  
    								  
			Component.Apex.Column columnPercOct = new Component.Apex.Column(
										headerValue='Oct: % of revenue '
    								  );
			columnPercOct.expressions.value = '{!item.percStr10}';  
    								  
    		table.childComponents.add(columnAmountOct);
    		table.childComponents.add(columnPercOct);
        }
        if(setSelectedMonths.contains(11)){
			Component.Apex.Column columnAmountNov = new Component.Apex.Column(
										headerValue='Nov: Sum in € '
    								  );
    		columnAmountNov.expressions.value = '{!item.numStr11}';	
    							  
			Component.Apex.Column columnPercNov = new Component.Apex.Column(
										headerValue='Nov: % of revenue '
    								  );
    		columnPercNov.expressions.value = '{!item.percStr11}';
    								  
    		table.childComponents.add(columnAmountNov);
    		table.childComponents.add(columnPercNov);
        }
        if(setSelectedMonths.contains(12)){
			Component.Apex.Column columnAmountDec = new Component.Apex.Column(
										headerValue='Dec: Sum in € '
    								  );
    		columnAmountDec.expressions.value = '{!item.numStr12}';	
    							  
			Component.Apex.Column columnPercDec = new Component.Apex.Column(
										headerValue='Dec: % of revenue '
    								  );
    		columnPercDec.expressions.value = '{!item.percStr12}';
    		
    		table.childComponents.add(columnAmountDec);
    		table.childComponents.add(columnPercDec);
        }
        //adding Sum column
        Component.Apex.Column columnAmountTotal = new Component.Apex.Column(
        									 headerValue='Total: Sum in €'
        									);
        columnAmountTotal.expressions.value = '{!item.sumNumsStr}';
        
        Component.Apex.Column columnPercTotal = new Component.Apex.Column(
        									 headerValue='Total: % of revenue'
        									);
        columnPercTotal.expressions.value = '{!item.sumPercStr}';
        
        table.childComponents.add(columnAmountTotal);
        table.childComponents.add(columnPercTotal);
        
        //end dynmaic pageblocktable vodooo
        return null;
    }// End Methode runReport()
    
    string padIntegerWithZero(integer i) {
        if(i < 10) {return '0' + string.valueof(i);}
        else {return string.valueof(i);}
    }
}// End class