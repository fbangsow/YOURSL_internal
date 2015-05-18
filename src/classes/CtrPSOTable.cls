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
  public static void savefunction(String LineItemIdMap, String selectedDate, Decimal numberOfHours) {

    String[] datefrmt = dateFormatter(selectedDate);
    Date myDate = date.newinstance(Integer.valueOf(datefrmt[2]), Integer.valueOf(datefrmt[1]), Integer.valueOf(datefrmt[0]));
    PsoToolController.getInstance().allocateResource(LineItemIdMap, myDate, numberOfHours / 8);

  }

  public static String[] dateFormatter(String dateString) {

    return dateString.split('[.]{1}[\\s]?');
  }
  
  public void runJob(){  
  
      Delete [Select ID from Planning_statistics__C];
      PlanningScheduleUpdate updateSchedule = new PlanningScheduleUpdate();   
    
  }

}