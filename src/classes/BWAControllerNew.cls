public class BWAControllerNew {
    public Opportunity oppStart{get;set;}
    public Opportunity oppEnd{get;set;}
    public List<ChartDataWrapper> listChartData{get;set;}
    public boolean showReport{get; set;}
    private BWAInvoiceQuery bwa;
    public String bereichAuswahl{get; set;}

    public BWAControllerNew() {
        oppStart = new Opportunity();
        oppEnd = new Opportunity();
        showReport = false;
        listChartData = new List<ChartDataWrapper>();
    }

    public List<SelectOption> getBereiche(){
        List<SelectOption> bereiche = new List<SelectOption>();
        bereiche.add(new SelectOption('Alle', 'Alle'));
        bereiche.add(new SelectOption('North', 'Europe'));
        bereiche.add(new SelectOption('South', 'International'));
        bereiche.add(new SelectOption('CCEAG', 'CCE AG'));
        bereiche.add(new SelectOption('Telekom', 'Channel'));
        bereiche.add(new SelectOption('YOURSL', 'Headquater'));
    return bereiche;
    }

    public PageReference runReport() {
        bwa = new BWAInvoiceQuery();
        listChartData = bwa.getBWAReport(bereichAuswahl, oppStart, oppEnd);
        showReport = bwa.showReport;
    return null;
    }
}