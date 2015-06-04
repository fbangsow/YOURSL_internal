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

    return PsoToolController.getInstance().getAccountsAndOpportunities().JSON();
  }
 
  @RemoteAction
  public static string getAccountsonload(String list_of_ids,String dateparam) {

    String[] datefrmt = dateFormatter(dateparam);
    Date myDate = date.newinstance(Integer.valueOf(datefrmt[2]), Integer.valueOf(datefrmt[1]), Integer.valueOf(datefrmt[0]));

 list<String> listofdata=new list<String>();
listofdata=list_of_ids.split(',');

system.debug('@@@'+listofdata);
system.debug(PsoToolController.getInstance().setSelectedOpportunities(listofdata).setStartDate(myDate).getDataSet().JSON());
    return PsoToolController.getInstance().setSelectedOpportunities(listofdata).setStartDate(myDate).getDataSet().JSON();
  }
 

  @RemoteAction
  public static string getDataofMonth(String dateparam,String listofdata) {

    String[] datefrmt = dateFormatter(dateparam);
    Date myDate = date.newinstance(Integer.valueOf(datefrmt[2]), Integer.valueOf(datefrmt[1]), Integer.valueOf(datefrmt[0]));

     list<String> listofdataforlist=new list<String>();
listofdataforlist=listofdata.split(',');
return  PsoToolController.getInstance().setSelectedOpportunities(listofdataforlist).setStartDate(myDate).getDataSet().JSON();
    //return PsoToolController.getInstance().setStartDate(myDate).getAccountsAndOpportunities().JSON();
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
      else{

           batchPSOTool b = new batchPSOTool(DateValue, true,false);
           Database.executeBatch(b);  
          //PlanningScheduleUpdate updateSchedule = new PlanningScheduleUpdate(DateValue, true,false);             
      }
  }
  
   public void runMonthlyJob(){      
   
    if(DateValue == '')
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please select Date before running the job'));
    else{              
           batchPSOTool b = new batchPSOTool(DateValue,false,true);
           Database.executeBatch(b);  
          //PlanningScheduleUpdate updateSchedule = new PlanningScheduleUpdate(DateValue, false,true);             
      }  
    
  }

}