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
    public Date PreviousWeekStart { get;set;}
    public Date PreviousWeekEnd  { get;set;}
    public Date CurrentWeekStart { get;set;}
    public Date CurrentWeekEnd  { get;set;}
    public Date PreviousMonthStart { get;set;}
    public Date PreviousMonthEnd  { get;set;}
    public Date CurrentMonthStart { get;set;}
    public Date CurrentMonthEnd  { get;set;}
    public Date PreviousMonthLastMonday { get;set;}
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

        Map < String, Integer > PreviousMonthLastMondayMap = new Map < String, Integer > ();
        PreviousMonthLastMondayMap.put('Monday', 0);
        PreviousMonthLastMondayMap.put('Tuesday', 1);
        PreviousMonthLastMondayMap.put('Wednesday', 2);
        PreviousMonthLastMondayMap.put('Thursday', 3);
        PreviousMonthLastMondayMap.put('Friday', 4);
        PreviousMonthLastMondayMap.put('Saturday', 5);
        PreviousMonthLastMondayMap.put('Sunday', 6);
        Date previousdate = PreviousMonthend;
        Datetime previousdatetime = (DateTime) previousdate;
        String dayOfWk = previousdatetime.format('EEEE');
        DateTime tempDateTime = previousdatetime - PreviousMonthLastMondayMap.get(dayOfWk);
        PreviousMonthLastMonday = Date.newInstance(tempDateTime.year(), tempDateTime.month(),tempDateTime.day());
      
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
      
      if(!IsMonthChangeinWeekPlanned)
          Delete [Select ID from Planning_statistics__C where Time_Type__c = 'Week' and Data_Type__c ='Planned' and Start_Date__c <= :CurrentWeekEnd  and Start_Date__c >= :CurrentWeekStart  ];
      else
          Delete [Select ID from Planning_statistics__C where Time_Type__c = 'Week' and Data_Type__c ='Planned' and Start_Date__c <= :CurrentMonthEnd  and Start_Date__c >= :CurrentWeekStart  ];
      if(!IsMonthChangeinWeekActual)
          Delete [Select ID from Planning_statistics__C where Time_Type__c = 'Week' and Data_Type__c ='Actual' and Start_Date__c <= :PreviousWeekEnd  and Start_Date__c >= :PreviousWeekStart  ];
      else
          Delete [Select ID from Planning_statistics__C where Time_Type__c = 'Week' and Data_Type__c ='Actual' and Start_Date__c <= :PreviousWeekEnd  and Start_Date__c >= :CurrentMonthStart  ];     
      
      PlanningScheduleUpdate updateSchedule = new PlanningScheduleUpdate();   
    
  }
  
   public void runMonthlyJob(){     
   
    if(!IsMonthChangeinWeekPlanned)
      Delete [Select ID from Planning_statistics__C where Time_Type__c = 'Month' and Data_Type__c ='Planned' and Start_Date__c <= :CurrentMonthEnd  and Start_Date__c >= :CurrentMonthStart ];
    else
      Delete [Select ID from Planning_statistics__C where Time_Type__c = 'Month' and Data_Type__c ='Planned' and Start_Date__c <= :CurrentMonthEnd  and Start_Date__c >= :CurrentMonthStart ];   
    if(!IsMonthChangeinWeekActual)  
      Delete [Select ID from Planning_statistics__C where Time_Type__c = 'Month' and Data_Type__c ='Actual' and Start_Date__c <= :PreviousMonthEnd  and Start_Date__c >= :PreviousMonthStart ];
    else
      Delete [Select ID from Planning_statistics__C where Time_Type__c = 'Month' and Data_Type__c ='Actual' and Start_Date__c <= :PreviousMonthEnd  and Start_Date__c >= :PreviousMonthStart ];  
      
      PlanningScheduleUpdate updateSchedule = new PlanningScheduleUpdate();   
    
  }

}