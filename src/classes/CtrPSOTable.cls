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

    public void init() {

      jsonstring = string.valueof(PsoToolController.getInstance().getDataSet().JSON());
   }

  @RemoteAction
  public static string getAccount() {

    return PsoToolController.getInstance().getDataSet().JSON();
  }

  @RemoteAction
  public static string getDataofMonth(String dateparam) {

    String[] datefrmt = dateFormatter(dateparam);
    Date myDate = date.newinstance(Integer.valueOf(datefrmt[2]), Integer.valueOf(datefrmt[1]), Integer.valueOf(datefrmt[0]));

    return PsoToolController.getInstance().getDataSet(myDate).JSON();
  }

  @RemoteAction
  public static void savefunction(String LineItemIdMap, String selectedDate, Decimal  numberOfHours) {
    system.debug(numberOfHours);

    String[] datefrmt = dateFormatter(selectedDate);
    Date myDate = date.newinstance(Integer.valueOf(datefrmt[2]), Integer.valueOf(datefrmt[1]), Integer.valueOf(datefrmt[0]));
    PsoToolController.getInstance().allocateResource(LineItemIdMap, myDate, numberOfHours / 8);

  }

  public static String[] dateFormatter(String dateString) {

    return dateString.split('[.]{1}[\\s]?');
  }

    
  public void runWeeklyJob(){  

      if(DateValue == '')
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please select Date before running the job'));
      else     
          PlanningScheduleUpdate updateSchedule = new PlanningScheduleUpdate(DateValue, true,false);             
    
  }
  
   public void runMonthlyJob(){      
   
    if(DateValue == '')
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please select Date before running the job'));
    else   
      PlanningScheduleUpdate updateSchedule = new PlanningScheduleUpdate(DateValue,false,true);     
    
  }

}