/* ------------------------------------
@Project : PSO Tool
@Company: MOLD TEK
@Author: PhanI,Anudeep
@Review : Kve
@Creation date: 20/03/2015
@Description : Controller class to call backend Methods.
---------------------------------------*/
public class CtrPSOTable {

    public string jsonstring {set; get;}
    public String DateValue {get; set;}

    public CtrPSOTable(){

    }

 @RemoteAction
  public static void  getChangedProjectHealth(String opptrtuntyid,String changedvalue) {
  system.debug('opptrtuntyid'+opptrtuntyid);
  system.debug('changedbd'+changedvalue);
     PsoToolController.getInstance().setProjectHealthReason(opptrtuntyid,changedvalue);
  }

  @RemoteAction
  public static string getAccount() {

    return PsoToolController.getInstance().getFilterValues().JSON();
  }
    @RemoteAction
  public static string getProjectHealth() {

    return PsoToolController.getInstance().getProjectHealthReasons().JSON();
  }

  @RemoteAction
  public static string getAccountsonload(String list_of_ids,String dateparam, String resource_list_of_ids) {

    String[] datefrmt = dateFormatter(dateparam);
    Date myDate = date.newinstance(Integer.valueOf(datefrmt[2]), Integer.valueOf(datefrmt[1]), Integer.valueOf(datefrmt[0]));

 	list<String> listofdata=new list<String>();
	list<String> listOfResourceData = new list<String>();
	listOfResourceData = resource_list_of_ids.split(',');
	listofdata=list_of_ids.split(',');

	if(list_of_ids=='none' && resource_list_of_ids=='none'){
		return '{"Customers": []}';
	}
	else if(list_of_ids=='none' && resource_list_of_ids==''){
		return PsoToolController.getInstance().showAllContacts().setStartDate(myDate).getDataSet().JSON();
	}
	else if(list_of_ids=='none' && resource_list_of_ids!=''){
		return PsoToolController.getInstance().setSelectedContacts(listOfResourceData).setStartDate(myDate).getDataSet().JSON();
	}
	else if(list_of_ids=='' && resource_list_of_ids=='none'){
		return PsoToolController.getInstance().showAllOpportunities().setStartDate(myDate).getDataSet().JSON();
	}
	else if(list_of_ids=='' && resource_list_of_ids==''){
		return PsoToolController.getInstance().showAllOpportunities().showAllContacts().setStartDate(myDate).getDataSet().JSON();
	}
	else if(list_of_ids=='' && resource_list_of_ids!=''){
		return PsoToolController.getInstance().showAllOpportunities().setSelectedContacts(listOfResourceData).setStartDate(myDate).getDataSet().JSON();
	}
	else if(list_of_ids!='' && resource_list_of_ids=='none'){
		return PsoToolController.getInstance().setSelectedOpportunities(listofdata).setStartDate(myDate).getDataSet().JSON();
	}
	else if(list_of_ids!='' && resource_list_of_ids==''){
		return PsoToolController.getInstance().setSelectedOpportunities(listofdata).showAllContacts().setStartDate(myDate).getDataSet().JSON();
	}
	else if(list_of_ids!='' && resource_list_of_ids!=''){
		return PsoToolController.getInstance().setSelectedOpportunities(listofdata).setSelectedContacts(listOfResourceData).setStartDate(myDate).getDataSet().JSON();
	}
	else {
		return '{"Customers": []}';
	}
  }
    @RemoteAction
  public static string getDataofMonthfilter(String dateparam) {

    String[] datefrmt = dateFormatter(dateparam);
    Date myDate = date.newinstance(Integer.valueOf(datefrmt[2]), Integer.valueOf(datefrmt[1]), Integer.valueOf(datefrmt[0]));


//return  PsoToolController.getInstance().setSelectedOpportunities(listofdataforlist).setStartDate(myDate).getDataSet().JSON();
    return PsoToolController.getInstance().setStartDate(myDate).getFilterValues().JSON();

  }

  @RemoteAction
  public static string getDataofMonth(String dateparam,String listofdata) {

    String[] datefrmt = dateFormatter(dateparam);
    Date myDate = date.newinstance(Integer.valueOf(datefrmt[2]), Integer.valueOf(datefrmt[1]), Integer.valueOf(datefrmt[0]));

     list<String> listofdataforlist=new list<String>();
listofdataforlist=listofdata.split(',');
return  PsoToolController.getInstance().setSelectedOpportunities(listofdataforlist).setStartDate(myDate).getDataSet().JSON();
    //return PsoToolController.getInstance().setStartDate(myDate).getFilterValues().JSON();

  }

  @RemoteAction
  public static String runjobvalue( String selectedDate) {

    Boolean IsPlanned=true;

    String[] datefrmt = dateFormatter(selectedDate);
    Date JobDate = date.newinstance(Integer.valueOf(datefrmt[2]), Integer.valueOf(datefrmt[0]), Integer.valueOf(datefrmt[1]));

   String dates = StatisticsCalculator.getInstance(JobDate, IsPlanned).getDatesToBeDisplayed().JSON();
return dates;
  }
    @RemoteAction
  public static PsoToolController.Result savefunction(String LineItemIdMap, String selectedDate, Decimal  numberOfHours) {
    system.debug(numberOfHours);

    String[] datefrmt = dateFormatter(selectedDate);
    Date myDate = date.newinstance(Integer.valueOf(datefrmt[2]), Integer.valueOf(datefrmt[1]), Integer.valueOf(datefrmt[0]));

    PsoToolController.Result result =PsoToolController.getInstance().allocateResource(LineItemIdMap, myDate, numberOfHours / 8);
return result;
  }

  public static String[] dateFormatter(String dateString) {

    return dateString.split('[.]{1}[\\s]?');
  }


  public void runJob(){

      if(DateValue == '')
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please select Date before running the job'));
      else{
            String[] myDateOnly = DateValue.split(' ');
            String[] strDate = myDateOnly[0].split('/');
            Integer myIntDate = integer.valueOf(strDate[1]);
            Integer myIntMonth = integer.valueOf(strDate[0]);
            Integer myIntYear = integer.valueOf(strDate[2]);
            Date myjobDate = Date.newInstance(myIntYear, myIntMonth, myIntDate);

           StatisticsCalculator.getInstance(myjobDate, true).createStatistics();
      }
  }

   /*public void runMonthlyJob(){

    if(DateValue == '')
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please select Date before running the job'));
    else{
           batchPSOTool b = new batchPSOTool(DateValue,false,true);
           Database.executeBatch(b);
          //PlanningScheduleUpdate updateSchedule = new PlanningScheduleUpdate(DateValue, false,true);
      }

  }*/

}