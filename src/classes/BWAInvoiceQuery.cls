public class BWAInvoiceQuery {
    public boolean showReport{get; set;}
    private Integer numberMonth;


    double totalUmsatzErloese;
    double aktEigenleistung;
    double totalSonBetrErloese;
    double material;
    double totalFremdLeistung;
    double totalGehaltskosten;
    double totalRaumkosten;
    Double BetrieblSteuerKfZSteuern;
    Double VersicherungBeitrage;
    Double KfZKosten;
    Double WerbeMarketingReisekosten;
    Double FremdarbeitenNichtProjektbezogen;
    Double ReparaturInstandhaltung;
    Double Afa;
    Double SonstigeKosten;
    Double ZinsaufwandNeutrAufwand;
    Double ZinsertragNeutrErtrag;
    Double SteuernEinkUErtrag;

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
        String from5;
        String to5;



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
        from2 = '2660';
        to2 = '2666';

        query = 'SELECT sum(Debitor_Invoice__r.' + bereichInvoiceAmount_AusgangsRech + ')' +
                ' FROM Debitor_Invoice_Status__c' +
                ' WHERE Debitor_Invoice__r.Invoice_date__c >= ' + startDateStr +
                ' AND Debitor_Invoice__r.Invoice_date__c <= ' + endDateStr +
                ' AND ((debit_account__r.name >= :from1 AND debit_account__r.name <= :to1) OR (debit_account__r.name >= :from2 AND debit_account__r.name <= :to2))';


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
//Betriebl. Steuer/KfZ-Steuern
        from1 = '4510';
        query = 'SELECT sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + ')' +
        ' FROM Kreditor_Invoice_Status__c' +
        ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr +
        ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
        ' AND debit_account__r.name = :from1';
        groupedResults = Database.query(query);
        BetrieblSteuerKfZSteuern = double.valueOf(groupedResults[0].get('expr0'));
        if(BetrieblSteuerKfZSteuern == null ) {BetrieblSteuerKfZSteuern = 0;}
//Versicherung/Beiträge
        from1 = '4360';
        to1 = '4390';
        query = 'SELECT sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + ')' +
        ' FROM Kreditor_Invoice_Status__c' +
        ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr +
        ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
        ' AND ((debit_account__r.name >= :from1 AND debit_account__r.name <= :to1))';
        groupedResults = Database.query(query);
        VersicherungBeitrage = double.valueOf(groupedResults[0].get('expr0'));
        if(VersicherungBeitrage == null ) {VersicherungBeitrage = 0;}
//KfZ-Kosten (o.St.)
        from1 = '4530';
        to1 = '4595';
        query = 'SELECT sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + ')' +
        ' FROM Kreditor_Invoice_Status__c' +
        ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr +
        ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
        ' AND ((debit_account__r.name >= :from1 AND debit_account__r.name <= :to1))';
        groupedResults = Database.query(query);
        KfZKosten = double.valueOf(groupedResults[0].get('expr0'));
        if(KfZKosten == null ) {KfZKosten = 0;}
//Werbe-/Marketing-/Reisekosten
        from1 = '4600';
        to1 = '4654';
        from2 = '4660';
        to2 = '4666';
        query = 'SELECT sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech +')' +
        ' FROM Kreditor_Invoice_Status__c' +
        ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr +
        ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
        ' AND ((debit_account__r.name >= :from1 AND debit_account__r.name <= :to1) OR (debit_account__r.name >= :from2 AND debit_account__r.name <= :to2))';
        groupedResults = Database.query(query);
        WerbeMarketingReisekosten = double.valueOf(groupedResults[0].get('expr0'));
        if(WerbeMarketingReisekosten == null) {WerbeMarketingReisekosten = 0;}
//Fremdarbeiten nicht Projektbezogen
        from1 = '4780';
        to1 = '4786';
        query = 'SELECT sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + ')' +
        ' FROM Kreditor_Invoice_Status__c' +
        ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr +
        ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
        ' AND ((debit_account__r.name >= :from1 AND debit_account__r.name <= :to1))';
        groupedResults = Database.query(query);
        FremdarbeitenNichtProjektbezogen = double.valueOf(groupedResults[0].get('expr0'));
        if(FremdarbeitenNichtProjektbezogen == null ) {FremdarbeitenNichtProjektbezogen = 0;}
//Reparatur/Instandhaltung
        from1 = '4805';
        to1 = '4806';
        query = 'SELECT sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + ')' +
        ' FROM Kreditor_Invoice_Status__c' +
        ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr +
        ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
        ' AND ((debit_account__r.name >= :from1 AND debit_account__r.name <= :to1))';
        groupedResults = Database.query(query);
        ReparaturInstandhaltung = double.valueOf(groupedResults[0].get('expr0'));
        if(ReparaturInstandhaltung == null ) {ReparaturInstandhaltung = 0;}
//Afa
        from1 = '4820';
        to1 = '4882';
        query = 'SELECT sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + ')' +
        ' FROM Kreditor_Invoice_Status__c' +
        ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr +
        ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
        ' AND ((debit_account__r.name >= :from1 AND debit_account__r.name <= :to1))';
        groupedResults = Database.query(query);
        Afa = double.valueOf(groupedResults[0].get('expr0'));
        if(Afa == null ) {Afa = 0;}
//Sonstige Kosten
        from1 = '4900';
        to1 = '4985';
        from2 = '2150';
        to2 = '2176';
        query = 'SELECT sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech +')' +
        ' FROM Kreditor_Invoice_Status__c' +
        ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr +
        ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
        ' AND ((debit_account__r.name >= :from1 AND debit_account__r.name <= :to1) OR (debit_account__r.name >= :from2 AND debit_account__r.name <= :to2))';
        groupedResults = Database.query(query);
        SonstigeKosten = double.valueOf(groupedResults[0].get('expr0'));
        if(SonstigeKosten == null) {SonstigeKosten = 0;}
//Zinsaufwand/neutr. Aufwand
        from1 = '2100';
        to1 = '2149';
        from2 = '2309';
        to2 = '2494';
        from3 = '2020';
        to3 = '2020';
        query = 'SELECT sum(Debitor_Invoice__r.' + bereichInvoiceAmount_AusgangsRech + ')' +
                ' FROM Debitor_Invoice_Status__c' +
                ' WHERE Debitor_Invoice__r.Invoice_date__c >= ' + startDateStr +
                ' AND Debitor_Invoice__r.Invoice_date__c <= ' + endDateStr +
                ' AND ((debit_account__r.name >= :from1 AND debit_account__r.name <= :to1) OR (debit_account__r.name >= :from2 AND debit_account__r.name <= :to2)' +
                ' OR (debit_account__r.name >= :from3 AND debit_account__r.name <= :to3))';
        groupedResults = Database.query(query);
        ZinsaufwandNeutrAufwand = double.valueOf(groupedResults[0].get('expr0'));
        if(ZinsaufwandNeutrAufwand == null) {ZinsaufwandNeutrAufwand = 0;}
//Zinsertrag/neuntr. Ertrag
        from1 = '2500';
        to1 = '2509';
        from2 = '2650';
        to2 = '2659';
        from3 = '2742';
        to3 = '2749';
        from4 = '2315';
        to4 = '2315';
        from5 = '8906';
        to5 = '8959';
        query = 'SELECT sum(Debitor_Invoice__r.' + bereichInvoiceAmount_AusgangsRech + ')' +
                ' FROM Debitor_Invoice_Status__c' +
                ' WHERE Debitor_Invoice__r.Invoice_date__c >= ' + startDateStr +
                ' AND Debitor_Invoice__r.Invoice_date__c <= ' + endDateStr +
                ' AND ((debit_account__r.name >= :from1 AND debit_account__r.name <= :to1) OR (debit_account__r.name >= :from2 AND debit_account__r.name <= :to2)' +
                ' OR (debit_account__r.name >= :from3 AND debit_account__r.name <= :to3) OR (debit_account__r.name >= :from5 AND debit_account__r.name <= :to5))';
        groupedResults = Database.query(query);
        ZinsertragNeutrErtrag = double.valueOf(groupedResults[0].get('expr0'));
        if(ZinsertragNeutrErtrag == null) {ZinsertragNeutrErtrag = 0;}
//Steuern Eink. u. Ertrag
        from1 = '2200';
        to1 = '2289';
        query = 'SELECT sum(Kreditor_Invoice__r.' + bereichInvoiceAmount_EingangsRech + ')' +
        ' FROM Kreditor_Invoice_Status__c' +
        ' WHERE Kreditor_Invoice__r.Invoice_date__c >= ' + startDateStr +
        ' AND Kreditor_Invoice__r.Invoice_date__c <= ' + endDateStr +
        ' AND ((debit_account__r.name >= :from1 AND debit_account__r.name <= :to1))';
        groupedResults = Database.query(query);
        SteuernEinkUErtrag = double.valueOf(groupedResults[0].get('expr0'));
        if(SteuernEinkUErtrag == null ) {SteuernEinkUErtrag = 0;}

        //Berechnung Summen
        Double gesamtleistung = totalUmsatzErloese + totalSonBetrErloese + aktEigenleistung;
        Double rohertrag = gesamtleistung - totalFremdLeistung -material;
        Double gesamtkosten = totalGehaltskosten + totalRaumkosten + BetrieblSteuerKfZSteuern + VersicherungBeitrage + KfZKosten + WerbeMarketingReisekosten + FremdarbeitenNichtProjektbezogen + ReparaturInstandhaltung + Afa + SonstigeKosten;
        Double BetriebsergebnisEBIDA = rohertrag + Afa - gesamtkosten;
        Double BetriebsergebnisEBIT = rohertrag - gesamtkosten;
        Double ErgebnisVorSteuernEBT = BetriebsergebnisEBIT - ZinsaufwandNeutrAufwand + ZinsertragNeutrErtrag;
        Double Ergebnis = ErgebnisVorSteuernEBT - SteuernEinkUErtrag;

        showReport = true;

        ChartDataWrapper chartDataUmsatz = new ChartDataWrapper('Umsatz', getString(totalUmsatzErloese), getPercentStr(totalUmsatzErloese, gesamtleistung));
        ChartDataWrapper chartDataAktEigenleistung = new ChartDataWrapper('-- akt. Eigenleistung', getString(aktEigenleistung), getPercentStr(aktEigenleistung, gesamtleistung));
        ChartDataWrapper chartDataSonstErtraege = new ChartDataWrapper('-- sonst. betr. Erlöse', getString(totalSonBetrErloese), getPercentStr(totalSonBetrErloese, gesamtleistung));
        ChartDataWrapper chartDataGesamtLeistung = new ChartDataWrapper('Gesamtleistung', getString(gesamtleistung), getPercentStr(gesamtleistung, gesamtleistung));
        ChartDataWrapper chartDataMaterial = new ChartDataWrapper('-- Material', getString(material), getPercentStr(material, gesamtleistung));
        ChartDataWrapper chartDataFremdleistungen = new ChartDataWrapper('-- Fremddienstleistungen', getString(totalFremdLeistung), getPercentStr(totalFremdLeistung, gesamtleistung));
        ChartDataWrapper chartDataRohertrag = new ChartDataWrapper('Rohertrag', getString(rohertrag), getPercentStr(rohertrag, gesamtleistung));
        ChartDataWrapper chartDataPersonal = new ChartDataWrapper('-- Personal', getString(totalGehaltskosten), getPercentStr(totalGehaltskosten, gesamtleistung));
        ChartDataWrapper chartDataRaumkosten = new ChartDataWrapper('-- Raumkosten', getString(totalRaumkosten), getPercentStr(totalRaumkosten, gesamtleistung));
        ChartDataWrapper chartBetrieblSteuerKfZSteuern = new ChartDataWrapper('-- Betriebl. Steuer/KfZ-Steuern', getString(BetrieblSteuerKfZSteuern), getPercentStr(BetrieblSteuerKfZSteuern, gesamtleistung));
        ChartDataWrapper chartVersicherungBeitrage = new ChartDataWrapper('-- Versicherung/Beiträge', getString(VersicherungBeitrage), getPercentStr(VersicherungBeitrage, gesamtleistung));
        ChartDataWrapper chartKfZKosten = new ChartDataWrapper('-- KfZ-Kosten (o.St.)', getString(KfZKosten), getPercentStr(KfZKosten, gesamtleistung));
        ChartDataWrapper chartWerbeMarketingReisekosten = new ChartDataWrapper('-- Werbe-/Marketing-/Reisekosten', getString(WerbeMarketingReisekosten), getPercentStr(WerbeMarketingReisekosten, gesamtleistung));
        ChartDataWrapper chartFremdarbeitenNichtProjektbezogen = new ChartDataWrapper('-- Fremdarbeiten nicht Projektbezogen', getString(FremdarbeitenNichtProjektbezogen), getPercentStr(FremdarbeitenNichtProjektbezogen, gesamtleistung));
        ChartDataWrapper chartReparaturInstandhaltung = new ChartDataWrapper('-- Reparatur/Instandhaltung', getString(ReparaturInstandhaltung), getPercentStr(ReparaturInstandhaltung, gesamtleistung));
        ChartDataWrapper chartAfa = new ChartDataWrapper('-- Afa', getString(Afa), getPercentStr(Afa, gesamtleistung));
        ChartDataWrapper chartSonstigeKosten = new ChartDataWrapper('-- Sonstige Kosten', getString(SonstigeKosten), getPercentStr(SonstigeKosten, gesamtleistung));
        ChartDataWrapper chartGesamtkosten = new ChartDataWrapper('Gesamtkosten', getString(gesamtkosten), getPercentStr(gesamtkosten, gesamtleistung));
        ChartDataWrapper chartBetriebsergebnisEBIDA = new ChartDataWrapper('Betriebsergebnis/EBIDA', getString(BetriebsergebnisEBIDA), getPercentStr(BetriebsergebnisEBIDA, gesamtleistung));
        ChartDataWrapper chartBetriebsergebnisEBIT = new ChartDataWrapper('Betriebsergebnis/EBIT', getString(BetriebsergebnisEBIT), getPercentStr(BetriebsergebnisEBIT, gesamtleistung));
        ChartDataWrapper chartZinsaufwandNeutrAufwand = new ChartDataWrapper('-- Zinsaufwand/neutr. Aufwand', getString(ZinsaufwandNeutrAufwand), getPercentStr(ZinsaufwandNeutrAufwand, gesamtleistung));
        ChartDataWrapper chartZinsertragNeutrErtrag = new ChartDataWrapper('-- Zinsertrag/neuntr. Ertrag', getString(ZinsertragNeutrErtrag), getPercentStr(ZinsertragNeutrErtrag, gesamtleistung));
        ChartDataWrapper chartErgebnisVorSteuernEBT= new ChartDataWrapper('Ergebnis vor Steuern/EBT', getString(ErgebnisVorSteuernEBT), getPercentStr(ErgebnisVorSteuernEBT, gesamtleistung));
        ChartDataWrapper chartSteuernEinkUErtrag = new ChartDataWrapper('-- Steuern Eink. u. Ertrag ', getString(SteuernEinkUErtrag), getPercentStr(SteuernEinkUErtrag, gesamtleistung));
        ChartDataWrapper chartDataErgebnis = new ChartDataWrapper('Ergebnis', getString(Ergebnis), getPercentStr(Ergebnis, gesamtleistung));
        listChartData.add(chartDataUmsatz);
        listChartData.add(chartDataAktEigenleistung);
        listChartData.add(chartDataSonstErtraege);
        listChartData.add(chartDataGesamtLeistung);
        listChartData.add(chartDataMaterial);
        listChartData.add(chartDataFremdleistungen);
        listChartData.add(chartDataRohertrag);
        listChartData.add(chartDataPersonal);
        listChartData.add(chartDataRaumkosten);
        listChartData.add(chartBetrieblSteuerKfZSteuern);
        listChartData.add(chartVersicherungBeitrage);
        listChartData.add(chartKfZKosten);
        listChartData.add(chartWerbeMarketingReisekosten);
        listChartData.add(chartFremdarbeitenNichtProjektbezogen);
        listChartData.add(chartReparaturInstandhaltung);
        listChartData.add(chartAfa);
        listChartData.add(chartSonstigeKosten);
        listChartData.add(chartGesamtkosten);
        listChartData.add(chartBetriebsergebnisEBIDA);
        listChartData.add(chartBetriebsergebnisEBIT);
        listChartData.add(chartZinsaufwandNeutrAufwand);
        listChartData.add(chartZinsertragNeutrErtrag);
        listChartData.add(chartErgebnisVorSteuernEBT);
        listChartData.add(chartSteuernEinkUErtrag);
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
            Decimal percent = (numerator/denumerator)*100;
            percStr = percent.setScale(1).toPlainString() + '%';
        }
    return percStr;
    }

    private String getString(Double value){
        return ((double)math.round((decimal)(value*100))/100).intValue().format();
    }



}