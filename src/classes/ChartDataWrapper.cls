public class ChartDataWrapper {
	
    public string rowName{get; set;}
	public string totalValue{get; set;}
	public string totalPercStr{get; set;}

	public chartDataWrapper(String rowName,String totalValue,String totalPercStr){
		this.rowName = rowName;
		this.totalValue = totalValue;
		this.totalPercStr = totalPercStr;
	}
    
}