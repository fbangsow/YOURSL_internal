public with sharing class BalanceReportCont {
    
    public boolean showReport{get; set;}
    
    public class infos {
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
            
        }
    }
    
    public infos infoRevenue{get; set;}
    public infos infoThirdParty{get; set;}
    public infos infoMargin{get; set;}
    public infos infoCost{get; set;}
    public infos infoEBITDA{get; set;}
    
    //public list<infos> infosList{get; set;}
    /*
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
    */
    
    public opportunity oppStart{get;set;} //used because it has a date field
    public opportunity oppEnd{get;set;} //used because it has a date field
    string startDateStr;
    string endDateStr;
    
    public BalanceReportCont() {
        oppStart = new Opportunity();
        oppEnd = new Opportunity();
        oppStart.closeDate = date.valueof('2011-7-1');
        oppEnd.closeDate = date.valueof('2012-6-30');
        showReport = false;
    }
    
    public pageReference runReport() {
        list<Debitoren_Rechnung__c> ausgangRechs;
        list<Kreditor_Invoice_Status__c> eingangRechStatuses;
        string query;
        //map<id, string> kontorahmenIdToName = new map<id, string>();
        //list<Chart_of_Accounts__c> kontoRahmens;
        
        if(oppStart.CloseDate >  oppEnd.CloseDate) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Start date cannot be later than end date'));
            return null;
        }
        
        startDateStr = string.valueof(oppStart.CloseDate.year()) + '-' + padIntegerWithZero(oppStart.CloseDate.month()) + '-' + padIntegerWithZero(oppStart.CloseDate.day());
        endDateStr = string.valueof(oppEnd.CloseDate.year()) + '-' + padIntegerWithZero(oppEnd.CloseDate.month()) + '-' + padIntegerWithZero(oppEnd.CloseDate.day());
        
        /* revenue */
        query = 'SELECT Id, Invoice_Amount_net__c, Invoice_date__c ' +
                ' FROM Debitoren_Rechnung__c' + 
                ' WHERE Invoice_date__c >= ' + startDateStr + 
                ' AND Invoice_date__c <= ' + endDateStr;
        ausgangRechs = Database.query(query);
        infoRevenue = new infos();
        for(Debitoren_Rechnung__c ausgangRech : ausgangRechs) {
            if(ausgangRech.Invoice_date__c.Month() == 1) {
                infoRevenue.num1 += ausgangRech.Invoice_Amount_net__c;
                infoRevenue.perc1 = 100;
            }
            if(ausgangRech.Invoice_date__c.Month() == 2) {
                infoRevenue.num2 += ausgangRech.Invoice_Amount_net__c;
                infoRevenue.perc2 = 100;
            }
            if(ausgangRech.Invoice_date__c.Month() == 3) {
                infoRevenue.num3 += ausgangRech.Invoice_Amount_net__c;
                infoRevenue.perc3 = 100;
            }
            if(ausgangRech.Invoice_date__c.Month() == 4) {
                infoRevenue.num4 += ausgangRech.Invoice_Amount_net__c;
                infoRevenue.perc4 = 100;
            }
            if(ausgangRech.Invoice_date__c.Month() == 5) {
                infoRevenue.num5 += ausgangRech.Invoice_Amount_net__c;
                infoRevenue.perc5 = 100;
            }
            if(ausgangRech.Invoice_date__c.Month() == 6) {
                infoRevenue.num6 += ausgangRech.Invoice_Amount_net__c;
                infoRevenue.perc6 = 100;
            }
            if(ausgangRech.Invoice_date__c.Month() == 7) {
                infoRevenue.num7 += ausgangRech.Invoice_Amount_net__c;
                infoRevenue.perc7 = 100;
            }
            if(ausgangRech.Invoice_date__c.Month() == 8) {
                infoRevenue.num8 += ausgangRech.Invoice_Amount_net__c;
                infoRevenue.perc8 = 100;
            }
            if(ausgangRech.Invoice_date__c.Month() == 9) {
                infoRevenue.num9 += ausgangRech.Invoice_Amount_net__c;
                infoRevenue.perc9 = 100;
            }
            if(ausgangRech.Invoice_date__c.Month() == 10) {
                infoRevenue.num10 += ausgangRech.Invoice_Amount_net__c;
                infoRevenue.perc10 = 100;
            }
            if(ausgangRech.Invoice_date__c.Month() == 11) {
                infoRevenue.num11 += ausgangRech.Invoice_Amount_net__c;
                infoRevenue.perc11 = 100;
            }
            if(ausgangRech.Invoice_date__c.Month() == 12) {
                infoRevenue.num12 += ausgangRech.Invoice_Amount_net__c;
                infoRevenue.perc12 = 100;
            }
        }
        infoRevenue.updateFields(infoRevenue);
        
        /* Third party service cost */
        query = 'SELECT id, Kreditor_Invoice__r.Invoice_amount__c, Kreditor_Invoice__r.Invoice_date__c ' +
                ' FROM Kreditor_Invoice_Status__c' + 
                ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
                ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
                ' AND debit_account__r.name = \'3100\'';
        eingangRechStatuses = Database.query(query);
        infoThirdParty = new infos();   
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
        
        /* margin */
        infoMargin = new infos();   
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
                ' AND debit_account__c != null';
        eingangRechStatuses = Database.query(query);
        
        infoCost = new infos();   
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
        infoCost.updateFields(infoRevenue);
        
        /* EBITDA */
        infoEBITDA = new infos();   
        infoEBITDA.num1 = infoRevenue.num1 - infoThirdParty.num1 - infoCost.num1;
        infoEBITDA.num2 = infoRevenue.num2 - infoThirdParty.num2 - infoCost.num2;
        infoEBITDA.num3 = infoRevenue.num3 - infoThirdParty.num3 - infoCost.num3;
        infoEBITDA.num4 = infoRevenue.num4 - infoThirdParty.num4 - infoCost.num4;
        infoEBITDA.num5 = infoRevenue.num5 - infoThirdParty.num5 - infoCost.num5;
        infoEBITDA.num6 = infoRevenue.num6 - infoThirdParty.num6 - infoCost.num6;
        infoEBITDA.num7 = infoRevenue.num7 - infoThirdParty.num7 - infoCost.num7;
        infoEBITDA.num8 = infoRevenue.num8 - infoThirdParty.num8 - infoCost.num8;
        infoEBITDA.num9 = infoRevenue.num9 - infoThirdParty.num9 - infoCost.num9;
        infoEBITDA.num10 = infoRevenue.num10 - infoThirdParty.num10 - infoCost.num10;
        infoEBITDA.num11 = infoRevenue.num11 - infoThirdParty.num11 - infoCost.num11;
        infoEBITDA.num12 = infoRevenue.num12 - infoThirdParty.num12 - infoCost.num12;
        infoEBITDA.updateFields(infoRevenue);
        
        showReport = true;
        
        return null;
    }
    
    string padIntegerWithZero(integer i) {
        if(i < 10) {return '0' + string.valueof(i);}
        else {return string.valueof(i);}
    }
}