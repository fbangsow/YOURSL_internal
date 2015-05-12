public class BWAControllerNew {
	
    public Opportunity oppStart{get;set;} //used because it has a date field
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
        
        //bwa = new BWAInvoiceQuery();
	}
    
    public List<SelectOption> getBereiche(){
        List<SelectOption> bereiche = new List<SelectOption>();
        bereiche.add(new SelectOption('Alle', 'Alle'));
        bereiche.add(new SelectOption('North', 'North'));
        bereiche.add(new SelectOption('South', 'South'));
        bereiche.add(new SelectOption('CCEAG', 'CCEAG'));
        bereiche.add(new SelectOption('Telekom', 'Telekom'));
        bereiche.add(new SelectOption('YOURSL', 'YOURSL'));
    return bereiche;
    }
    
    public PageReference runReport() {
    	
        bwa = new BWAInvoiceQuery();
        listChartData = bwa.getBWAReport(bereichAuswahl, oppStart, oppEnd);
        showReport = bwa.showReport;
     
    return null;    
    }
    
    
}