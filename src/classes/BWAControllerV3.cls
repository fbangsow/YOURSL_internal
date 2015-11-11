public class BWAControllerV3 {

    public Opportunity oppStart{get;set;} //used because it has a date field
	public Opportunity oppEnd{get;set;}
    public List<ChartDataWrapper> listChartData{get;set;}
    public boolean showReport{get; set;}
    private BWAInvoiceQueryV3 bwa;
    public String bereichAuswahl{get; set;}

    public BWAControllerV3() {
		oppStart = new Opportunity();
		oppEnd = new Opportunity();
		showReport = false;

		listChartData = new List<ChartDataWrapper>();

        //bwa = new BWAInvoiceQuery();
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

        bwa = new BWAInvoiceQueryV3();
        listChartData = bwa.getBWAReport(bereichAuswahl, oppStart, oppEnd);
        showReport = bwa.showReport;

    return null;
    }
}