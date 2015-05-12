public class BWAInvoiceQueryV3 {
    
    public boolean showReport{get; set;}

    public Integer numberMonth{get; set;}
    
    
    double totalUmsatzErloese;
    double aktEigenleistung;
    double totalSonBetrErloese;
    double material;
    double totalFremdLeistung;
    double totalGehaltskosten;
    double totalRaumkosten;
    double totalWerbekosten;
    double totalAndereKosten;
    double totalReisekosten;
    Double totalITKosten;
    Double afa;
    Double aoErgebnis;
    Double finanzergebnis;
    Double totalSteuern;


    
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
        
        String from1;
        String to1;
        String from2;
        String to2;
        String from3;
        String to3;
        String from4;
        String to4; 



        //UMSATZ
        from1 = '8000';
        to1 = '8540';
        from2 = '8700';
        to2 = '8799';       

        query = 'SELECT sum(Debitor_Invoice__r.' + bereichInvoiceAmount_AusgangsRech + ')' +
                ' FROM Debitor_Invoice_Status__c' + 
                ' WHERE Debitor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
                ' AND Debitor_Invoice__r.Invoice_date__c <= ' + endDateStr +
                ' AND ((debit_account__r.name >= :from1 AND debit_account__r.name <= :to1) OR (debit_account__r.name >= :from2 AND debit_account__r.name <= :to2))';        
                            
        groupedResults = Database.query(query);
        totalUmsatzErloese = double.valueOf(groupedResults[0].get('expr0'));
        if(totalUmsatzErloese == null) {totalUmsatzErloese = 0;}

        //akt. Eigenleistung
        from1 = '8990';
        to1 = '8995';

        query = 'SELECT sum(Debitor_Invoice__r.' + bereichInvoiceAmount_AusgangsRech + ')' +
                ' FROM Debitor_Invoice_Status__c' + 
                ' WHERE Debitor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
                ' AND Debitor_Invoice__r.Invoice_date__c <= ' + endDateStr +
                ' AND ((debit_account__r.name >= :from1 AND debit_account__r.name <= :to1))';
                
        
        groupedResults = Database.query(query);
        
        aktEigenleistung = double.valueOf(groupedResults[0].get('expr0'));
        if(aktEigenleistung == null) {aktEigenleistung = 0;}

    
        //So. betr. Erlöse
        from1 = '8590';
        to1 = '8649';
        from2 = '8800';
        to2 = '8853';
        from3 = '2660';
        to3 = '2666';
        from4 = '2700';
        to4 = '2764';

        query = 'SELECT sum(Debitor_Invoice__r.' + bereichInvoiceAmount_AusgangsRech + ')' +
                ' FROM Debitor_Invoice_Status__c' + 
                ' WHERE Debitor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
                ' AND Debitor_Invoice__r.Invoice_date__c <= ' + endDateStr +
                ' AND ((debit_account__r.name >= :from1 AND debit_account__r.name <= :to1) OR (debit_account__r.name >= :from2 AND debit_account__r.name <= :to2)' +
                ' OR (debit_account__r.name >= :from3 AND debit_account__r.name <= :to3) OR (debit_account__r.name >= :from4 AND debit_account__r.name <= :to4))';              
        
        
        groupedResults = Database.query(query);
        
        totalSonBetrErloese = double.valueOf(groupedResults[0].get('expr0'));
        if(totalSonBetrErloese == null) {totalSonBetrErloese = 0;}
        totalSonBetrErloese += (fixAmount_Erloese * numberMonth);//+ fester Betrag 1612,12€
 
        //Material
        from1 = '3200';
        to1 = '3969';       
        
        query = 'SELECT sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + ')' +
                ' FROM Kreditor_Invoice_Status__c' + 
                ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
                ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
                ' AND ((debit_account__r.name >= :from1 AND debit_account__r.name <= :to1))';
                
        groupedResults = Database.query(query);
        material = double.valueOf(groupedResults[0].get('expr0'));
        if(material == null) {material = 0;}

        
        //Fremddienstleistungen
        from1 = '3100';
        to1 = '3165';       
        

        query = 'SELECT sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + ')' +
                ' FROM Kreditor_Invoice_Status__c' + 
                ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
                ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
                ' AND ((debit_account__r.name >= :from1 AND debit_account__r.name <= :to1))';

                
        groupedResults = Database.query(query);
        totalFremdLeistung = double.valueOf(groupedResults[0].get('expr0'));
        if(totalFremdLeistung == null) {totalFremdLeistung = 0;}
    
        
        //Gehaltskosten
        from1 = '4100';
        to1 = '4199';
        from2 = '1740';
        to2 = '1750';


        query = 'SELECT sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech +')' +
        ' FROM Kreditor_Invoice_Status__c' + 
        ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
        ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
        ' AND ((debit_account__r.name >= :from1 AND debit_account__r.name <= :to1) OR (debit_account__r.name >= :from2 AND debit_account__r.name <= :to2))';
        
        groupedResults = Database.query(query);
        totalGehaltskosten = double.valueOf(groupedResults[0].get('expr0'));
        
        
        if(totalGehaltskosten == null) {totalGehaltskosten = 0;}
        totalGehaltskosten += (fixAmount_Gehalt* numberMonth);
        


        //Raumkosten
        from1 = '4200';
        to1 = '4280';


        query = 'SELECT sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + ')' +
        ' FROM Kreditor_Invoice_Status__c' + 
        ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
        ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
        ' AND ((debit_account__r.name >= :from1 AND debit_account__r.name <= :to1))';


        groupedResults = Database.query(query);
        totalRaumkosten = double.valueOf(groupedResults[0].get('expr0'));   
        
        if(totalRaumkosten == null ) {totalRaumkosten = 0;}
        
        

        //Werbekosten
        from1 = '4600';
        to1 = '4654';
        from2 = '4781';
        to2 = '4781';


        query = 'SELECT sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + ')' +
        ' FROM Kreditor_Invoice_Status__c' + 
        ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
        ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
        ' AND ((debit_account__r.name >= :from1 AND debit_account__r.name <= :to1) OR (debit_account__r.name >= :from2 AND debit_account__r.name <= :to2))';


        groupedResults = Database.query(query);
        totalWerbekosten = double.valueOf(groupedResults[0].get('expr0'));
        
        if(totalWerbekosten == null) {totalWerbekosten = 0;}
        
        
                
        //Sonstige Kosten
        from1 = '4200';
        to1 = '4810';
        from2 = '4900';
        to2 = '4985';
        from3 = '2150';
        to3 = '2176';


        query = 'SELECT sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + ')' +
        ' FROM Kreditor_Invoice_Status__c' + 
        ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
        ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
        ' AND ((debit_account__r.name >= :from1 AND debit_account__r.name <= :to1) OR (debit_account__r.name >= :from2 AND debit_account__r.name <= :to2)' +
                ' OR (debit_account__r.name >= :from3 AND debit_account__r.name <= :to3))';


        groupedResults = Database.query(query);
        totalAndereKosten = double.valueOf(groupedResults[0].get('expr0'));

        if(totalAndereKosten == null) {totalAndereKosten = 0;}
        
        

        //Reisekosten
        from1 = '4660';
        to1 = '4666';


        query = 'SELECT sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + ')' +
        ' FROM Kreditor_Invoice_Status__c' + 
        ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
        ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
        ' AND ((debit_account__r.name >= :from1 AND debit_account__r.name <= :to1))';

        groupedResults = Database.query(query);
        totalReisekosten = double.valueOf(groupedResults[0].get('expr0'));
        
        
        if(totalReisekosten == null) {totalReisekosten = 0;}
        

        //IT-Kosten
        from1 = '4806';
        to1 = '4806';
        from2 = '4920';
        to2 = '4925';


        query = 'SELECT sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + ')' +
        ' FROM Kreditor_Invoice_Status__c' + 
        ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
        ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
        ' AND ((debit_account__r.name >= :from1 AND debit_account__r.name <= :to1) OR (debit_account__r.name >= :from2 AND debit_account__r.name <= :to2))';


        groupedResults = Database.query(query);
        totalITKosten = double.valueOf(groupedResults[0].get('expr0'));
        
        if(totalITKosten == null) {totalITKosten = 0;}
        

        //AfA
        from1 = '4820';
        to1 = '4882';


        query = 'SELECT sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + ')' +
        ' FROM Kreditor_Invoice_Status__c' + 
        ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
        ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
        ' AND ((debit_account__r.name >= :from1 AND debit_account__r.name <= :to1))';


        groupedResults = Database.query(query);
        afa = double.valueOf(groupedResults[0].get('expr0'));
                
        if(afa == null) {afa = 0;}
        


        //Finanzergebnis
        from1 = '2100';
        to1 = '2149';
        from2 = '2490';
        to2 = '2494';
        from3 = '2650';
        to3 = '2659';       


        query = 'SELECT sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + ')' +
        ' FROM Kreditor_Invoice_Status__c' + 
        ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
        ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
        ' AND ((debit_account__r.name >= :from1 AND debit_account__r.name <= :to1) OR (debit_account__r.name >= :from2 AND debit_account__r.name <= :to2)' +
                ' OR (debit_account__r.name >= :from3 AND debit_account__r.name <= :to3))';


        groupedResults = Database.query(query);
        finanzergebnis = double.valueOf(groupedResults[0].get('expr0'));
                
        if(finanzergebnis == null) {
            finanzergebnis = 0;
        } else {
            finanzergebnis = finanzergebnis*(-1);
        }
        

        //a.o. Ergebnis
        from1 = '2500';
        to1 = '2509';


        query = 'SELECT sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + ')' +
        ' FROM Kreditor_Invoice_Status__c' + 
        ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
        ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
        ' AND ((debit_account__r.name >= :from1 AND debit_account__r.name <= :to1))';


        groupedResults = Database.query(query);
        aoErgebnis = double.valueOf(groupedResults[0].get('expr0'));    
        
        if(aoErgebnis == null) {aoErgebnis = 0;}
            


        //Steuern
        from1 = '4510';
        to1 = '4510';
        from2 = '2200';
        to2 = '2289';


        query = 'SELECT sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + ')' +
        ' FROM Kreditor_Invoice_Status__c' + 
        ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr + 
        ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
        ' AND ((debit_account__r.name >= :from1 AND debit_account__r.name <= :to1) OR (debit_account__r.name >= :from2 AND debit_account__r.name <= :to2))';


        groupedResults = Database.query(query);
        totalSteuern = double.valueOf(groupedResults[0].get('expr0'));
        
        if(totalSteuern == null) {totalSteuern = 0;}
                                            

        //Berechnung Summen
        Double gesamtleistung = totalUmsatzErloese + totalSonBetrErloese + aktEigenleistung;
        Double rohertrag = gesamtleistung - totalFremdLeistung -material;
        totalAndereKosten = totalAndereKosten - totalRaumkosten - totalITKosten -totalWerbekosten - totalReisekosten - totalSteuern;
        Double ebit = rohertrag -totalGehaltskosten - totalRaumkosten - totalITKosten - totalWerbekosten - totalReisekosten - totalAndereKosten - afa - material;
        Double ebt = ebit + finanzergebnis;
        Double ergebnis = ebt + aoErgebnis - totalSteuern;


        
        showReport = true;
        
        ChartDataWrapper chartDataUmsatz = new ChartDataWrapper('Umsatz', getString(totalUmsatzErloese), getPercentStr(totalUmsatzErloese, gesamtleistung));
        ChartDataWrapper chartDataAktEigenleistung = new ChartDataWrapper('-- akt. Eigenleistung', getString(aktEigenleistung), getPercentStr(aktEigenleistung, gesamtleistung));
        ChartDataWrapper chartDataSonstErtraege = new ChartDataWrapper('-- Sonst. betr. Erträge', getString(totalSonBetrErloese), getPercentStr(totalSonBetrErloese, gesamtleistung));
        ChartDataWrapper chartDataGesamtLeistung = new ChartDataWrapper('Gesamtleistung', getString(gesamtleistung), getPercentStr(gesamtleistung, gesamtleistung));
        ChartDataWrapper chartDataMaterial = new ChartDataWrapper('-- Material', getString(material), getPercentStr(material, gesamtleistung));
        ChartDataWrapper chartDataFremdleistungen = new ChartDataWrapper('-- Fremddienstleistungen', getString(totalFremdLeistung), getPercentStr(totalFremdLeistung, gesamtleistung));
        ChartDataWrapper chartDataRohertrag = new ChartDataWrapper('Rohertrag', getString(rohertrag), getPercentStr(rohertrag, gesamtleistung));
        ChartDataWrapper chartDataPersonal = new ChartDataWrapper('-- Personal', getString(totalGehaltskosten), getPercentStr(totalGehaltskosten, gesamtleistung));
        ChartDataWrapper chartDataRaumkosten = new ChartDataWrapper('-- Raumkosten', getString(totalRaumkosten), getPercentStr(totalRaumkosten, gesamtleistung));
        ChartDataWrapper chartDataITKosten = new ChartDataWrapper('-- IT/TK-Kosten', getString(totalITKosten), getPercentStr(totalITKosten, gesamtleistung));
        ChartDataWrapper chartDataMarketing = new ChartDataWrapper('-- Werbe-/Marketingkosten', getString(totalWerbekosten), getPercentStr(totalWerbekosten, gesamtleistung));
        ChartDataWrapper chartDataReisekosten = new ChartDataWrapper('-- Reisekosten', getString(totalReisekosten), getPercentStr(totalReisekosten, gesamtleistung));
        ChartDataWrapper chartDataSonstigeKosten = new ChartDataWrapper('-- Sonstige Kosten', getString(totalAndereKosten), getPercentStr(totalAndereKosten, gesamtleistung));
        ChartDataWrapper chartDataAfa= new ChartDataWrapper('-- Afa', getString(afa), getPercentStr(afa, gesamtleistung));
        ChartDataWrapper chartDataEbit = new ChartDataWrapper('EBIT', getString(ebit), getPercentStr(ebit, gesamtleistung));
        ChartDataWrapper chartDataFinanzergebnis = new ChartDataWrapper('-- Finanzergebnis', getString(finanzergebnis), getPercentStr(finanzergebnis, gesamtleistung));
        ChartDataWrapper chartDataEbt = new ChartDataWrapper('EBT', getString(ebt), getPercentStr(ebt, gesamtleistung));
        ChartDataWrapper chartDataAOErgebnis = new ChartDataWrapper('-- a.o. Ergebnis', getString(aoErgebnis), getPercentStr(aoErgebnis, gesamtleistung));
        ChartDataWrapper chartDataSteuern = new ChartDataWrapper('-- Steuern', getString(totalSteuern), getPercentStr(totalSteuern, gesamtleistung));
        ChartDataWrapper chartDataErgebnis = new ChartDataWrapper('Ergebnis', getString(ergebnis), getPercentStr(ergebnis, gesamtleistung));


        
        listChartData.add(chartDataUmsatz);
        listChartData.add(chartDataAktEigenleistung);
        listChartData.add(chartDataSonstErtraege);
        listChartData.add(chartDataGesamtLeistung);
        listChartData.add(chartDataMaterial);
        listChartData.add(chartDataFremdleistungen);
        listChartData.add(chartDataRohertrag);
        listChartData.add(chartDataPersonal);
        listChartData.add(chartDataRaumkosten);
        listChartData.add(chartDataITKosten);
        listChartData.add(chartDataMarketing);
        listChartData.add(chartDataReisekosten);
        listChartData.add(chartDataSonstigeKosten);
        listChartData.add(chartDataAfa);
        listChartData.add(chartDataEbit);
        listChartData.add(chartDataFinanzergebnis);
        listChartData.add(chartDataEbt);
        listChartData.add(chartDataAOErgebnis);
        listChartData.add(chartDataSteuern);
        listChartData.add(chartDataErgebnis);
 
    return listChartData;
    }
    

    
    private string padIntegerWithZero(integer i) {
        if(i < 10) {return '0' + string.valueof(i);}
        else {return string.valueof(i);}
    }

    private String getPercentStr(Double numerator, Double denumerator){
        String percStr = 'N/A';
        
        if(denumerator != 0){
            Double percent = (numerator/denumerator)*100;
            percStr =  ((double)math.round((decimal)(percent*100))/100).format() + '%';
        }
        
    return percStr;
    }

    private String getString(Double value){
        return ((double)math.round((decimal)(value*100))/100).format();
    }
    
    
}