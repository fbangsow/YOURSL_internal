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
  
    public Date d = System.today();
    public Datetime dt = (DateTime) d;
    public String dayOfWeek = dt.format('EEEE');
    public String DateValue {get; set;}
    public Date PreviousWeekStart { get;set;}
    public Date PreviousWeekEnd  { get;set;}
    public Date CurrentWeekStart { get;set;}
    public Date CurrentWeekEnd  { get;set;}
    public Date PreviousMonthStart { get;set;}
    public Date PreviousMonthEnd  { get;set;}
    public Date CurrentMonthStart { get;set;}
    public Date CurrentMonthEnd  { get;set;}
    public Date PreviousMonthLastMonday { get;set;}
    public Date CurrentMonthFirstSunday { get;set;}
    public Boolean IsMonthChangeinWeekPlanned {get;set;}
    public Boolean IsMonthChangeinWeekActual {get;set;}

    
    public CtrPSOTable(){
    
        getDatesForCalculation();
    }

    public void init() {

      jsonstring = string.valueof(PsoToolController.getInstance().getDataSet().JSON());
   }
  
    public void getDatesForCalculation(){

        PreviousWeekStart = d.toStartOfWeek()-7;
        PreviousWeekEnd = d.toStartOfWeek()-1;
        CurrentWeekStart = d.toStartOfWeek();
        CurrentWeekEnd = d.toStartOfWeek()+6;
        IsMonthChangeinWeekPlanned = false;
        IsMonthChangeinWeekActual = false;
         
        Integer prevmonth=0;
        Integer nxtmonth=0;
        Integer currentmonth=0;
        Integer y = d.year();
        Integer m = d.month();
        Integer dy;
        Integer currentday;
        Integer nxtdy;
        Integer year= y;
        prevmonth=m-1;
        nxtmonth=m+1;
        currentmonth =m;
          PreviousMonthStart = date.newinstance(year, prevmonth, 1);
          CurrentMonthStart = date.newInstance(year, currentmonth, 1);
       
          dy = Date.daysinmonth(y, prevmonth)-1;
          currentday = Date.daysInMonth(y, currentmonth)-1;
          nxtdy= Date.daysinmonth(y, nxtmonth)-1;

          PreviousMonthEnd=date.newinstance(year, prevmonth, 1+dy);
          CurrentMonthEnd = date.newInstance(year, currentmonth, 1+currentday);
        if(m==12)
        {
             PreviousMonthStart = date.newinstance(year, prevmonth, 1);
             PreviousMonthEnd=date.newinstance(year, prevmonth, 1+dy);
             CurrentMonthStart = date.newInstance(year, currentmonth, 1);
             CurrentMonthEnd = date.newInstance(year, currentmonth, 1+currentday);
             year= y+1;     
             nxtdy= Date.daysinmonth(y, nxtmonth)-1;       
        }
        if(PreviousWeekStart.month() !=PreviousWeekEnd.month())
        {
            IsMonthChangeinWeekActual = true;
        }
         if(CurrentWeekStart.month() !=CurrentWeekEnd.month())
        {
            IsMonthChangeinWeekPlanned = true;
        }

       Map < String, Integer > PreviousMonthLastMondayMap = new Map < String, Integer >{'Monday' => 0,'Tuesday' => 1,
                                                    'Wednesday' => 2,'Thursday' => 3,'Friday' => 4,'Saturday' =>5,'Sunday' =>6};
        Date previousdate = PreviousMonthend;
        Datetime previousdatetime = (DateTime) previousdate;
        String dayOfWk = previousdatetime.format('EEEE');
        DateTime tempDateTime = previousdatetime - PreviousMonthLastMondayMap.get(dayOfWk);
        PreviousMonthLastMonday = Date.newInstance(tempDateTime.year(), tempDateTime.month(),tempDateTime.day());

        Map < String, Integer > CurrentMonthFirstSundayMap = new Map < String, Integer >{'Monday' => 6,'Tuesday' => 5,
                                                    'Wednesday' => 4,'Thursday' => 3,'Friday' => 2,'Saturday' =>1,'Sunday' =>0};    
        Date currentdate = CurrentMonthStart;
        Datetime currentdatetime = (DateTime) currentdate;
        String dayOfWeek = currentdatetime.format('EEEE');
        DateTime tmpDateTime = currentdatetime + CurrentMonthFirstSundayMap.get(dayOfWeek);
        CurrentMonthFirstSunday = Date.newInstance(tmpDateTime.year(), tmpDateTime.month(),tmpDateTime.day());
      
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
      else{
      if(!IsMonthChangeinWeekPlanned)
          Delete [Select ID from Planning_statistics__C where Time_Type__c = 'Week' and Data_Type__c ='Planned' and Start_Date__c <= :CurrentWeekEnd  and Start_Date__c >= :CurrentWeekStart  ];
      else
          Delete [Select ID from Planning_statistics__C where Time_Type__c = 'Week' and Data_Type__c ='Planned' and Start_Date__c <= :CurrentMonthEnd  and Start_Date__c >= :CurrentWeekStart  ];
      if(!IsMonthChangeinWeekActual)
          Delete [Select ID from Planning_statistics__C where Time_Type__c = 'Week' and Data_Type__c ='Actual' and Start_Date__c <= :PreviousWeekEnd  and Start_Date__c >= :PreviousWeekStart  ];
      else
          Delete [Select ID from Planning_statistics__C where Time_Type__c = 'Week' and Data_Type__c ='Actual' and Start_Date__c <= :PreviousWeekEnd  and Start_Date__c >= :CurrentMonthStart  ];     
      
        PlanningScheduleUpdate updateSchedule = new PlanningScheduleUpdate(DateValue);   
    }
    
  }
  
   public void runMonthlyJob(){      
   
    if(DateValue == '')
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please select Date before running the job'));
    else{
      Delete [Select ID from Planning_statistics__C where Time_Type__c = 'Month' and Data_Type__c ='Planned' and Start_Date__c <= :CurrentMonthEnd  and Start_Date__c >= :CurrentMonthStart ];  
      Delete [Select ID from Planning_statistics__C where Time_Type__c = 'Week' and Data_Type__c ='Planned' and Start_Date__c <= :CurrentMonthFirstSunday  and Start_Date__c >= :CurrentMonthStart ];    
      Delete [Select ID from Planning_statistics__C where Time_Type__c = 'Month' and Data_Type__c ='Actual' and Start_Date__c <= :PreviousMonthEnd  and Start_Date__c >= :PreviousMonthStart ];
      Delete [Select ID from Planning_statistics__C where Time_Type__c = 'Week' and Data_Type__c ='Actual' and Start_Date__c <= :PreviousMonthEnd  and Start_Date__c >= :PreviousMonthLastMonday ];    

      PlanningScheduleUpdate updateSchedule = new PlanningScheduleUpdate(DateValue);         
    }      
    
  }

}