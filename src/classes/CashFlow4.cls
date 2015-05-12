/* **************************************************************
// Creater: Alexander Erdikler/Chris Sandra Schautt/Alexander Faust
// Description: retrieves and sums up all information for CashFlow
// Testclass: CashFlow4_Test
// Apex Class Access: System Administrator/YOUR SL System Administrator
// Last modified by: Alexander Faust
// Last modified date: 07.01.2013
// Latests changes: 11.12.2012: renamed "Samsung Bank" account number, and excluded this account from Calculate_Sum_DeblistObj Method
					07.01.2013: exluded charts 1369,11805 and 70505 from listKontorahmen in constructor method	
					07.01.2013: exluded debitor invoices with "*W8T*" in name field from collection of mapAusgRgAll (DH)
					08.09.2014: added two new bank accounts (mapBank5Sparkonto, mapBank6USD)
                    18.02.2015: Changed Opportunity stage name to 'Won'
// ************************************************************** */

public class CashFlow4 {
    
    private transient Map<Id,Bank_Konto__c> mapBank1Giro = new Map<Id,Bank_Konto__c>();
    private transient Map<Id,Bank_Konto__c> mapBank2 = new Map<Id,Bank_Konto__c>();
    private transient Map<Id,Bank_Konto__c> mapBank3Linie = new Map<Id,Bank_Konto__c>();
    private transient Map<Id,Bank_Konto__c> mapBank4Samsung = new Map<Id,Bank_Konto__c>();
    private transient Map<Id,Bank_Konto__c> mapBank5Sparkonto = new Map<Id,Bank_Konto__c>();
    private transient Map<Id,Bank_Konto__c> mapBank6USD = new Map<Id,Bank_Konto__c>();
    
    private transient Map<Id,Debitoren_Rechnung__c> mapAusgRgAll = new Map<Id,Debitoren_Rechnung__c>();
    private transient Map<Id,Kreditor__c> mapEingRgAll = new Map<Id,Kreditor__c>();
    private transient Map<Id,Account> mapAccountGermanyAll = new  Map<Id,Account>();
    //private transient Map<Id,OpportunityLineItem> mapOpportunityLineItem = new Map<Id,OpportunityLineItem>();
    
    //For all OLIs related to Out/Ingoing invoices
    private transient Map<Id,OpportunityLineItem> mapOpportunityOutLineItem = new Map<Id,OpportunityLineItem>();
    private transient Map<Id,OpportunityLineItem> mapOpportunityInLineItem = new Map<Id,OpportunityLineItem>();
    
    private transient Map<Id,OpportunityLineItem> mapAllOLIS = new Map<Id,OpportunityLineItem>();
    
    //private transient Map<Id,Opportunity> mapOpportunity = new Map<Id,Opportunity>();
    
    //For all Opps related to Out/Ingoing invoices
    private transient Map<Id,Opportunity> mapOpportunityOut = new Map<Id,Opportunity>();
    private transient Map<Id,Opportunity> mapOpportunityIn = new Map<Id,Opportunity>();
    private transient Map<Id,Opportunity> mapOpportunityAll = new Map<Id,Opportunity>();
    
    public Date StartDate{get;set;}
    
    // this will show the bank table
    public transient List<DebListObj__c> ObjBank1{get;set;}
    
    // this will show the not invoiced Opportunity LineItems
    public transient List<DebListObj__c> ObjTurnover{get;set;}
    
    // this will show the budgeted cost alias KreditorInvoices that are unpaid
    public transient List<DebListObj__c> ObjKosten{get;set;}

    // this will show the not invoiced Opportunity LineItems VAT
    public transient List<DebListObj__c> ObjMwSt{get;set;}
    private transient List<DebListObj__c> ObjMwStUmsatz{get;set;}
    private transient List<DebListObj__c> ObjMwStKosten{get;set;}
    
    // this will show the unpaid DebitInvoices
    public transient List<DebListObj__c> ObjOPOSDebitInvoices{get;set;}
    
    // this will show the real cost alias KreditorInvoices that are unpaid
    public transient List<DebListObj__c> ObjOPOSKreditInvoices{get;set;}
    
    // this will show the not invoiced Opportunity LineItems VAT
    public transient List<DebListObj__c> ObjCashFlow{get;set;}
    
    // this will show the not invoiced Opportunity LineItems VAT
    public transient List<DebListObj__c> ObjInvestExpenses{get;set;}
    
    // this dates are shown in the VFPage
    // dateToday is used for seperating the dates
    public transient Date dateToday {get;set;}
    public transient Date dateBeforeToday {get;set;}
    public transient Date dateAfterToday {get;set;}
    public transient Date FirstDate {get;set;}
    
    public transient Date date2{get;set;}
    public transient Date date3{get;set;}
    public transient Date date4{get;set;}
    public transient Date date5{get;set;}
    public transient Date date6{get;set;}
    public transient Date date7{get;set;}
    public transient Date date8{get;set;}
    public transient Date date9{get;set;}
    public transient Date date10{get;set;}
    public transient Date date11{get;set;}
    public transient Date date12{get;set;}
    public transient Date date13{get;set;}
    public transient Date date14{get;set;}
    public transient Date date_endWeek3{get;set;}
    public transient Date date_endWeek4{get;set;}
    public transient Date date_endWeek5{get;set;} 
    public transient Date date_endWeek6{get;set;}
    public transient Date date_endWeek7{get;set;}
    public transient Date date_endWeek8{get;set;}
    public transient Date date_endWeek9{get;set;}
    public transient Date date_endWeek10{get;set;} 
    public transient Date date_endWeek11{get;set;} 
    public transient Date date_endWeek12{get;set;}   
    
    public transient integer calendarWeek3{get;set;}
    public transient integer calendarWeek4{get;set;}
    public transient integer calendarWeek5{get;set;}
    public transient integer calendarWeek6{get;set;}
    public transient integer calendarWeek7{get;set;}
    public transient integer calendarWeek8{get;set;}
    public transient integer calendarWeek9{get;set;}
    public transient integer calendarWeek10{get;set;}
    public transient integer calendarWeek11{get;set;}
    public transient integer calendarWeek12{get;set;}
    
    
    public transient Double differenz {get;set;}
    public transient Double differenz2 {get;set;}
    public transient Double differenz3 {get;set;}
    public transient Double differenz4 {get;set;}
    //to-be-checked-for-delete
    public transient DebListObj__c objeBank1 {get;set;}
    public transient DebListObj__c objeBank2 {get;set;}
    public transient DebListObj__c objeBank3 {get;set;}
    ////END to-be-checked-for-delete
        public transient DebListObj__c sumTurnover{get;set;}
    public transient DebListObj__c sumUmsatzOPOS{get;set;}
    public transient DebListObj__c sumKosten{get;set;}
    public transient DebListObj__c sumKostenOPOS{get;set;}
            
    
    //debug variables
    public transient Double differenzCol1 {get;set;}
    public transient Double differenzCol2 {get;set;}
    public transient Double differenzCol3 {get;set;}
    public transient Double differenzCol4 {get;set;}
    public transient Double differenzCol5 {get;set;}
    //end debug variables
    
    public transient List<DebListObj__c> cashFlowBank {get;set;}
    
    private transient Map<Id,Kreditor__c> allPaidCreditInvoices {get;set;}
    private transient Map<Id,Debitoren_Rechnung__c> allPaidDebitInvoices {get;set;}
    
    public transient List<ChartData> myChartData{get;set;}
    // calculation Sum of VAT
    private transient Double SumOfVAT = 0.0;
    
    // +++++++++++++++ constructor  +++++++++++++++ 
    public CashFlow4(){
        dateToday = Date.today();
        dateBeforeToday = dateToday.addDays(-1);
        dateAfterToday = dateToday.addDays(1);
        date2 = dateToday.addDays(2);
        date3 = dateToday.addDays(3);
        date4 = dateToday.addDays(4);
        date5 = dateToday.addDays(5);
        date6 = dateToday.addDays(6);
        date7 = dateToday.addDays(7); // Eine Woche
        date8 = dateToday.addDays(8);
        date9 = dateToday.addDays(9);
        date10 = dateToday.addDays(10);
        date11 = dateToday.addDays(11);
        date12 = dateToday.addDays(12);
        date13 = dateToday.addDays(13);
        date14 = dateToday.addDays(14); // Zwei Wochen
        date_endWeek3 = dateToday.addDays(21).toStartOfWeek().addDays(4); // Drei Wochen
        date_endWeek4 = date_endWeek3.addDays(7);
        date_endWeek5 = date_endWeek4.addDays(7);
        date_endWeek6 = date_endWeek5.addDays(7);
        date_endWeek7 = date_endWeek6.addDays(7);
        date_endWeek8 = date_endWeek7.addDays(7);
        date_endWeek9 = date_endWeek8.addDays(7);
        date_endWeek10 = date_endWeek9.addDays(7);
        date_endWeek11 = date_endWeek10.addDays(7);
        date_endWeek12 = date_endWeek11.addDays(7);
        /*date_endWeek4 = dateToday.addDays(28); // Vier Wochen
        date_endWeek5 = dateToday.addDays(35); // Fünf Wochen
        date_endWeek6 = dateToday.addDays(42);// Sechs Wochen
        date_endWeek7 = dateToday.addDays(49);// Sieben Wochen
        date_endWeek8 = dateToday.addDays(56); // Acht Wochen
        date_endWeek9 = dateToday.addDays(63);// Neun Wochen
        date_endWeek10 = dateToday.addDays(70);//Zehn Wochen
        date_endWeek11 = dateToday.addDays(77);//Elf Wochen
        date_endWeek12 = dateToday.addDays(84);//Zwölf Wochen*/
        
        
        calendarWeek3 = getCalendarWeek(date_endWeek3);
        calendarWeek4 = getCalendarWeek(date_endWeek4);
        calendarWeek5 = getCalendarWeek(date_endWeek5);
        calendarWeek6 = getCalendarWeek(date_endWeek6);
        calendarWeek7 = getCalendarWeek(date_endWeek7);
        calendarWeek8 = getCalendarWeek(date_endWeek8);
        calendarWeek9 = getCalendarWeek(date_endWeek9);
        calendarWeek10 = getCalendarWeek(date_endWeek10);
        calendarWeek11 = getCalendarWeek(date_endWeek11);
        calendarWeek12 = getCalendarWeek(date_endWeek12);
        
        
        ObjBank1 = new List<DebListObj__c>(); 
        ObjTurnover = new List<DebListObj__c>();
        ObjKosten = new List<DebListObj__c>();
        ObjMwSt = new List<DebListObj__c>();
        ObjOPOSDebitInvoices = new List<DebListObj__c>();
        ObjOPOSKreditInvoices = new List<DebListObj__c>();
        ObjCashFlow = new List<DebListObj__c>();
        ObjInvestExpenses = new List<DebListObj__c>();
        ObjMwStUmsatz = new List<DebListObj__c>();
        ObjMwStKosten = new List<DebListObj__c>();
        
        myChartData = new List<ChartData>();
        
        // First Date for Beginning selecting Kreditor and Debitor Invoices
        FirstDate = Date.newInstance(2012,7,1);
        
        
        //for all Opps related to outgoing invoices
        Set<Id> setRelatedOutOppIds = new Set<Id>();
        
        //for all Opps related to ingoing invoices
        Set<Id> setRelatedInOppIds = new Set<Id>();
        
        Set<Id> setAllPaidCreditInvoices = new Set<Id>();
        Set<Id> setAllPaidDebitInvoices = new Set<Id>();
        Account aYOURSL = [SELECT Id FROM Account WHERE Name='YOUR SL GmbH' LIMIT 1];
        try{
            mapBank1Giro = new Map<Id,Bank_Konto__c>([
                                            SELECT Id, Buchungsdatum__c, Betrag__c, 
                                            Waehrung__c From Bank_Konto__c WHERE Kontonummer__c = '667990343']);
           mapBank2  = new Map<Id,Bank_Konto__c>([
                                            SELECT Id, Buchungsdatum__c, Betrag__c, 
                                            Waehrung__c From Bank_Konto__c WHERE Kontonummer__c = '18379333']);
           mapBank3Linie = new Map<Id,Bank_Konto__c>([
                                            SELECT Id, Buchungsdatum__c, Betrag__c, 
                                            Waehrung__c From Bank_Konto__c WHERE Kontonummer__c = '667990343Linie']); 
           mapBank4Samsung = new Map<Id,Bank_Konto__c>([
                                            SELECT Id, Buchungsdatum__c, Betrag__c, 
                                            Waehrung__c From Bank_Konto__c WHERE Kontonummer__c = '18858380']);
           mapBank5Sparkonto = new Map<Id,Bank_Konto__c>([
                                            SELECT Id, Buchungsdatum__c, Betrag__c, 
                                            Waehrung__c From Bank_Konto__c WHERE Kontonummer__c = '23869250']);
           mapBank6USD = new Map<Id,Bank_Konto__c>([
                                            SELECT Id, Buchungsdatum__c, Betrag__c, 
                                            Waehrung__c From Bank_Konto__c WHERE Kontonummer__c = '23821982']);            
            
            
        }catch(QueryException ex){
            ApexPages.addMessages(ex);
        }
        try{
                allPaidDebitInvoices = new Map<Id,Debitoren_Rechnung__c>([
                                                                        Select Id,Opportunity__c FROM Debitoren_Rechnung__c
                                                                        WHERE Payment_Status__c = 'Paid'
                                                                ]);
                                                                
                for(Debitoren_Rechnung__c debInv: allPaidDebitInvoices.values()){
                        if(!setAllPaidDebitInvoices.contains(debInv.Opportunity__c)){
                                setAllPaidDebitInvoices.add(debInv.Opportunity__c);
                        }
                }
            id idSamsungKonto = 'a0oD0000002Njdr';                                    
            mapAusgRgAll = new Map<Id,Debitoren_Rechnung__c>([
                                        SELECT
                                        /*(SELECT debit_account__c, credit_account__c, Payment_Status__c, Name, 
                                            Debitor_Invoice__c, Id FROM Ausgangsrechnungsstatus1D__r WHERE debit_account__c != 'a0oD0000002Njdr' AND Payment_Status__c = 'Unpaid'),*/                                   
                                        Id, Invoice_Amount_total__c, VAT_calc__c,debit_account__c, Due_Date__c, credit_account__c, 
                                                Invoice_Amount_net__c, Name,Rechnungsnummer__c, Paid__c, Payment_Status__c, 
                                                Opportunity__c FROM Debitoren_Rechnung__c WHERE Payment_Status__c = 'Unpaid' AND Invoice_date__c >= :FirstDate AND Due_Date__c <= :date_endWeek12 AND (NOT Name LIKE '%W8T%') ORDER BY Invoice_date__c  ]);
            for(Debitoren_Rechnung__c oneDebInvoice : mapAusgRgAll.values()){
                if(!setRelatedOutOppIds.contains(oneDebInvoice.Opportunity__c) /*&& oneDebInvoice.Ausgangsrechnungsstatus1D__r.size() > 0*/){
                        setRelatedOutOppIds.add(oneDebInvoice.Opportunity__c);
                }
                
            }
        }catch(QueryException ex){
            ApexPages.addMessages(ex);
        }
        try{
                
                
                
                
            List<Chart_of_Accounts__c> listKontorahmen = new List<Chart_of_Accounts__c>([SELECT c.Name, c.Id From Chart_of_Accounts__c c 
            WHERE c.Name = '1000' OR c.Name = '1000' OR c.Name = '1200' OR c.Name = '1361' OR c.Name = '1362' OR c.Name = '1365' OR c.Name = '631' OR c.Name='1369' OR c.Name='11805' OR c.Name='70505']);
            mapEingRgAll = new Map<Id,Kreditor__c>([
                                    SELECT 
                                        (SELECT debit_account__c, credit_account__c, Payment_Status__c, Name, 
                                            Kreditor_Invoice__c, Id FROM Kreditor_Invoice_Status__r WHERE debit_account__c NOT IN :listKontorahmen AND Payment_Status__c = 'Unpaid'),
                                    Ueberweisungsbetrag__c, VAT_calc__c, Opportunity__c, Invoice_due_on__c, 
                                    Invoice_date__c, Invoice_amount__c, Invoice_Number__c, Budget__c, Name,
                                    Amount_Total__c, Account__c 
                                    FROM Kreditor__c WHERE Invoice_date__c >= :FirstDate AND Invoice_due_on__c <= :date_endWeek12 AND Payment_Status__c = 'Unpaid' ORDER BY Invoice_date__c]);
            for(Kreditor__c oneKreditorInvoice : mapEingRgAll.values()){
                if(!setRelatedInOppIds.contains(oneKreditorInvoice.Opportunity__c)){
                        setRelatedInOppIds.add(oneKreditorInvoice.Opportunity__c);
                }
            }
            
            allPaidCreditInvoices = new Map<Id,Kreditor__c>([
                                    SELECT 
                                        (SELECT debit_account__c, credit_account__c, Payment_Status__c, Name, 
                                            Kreditor_Invoice__c, Id FROM Kreditor_Invoice_Status__r WHERE debit_account__c NOT IN :listKontorahmen AND Payment_Status__c = 'Paid'),
                                    Ueberweisungsbetrag__c, VAT_calc__c, Opportunity__c, Invoice_due_on__c, 
                                    Invoice_date__c, Invoice_amount__c, Invoice_Number__c, Budget__c, Name,
                                    Amount_Total__c, Account__c 
                                    FROM Kreditor__c WHERE Payment_Status__c = 'Paid' ORDER BY Invoice_date__c]);
                                    
                        for(Kreditor__c oneKredInv : allPaidCreditInvoices.values()){
                                if(!setAllPaidCreditInvoices.contains(oneKredInv.Opportunity__c)){
                                        setAllPaidCreditInvoices.add(oneKredInv.Opportunity__c);
                                }
                        }
            
            
        }catch(QueryException ex){
            ApexPages.addMessages(ex);
        }
        try{
            mapAccountGermanyAll = new  Map<Id,Account>([SELECT Name, Id, BillingCountry FROM Account WHERE BillingCountry = 'Deutschland' OR BillingCountry = 'Germany']);
        }catch(QueryException ex){
            ApexPages.addMessages(ex);
        }
        
        try{
                
                
                        mapOpportunityIn = new Map<Id,Opportunity>([ SELECT Id, Name, AccountId,(SELECT Id FROM OpportunityLineItems WHERE Leistung_erbracht__c = FALSE ) FROM Opportunity
                                                WHERE StageName = 'Won' AND Name != '° Urlaub/Krankheit/Feiertage' AND Id IN :setRelatedInOppIds]);
                                                
                        mapOpportunityOut = new Map<Id,Opportunity>([ SELECT Id, Name, AccountId,(SELECT Id FROM OpportunityLineItems WHERE Leistung_erbracht__c = FALSE ) FROM Opportunity
                                                WHERE StageName = 'Won' AND Name != '° Urlaub/Krankheit/Feiertage' AND Id IN :setRelatedOutOppIds]);
                        
                        mapOpportunityAll = new Map<Id,Opportunity>([ SELECT Id, Name, AccountId,Expected_date_of_payment__c ,(SELECT Id FROM OpportunityLineItems WHERE Leistung_erbracht__c = FALSE and (ServiceDate <=: date_endWeek12) AND (NOT PricebookEntry.Name LIKE 'UNBILLABLE%')) FROM Opportunity
                                                WHERE (StageName = 'Won' OR ForecastCategoryName='Commit') AND Name != '° Urlaub/Krankheit/Feiertage' AND AccountId !=:aYOURSL.Id /*AND Id NOT IN :setRelatedOutOppIds AND Id NOT IN:setRelatedInOppIds AND Id NOT IN:setAllPaidCreditInvoices AND Id NOT IN: setAllPaidDebitInvoices*/]);
                        
        }catch(QueryException ex){
            ApexPages.addMessages(ex);
        }
    
        try{
                                         
                        mapOpportunityInLineItem = new Map<Id,OpportunityLineItem>([
                                                SELECT UnitPrice, Startdatum__c, ServiceDate, OpportunityId,
                                                Opportunity.Name, Opportunity.CloseDate, Opportunity.Id,
                                                Opportunity.Expected_date_of_payment__c, Opportunity.AccountId,
                                                Sales_Price_hrs__c, Quantity, ListPrice, Leistung_erbracht__c, Id,
                                                Erwarteter_Zahlungseingang__c,
                                                (SELECT ScheduleDate, Quantity, Id FROM OpportunityLineItemSchedules) 
                                                FROM OpportunityLineItem 
                                                WHERE Opportunity.StageName = 'Won'
                                                AND Opportunity.Name != '° Urlaub/Krankheit/Feiertage' 
                                                AND Opportunity.Id IN :setRelatedInOppIds
                                                AND Leistung_erbracht__c = FALSE]);
                                                
                                                
                        mapOpportunityOutLineItem = new Map<Id,OpportunityLineItem>([
                                                SELECT UnitPrice, Startdatum__c, ServiceDate, OpportunityId,
                                                Opportunity.Name, Opportunity.CloseDate, Opportunity.Id,
                                                Opportunity.Expected_date_of_payment__c, Opportunity.AccountId,
                                                Sales_Price_hrs__c, Quantity, ListPrice, Leistung_erbracht__c, Id,
                                                Erwarteter_Zahlungseingang__c,
                                                (SELECT ScheduleDate, Quantity, Id FROM OpportunityLineItemSchedules) 
                                                FROM OpportunityLineItem 
                                                WHERE Opportunity.StageName = 'Won'
                                                AND Opportunity.Name != '° Urlaub/Krankheit/Feiertage' 
                                                AND Opportunity.Id IN :setRelatedOutOppIds
                                                AND Leistung_erbracht__c = FALSE]);
                                                
                        mapAllOLIS = new Map<Id,OpportunityLineItem>([
                                                SELECT UnitPrice, Startdatum__c, ServiceDate, OpportunityId,
                                                Opportunity.Name, Opportunity.CloseDate, Opportunity.Id,
                                                Opportunity.Expected_date_of_payment__c, Opportunity.AccountId,
                                                Sales_Price_hrs__c, Quantity, ListPrice, Leistung_erbracht__c, Id,
                                                Erwarteter_Zahlungseingang__c,PricebookEntry.Name,
                                                (SELECT ScheduleDate, Quantity, Id FROM OpportunityLineItemSchedules) 
                                                FROM OpportunityLineItem 
                                                WHERE (Opportunity.StageName = 'Won'
                                                OR Opportunity.ForecastCategoryName='Commit')
                                                AND Opportunity.Name != '° Urlaub/Krankheit/Feiertage'
                                                AND (NOT PricebookEntry.Name LIKE 'UNBILLABLE%')
                                                AND Opportunity.AccountId !=:aYOURSL.Id
                                                /*AND Opportunity.Id NOT IN: setRelatedOutOppIds
                                                AND Opportunity.Id NOT IN: setRelatedInOppIds 
                                                AND Opportunity.Id NOT IN: setAllPaidDebitInvoices
                                                AND Opportunity.Id NOT IN: setAllPaidCreditInvoices*/
                                                AND ServiceDate <=: date_endWeek12
                                                AND Leistung_erbracht__c = FALSE]);
                        

        }catch(QueryException ex){
            ApexPages.addMessages(ex);
        }
        
        
        try{

        }catch(QueryException ex){
            ApexPages.addMessages(ex);
        }
        
        
        Fill_Bank();
        Fill_Turnover();
        Fill_OPOSDebitInvoices();
        Fill_Kosten();
        Fill_InvestExpenses();
        Fill_ObjCashFlow();
        //Fill_MwSt();
        
    }// END contructor public CashFlow4(ApexPages.StandardController stdController)
    
    
    private Integer getCalendarWeek(Date theDate){
        //Date baseDate = Date.newInstance(2006,1,1);
        //return Math.Mod((baseDate.daysBetween(theDate))/7,52)+1;
        
        //return Math.Mod(Math.round((theDate.dayOfYear()/7)+1),52)+1;
        //return Math.Mod(Math.round((theDate.dayOfYear()/7)),52)+1;
        datetime dt;
        //dt = dt.newInstance(theDate, Time.newInstance(12, 0, 0, 0));
        dt = datetime.newInstance(theDate, Time.newInstance(12, 0, 0, 0));
        //return Math.round(theDate.dayOfYear()/7);
        return integer.valueof(dt.Format('w'));
        //return Math.ceil((Double)(theDate.dayOfYear()) / 7).intValue();
    } // END private Integer getCalendarWeek(Date theDate)
    
    public void Fill_InvestExpenses(){
        
        //sumUmsatz = Calculate_SUM_DebListObj(ObjUmsatz);
        sumUmsatzOPOS = Calculate_SUM_DebListObj(ObjOPOSDebitInvoices);
        sumKosten = Calculate_SUM_DebListObj(ObjKosten);
        sumTurnover = Calculate_SUM_DebListObj(ObjTurnover);
        //sumKostenOPOS = Calculate_SUM_DebListObj(ObjOPOSKreditInvoices);
        
        
        DebListObj__c oneRow = new DebListObj__c(
                RowName__c='Ein-/Ausgaben',
                debDueDate01__c = (sumUmsatzOPOS.debDueDate01__c + sumTurnover.debDueDate01__c) - sumKosten.debDueDate01__c,
                debDueDate02__c = (sumUmsatzOPOS.debDueDate02__c + sumTurnover.debDueDate02__c) - sumKosten.debDueDate02__c,
                debDueDate03__c = (sumUmsatzOPOS.debDueDate03__c + sumTurnover.debDueDate03__c) - sumKosten.debDueDate03__c,
                debDueDate04__c = (sumUmsatzOPOS.debDueDate04__c + sumTurnover.debDueDate04__c) - sumKosten.debDueDate04__c,
                debDueDate05__c = (sumUmsatzOPOS.debDueDate05__c + sumTurnover.debDueDate05__c) - sumKosten.debDueDate05__c,
                debDueDate06__c = (sumUmsatzOPOS.debDueDate06__c + sumTurnover.debDueDate06__c) - sumKosten.debDueDate06__c,
                debDueDate07__c = (sumUmsatzOPOS.debDueDate07__c + sumTurnover.debDueDate07__c) - sumKosten.debDueDate07__c,
                debDueDate08__c = (sumUmsatzOPOS.debDueDate08__c + sumTurnover.debDueDate08__c) - sumKosten.debDueDate08__c,
                debDueDate09__c = (sumUmsatzOPOS.debDueDate09__c + sumTurnover.debDueDate09__c) - sumKosten.debDueDate09__c,
                debDueDate10__c = (sumUmsatzOPOS.debDueDate10__c + sumTurnover.debDueDate10__c) - sumKosten.debDueDate10__c,
                debDueDate11__c = (sumUmsatzOPOS.debDueDate11__c + sumTurnover.debDueDate11__c) - sumKosten.debDueDate11__c,
                debDueDate12__c = (sumUmsatzOPOS.debDueDate12__c + sumTurnover.debDueDate12__c) - sumKosten.debDueDate12__c,
                debDueDate13__c = (sumUmsatzOPOS.debDueDate13__c + sumTurnover.debDueDate13__c) - sumKosten.debDueDate13__c,
                debDueDate14__c = (sumUmsatzOPOS.debDueDate14__c + sumTurnover.debDueDate14__c) - sumKosten.debDueDate14__c,
                debDueDate15__c = (sumUmsatzOPOS.debDueDate15__c + sumTurnover.debDueDate15__c) - sumKosten.debDueDate15__c,
                debDueDate16__c = (sumUmsatzOPOS.debDueDate16__c + sumTurnover.debDueDate16__c) - sumKosten.debDueDate16__c,
                debDueDate17__c = (sumUmsatzOPOS.debDueDate17__c + sumTurnover.debDueDate17__c) - sumKosten.debDueDate17__c,
                debDueDate18__c = (sumUmsatzOPOS.debDueDate18__c + sumTurnover.debDueDate18__c) - sumKosten.debDueDate18__c,
                debDueDate19__c = (sumUmsatzOPOS.debDueDate19__c + sumTurnover.debDueDate19__c) - sumKosten.debDueDate19__c,
                debDueDate20__c = (sumUmsatzOPOS.debDueDate20__c + sumTurnover.debDueDate20__c) - sumKosten.debDueDate20__c,
                debDueDate21__c = (sumUmsatzOPOS.debDueDate21__c + sumTurnover.debDueDate21__c) - sumKosten.debDueDate21__c,
                debDueDate22__c = (sumUmsatzOPOS.debDueDate22__c + sumTurnover.debDueDate22__c) - sumKosten.debDueDate22__c,
                debDueDate23__c = (sumUmsatzOPOS.debDueDate23__c + sumTurnover.debDueDate23__c) - sumKosten.debDueDate23__c,
                debDueDate24__c = (sumUmsatzOPOS.debDueDate24__c + sumTurnover.debDueDate24__c) - sumKosten.debDueDate24__c,
                debDueDate25__c = (sumUmsatzOPOS.debDueDate25__c + sumTurnover.debDueDate25__c) - sumKosten.debDueDate25__c
        );
        
        ObjInvestExpenses.add(oneRow);
        
    }
    
    public void Fill_Bank(){
        
        Double giroStand = 0.0;
        
        for(Bank_Konto__c oneBank : mapBank1Giro.values()){
				if(oneBank.Betrag__c != null){
                	giroStand += oneBank.Betrag__c;
				}
        }// END for(Bank_Konto__c oneBank : mapBank1Giro.values())
        
   
        
        ObjBank1.add(new DebListObj__c(
                                                RowName__c = '667990343 Girokonto',
                                                debDueDate01__c = giroStand
                                                                        )
        );

        
        Double dFestgeldStand = 0.0;
        for(Bank_Konto__c oneBank : mapBank2.values()){
				if(oneBank.Betrag__c != null){
                        dFestgeldStand += oneBank.Betrag__c;
				}
                
                
        }// END for(Bank_Konto__c oneBank : mapBank1Giro.values())        
        ObjBank1.add(new DebListObj__c( RowName__c = '18379333 Festgeld',
                                debDueDate01__c = dFestgeldStand,
                                debDueDate02__c = dFestgeldStand,
                                debDueDate03__c = dFestgeldStand,
                                debDueDate04__c = dFestgeldStand,
                                debDueDate05__c = dFestgeldStand,
                                debDueDate06__c = dFestgeldStand,
                                debDueDate07__c = dFestgeldStand,
                                debDueDate08__c = dFestgeldStand,
                                debDueDate09__c = dFestgeldStand,
                                debDueDate10__c = dFestgeldStand,
                                debDueDate11__c = dFestgeldStand,
                                debDueDate12__c = dFestgeldStand,
                                debDueDate13__c = dFestgeldStand,
                                debDueDate14__c = dFestgeldStand,
                                debDueDate15__c = dFestgeldStand,
                                debDueDate16__c = dFestgeldStand,
                                debDueDate17__c = dFestgeldStand,
                                debDueDate18__c = dFestgeldStand,
                                debDueDate19__c = dFestgeldStand,
                                debDueDate20__c = dFestgeldStand,
                                debDueDate21__c = dFestgeldStand,
                                debDueDate22__c = dFestgeldStand,
                                debDueDate23__c = dFestgeldStand,
                                debDueDate24__c = dFestgeldStand,
                                debDueDate25__c = dFestgeldStand
                                ));

        Double dLinieStand = 0.0;
        for(Bank_Konto__c oneBank : mapBank3Linie.values()){
        	if(oneBank.Betrag__c != null){
                        dLinieStand += oneBank.Betrag__c;
        	}
                        
        }// END for(Bank_Konto__c oneBank : mapBank1Giro.values())   
             
        ObjBank1.add(new DebListObj__c( RowName__c = '667990343 Linie',
                                debDueDate01__c = dLinieStand,
                                debDueDate02__c = dLinieStand,
                                debDueDate03__c = dLinieStand,
                                debDueDate04__c = dLinieStand,
                                debDueDate05__c = dLinieStand,
                                debDueDate06__c = dLinieStand,
                                debDueDate07__c = dLinieStand,
                                debDueDate08__c = dLinieStand,
                                debDueDate09__c = dLinieStand,
                                debDueDate10__c = dLinieStand,
                                debDueDate11__c = dLinieStand,
                                debDueDate12__c = dLinieStand,
                                debDueDate13__c = dLinieStand,
                                debDueDate14__c = dLinieStand,
                                debDueDate15__c = dLinieStand,
                                debDueDate16__c = dLinieStand,
                                debDueDate17__c = dLinieStand,
                                debDueDate18__c = dLinieStand,
                                debDueDate19__c = dLinieStand,
                                debDueDate20__c = dLinieStand,
                                debDueDate21__c = dLinieStand,
                                debDueDate22__c = dLinieStand,
                                debDueDate23__c = dLinieStand,
                                debDueDate24__c = dLinieStand,
                                debDueDate25__c = dLinieStand
                                ));
                                
        Double dSamsungStand = 0.0;
        for(Bank_Konto__c oneBank : mapBank4Samsung.values()){
        		if( oneBank.Betrag__c != null){
                        dSamsungStand += oneBank.Betrag__c;
        		}
                        
        }// END for(Bank_Konto__c oneBank : mapBank1Giro.values())   
             
        ObjBank1.add(new DebListObj__c( RowName__c = '18858380 Samsung (Transfer)',
                                debDueDate01__c = dSamsungStand,
                                debDueDate02__c = dSamsungStand,
                                debDueDate03__c = dSamsungStand,
                                debDueDate04__c = dSamsungStand,
                                debDueDate05__c = dSamsungStand,
                                debDueDate06__c = dSamsungStand,
                                debDueDate07__c = dSamsungStand,
                                debDueDate08__c = dSamsungStand,
                                debDueDate09__c = dSamsungStand,
                                debDueDate10__c = dSamsungStand,
                                debDueDate11__c = dSamsungStand,
                                debDueDate12__c = dSamsungStand,
                                debDueDate13__c = dSamsungStand,
                                debDueDate14__c = dSamsungStand,
                                debDueDate15__c = dSamsungStand,
                                debDueDate16__c = dSamsungStand,
                                debDueDate17__c = dSamsungStand,
                                debDueDate18__c = dSamsungStand,
                                debDueDate19__c = dSamsungStand,
                                debDueDate20__c = dSamsungStand,
                                debDueDate21__c = dSamsungStand,
                                debDueDate22__c = dSamsungStand,
                                debDueDate23__c = dSamsungStand,
                                debDueDate24__c = dSamsungStand,
                                debDueDate25__c = dSamsungStand
                                ));
        
        Double dSparkontoStand = 0.0;
        for(Bank_Konto__c oneBank : mapBank5Sparkonto.values()){
        		if( oneBank.Betrag__c != null){
                        dSparkontoStand += oneBank.Betrag__c;
        		}
                        
        }  
             
        ObjBank1.add(new DebListObj__c( RowName__c = '23869250 Sparkonto',
                                debDueDate01__c = dSparkontoStand,
                                debDueDate02__c = dSparkontoStand,
                                debDueDate03__c = dSparkontoStand,
                                debDueDate04__c = dSparkontoStand,
                                debDueDate05__c = dSparkontoStand,
                                debDueDate06__c = dSparkontoStand,
                                debDueDate07__c = dSparkontoStand,
                                debDueDate08__c = dSparkontoStand,
                                debDueDate09__c = dSparkontoStand,
                                debDueDate10__c = dSparkontoStand,
                                debDueDate11__c = dSparkontoStand,
                                debDueDate12__c = dSparkontoStand,
                                debDueDate13__c = dSparkontoStand,
                                debDueDate14__c = dSparkontoStand,
                                debDueDate15__c = dSparkontoStand,
                                debDueDate16__c = dSparkontoStand,
                                debDueDate17__c = dSparkontoStand,
                                debDueDate18__c = dSparkontoStand,
                                debDueDate19__c = dSparkontoStand,
                                debDueDate20__c = dSparkontoStand,
                                debDueDate21__c = dSparkontoStand,
                                debDueDate22__c = dSparkontoStand,
                                debDueDate23__c = dSparkontoStand,
                                debDueDate24__c = dSparkontoStand,
                                debDueDate25__c = dSparkontoStand
                                ));        
        
        Double dUSDStand = 0.0;
        for(Bank_Konto__c oneBank : mapBank6USD.values()){
        		if( oneBank.Betrag__c != null){
                        dUSDStand += oneBank.Betrag__c;
        		}
                        
        }  
             
        ObjBank1.add(new DebListObj__c( RowName__c = '23821982 USD',
                                debDueDate01__c = dUSDStand,
                                debDueDate02__c = dUSDStand,
                                debDueDate03__c = dUSDStand,
                                debDueDate04__c = dUSDStand,
                                debDueDate05__c = dUSDStand,
                                debDueDate06__c = dUSDStand,
                                debDueDate07__c = dUSDStand,
                                debDueDate08__c = dUSDStand,
                                debDueDate09__c = dUSDStand,
                                debDueDate10__c = dUSDStand,
                                debDueDate11__c = dUSDStand,
                                debDueDate12__c = dUSDStand,
                                debDueDate13__c = dUSDStand,
                                debDueDate14__c = dUSDStand,
                                debDueDate15__c = dUSDStand,
                                debDueDate16__c = dUSDStand,
                                debDueDate17__c = dUSDStand,
                                debDueDate18__c = dUSDStand,
                                debDueDate19__c = dUSDStand,
                                debDueDate20__c = dUSDStand,
                                debDueDate21__c = dUSDStand,
                                debDueDate22__c = dUSDStand,
                                debDueDate23__c = dUSDStand,
                                debDueDate24__c = dUSDStand,
                                debDueDate25__c = dUSDStand
                                ));        
      

    } // END public void Fill_Bank()
    

    
    
    public void Fill_Kosten(){
       
        List<Kreditor__c> listEingRg = mapEingRgAll.values();
        
        for(Kreditor__c oneEinRg : listEingRg){
            Double dSumCurrentMonth = 0.0;
            Double dSumTillLastMonth = 0.0;
            Double dSumLastMonth = 0.0;
            Double dSumNextMonth = 0.0;
            
            // to calc the VAT
            Double dSumCurrentMonthVAT = 0.0;
            Double dSumTillLastMonthVAT = 0.0;
            Double dSumLastMonthVAT = 0.0;
            Double dSumNextMonthVAT = 0.0;
            
            DebListObj__c oneRowEinRg = new DebListObj__c(RowName__c = oneEinRg.Name + '; RgNr: ' + oneEinRg.Invoice_Number__c );
                DebListObj__c oneRowMwst = new DebListObj__c(RowName__c = oneEinRg.Name + '; RgNr: ' + oneEinRg.Invoice_Number__c );
            
                oneRowEinRg = initRow(oneRowEinRg);
                oneRowMwst = initRow(oneRowMwst);
                
  			String sUrl = System.URL.getSalesforceBaseUrl().getHost();
            
            sUrl = 'https://'
                            + sUrl.substring(2,6) 
                            + 'salesforce.com'
                            + '/'
                            + oneEinRg.Id;
                            
			oneRowEinRg.link__c = sUrl;
            
            for(Kreditor_Invoice_Status__c oneEinRgSt : oneEinRg.Kreditor_Invoice_Status__r){
                
                    if(oneEinRg.Invoice_due_on__c < dateToday){
                        oneRowEinRg.Overdue__c = true;
                        oneRowEinRg.debDueDate01__c = oneEinRg.Amount_total__c;
                        oneRowMwst.debDueDate01__c =oneEinRg.VAT_calc__c;
                    }else if(oneEinRg.Invoice_due_on__c == dateToday){
                        oneRowEinRg.debDueDate01__c =oneEinRg.Amount_total__c;
                        oneRowMwst.debDueDate01__c =oneEinRg.VAT_calc__c;
                    }else if(oneEinRg.Invoice_due_on__c == dateAfterToday){
                        oneRowEinRg.debDueDate02__c =oneEinRg.Amount_total__c;
                        oneRowMwst.debDueDate02__c =oneEinRg.VAT_calc__c;
                    }else if(oneEinRg.Invoice_due_on__c == date2){
                        oneRowEinRg.debDueDate03__c =oneEinRg.Amount_total__c;
                        oneRowMwst.debDueDate03__c =oneEinRg.VAT_calc__c;
                    }else if(oneEinRg.Invoice_due_on__c == date3){
                        oneRowEinRg.debDueDate04__c =oneEinRg.Amount_total__c;
                        oneRowMwst.debDueDate04__c =oneEinRg.VAT_calc__c;
                    }else if(oneEinRg.Invoice_due_on__c == date4){
                        oneRowEinRg.debDueDate05__c =oneEinRg.Amount_total__c;
                        oneRowMwst.debDueDate05__c =oneEinRg.VAT_calc__c;
                    }else if(oneEinRg.Invoice_due_on__c == date5){
                        oneRowEinRg.debDueDate06__c =oneEinRg.Amount_total__c;
                        oneRowMwst.debDueDate06__c =oneEinRg.VAT_calc__c;
                    }else if(oneEinRg.Invoice_due_on__c == date6){
                        oneRowEinRg.debDueDate07__c =oneEinRg.Amount_total__c;
                        oneRowMwst.debDueDate07__c =oneEinRg.VAT_calc__c;
                    }else if(oneEinRg.Invoice_due_on__c == date7){
                        oneRowEinRg.debDueDate08__c =oneEinRg.Amount_total__c;
                        oneRowMwst.debDueDate08__c =oneEinRg.VAT_calc__c;
                    }else if(oneEinRg.Invoice_due_on__c == date8){
                        oneRowEinRg.debDueDate09__c =oneEinRg.Amount_total__c;
                        oneRowMwst.debDueDate09__c =oneEinRg.VAT_calc__c;
                    }else if(oneEinRg.Invoice_due_on__c == date9){
                        oneRowEinRg.debDueDate10__c =oneEinRg.Amount_total__c;
                        oneRowMwst.debDueDate10__c =oneEinRg.VAT_calc__c;
                    }else if(oneEinRg.Invoice_due_on__c == date10){
                        oneRowEinRg.debDueDate11__c =oneEinRg.Amount_total__c;
                        oneRowMwst.debDueDate11__c =oneEinRg.VAT_calc__c;
                    }else if(oneEinRg.Invoice_due_on__c == date11){
                        oneRowEinRg.debDueDate12__c =oneEinRg.Amount_total__c;
                        oneRowMwst.debDueDate12__c =oneEinRg.VAT_calc__c;
                    }else if(oneEinRg.Invoice_due_on__c == date12){
                        oneRowEinRg.debDueDate13__c =oneEinRg.Amount_total__c;
                        oneRowMwst.debDueDate13__c =oneEinRg.VAT_calc__c;
                        
                    }else if(oneEinRg.Invoice_due_on__c == date13){
                        oneRowEinRg.debDueDate14__c =oneEinRg.Amount_total__c;
                        oneRowMwst.debDueDate14__c =oneEinRg.VAT_calc__c;
                    }else if(oneEinRg.Invoice_due_on__c == date14){
                        oneRowEinRg.debDueDate15__c =oneEinRg.Amount_total__c;
                        oneRowMwst.debDueDate15__c =oneEinRg.VAT_calc__c;
                    }else if(oneEinRg.Invoice_due_on__c > date14 && oneEinRg.Invoice_due_on__c <= date_endWeek3){ //Woche 3
                        oneRowEinRg.debDueDate16__c += oneEinRg.Amount_total__c;
                        oneRowMwst.debDueDate16__c +=oneEinRg.VAT_calc__c;
                    }else if(oneEinRg.Invoice_due_on__c > date_endWeek3 && oneEinRg.Invoice_due_on__c <= date_endWeek4){ //Woche 4
                        oneRowEinRg.debDueDate17__c += oneEinRg.Amount_total__c;
                        oneRowMwst.debDueDate17__c +=oneEinRg.VAT_calc__c;
                    }else if(oneEinRg.Invoice_due_on__c > date_endWeek4 && oneEinRg.Invoice_due_on__c <= date_endWeek5){ // Woche 5
                        oneRowEinRg.debDueDate18__c += oneEinRg.Amount_total__c;
                        oneRowMwst.debDueDate18__c +=oneEinRg.VAT_calc__c;
                    }else if(oneEinRg.Invoice_due_on__c > date_endWeek5 && oneEinRg.Invoice_due_on__c <= date_endWeek6){ // Woche 6
                        oneRowEinRg.debDueDate19__c += oneEinRg.Amount_total__c;
                        oneRowMwst.debDueDate19__c +=oneEinRg.VAT_calc__c;
                    }else if(oneEinRg.Invoice_due_on__c > date_endWeek6 && oneEinRg.Invoice_due_on__c <= date_endWeek7){ // Woche 7
                        oneRowEinRg.debDueDate20__c += oneEinRg.Amount_total__c;
                        oneRowMwst.debDueDate20__c +=oneEinRg.VAT_calc__c;
                    }else if(oneEinRg.Invoice_due_on__c > date_endWeek7 && oneEinRg.Invoice_due_on__c <= date_endWeek8){ // Woche8
                        oneRowEinRg.debDueDate21__c += oneEinRg.Amount_total__c;
                        oneRowMwst.debDueDate21__c +=oneEinRg.VAT_calc__c;
                    }else if(oneEinRg.Invoice_due_on__c > date_endWeek8 && oneEinRg.Invoice_due_on__c <= date_endWeek9){
                        oneRowEinRg.debDueDate22__c += oneEinRg.Amount_total__c;
                        oneRowMwst.debDueDate22__c +=oneEinRg.VAT_calc__c;
                    }else if(oneEinRg.Invoice_due_on__c > date_endWeek9 && oneEinRg.Invoice_due_on__c <= date_endWeek10){
                        oneRowEinRg.debDueDate23__c += oneEinRg.Amount_total__c;
                        oneRowMwst.debDueDate23__c +=oneEinRg.VAT_calc__c;
                    }else if(oneEinRg.Invoice_due_on__c > date_endWeek10 && oneEinRg.Invoice_due_on__c <= date_endWeek11){
                        oneRowEinRg.debDueDate24__c += oneEinRg.Amount_total__c;
                        oneRowMwst.debDueDate24__c +=oneEinRg.VAT_calc__c;
                    }else if(oneEinRg.Invoice_due_on__c > date_endWeek11 && oneEinRg.Invoice_due_on__c <= date_endWeek12){
                        oneRowEinRg.debDueDate25__c += oneEinRg.Amount_total__c;
                        oneRowMwst.debDueDate25__c +=oneEinRg.VAT_calc__c;
                    }
                        
                        
                    
                           
            }// END for(Kreditor_Invoice_Status__c oneEinRgSt : oneEinRg.Kreditor_Invoice_Status__r)
            ObjKosten.add(oneRowEinRg);
            ObjMwStKosten.add(oneRowMwst);
                     
        }// END for(Kreditor__c oneEinRg : listEingRg)
    }// END public void Fill_Kosten()
    
    
        private DebListObj__c initRow(DebListObj__c oneRow){
                oneRow.debDueDate01__c = 0.0;
                oneRow.debDueDate02__c = 0.0;
                oneRow.debDueDate03__c = 0.0;
                oneRow.debDueDate04__c = 0.0;
                oneRow.debDueDate05__c = 0.0;
                oneRow.debDueDate06__c = 0.0;
                oneRow.debDueDate07__c = 0.0;
                oneRow.debDueDate08__c = 0.0;
                oneRow.debDueDate09__c = 0.0;
                oneRow.debDueDate10__c = 0.0;
                oneRow.debDueDate11__c = 0.0;
                oneRow.debDueDate12__c = 0.0;
                oneRow.debDueDate13__c = 0.0;
                oneRow.debDueDate14__c = 0.0;
                oneRow.debDueDate15__c = 0.0;
                oneRow.debDueDate16__c = 0.0;
                oneRow.debDueDate17__c = 0.0;
                oneRow.debDueDate18__c = 0.0;
                oneRow.debDueDate19__c = 0.0;
                oneRow.debDueDate20__c = 0.0;
                oneRow.debDueDate21__c = 0.0;
                oneRow.debDueDate22__c = 0.0;
                oneRow.debDueDate23__c = 0.0;
                oneRow.debDueDate24__c = 0.0;
                oneRow.debDueDate25__c = 0.0;
                
                return oneRow;
        }   
        
        
    private DebListObj__c Calculate_SUM_DebListObj(List<DebListObj__c> ListTable){
        Double[] doubleSumArray = new Double[]{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
        
        for(DebListObj__c oneRow : ListTable){
        		if(oneRow.RowName__c != '18858380 Samsung (Transfer)'){//dont sum up Samsung account into cashFlow
	                if(oneRow.debDueDate01__c != null && oneRow.debDueDate01__c != 0.0){
	                        doubleSumArray[0] += oneRow.debDueDate01__c;
	                }
	                if(oneRow.debDueDate02__c != null && oneRow.debDueDate02__c != 0.0){
	                        doubleSumArray[1] += oneRow.debDueDate02__c;
	                }
	                if(oneRow.debDueDate03__c != null && oneRow.debDueDate03__c != 0.0){
	                        doubleSumArray[2] += oneRow.debDueDate03__c;
	                }
	                if(oneRow.debDueDate04__c != null && oneRow.debDueDate04__c != 0.0){
	                        doubleSumArray[3] += oneRow.debDueDate04__c;
	                }
	                if(oneRow.debDueDate05__c != null && oneRow.debDueDate05__c != 0.0){
	                        doubleSumArray[4] += oneRow.debDueDate05__c;
	                }
	                if(oneRow.debDueDate06__c != null && oneRow.debDueDate06__c != 0.0){
	                        doubleSumArray[5] += oneRow.debDueDate06__c;
	                }
	                if(oneRow.debDueDate07__c != null && oneRow.debDueDate07__c != 0.0){
	                        doubleSumArray[6] += oneRow.debDueDate07__c;
	                }
	                if(oneRow.debDueDate08__c != null && oneRow.debDueDate08__c != 0.0){
	                        doubleSumArray[7] += oneRow.debDueDate08__c;
	                }
	                if(oneRow.debDueDate09__c != null && oneRow.debDueDate09__c != 0.0){
	                        doubleSumArray[8] += oneRow.debDueDate09__c;
	                }
	                if(oneRow.debDueDate10__c != null && oneRow.debDueDate10__c != 0.0){
	                        doubleSumArray[9] += oneRow.debDueDate10__c;
	                }
	                if(oneRow.debDueDate11__c != null && oneRow.debDueDate11__c != 0.0){
	                        doubleSumArray[10] += oneRow.debDueDate11__c;
	                }
	                if(oneRow.debDueDate12__c != null && oneRow.debDueDate12__c != 0.0){
	                        doubleSumArray[11] += oneRow.debDueDate12__c;
	                }
	                if(oneRow.debDueDate13__c != null && oneRow.debDueDate13__c != 0.0){
	                        doubleSumArray[12] += oneRow.debDueDate13__c;
	                }
	                if(oneRow.debDueDate14__c != null && oneRow.debDueDate14__c != 0.0){
	                        doubleSumArray[13] += oneRow.debDueDate14__c;
	                }
	                if(oneRow.debDueDate15__c != null && oneRow.debDueDate15__c != 0.0){
	                        doubleSumArray[14] += oneRow.debDueDate15__c;
	                }
	                if(oneRow.debDueDate16__c != null && oneRow.debDueDate16__c != 0.0){
	                        doubleSumArray[15] += oneRow.debDueDate16__c;
	                }
	                if(oneRow.debDueDate17__c != null && oneRow.debDueDate17__c != 0.0){
	                        doubleSumArray[16] += oneRow.debDueDate17__c;
	                }
	                if(oneRow.debDueDate18__c != null && oneRow.debDueDate18__c != 0.0){
	                        doubleSumArray[17] += oneRow.debDueDate18__c;
	                }
	                if(oneRow.debDueDate19__c != null && oneRow.debDueDate19__c != 0.0){
	                        doubleSumArray[18] += oneRow.debDueDate19__c;
	                }
	                if(oneRow.debDueDate20__c != null && oneRow.debDueDate20__c != 0.0){
	                        doubleSumArray[19] += oneRow.debDueDate20__c;
	                }
	                if(oneRow.debDueDate21__c != null && oneRow.debDueDate21__c != 0.0){
	                        doubleSumArray[20] += oneRow.debDueDate21__c;
	                }
	                if(oneRow.debDueDate22__c != null && oneRow.debDueDate22__c != 0.0){
	                        doubleSumArray[21] += oneRow.debDueDate22__c;
	                }
	                if(oneRow.debDueDate23__c != null && oneRow.debDueDate23__c != 0.0){
	                        doubleSumArray[22] += oneRow.debDueDate23__c;
	                }
	                if(oneRow.debDueDate24__c != null && oneRow.debDueDate24__c != 0.0){
	                        doubleSumArray[23] += oneRow.debDueDate24__c;
	                }
	                if(oneRow.debDueDate25__c != null && oneRow.debDueDate25__c != 0.0){
	                        doubleSumArray[24] += oneRow.debDueDate25__c;
	                }
        		}//if(oneRow.RowName__c != '18858380 Samsung (Transfer)')
        }//for(DebListObj__c oneRow : ListTable)
        DebListObj__c OneRow = new DebListObj__c (RowName__c = 'Summe', 
                                        debDueDate01__c = doubleSumArray[0],
                                        debDueDate02__c = doubleSumArray[1],
                                        debDueDate03__c = doubleSumArray[2],
                                        debDueDate04__c = doubleSumArray[3],
                                        debDueDate05__c = doubleSumArray[4],
                                        debDueDate06__c = doubleSumArray[5],
                                        debDueDate07__c = doubleSumArray[6],
                                        debDueDate08__c = doubleSumArray[7],
                                        debDueDate09__c = doubleSumArray[8],
                                        debDueDate10__c = doubleSumArray[9],
                                        debDueDate11__c = doubleSumArray[10],
                                        debDueDate12__c = doubleSumArray[11],
                                        debDueDate13__c = doubleSumArray[12],
                                        debDueDate14__c = doubleSumArray[13],
                                        debDueDate15__c = doubleSumArray[14],
                                        debDueDate16__c = doubleSumArray[15],
                                        debDueDate17__c = doubleSumArray[16],
                                        debDueDate18__c = doubleSumArray[17],
                                        debDueDate19__c = doubleSumArray[18],
                                        debDueDate20__c = doubleSumArray[19],
                                        debDueDate21__c = doubleSumArray[20],
                                        debDueDate22__c = doubleSumArray[21],
                                        debDueDate23__c = doubleSumArray[22],
                                        debDueDate24__c = doubleSumArray[23],
                                        debDueDate25__c = doubleSumArray[24]
                                        );
        return OneRow;
    }// END private DebListObj__c Calculate_SUM_DebListObj(List<DebListObj__c> ListTable)
  
    
    
    public void Fill_OPOSDebitInvoices(){
        
                for(Debitoren_Rechnung__c oneDebRg : mapAusgRgAll.values()){
                		System.debug('**********DEBUG: ID: '+oneDebRg.Id);
                		System.debug('**********DEBUG: Opp: '+oneDebRg.Opportunity__c);
						DebListObj__c oneRow;
                        //DebListObj__c oneRow = new DebListObj__c(RowName__c = oneDebRg.Name + ' ; '+ mapOpportunityOut.get(oneDebRg.Opportunity__c).Name);
                        /*String sOppName = mapOpportunityOut.get(oneDebRg.Opportunity__c).Name;
                        if(sOppName == null){
                        	oneRow = new DebListObj__c(RowName__c = oneDebRg.Name);	
                        }else{
                        	oneRow = new DebListObj__c(RowName__c = oneDebRg.Name + ' ; '+ sOppName);
                        }*/
                        
                        if(mapOpportunityOut.containsKey(oneDebRg.Opportunity__c)){
                        	oneRow = new DebListObj__c(RowName__c = oneDebRg.Name + ' ; '+ mapOpportunityOut.get(oneDebRg.Opportunity__c).Name);
                        }else{
                        	oneRow = new DebListObj__c(RowName__c = oneDebRg.Name);
                        }
                         
                        oneRow = initRow(oneRow);
                        String sUrl = System.URL.getSalesforceBaseUrl().getHost();
            
			            sUrl = 'https://'
			                            + sUrl.substring(2,6) 
			                            + 'salesforce.com'
			                            + '/'
			                            + oneDebRg.Id;
			                            
						oneRow.link__c = sUrl;
            
                        
                        //oneRowMwst = initRow(oneRowMwst);
                        if(oneDebRg.Due_Date__c < dateToday){
                                oneRow.Overdue__c = true;
                                oneRow.debDueDate01__c = oneDebRg.Invoice_Amount_total__c;
                        //      oneRowMwst.debDueDate01__c = oneDebRg.VAT_calc__c;
                        }else if(oneDebRg.Due_Date__c == dateToday){
                                oneRow.debDueDate01__c = oneDebRg.Invoice_Amount_total__c;
                        //      oneRowMwst.debDueDate01__c = oneDebRg.VAT_calc__c;
                        }else if(oneDebRg.Due_Date__c == dateAfterToday){
                                oneRow.debDueDate02__c = oneDebRg.Invoice_Amount_total__c;
                        //      oneRowMwst.debDueDate02__c = oneDebRg.VAT_calc__c;
                        }else if(oneDebRg.Due_Date__c == date2){
                                oneRow.debDueDate03__c = oneDebRg.Invoice_Amount_total__c;
                        //      oneRowMwst.debDueDate03__c = oneDebRg.VAT_calc__c;
                        }else if(oneDebRg.Due_Date__c == date3){
                                oneRow.debDueDate04__c = oneDebRg.Invoice_Amount_total__c;
                        //      oneRowMwst.debDueDate04__c = oneDebRg.VAT_calc__c;
                        }else if(oneDebRg.Due_Date__c == date4){
                                oneRow.debDueDate05__c = oneDebRg.Invoice_Amount_total__c;
                        //      oneRowMwst.debDueDate05__c = oneDebRg.VAT_calc__c;
                        }else if(oneDebRg.Due_Date__c == date5){
                                oneRow.debDueDate06__c = oneDebRg.Invoice_Amount_total__c;
                        //      oneRowMwst.debDueDate06__c = oneDebRg.VAT_calc__c;
                        }else if(oneDebRg.Due_Date__c == date6){
                                oneRow.debDueDate07__c = oneDebRg.Invoice_Amount_total__c;
                        //      oneRowMwst.debDueDate07__c = oneDebRg.VAT_calc__c;
                        }else if(oneDebRg.Due_Date__c == date7){
                                oneRow.debDueDate08__c = oneDebRg.Invoice_Amount_total__c;
                        //      oneRowMwst.debDueDate08__c = oneDebRg.VAT_calc__c;
                        }else if(oneDebRg.Due_Date__c == date8){
                                oneRow.debDueDate09__c = oneDebRg.Invoice_Amount_total__c;
                        //      oneRowMwst.debDueDate09__c = oneDebRg.VAT_calc__c;
                        }else if(oneDebRg.Due_Date__c == date9){
                                oneRow.debDueDate10__c = oneDebRg.Invoice_Amount_total__c;
                        //      oneRowMwst.debDueDate10__c = oneDebRg.VAT_calc__c;
                        }else if(oneDebRg.Due_Date__c == date10){
                                oneRow.debDueDate11__c = oneDebRg.Invoice_Amount_total__c;
                        //      oneRowMwst.debDueDate11__c = oneDebRg.VAT_calc__c;
                        }else if(oneDebRg.Due_Date__c == date11){
                                oneRow.debDueDate12__c = oneDebRg.Invoice_Amount_total__c;
                        //      oneRowMwst.debDueDate12__c = oneDebRg.VAT_calc__c;
                        }else if(oneDebRg.Due_Date__c == date12){
                                oneRow.debDueDate13__c = oneDebRg.Invoice_Amount_total__c;
                        //      oneRowMwst.debDueDate13__c = oneDebRg.VAT_calc__c;
                        }else if(oneDebRg.Due_Date__c == date13){
                                oneRow.debDueDate14__c = oneDebRg.Invoice_Amount_total__c;
                        //      oneRowMwst.debDueDate14__c = oneDebRg.VAT_calc__c;
                        }else if(oneDebRg.Due_Date__c == date14){
                                oneRow.debDueDate15__c = oneDebRg.Invoice_Amount_total__c;
                        //      oneRowMwst.debDueDate15__c = oneDebRg.VAT_calc__c;
                        }else if(oneDebRg.Due_Date__c > date14 && oneDebRg.Due_Date__c <= date_endWeek3){ //Woche 3
                oneRow.debDueDate16__c += oneDebRg.Invoice_Amount_total__c;
            //  oneRowMwst.debDueDate16__c +=oneDebRg.VAT_calc__c;
            }else if(oneDebRg.Due_Date__c > date_endWeek3 && oneDebRg.Due_Date__c <= date_endWeek4){ //Woche 4
                oneRow.debDueDate17__c += oneDebRg.Invoice_Amount_total__c;
            //  oneRowMwst.debDueDate17__c +=oneDebRg.VAT_calc__c;
            }else if(oneDebRg.Due_Date__c > date_endWeek4 && oneDebRg.Due_Date__c <= date_endWeek5){ // Woche 5
                oneRow.debDueDate18__c += oneDebRg.Invoice_Amount_total__c;
            //  oneRowMwst.debDueDate18__c +=oneDebRg.VAT_calc__c;
            }else if(oneDebRg.Due_Date__c > date_endWeek5 && oneDebRg.Due_Date__c <= date_endWeek6){ // Woche 6
                oneRow.debDueDate19__c += oneDebRg.Invoice_Amount_total__c;
            //  oneRowMwst.debDueDate19__c +=oneDebRg.VAT_calc__c;
            }else if(oneDebRg.Due_Date__c > date_endWeek6 && oneDebRg.Due_Date__c <= date_endWeek7){ // Woche 7
                oneRow.debDueDate20__c += oneDebRg.Invoice_Amount_total__c;
            //  oneRowMwst.debDueDate20__c +=oneDebRg.VAT_calc__c;
            }else if(oneDebRg.Due_Date__c > date_endWeek7 && oneDebRg.Due_Date__c <= date_endWeek8){ // Woche8
                oneRow.debDueDate21__c += oneDebRg.Invoice_Amount_total__c;
            //  oneRowMwst.debDueDate21__c +=oneDebRg.VAT_calc__c;
            }else if(oneDebRg.Due_Date__c > date_endWeek8 && oneDebRg.Due_Date__c <= date_endWeek9){
                oneRow.debDueDate22__c += oneDebRg.Invoice_Amount_total__c;
            }else if(oneDebRg.Due_Date__c > date_endWeek9 && oneDebRg.Due_Date__c <= date_endWeek10){
                oneRow.debDueDate23__c += oneDebRg.Invoice_Amount_total__c;
            }else if(oneDebRg.Due_Date__c > date_endWeek10 && oneDebRg.Due_Date__c <= date_endWeek11){
                oneRow.debDueDate24__c += oneDebRg.Invoice_Amount_total__c;
            }else if(oneDebRg.Due_Date__c > date_endWeek11 && oneDebRg.Due_Date__c <= date_endWeek12){
                oneRow.debDueDate25__c += oneDebRg.Invoice_Amount_total__c;
            }
                        
                        ObjOPOSDebitInvoices.add(oneRow);
                        //ObjMwStUmsatz.add(oneRowMwst);
    }
        
        
        
    }// END public void Fill_OPOSDebitInvoices()
    
    
    public void Fill_ObjCashFlow(){
        //Double sumBank1 = Calculate_SUM_DebListObj(ObjBank1);
        //DebListObj__c sumKostenOPOS = Calculate_SUM_DebListObj(ObjOPOSKreditInvoices);
        //DebListObj__c sumMwst = Calculate_SUM_DebListObj(ObjMwst);
        //ObjOPOSDebitInvoices
        //ObjOPOSKreditInvoices
        //DebListObj__c sumUmsatz = Calculate_SUM_DebListObj(ObjUmsatz);
        
                
        DebListObj__c sumBank = Calculate_SUM_DebListObj(ObjBank1);
        DebListObj__c sumUmsatzOPOS = Calculate_SUM_DebListObj(ObjOPOSDebitInvoices);
        DebListObj__c sumKosten = Calculate_SUM_DebListObj(ObjKosten);
        
        
        DebListObj__c cashFlow = new DebListObj__c (
                RowName__c = 'Cash Flow'
        );
        
        
        cashFlow.debDueDate01__c = ObjBank1[0].debDueDate01__c + ObjBank1[1].debDueDate01__c + ObjBank1[2].debDueDate01__c + ObjInvestExpenses[0].debDueDate01__c;
        
                ObjBank1[0].debDueDate02__c = ObjBank1[0].debDueDate01__c + ObjInvestExpenses[0].debDueDate01__c;
        
        cashFlow.debDueDate02__c = ObjBank1[0].debDueDate02__c + ObjBank1[1].debDueDate02__c + ObjBank1[2].debDueDate02__c + ObjInvestExpenses[0].debDueDate02__c;
        
                ObjBank1[0].debDueDate03__c = ObjBank1[0].debDueDate02__c + ObjInvestExpenses[0].debDueDate02__c;
                
        cashFlow.debDueDate03__c = ObjBank1[0].debDueDate03__c + ObjBank1[1].debDueDate03__c + ObjBank1[2].debDueDate03__c + ObjInvestExpenses[0].debDueDate03__c;
                
                ObjBank1[0].debDueDate04__c = ObjBank1[0].debDueDate03__c + ObjInvestExpenses[0].debDueDate03__c;
        
        cashFlow.debDueDate04__c = ObjBank1[0].debDueDate04__c + ObjBank1[1].debDueDate04__c + ObjBank1[2].debDueDate04__c + ObjInvestExpenses[0].debDueDate04__c;
        
                ObjBank1[0].debDueDate05__c = ObjBank1[0].debDueDate04__c + ObjInvestExpenses[0].debDueDate04__c;
                
        cashFlow.debDueDate05__c = ObjBank1[0].debDueDate05__c + ObjBank1[1].debDueDate05__c + ObjBank1[2].debDueDate05__c + ObjInvestExpenses[0].debDueDate05__c;
        
                ObjBank1[0].debDueDate06__c = ObjBank1[0].debDueDate05__c + ObjInvestExpenses[0].debDueDate05__c;
                
        cashFlow.debDueDate06__c = ObjBank1[0].debDueDate06__c + ObjBank1[1].debDueDate06__c + ObjBank1[2].debDueDate06__c + ObjInvestExpenses[0].debDueDate06__c;
        
                ObjBank1[0].debDueDate07__c = ObjBank1[0].debDueDate06__c + ObjInvestExpenses[0].debDueDate06__c;
        
        cashFlow.debDueDate07__c = ObjBank1[0].debDueDate07__c + ObjBank1[1].debDueDate07__c + ObjBank1[2].debDueDate07__c + ObjInvestExpenses[0].debDueDate07__c;
        
                ObjBank1[0].debDueDate08__c = ObjBank1[0].debDueDate07__c + ObjInvestExpenses[0].debDueDate07__c;
                
        cashFlow.debDueDate08__c = ObjBank1[0].debDueDate08__c + ObjBank1[1].debDueDate08__c + ObjBank1[2].debDueDate08__c + ObjInvestExpenses[0].debDueDate08__c;
        
                ObjBank1[0].debDueDate09__c = ObjBank1[0].debDueDate08__c + ObjInvestExpenses[0].debDueDate08__c;       
                
        cashFlow.debDueDate09__c = ObjBank1[0].debDueDate09__c + ObjBank1[1].debDueDate09__c + ObjBank1[2].debDueDate09__c + ObjInvestExpenses[0].debDueDate09__c;
        
                ObjBank1[0].debDueDate10__c = ObjBank1[0].debDueDate09__c + ObjInvestExpenses[0].debDueDate09__c;
                
        cashFlow.debDueDate10__c = ObjBank1[0].debDueDate10__c + ObjBank1[1].debDueDate10__c + ObjBank1[2].debDueDate10__c + ObjInvestExpenses[0].debDueDate10__c;
        
                ObjBank1[0].debDueDate11__c = ObjBank1[0].debDueDate10__c + ObjInvestExpenses[0].debDueDate10__c;
                
        cashFlow.debDueDate11__c = ObjBank1[0].debDueDate11__c + ObjBank1[1].debDueDate11__c + ObjBank1[2].debDueDate11__c + ObjInvestExpenses[0].debDueDate11__c;
        
                ObjBank1[0].debDueDate12__c = ObjBank1[0].debDueDate11__c + ObjInvestExpenses[0].debDueDate11__c;
        
        cashFlow.debDueDate12__c = ObjBank1[0].debDueDate12__c + ObjBank1[1].debDueDate12__c + ObjBank1[2].debDueDate12__c + ObjInvestExpenses[0].debDueDate12__c;
        
                ObjBank1[0].debDueDate13__c = ObjBank1[0].debDueDate12__c + ObjInvestExpenses[0].debDueDate12__c;
                
        cashFlow.debDueDate13__c = ObjBank1[0].debDueDate13__c + ObjBank1[1].debDueDate13__c + ObjBank1[2].debDueDate13__c + ObjInvestExpenses[0].debDueDate13__c;
        
                ObjBank1[0].debDueDate14__c = ObjBank1[0].debDueDate13__c + ObjInvestExpenses[0].debDueDate13__c;
                
        cashFlow.debDueDate14__c = ObjBank1[0].debDueDate14__c + ObjBank1[1].debDueDate14__c + ObjBank1[2].debDueDate14__c + ObjInvestExpenses[0].debDueDate14__c;
        
                ObjBank1[0].debDueDate15__c = ObjBank1[0].debDueDate14__c + ObjInvestExpenses[0].debDueDate14__c;
                
        cashFlow.debDueDate15__c = ObjBank1[0].debDueDate15__c + ObjBank1[1].debDueDate15__c + ObjBank1[2].debDueDate15__c + ObjInvestExpenses[0].debDueDate15__c;
        
                ObjBank1[0].debDueDate16__c = ObjBank1[0].debDueDate15__c + ObjInvestExpenses[0].debDueDate15__c;
        
        cashFlow.debDueDate16__c = ObjBank1[0].debDueDate16__c + ObjBank1[1].debDueDate16__c + ObjBank1[2].debDueDate16__c + ObjInvestExpenses[0].debDueDate16__c;
        
                ObjBank1[0].debDueDate17__c = ObjBank1[0].debDueDate16__c + ObjInvestExpenses[0].debDueDate16__c;
                
        cashFlow.debDueDate17__c = ObjBank1[0].debDueDate17__c + ObjBank1[1].debDueDate17__c + ObjBank1[2].debDueDate17__c + ObjInvestExpenses[0].debDueDate17__c;
        
                ObjBank1[0].debDueDate18__c = ObjBank1[0].debDueDate17__c + ObjInvestExpenses[0].debDueDate17__c;
                
        cashFlow.debDueDate18__c = ObjBank1[0].debDueDate18__c + ObjBank1[1].debDueDate18__c + ObjBank1[2].debDueDate18__c + ObjInvestExpenses[0].debDueDate18__c;
        
                ObjBank1[0].debDueDate19__c = ObjBank1[0].debDueDate18__c + ObjInvestExpenses[0].debDueDate18__c;
                
        cashFlow.debDueDate19__c = ObjBank1[0].debDueDate19__c + ObjBank1[1].debDueDate19__c + ObjBank1[2].debDueDate19__c + ObjInvestExpenses[0].debDueDate19__c;
        
                ObjBank1[0].debDueDate20__c = ObjBank1[0].debDueDate19__c + ObjInvestExpenses[0].debDueDate19__c;
                
        cashFlow.debDueDate20__c = ObjBank1[0].debDueDate20__c + ObjBank1[1].debDueDate20__c + ObjBank1[2].debDueDate20__c + ObjInvestExpenses[0].debDueDate20__c;
        
                ObjBank1[0].debDueDate21__c = ObjBank1[0].debDueDate20__c + ObjInvestExpenses[0].debDueDate20__c;
                
        cashFlow.debDueDate21__c = ObjBank1[0].debDueDate21__c + ObjBank1[1].debDueDate21__c + ObjBank1[2].debDueDate21__c + ObjInvestExpenses[0].debDueDate21__c;
        
                ObjBank1[0].debDueDate22__c = ObjBank1[0].debDueDate21__c + ObjInvestExpenses[0].debDueDate21__c;
        
        cashFlow.debDueDate22__c = ObjBank1[0].debDueDate22__c + ObjBank1[1].debDueDate22__c + ObjBank1[2].debDueDate22__c + ObjInvestExpenses[0].debDueDate22__c;
        
                ObjBank1[0].debDueDate23__c = ObjBank1[0].debDueDate22__c + ObjInvestExpenses[0].debDueDate22__c;
                
        cashFlow.debDueDate23__c = ObjBank1[0].debDueDate23__c + ObjBank1[1].debDueDate23__c + ObjBank1[2].debDueDate23__c + ObjInvestExpenses[0].debDueDate23__c;
        
                ObjBank1[0].debDueDate24__c = ObjBank1[0].debDueDate23__c + ObjInvestExpenses[0].debDueDate23__c;
        
        cashFlow.debDueDate24__c = ObjBank1[0].debDueDate24__c + ObjBank1[1].debDueDate24__c + ObjBank1[2].debDueDate24__c + ObjInvestExpenses[0].debDueDate24__c;
        
                ObjBank1[0].debDueDate25__c = ObjBank1[0].debDueDate24__c + ObjInvestExpenses[0].debDueDate24__c;
                
        cashFlow.debDueDate25__c = ObjBank1[0].debDueDate25__c + ObjBank1[1].debDueDate25__c + ObjBank1[2].debDueDate25__c + ObjInvestExpenses[0].debDueDate25__c;
                
        ObjCashFlow.add(cashFlow);
        
        
        myChartData.add(new ChartData(10000000.00,ObjBank1[0].debDueDate01__c,cashFlow.debDueDate01__c,ObjInvestExpenses[0].debDueDate01__c,sumTurnover.debDueDate01__c,sumUmsatzOPOS.debDueDate01__c,sumKosten.debDueDate01__c,String.valueOf(dateToday),135000.00));
        myChartData.add(new ChartData(10000000.00,ObjBank1[0].debDueDate02__c,cashFlow.debDueDate02__c,ObjInvestExpenses[0].debDueDate02__c,sumTurnover.debDueDate02__c,sumUmsatzOPOS.debDueDate02__c,sumKosten.debDueDate02__c,String.valueOf(dateAfterToday),135000.00));
        myChartData.add(new ChartData(10000000.00,ObjBank1[0].debDueDate03__c,cashFlow.debDueDate03__c,ObjInvestExpenses[0].debDueDate03__c,sumTurnover.debDueDate03__c,sumUmsatzOPOS.debDueDate03__c,sumKosten.debDueDate03__c,String.valueOf(date2),135000.00));
        myChartData.add(new ChartData(10000000.00,ObjBank1[0].debDueDate04__c,cashFlow.debDueDate04__c,ObjInvestExpenses[0].debDueDate04__c,sumTurnover.debDueDate04__c,sumUmsatzOPOS.debDueDate04__c,sumKosten.debDueDate04__c,String.valueOf(date3),135000.00));
        myChartData.add(new ChartData(10000000.00,ObjBank1[0].debDueDate05__c,cashFlow.debDueDate05__c,ObjInvestExpenses[0].debDueDate05__c,sumTurnover.debDueDate05__c,sumUmsatzOPOS.debDueDate05__c,sumKosten.debDueDate05__c,String.valueOf(date4),135000.00));
        myChartData.add(new ChartData(10000000.00,ObjBank1[0].debDueDate06__c,cashFlow.debDueDate06__c,ObjInvestExpenses[0].debDueDate06__c,sumTurnover.debDueDate06__c,sumUmsatzOPOS.debDueDate06__c,sumKosten.debDueDate06__c,String.valueOf(date5),135000.00));
        myChartData.add(new ChartData(10000000.00,ObjBank1[0].debDueDate07__c,cashFlow.debDueDate07__c,ObjInvestExpenses[0].debDueDate07__c,sumTurnover.debDueDate07__c,sumUmsatzOPOS.debDueDate07__c,sumKosten.debDueDate07__c,String.valueOf(date6),135000.00));
        myChartData.add(new ChartData(10000000.00,ObjBank1[0].debDueDate08__c,cashFlow.debDueDate08__c,ObjInvestExpenses[0].debDueDate08__c,sumTurnover.debDueDate08__c,sumUmsatzOPOS.debDueDate08__c,sumKosten.debDueDate08__c,String.valueOf(date7),135000.00));
        myChartData.add(new ChartData(10000000.00,ObjBank1[0].debDueDate09__c,cashFlow.debDueDate09__c,ObjInvestExpenses[0].debDueDate09__c,sumTurnover.debDueDate09__c,sumUmsatzOPOS.debDueDate09__c,sumKosten.debDueDate09__c,String.valueOf(date8),135000.00));
        myChartData.add(new ChartData(10000000.00,ObjBank1[0].debDueDate10__c,cashFlow.debDueDate10__c,ObjInvestExpenses[0].debDueDate10__c,sumTurnover.debDueDate10__c,sumUmsatzOPOS.debDueDate10__c,sumKosten.debDueDate10__c,String.valueOf(date9),135000.00));
        myChartData.add(new ChartData(10000000.00,ObjBank1[0].debDueDate11__c,cashFlow.debDueDate11__c,ObjInvestExpenses[0].debDueDate11__c,sumTurnover.debDueDate11__c,sumUmsatzOPOS.debDueDate11__c,sumKosten.debDueDate11__c,String.valueOf(date10),135000.00));
        myChartData.add(new ChartData(10000000.00,ObjBank1[0].debDueDate12__c,cashFlow.debDueDate12__c,ObjInvestExpenses[0].debDueDate12__c,sumTurnover.debDueDate12__c,sumUmsatzOPOS.debDueDate12__c,sumKosten.debDueDate12__c,String.valueOf(date11),135000.00));
        myChartData.add(new ChartData(10000000.00,ObjBank1[0].debDueDate13__c,cashFlow.debDueDate13__c,ObjInvestExpenses[0].debDueDate13__c,sumTurnover.debDueDate13__c,sumUmsatzOPOS.debDueDate13__c,sumKosten.debDueDate13__c,String.valueOf(date12),135000.00));
        myChartData.add(new ChartData(10000000.00,ObjBank1[0].debDueDate14__c,cashFlow.debDueDate14__c,ObjInvestExpenses[0].debDueDate14__c,sumTurnover.debDueDate14__c,sumUmsatzOPOS.debDueDate14__c,sumKosten.debDueDate14__c,String.valueOf(date13),135000.00));
        myChartData.add(new ChartData(10000000.00,ObjBank1[0].debDueDate15__c,cashFlow.debDueDate15__c,ObjInvestExpenses[0].debDueDate15__c,sumTurnover.debDueDate15__c,sumUmsatzOPOS.debDueDate15__c,sumKosten.debDueDate15__c,String.valueOf(date14),135000.00));
        myChartData.add(new ChartData(10000000.00,ObjBank1[0].debDueDate16__c,cashFlow.debDueDate16__c,ObjInvestExpenses[0].debDueDate16__c,sumTurnover.debDueDate16__c,sumUmsatzOPOS.debDueDate16__c,sumKosten.debDueDate16__c,String.valueOf('CW '+calendarWeek3),135000.00));
        myChartData.add(new ChartData(10000000.00,ObjBank1[0].debDueDate17__c,cashFlow.debDueDate17__c,ObjInvestExpenses[0].debDueDate17__c,sumTurnover.debDueDate17__c,sumUmsatzOPOS.debDueDate17__c,sumKosten.debDueDate17__c,String.valueOf('CW '+calendarWeek4),135000.00));
        myChartData.add(new ChartData(10000000.00,ObjBank1[0].debDueDate18__c,cashFlow.debDueDate18__c,ObjInvestExpenses[0].debDueDate18__c,sumTurnover.debDueDate18__c,sumUmsatzOPOS.debDueDate18__c,sumKosten.debDueDate18__c,String.valueOf('CW '+calendarWeek5),135000.00));
        myChartData.add(new ChartData(10000000.00,ObjBank1[0].debDueDate19__c,cashFlow.debDueDate19__c,ObjInvestExpenses[0].debDueDate19__c,sumTurnover.debDueDate19__c,sumUmsatzOPOS.debDueDate19__c,sumKosten.debDueDate19__c,String.valueOf('CW '+calendarWeek6),135000.00));
        myChartData.add(new ChartData(10000000.00,ObjBank1[0].debDueDate20__c,cashFlow.debDueDate20__c,ObjInvestExpenses[0].debDueDate20__c,sumTurnover.debDueDate20__c,sumUmsatzOPOS.debDueDate20__c,sumKosten.debDueDate20__c,String.valueOf('CW '+calendarWeek7),135000.00));
        myChartData.add(new ChartData(10000000.00,ObjBank1[0].debDueDate21__c,cashFlow.debDueDate21__c,ObjInvestExpenses[0].debDueDate21__c,sumTurnover.debDueDate21__c,sumUmsatzOPOS.debDueDate21__c,sumKosten.debDueDate21__c,String.valueOf('CW '+calendarWeek8),135000.00));
        myChartData.add(new ChartData(10000000.00,ObjBank1[0].debDueDate22__c,cashFlow.debDueDate22__c,ObjInvestExpenses[0].debDueDate22__c,sumTurnover.debDueDate22__c,sumUmsatzOPOS.debDueDate22__c,sumKosten.debDueDate22__c,String.valueOf('CW '+calendarWeek9),135000.00));
        myChartData.add(new ChartData(10000000.00,ObjBank1[0].debDueDate23__c,cashFlow.debDueDate23__c,ObjInvestExpenses[0].debDueDate23__c,sumTurnover.debDueDate23__c,sumUmsatzOPOS.debDueDate23__c,sumKosten.debDueDate23__c,String.valueOf('CW '+calendarWeek10),135000.00));
        myChartData.add(new ChartData(10000000.00,ObjBank1[0].debDueDate24__c,cashFlow.debDueDate24__c,ObjInvestExpenses[0].debDueDate24__c,sumTurnover.debDueDate24__c,sumUmsatzOPOS.debDueDate24__c,sumKosten.debDueDate24__c,String.valueOf('CW '+calendarWeek11),135000.00));
        myChartData.add(new ChartData(10000000.00,ObjBank1[0].debDueDate17__c,cashFlow.debDueDate25__c,ObjInvestExpenses[0].debDueDate25__c,sumTurnover.debDueDate25__c,sumUmsatzOPOS.debDueDate25__c,sumKosten.debDueDate25__c,String.valueOf('CW '+calendarWeek12),135000.00));
        //cashFlow.debDueDate01__c,String.valueOf(dateToday)));
        
        
        
    /*  myChartData.add(new ChartData(cashFlow.debDueDate01__c,String.valueOf(dateToday)));
        myChartData.add(new ChartData(cashFlow.debDueDate02__c,String.valueOf(dateAfterToday)));
        myChartData.add(new ChartData(cashFlow.debDueDate03__c,String.valueOf(date2)));
        myChartData.add(new ChartData(cashFlow.debDueDate04__c,String.valueOf(date3)));
        myChartData.add(new ChartData(cashFlow.debDueDate05__c,String.valueOf(date4)));
        myChartData.add(new ChartData(cashFlow.debDueDate06__c,String.valueOf(date5)));
        myChartData.add(new ChartData(cashFlow.debDueDate07__c,String.valueOf(date6)));
        myChartData.add(new ChartData(cashFlow.debDueDate08__c,String.valueOf(date7)));
        myChartData.add(new ChartData(cashFlow.debDueDate09__c,String.valueOf(date8)));
        myChartData.add(new ChartData(cashFlow.debDueDate10__c,String.valueOf(date9)));
        myChartData.add(new ChartData(cashFlow.debDueDate11__c,String.valueOf(date10)));
        myChartData.add(new ChartData(cashFlow.debDueDate12__c,String.valueOf(date11)));
        myChartData.add(new ChartData(cashFlow.debDueDate13__c,String.valueOf(date12)));
        myChartData.add(new ChartData(cashFlow.debDueDate14__c,String.valueOf(date13)));
        myChartData.add(new ChartData(cashFlow.debDueDate15__c,String.valueOf(date14)));
        myChartData.add(new ChartData(cashFlow.debDueDate16__c,String.valueOf('CW '+calendarWeek3)));
        myChartData.add(new ChartData(cashFlow.debDueDate17__c,String.valueOf('CW '+calendarWeek4)));
        myChartData.add(new ChartData(cashFlow.debDueDate18__c,String.valueOf('CW '+calendarWeek5)));
        myChartData.add(new ChartData(cashFlow.debDueDate19__c,String.valueOf('CW '+calendarWeek6)));
        myChartData.add(new ChartData(cashFlow.debDueDate20__c,String.valueOf('CW '+calendarWeek7)));
        myChartData.add(new ChartData(cashFlow.debDueDate21__c,String.valueOf('CW '+calendarWeek8)));
        myChartData.add(new ChartData(cashFlow.debDueDate22__c,String.valueOf('CW '+calendarWeek9)));
        myChartData.add(new ChartData(cashFlow.debDueDate23__c,String.valueOf('CW '+calendarWeek10)));
        myChartData.add(new ChartData(cashFlow.debDueDate24__c,String.valueOf('CW '+calendarWeek11)));
        myChartData.add(new ChartData(cashFlow.debDueDate25__c,String.valueOf('CW '+calendarWeek12)));*/
        
        
  
    }//public void Fill_ObjCashFlow()
    
    private boolean checkForEmptyRows(DebListObj__c obj){
        boolean flag = false;
        
        
                if (obj.debDueDate01__c != 0.0){
                        flag = true;
                }else if(obj.debDueDate02__c != 0.0){
                        flag = true;
                }else if(obj.debDueDate03__c != 0.0){
                        flag = true;
                }else if(obj.debDueDate04__c != 0.0){
                        flag = true;
                }else if(obj.debDueDate05__c != 0.0){
                        flag = true;
                }else if(obj.debDueDate06__c != 0.0){
                        flag = true;
                }else if(obj.debDueDate07__c != 0.0){
                        flag = true;
                }else if(obj.debDueDate08__c != 0.0){
                        flag = true;
                }else if(obj.debDueDate09__c != 0.0){
                        flag = true;
                }else if(obj.debDueDate10__c != 0.0){
                        flag = true;
                }else if(obj.debDueDate11__c != 0.0){
                        flag = true;
                }else if(obj.debDueDate12__c != 0.0){
                        flag = true;
                }else if(obj.debDueDate13__c != 0.0){
                        flag = true;
                }else if(obj.debDueDate14__c != 0.0){
                        flag = true;
                }else if(obj.debDueDate15__c != 0.0){
                        flag = true;
                }else if(obj.debDueDate16__c != 0.0){
                        flag = true;
                }else if(obj.debDueDate17__c != 0.0){
                        flag = true;
                }else if(obj.debDueDate18__c != 0.0){
                        flag = true;
                }else if(obj.debDueDate19__c != 0.0){
                        flag = true;
                }else if(obj.debDueDate20__c != 0.0){
                        flag = true;
                }else if(obj.debDueDate21__c != 0.0){
                        flag = true;
                }else if(obj.debDueDate22__c != 0.0){
                        flag = true;
                }else if(obj.debDueDate23__c != 0.0){
                        flag = true;
                }else if(obj.debDueDate24__c != 0.0){
                        flag = true;
                }else if(obj.debDueDate25__c != 0.0){
                        flag = true;
                }
        
        return flag;
    }
    
    public void Fill_Turnover(){
        List<Opportunity> listOpps = mapOpportunityAll.values();
        
        List<OpportunityLineItem> listOLI = mapAllOLIS.values();
        DebListObj__c oneRow;
        DebListObj__c oneRowMwst;
        
        
        for(Opportunity oneOpp : listOpps){
            oneRow = new DebListObj__c(RowName__c=oneOpp.Name);
            oneRowMwst = new DebListObj__c(RowName__c=oneOpp.Name);
                    
            oneRow = initRow(oneRow);
            oneRowMwst = initRow(oneRowMwst);
            
            String sUrl = System.URL.getSalesforceBaseUrl().getHost();
            
            sUrl = 'https://'
                            + sUrl.substring(2,6) 
                            + 'salesforce.com'
                            + '/'
                            + oneOpp.Id;
                            
			oneRow.link__c = sUrl;
            
            
            
            if(!oneOpp.OpportunityLineItems.isEmpty()){
                List<OpportunityLineItem> listOLIofOneOpp = oneOpp.OpportunityLineItems;
                
                for(OpportunityLineItem oneOLI2: listOLIofOneOpp){
                        
                        
                    OpportunityLineItem oneOLI = mapAllOLIS.get(oneOLI2.Id);
                    
                    /*
                     SELECT UnitPrice, Startdatum__c, ServiceDate, OpportunityId,
                                                Opportunity.Name, Opportunity.CloseDate, Opportunity.Id,
                                                Opportunity.Expected_date_of_payment__c, Opportunity.AccountId,
                                                Sales_Price_hrs__c, Quantity, ListPrice, Leistung_erbracht__c, Id,
                                                Erwarteter_Zahlungseingang__c,PricebookEntry.Name,
                                                (SELECT ScheduleDate, Quantity, Id FROM OpportunityLineItemSchedules) 
                                                FROM OpportunityLineItem 
                                                WHERE (Opportunity.StageName = 'Geschlossene und gewonnene'
                                                OR Opportunity.ForecastCategoryName='Commit')
                                                AND Opportunity.Name != '° Urlaub/Krankheit/Feiertage'
                                                AND (NOT PricebookEntry.Name LIKE 'UNBILLABLE%')
                                                AND Opportunity.AccountId !=:aYOURSL.Id
                                                AND ServiceDate <=: date_endWeek12
                                                AND Leistung_erbracht__c = FALSE]);
                                                
                    */
                    
                    //System.debug('****** DEBUG OppName'+ oneOpp.Name+' OLIName '+oneOLI.PricebookEntry.Name+'  ServiceDate '+oneOLI.ServiceDate+' Price '+oneOLI.UnitPrice+'  Quantity '+oneOLI.Quantity);
                    
                    
                    /*oneRow = new DebListObj__c(RowName__c=oneOpp.Name);
                    oneRowMwst = new DebListObj__c(RowName__c=oneOpp.Name);
                    
                    oneRow = initRow(oneRow);
                    oneRowMwst = initRow(oneRowMwst);*/
                    
                   /*if(!oneOLI.OpportunityLineItemSchedules.isEmpty()){
                        List<OpportunityLineItemSchedule> listOLISch = oneOLI.OpportunityLineItemSchedules;
                            for(OpportunityLineItemSchedule olisch: listOLISch){
                                
                                Date dateNext10thOfM = olisch.ScheduleDate.addMonths(1).toStartOfMonth().addDays(10);
                                                                if(dateNext10thOfM == dateToday){
                                        oneRow.debDueDate01__c += (oneOLI.UnitPrice * olisch.Quantity)* 1.19;
                                        oneRowMwst.debDueDate01__c += (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == dateAfterToday){
                                        oneRow.debDueDate02__c += (oneOLI.UnitPrice * olisch.Quantity)* 1.19;
                                        oneRowMwst.debDueDate02__c += (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == date2){
                                        oneRow.debDueDate03__c += (oneOLI.UnitPrice * olisch.Quantity)* 1.19;
                                        oneRowMwst.debDueDate03__c += (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == date3){
                                        oneRow.debDueDate04__c += (oneOLI.UnitPrice * olisch.Quantity)* 1.19;
                                        oneRowMwst.debDueDate04__c += (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == date4){
                                        oneRow.debDueDate05__c += (oneOLI.UnitPrice * olisch.Quantity)* 1.19;
                                        oneRowMwst.debDueDate05__c += (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == date5){
                                        oneRow.debDueDate06__c += (oneOLI.UnitPrice * olisch.Quantity)* 1.19;
                                        oneRowMwst.debDueDate06__c += (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == date6){
                                        oneRow.debDueDate07__c += (oneOLI.UnitPrice * olisch.Quantity)* 1.19;
                                        oneRowMwst.debDueDate07__c += (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == date7){
                                        oneRow.debDueDate08__c += (oneOLI.UnitPrice * olisch.Quantity)* 1.19;
                                        oneRowMwst.debDueDate08__c += (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == date8){
                                        oneRow.debDueDate09__c += (oneOLI.UnitPrice * olisch.Quantity)* 1.19;
                                        oneRowMwst.debDueDate09__c += (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == date9){
                                        oneRow.debDueDate10__c += (oneOLI.UnitPrice * olisch.Quantity)* 1.19;
                                        oneRowMwst.debDueDate10__c += (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == date10){
                                        oneRow.debDueDate11__c += (oneOLI.UnitPrice * olisch.Quantity)* 1.19;
                                        oneRowMwst.debDueDate11__c += (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == date11){
                                        oneRow.debDueDate12__c += (oneOLI.UnitPrice * olisch.Quantity)* 1.19;
                                        oneRowMwst.debDueDate12__c += (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == date12){
                                        oneRow.debDueDate13__c += (oneOLI.UnitPrice * olisch.Quantity)* 1.19;
                                        oneRowMwst.debDueDate13__c += (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == date13){
                                        oneRow.debDueDate14__c += (oneOLI.UnitPrice * olisch.Quantity)* 1.19;
                                        oneRowMwst.debDueDate14__c += (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == date14){
                                        oneRow.debDueDate15__c += (oneOLI.UnitPrice * olisch.Quantity)* 1.19;
                                        oneRowMwst.debDueDate15__c += (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM > date14 && dateNext10thOfM <= date_endWeek3){
                                        oneRow.debDueDate16__c += (oneOLI.UnitPrice * olisch.Quantity)* 1.19;
                                        oneRowMwst.debDueDate16__c += (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM > date_endWeek3 && dateNext10thOfM <= date_endWeek4){
                                        oneRow.debDueDate17__c += (oneOLI.UnitPrice * olisch.Quantity)* 1.19;
                                        oneRowMwst.debDueDate17__c += (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM > date_endWeek4 && dateNext10thOfM <= date_endWeek5){
                                        oneRow.debDueDate18__c += (oneOLI.UnitPrice * olisch.Quantity)* 1.19;
                                        oneRowMwst.debDueDate18__c += (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM > date_endWeek5 && dateNext10thOfM <= date_endWeek6){
                                        oneRow.debDueDate19__c += (oneOLI.UnitPrice * olisch.Quantity)* 1.19;
                                        oneRowMwst.debDueDate19__c += (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM > date_endWeek6 && dateNext10thOfM <= date_endWeek7){
                                        oneRow.debDueDate20__c += (oneOLI.UnitPrice * olisch.Quantity)* 1.19;
                                        oneRowMwst.debDueDate20__c += (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM > date_endWeek7 && dateNext10thOfM <= date_endWeek8){
                                        oneRow.debDueDate21__c += (oneOLI.UnitPrice * olisch.Quantity)* 1.19;
                                        oneRowMwst.debDueDate21__c += (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM > date_endWeek8 && dateNext10thOfM <= date_endWeek9){
                                        oneRow.debDueDate22__c += (oneOLI.UnitPrice * olisch.Quantity)* 1.19;
                                        oneRowMwst.debDueDate22__c += (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM > date_endWeek9 && dateNext10thOfM <= date_endWeek10){
                                        oneRow.debDueDate23__c += (oneOLI.UnitPrice * olisch.Quantity)* 1.19;
                                        oneRowMwst.debDueDate23__c += (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM > date_endWeek10 && dateNext10thOfM <= date_endWeek11){
                                        oneRow.debDueDate24__c += (oneOLI.UnitPrice * olisch.Quantity)* 1.19;
                                        oneRowMwst.debDueDate24__c += (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM > date_endWeek11 && dateNext10thOfM <= date_endWeek12){
                                        oneRow.debDueDate25__c += (oneOLI.UnitPrice * olisch.Quantity)* 1.19;
                                        oneRowMwst.debDueDate25__c += (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }
                                
                                
                            }// END for(OpportunityLineItemSchedule olisch: listOLISch)
                            
                    }else{ // if(oneOLI.OpportunityLineItemSchedules.isEmpty())*/

                        Date expectedPayingDate = oneOLI.ServiceDate.addMonths(1).toStartOfMonth().addDays(Integer.valueOf(oneOpp.Expected_date_of_payment__c)==null?0:Integer.valueOf(oneOpp.Expected_date_of_payment__c));
                        System.debug('****** DEBUG OppName'+ oneOpp.Name+' OLIName '+oneOLI.PricebookEntry.Name+'  ServiceDate '+oneOLI.ServiceDate+' Price '+oneOLI.UnitPrice+'  Quantity '+oneOLI.Quantity+' ExpectedDate '+expectedPayingDate);
                        //System.debug('NAME: '+oneOpp.Name + ' LINE: '+oneOLI.PricebookEntry.Name + ' SERVICE: '+oneOLI.ServiceDate+' PAYING: '+expectedPayingDate);
                        if(expectedPayingDate <= date_endWeek12){ //check if calculated paying date is within date scope (to avoid empty lines)
                                if(expectedPayingDate == dateToday){
                                oneRow.debDueDate01__c += (oneOLI.UnitPrice * oneOLI.Quantity) * 1.19;
                                oneRowMwst.debDueDate01__c += (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                                }else if(expectedPayingDate == dateAfterToday){
                                        oneRow.debDueDate02__c += (oneOLI.UnitPrice * oneOLI.Quantity) * 1.19;
                                        oneRowMwst.debDueDate02__c += (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                                }else if(expectedPayingDate == date2){
                                        oneRow.debDueDate03__c += (oneOLI.UnitPrice * oneOLI.Quantity) * 1.19;
                                        oneRowMwst.debDueDate03__c += (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                                }else if(expectedPayingDate == date3){
                                        oneRow.debDueDate04__c += (oneOLI.UnitPrice * oneOLI.Quantity) * 1.19;
                                        oneRowMwst.debDueDate04__c += (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                                }else if(expectedPayingDate == date4){
                                        oneRow.debDueDate05__c += (oneOLI.UnitPrice * oneOLI.Quantity) * 1.19;
                                        oneRowMwst.debDueDate05__c += (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                                }else if(expectedPayingDate == date5){
                                        oneRow.debDueDate06__c += (oneOLI.UnitPrice * oneOLI.Quantity) * 1.19;
                                        oneRowMwst.debDueDate06__c += (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                                }else if(expectedPayingDate == date6){
                                        oneRow.debDueDate07__c += (oneOLI.UnitPrice * oneOLI.Quantity) * 1.19;
                                        oneRowMwst.debDueDate07__c += (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                                }else if(expectedPayingDate == date7){
                                        oneRow.debDueDate08__c += (oneOLI.UnitPrice * oneOLI.Quantity) * 1.19;
                                        oneRowMwst.debDueDate08__c += (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                                }else if(expectedPayingDate == date8){
                                        oneRow.debDueDate09__c += (oneOLI.UnitPrice * oneOLI.Quantity) * 1.19;
                                        oneRowMwst.debDueDate09__c += (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                                }else if(expectedPayingDate == date9){
                                        oneRow.debDueDate10__c += (oneOLI.UnitPrice * oneOLI.Quantity) * 1.19;
                                        oneRowMwst.debDueDate10__c += (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                                }else if(expectedPayingDate == date10){
                                        oneRow.debDueDate11__c += (oneOLI.UnitPrice * oneOLI.Quantity) * 1.19;
                                        oneRowMwst.debDueDate11__c += (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                                }else if(expectedPayingDate == date11){
                                        oneRow.debDueDate12__c += (oneOLI.UnitPrice * oneOLI.Quantity) * 1.19;
                                        oneRowMwst.debDueDate12__c += (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                                }else if(expectedPayingDate == date12){
                                        oneRow.debDueDate13__c += (oneOLI.UnitPrice * oneOLI.Quantity) * 1.19;
                                        oneRowMwst.debDueDate13__c += (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                                }else if(expectedPayingDate == date13){
                                        oneRow.debDueDate14__c += (oneOLI.UnitPrice * oneOLI.Quantity) * 1.19;
                                        oneRowMwst.debDueDate14__c += (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                                }else if(expectedPayingDate == date14){
                                        oneRow.debDueDate15__c += (oneOLI.UnitPrice * oneOLI.Quantity) * 1.19;
                                        oneRowMwst.debDueDate15__c += (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                                }else if(expectedPayingDate > date14 && expectedPayingDate <= date_endWeek3){
                                        oneRow.debDueDate16__c += (oneOLI.UnitPrice * oneOLI.Quantity) * 1.19;
                                        oneRowMwst.debDueDate16__c += (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                                }else if(expectedPayingDate > date_endWeek3 && expectedPayingDate <= date_endWeek4){
                                        oneRow.debDueDate17__c += (oneOLI.UnitPrice * oneOLI.Quantity) * 1.19;
                                        oneRowMwst.debDueDate17__c += (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                                }else if(expectedPayingDate > date_endWeek4 && expectedPayingDate <= date_endWeek5){
                                        oneRow.debDueDate18__c += (oneOLI.UnitPrice * oneOLI.Quantity) * 1.19;
                                        oneRowMwst.debDueDate18__c += (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                                }else if(expectedPayingDate > date_endWeek5 && expectedPayingDate <= date_endWeek6){
                                        oneRow.debDueDate19__c += (oneOLI.UnitPrice * oneOLI.Quantity) * 1.19;
                                        oneRowMwst.debDueDate19__c += (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                                }else if(expectedPayingDate > date_endWeek6 && expectedPayingDate <= date_endWeek7){
                                        oneRow.debDueDate20__c += (oneOLI.UnitPrice * oneOLI.Quantity) * 1.19;
                                        oneRowMwst.debDueDate20__c += (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                                }else if(expectedPayingDate > date_endWeek7 && expectedPayingDate <= date_endWeek8){
                                        oneRow.debDueDate21__c += (oneOLI.UnitPrice * oneOLI.Quantity) * 1.19;
                                        oneRowMwst.debDueDate21__c += (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                                }else if(expectedPayingDate > date_endWeek8 && expectedPayingDate <= date_endWeek9){
                                        oneRow.debDueDate22__c += (oneOLI.UnitPrice * oneOLI.Quantity) * 1.19;
                                        oneRowMwst.debDueDate22__c += (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                                }else if(expectedPayingDate > date_endWeek9 && expectedPayingDate <= date_endWeek10){
                                        oneRow.debDueDate23__c += (oneOLI.UnitPrice * oneOLI.Quantity) * 1.19;
                                        oneRowMwst.debDueDate23__c += (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                                }else if(expectedPayingDate > date_endWeek10 && expectedPayingDate <= date_endWeek11){
                                        oneRow.debDueDate24__c += (oneOLI.UnitPrice * oneOLI.Quantity) * 1.19;
                                        oneRowMwst.debDueDate24__c += (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                                }else if(expectedPayingDate > date_endWeek11 && expectedPayingDate <= date_endWeek12){
                                        oneRow.debDueDate25__c += (oneOLI.UnitPrice * oneOLI.Quantity) * 1.19;
                                        oneRowMwst.debDueDate25__c += (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                                }
                                
                       }//END if(expectedPayingDate <= date_endWeek12)
                        
                        
                                
                                
                        
                        
                    //}// END if(oneOLI.OpportunityLineItemSchedules.isEmpty())
                }// for(OpportunityLineItem oneOLI: listOLIofOneOpp)
            if(checkForEmptyRows(oneRow)){
                ObjTurnover.add(oneRow);        
            }
                
            /*if( mapAccountGermanyAll.containsKey(oneOpp.AccountId)){
                ObjMwstUmsatz.add(oneRowMwst);
                 }*///END if( mapAccountGermanyAll.containsKey(oneOpp.AccountId))
  
                
            }// END if(!oneOpp.OpportunityLineItems.isEmpty())

        }// for(Opportunity oneOpp : listOpps)

    }// END public void Fill_Umsatz()
    public Class ChartData{
        public decimal scale{get;set;}
        public decimal bank{get;set;}
        public decimal cashFlow{get;set;}
        public decimal investExpenses{get;set;}
        public decimal debitInvoiceForecast{get;set;}
        public decimal debitInvoiceD{get;set;}
        public decimal creditInvoice{get;set;}
        public String sDate{get;set;}
        public decimal redLine{get;set;}
        
        public ChartData(decimal scale,decimal bank,decimal cashFlow,decimal investExpenses,decimal debitInvoiceForecast, decimal debitInvoiceD,decimal creditInvoice, String sDate,decimal redLine){
                this.scale = scale;
                this.sDate = sDate;
                this.bank = bank;
                this.cashFlow = cashFlow;
                this.investExpenses = investExpenses;
                this.debitInvoiceForecast = debitInvoiceForecast;
                this.debitInvoiceD = debitInvoiceD;
                this.creditInvoice = creditInvoice;
                this.redLine = redLine;
        }
    }
    
}// END public with sharing class CashFlow4

//============ ATTIC ========= UNUSED BY MAYBE HELPFULL METHODS BELOW =============================

   /* public void Fill_Umsatz(){
        List<Opportunity> listOpps = mapOpportunityOut.values();
        List<OpportunityLineItem> listOLI = mapOpportunityOutLineItem.values();
        DebListObj__c oneRow;
        DebListObj__c oneRowMwst;
        for(Opportunity oneOpp : listOpps){
            
            Double dSumTillLastMonth = 0.0;
            Double dSumCurrentMonth = 0.0;
            Double dSumLastMonth = 0.0;
            Double dSumNextMonth = 0.0;
            // dateToday = Date.today();
            
            if(!oneOpp.OpportunityLineItems.isEmpty()){
                List<OpportunityLineItem> listOLIofOneOpp = oneOpp.OpportunityLineItems;
                
                for(OpportunityLineItem oneOLI2: listOLIofOneOpp){
                        // get list of OLI with Schedules as SubQuery
                        
                    OpportunityLineItem oneOLI = mapOpportunityOutLineItem.get(oneOLI2.Id);
                    oneRow = new DebListObj__c(RowName__c=oneOpp.Name);
                    oneRowMwst = new DebListObj__c(RowName__c=oneOpp.Name);
                    
                    oneRow = initRow(oneRow);
                    oneRowMwst = initRow(oneRowMwst);
                    
                    if(!oneOLI.OpportunityLineItemSchedules.isEmpty()){
                        List<OpportunityLineItemSchedule> listOLISch = oneOLI.OpportunityLineItemSchedules;
                            for(OpportunityLineItemSchedule olisch: listOLISch){
                                
                                Date dateNext10thOfM = olisch.ScheduleDate.addMonths(1).toStartOfMonth().addDays(10);
                                                                if(dateNext10thOfM == dateToday){
                                        oneRow.debDueDate01__c = oneOLI.UnitPrice * olisch.Quantity;
                                        oneRowMwst.debDueDate01__c = (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == dateAfterToday){
                                        oneRow.debDueDate02__c = oneOLI.UnitPrice * olisch.Quantity;
                                        oneRowMwst.debDueDate02__c = (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == date2){
                                        oneRow.debDueDate03__c = oneOLI.UnitPrice * olisch.Quantity;
                                        oneRowMwst.debDueDate03__c = (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == date3){
                                        oneRow.debDueDate04__c = oneOLI.UnitPrice * olisch.Quantity;
                                        oneRowMwst.debDueDate04__c = (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == date4){
                                        oneRow.debDueDate05__c = oneOLI.UnitPrice * olisch.Quantity;
                                        oneRowMwst.debDueDate05__c = (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == date5){
                                        oneRow.debDueDate06__c = oneOLI.UnitPrice * olisch.Quantity;
                                        oneRowMwst.debDueDate06__c = (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == date6){
                                        oneRow.debDueDate07__c = oneOLI.UnitPrice * olisch.Quantity;
                                        oneRowMwst.debDueDate07__c = (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == date7){
                                        oneRow.debDueDate08__c = oneOLI.UnitPrice * olisch.Quantity;
                                        oneRowMwst.debDueDate08__c = (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == date8){
                                        oneRow.debDueDate09__c = oneOLI.UnitPrice * olisch.Quantity;
                                        oneRowMwst.debDueDate09__c = (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == date9){
                                        oneRow.debDueDate10__c = oneOLI.UnitPrice * olisch.Quantity;
                                        oneRowMwst.debDueDate10__c = (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == date10){
                                        oneRow.debDueDate11__c = oneOLI.UnitPrice * olisch.Quantity;
                                        oneRowMwst.debDueDate11__c = (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == date11){
                                        oneRow.debDueDate12__c = oneOLI.UnitPrice * olisch.Quantity;
                                        oneRowMwst.debDueDate12__c = (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == date12){
                                        oneRow.debDueDate13__c = oneOLI.UnitPrice * olisch.Quantity;
                                        oneRowMwst.debDueDate13__c = (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == date13){
                                        oneRow.debDueDate14__c = oneOLI.UnitPrice * olisch.Quantity;
                                        oneRowMwst.debDueDate14__c = (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }else if(dateNext10thOfM == date14){
                                        oneRow.debDueDate15__c = oneOLI.UnitPrice * olisch.Quantity;
                                        oneRowMwst.debDueDate15__c = (oneOLI.UnitPrice * olisch.Quantity)*0.19;
                                }
                                
                                
                            }// END for(OpportunityLineItemSchedule olisch: listOLISch)
                            
                    }else{ // if(oneOLI.OpportunityLineItemSchedules.isEmpty())

                        
                        if(oneOLI.Erwarteter_Zahlungseingang__c == dateToday){
                                oneRow.debDueDate01__c = oneOLI.UnitPrice * oneOLI.Quantity;
                                oneRowMwst.debDueDate01__c = (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                        }else if(oneOLI.Erwarteter_Zahlungseingang__c == dateAfterToday){
                                oneRow.debDueDate02__c = oneOLI.UnitPrice * oneOLI.Quantity;
                                oneRowMwst.debDueDate02__c = (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                        }else if(oneOLI.Erwarteter_Zahlungseingang__c == date2){
                                oneRow.debDueDate03__c = oneOLI.UnitPrice * oneOLI.Quantity;
                                oneRowMwst.debDueDate03__c = (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                        }else if(oneOLI.Erwarteter_Zahlungseingang__c == date3){
                                oneRow.debDueDate04__c = oneOLI.UnitPrice * oneOLI.Quantity;
                                oneRowMwst.debDueDate04__c = (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                        }else if(oneOLI.Erwarteter_Zahlungseingang__c == date4){
                                oneRow.debDueDate05__c = oneOLI.UnitPrice * oneOLI.Quantity;
                                oneRowMwst.debDueDate05__c = (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                        }else if(oneOLI.Erwarteter_Zahlungseingang__c == date5){
                                oneRow.debDueDate06__c = oneOLI.UnitPrice * oneOLI.Quantity;
                                oneRowMwst.debDueDate06__c = (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                        }else if(oneOLI.Erwarteter_Zahlungseingang__c == date6){
                                oneRow.debDueDate07__c = oneOLI.UnitPrice * oneOLI.Quantity;
                                oneRowMwst.debDueDate07__c = (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                        }else if(oneOLI.Erwarteter_Zahlungseingang__c == date7){
                                oneRow.debDueDate08__c = oneOLI.UnitPrice * oneOLI.Quantity;
                                oneRowMwst.debDueDate08__c = (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                        }else if(oneOLI.Erwarteter_Zahlungseingang__c == date8){
                                oneRow.debDueDate09__c = oneOLI.UnitPrice * oneOLI.Quantity;
                                oneRowMwst.debDueDate09__c = (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                        }else if(oneOLI.Erwarteter_Zahlungseingang__c == date9){
                                oneRow.debDueDate10__c = oneOLI.UnitPrice * oneOLI.Quantity;
                                oneRowMwst.debDueDate10__c = (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                        }else if(oneOLI.Erwarteter_Zahlungseingang__c == date10){
                                oneRow.debDueDate11__c = oneOLI.UnitPrice * oneOLI.Quantity;
                                oneRowMwst.debDueDate11__c = (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                        }else if(oneOLI.Erwarteter_Zahlungseingang__c == date11){
                                oneRow.debDueDate12__c = oneOLI.UnitPrice * oneOLI.Quantity;
                                oneRowMwst.debDueDate12__c = (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                        }else if(oneOLI.Erwarteter_Zahlungseingang__c == date12){
                                oneRow.debDueDate13__c = oneOLI.UnitPrice * oneOLI.Quantity;
                                oneRowMwst.debDueDate13__c = (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                        }else if(oneOLI.Erwarteter_Zahlungseingang__c == date13){
                                oneRow.debDueDate14__c = oneOLI.UnitPrice * oneOLI.Quantity;
                                oneRowMwst.debDueDate14__c = (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                        }else if(oneOLI.Erwarteter_Zahlungseingang__c == date14){
                                oneRow.debDueDate15__c = oneOLI.UnitPrice * oneOLI.Quantity;
                                oneRowMwst.debDueDate15__c = (oneOLI.UnitPrice * oneOLI.Quantity)*0.19;
                        }
                        
                        
                    }// END if(oneOLI.OpportunityLineItemSchedules.isEmpty())
                }// for(OpportunityLineItem oneOLI: listOLIofOneOpp)
            
            ObjUmsatz.add(oneRow);    
            if( mapAccountGermanyAll.containsKey(oneOpp.AccountId)){
                ObjMwstUmsatz.add(oneRowMwst);
                 }//END if( mapAccountGermanyAll.containsKey(oneOpp.AccountId))
  
                
            }// END if(!oneOpp.OpportunityLineItems.isEmpty())

        }// for(Opportunity oneOpp : listOpps)

    }// END public void Fill_Umsatz()*/
    
       /* public void Fill_MwSt(){
        DebListObj__c SumObjMwStUmsatz = Calculate_SUM_DebListObj(ObjMwStUmsatz);
        DebListObj__c SumObjMwStKosten = Calculate_SUM_DebListObj(ObjMwStKosten);
        System.debug('@@@@@@@@@@@@@@@ MwStKosten size' + ObjMwStKosten.size());
        SumObjMwStUmsatz.RowName__c = 'MwSt Umsatz';
        SumObjMwStKosten.RowName__c = 'MwSt Kosten';
        // nachher löschen
        ObjMwSt.add(SumObjMwStUmsatz );
        ObjMwSt.add(SumObjMwStKosten );
    }// END public void Fill_MwSt() */