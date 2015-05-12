/* ------------------------------------
@Project : PSO Tool
@Company: MOLD TEK
@Author: Phani Joshi
@Creation date: 25/03/2015  
@Description : This class is used to calcualte Planned/Actual planning statistics and update OpportunityLineItemSchedule
object when ran weekly/monthly.
---------------------------------------*/
public class PlanningScheduleUpdate {

    public PlanningScheduleUpdate__c runTime = PlanningScheduleUpdate__c.getValues('PlanningScheduleUpdate');
    public Date d = System.today();
    public Datetime dt = (DateTime) d;
    public String dayOfWeek = dt.format('EEEE');
    public static final String SPECIAL_OPPORTUNITY = '° Urlaub/Krankheit/Feiertage';
    public Date PreviousWeekStart { get;set;}
    public Date PreviousWeekEnd  { get;set;}
    public Date CurrentWeekStart { get;set;}
    public Date CurrentWeekEnd  { get;set;}
    public Date PreviousMonthStart { get;set;}
    public Date PreviousMonthend  { get;set;}
    public Date CurrentMonthStart { get;set;}
    public Date CurrentMonthEnd  { get;set;}
    public Date PreviousMonthLastMonday { get;set;}


    public PlanningScheduleUpdate() {

          getDatesForCalculation();
          populateStatisticsData('Planned');
          updateOpportunityData();
          populateStatisticsData('Actual');
    }
 
    public void getDatesForCalculation(){

        PreviousWeekStart = d.toStartOfWeek()-7;
        PreviousWeekEnd = d.toStartOfWeek()-1;
        CurrentWeekStart = d.toStartOfWeek();
        CurrentWeekEnd = d.toStartOfWeek()+6;
         
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

    public void populateStatisticsData(String value) {

        List < OpportunityLineItem > OppLineItem = new List < OpportunityLineItem > ();
        List < OpportunityLineItemSchedule > OppLineItemSchedule = new List < OpportunityLineItemSchedule > ();
        List < Planning_statistics__c > Planningstatistics = new List < Planning_statistics__c > ();
        List < OpportunityLineItemSchedule > OppLineQuantity = new List < OpportunityLineItemSchedule > ();
        Set < Id > OppLineItemId = new Set < Id > ();
        List < OpportunityLineItemSchedule > oppLinSchdlst = new List < OpportunityLineItemSchedule > ();
        List < OpportunityLineItemSchedule > oppLinSchdlstdel = new List < OpportunityLineItemSchedule > ();
        Set < Id > oppLinSchdlstset = new set < Id > ();
    
        //Queries OLIS records which needs to deleted and stores in a list.
        //if (dayOfWeek == label.Dayofweek) {
        if (dayOfWeek == runTime.Dayofweek__c && value == label.Planned) {
            for (OpportunityLineItemSchedule OppLineItemSchdl: [SELECT Id, OpportunityLineItem.Contact__r.Id,
            OpportunityLineItem.unitprice, CreatedDate, OpportunityLineItemId,
            OpportunityLineItem.OpportunityId, ScheduleDate, SystemModstamp, Type, Quantity
            FROM OpportunityLineItemSchedule where Description != 'UNPLANNED'
            and ScheduleDate >= :PreviousWeekStart and ScheduleDate <= :PreviousWeekEnd and OpportunityLineItem.Managed_by_PSO_Tool__c = true
            and OpportunityLineItem.Opportunity.Name != : SPECIAL_OPPORTUNITY order by ScheduleDate ASC]) {
                oppLinSchdlst.add(OppLineItemSchdl);
            }
        }

        //Weekly logic 
        //if (dayOfWeek == label.Dayofweek) {
        if (dayOfWeek == runTime.Dayofweek__c) {
            Lstwrap = new List < Wrapper > ();
            if (value == label.Planned) {
                for (OpportunityLineItem OppLineItm: [Select Id, Name, ListPrice, UnitPrice, (Select Id, Quantity from OpportunityLineItemSchedules where Description != 'UNPLANNED'
                and ScheduleDate >= :CurrentWeekStart and ScheduleDate <= :CurrentWeekEnd order by ScheduleDate ASC) from opportunitylineItem
                where Managed_by_PSO_Tool__c = true and OpportunityLineItem.Opportunity.Name != : SPECIAL_OPPORTUNITY]) {
                    if (OppLineItm.OpportunityLineItemSchedules.size() > 0) {
                        CalculateValues(OppLineItm, 'Week', false);

                    }
                }
            }
            if (value == label.Actual) {
                
                for (OpportunityLineItem OppLineItmAc: [Select Id, Name, ListPrice, UnitPrice, (Select Id, Quantity from OpportunityLineItemSchedules where Description != 'UNPLANNED'
                and ScheduleDate >= :PreviousWeekStart and ScheduleDate <= :PreviousWeekEnd order by ScheduleDate ASC) from opportunitylineItem
                where Managed_by_PSO_Tool__c = true and OpportunityLineItem.Opportunity.Name != : SPECIAL_OPPORTUNITY]) {
                    if (OppLineItmAC.OpportunityLineItemSchedules.size() > 0) {
                        CalculateValues(OppLineItmAc, 'Week', false);

                    }
                }
            }
        }
        //Monthly logic
        //if (d.day() == Integer.valueof(label.DateofMonth)) {
        if (d.day() == runTime.DateofMonth__c) {
            system.debug('In month logic');
            if (dayOfWeek != 'Sunday') Lstwrap = new List < Wrapper > ();

            /* for(OpportunityLineItemSchedule OppLineItemSchdl : [SELECT id FROM OpportunityLineItemSchedule where Description !='UNPLANNED' and ScheduleDate <= THIS_MONTH and  ScheduleDate >=LAST_MONTH  order by ScheduleDate ASC ]){
                   oppLinSchdlst.add(OppLineItemSchdl); 
               }*/

            if (Value == label.Planned) {
                for (OpportunityLineItem OppLineItm: [select Id, Name, ListPrice, UnitPrice, (Select Id, Quantity from OpportunityLineItemSchedules where Description != 'UNPLANNED'
                and ScheduleDate >= :CurrentMonthStart and ScheduleDate <= :CurrentMonthEnd order by ScheduleDate ASC) from opportunitylineItem
                where Managed_by_PSO_Tool__c = true and OpportunityLineItem.Opportunity.Name != : SPECIAL_OPPORTUNITY]) {
                    if (OppLineItm.OpportunityLineItemSchedules.size() > 0) {

                        CalculateValues(OppLineItm, 'Month', false);
                    }
                }
            }


           if (Value == label.Actual) {
                for (OpportunityLineItem OppLineItmAC: [select Id, Name, ListPrice, UnitPrice, (Select Id, Quantity from OpportunityLineItemSchedules where Description != 'UNPLANNED'
                and ScheduleDate >= :PreviousMonthStart and ScheduleDate <= :PreviousMonthend order by ScheduleDate ASC) from opportunitylineItem
                where Managed_by_PSO_Tool__c = true and OpportunityLineItem.Opportunity.Name != : SPECIAL_OPPORTUNITY]) {
                    if (OppLineItmAC.OpportunityLineItemSchedules.size() > 0) {

                        CalculateValues(OppLineItmAC, 'Month', false);

                    }
                }
            }

            if (dayOfWeek != 'Sunday' && dayOfWeek != 'Monday') {

                if(value == label.Planned){ 

                for (OpportunityLineItemSchedule OppLineItemSchdl: [SELECT Id FROM OpportunityLineItemSchedule
                where Description != 'UNPLANNED'
                and ScheduleDate >= : PreviousMonthLastMonday and ScheduleDate <= : PreviousMonthEnd
                and OpportunityLineItem.Managed_by_PSO_Tool__c = true
                and OpportunityLineItem.Opportunity.Name != : SPECIAL_OPPORTUNITY order by ScheduleDate ASC]) {

                    oppLinSchdlst.add(OppLineItemSchdl);
                }
            }

                if (value == label.Actual && value == label.Planned) {
                   for (OpportunityLineItem OppLineItmAC: [Select Id, Name, ListPrice, UnitPrice, (Select id, Quantity from OpportunityLineItemSchedules where Description != 'UNPLANNED'
                    and ScheduleDate >= : PreviousMonthLastMonday and ScheduleDate <= : PreviousMonthEnd order by ScheduleDate ASC)
                    from opportunitylineItem where Managed_by_PSO_Tool__c = true and OpportunityLineItem.Opportunity.Name != : SPECIAL_OPPORTUNITY]) {
                         if (OppLineItmAC.OpportunityLineItemSchedules.size() > 0) {

                            CalculateValues(OppLineItmAC, 'Week', true);                                
                        }
                    }
                }

                /*if (value == label.Planned) {
                    for (OpportunityLineItem OppLineItmAC: [Select Id, Name, ListPrice, UnitPrice, (Select Id, Quantity from OpportunityLineItemSchedules where Description != 'UNPLANNED'
                    and ScheduleDate >= : PreviousMonthLastMonday and ScheduleDate <= : PreviousMonthEnd order by ScheduleDate ASC)
                    from opportunitylineItem where Managed_by_PSO_Tool__c = true and OpportunityLineItem.Opportunity.Name != : SPECIAL_OPPORTUNITY]) {
                        if (OppLineItmAC.OpportunityLineItemSchedules.size() > 0) {
                            CalculateValues(OppLineItmAC, 'Week', true);                                                                                
                        }
                    }
                }*/
            }
        }       
    
        for (wrapper wp: lstwrap) {
            Planning_statistics__c p = new Planning_statistics__c();
            p.OpportunityLineItemId__c = wp.OppLIne.id;
            p.Days__c = wp.Quantity;
            p.Revenue__c = wp.revenue;
            if (wp.TimeType == 'Week') {                
                if (!wp.IsWeeklyUpdateInMonth) {
                    if (value == label.Planned) {
                        p.Start_Date__c = CurrentWeekStart;
                        p.End_Date__c = CurrentWeekEnd;                     
                    }
                    if (value == label.Actual) {
                        p.Start_Date__c = PreviousWeekStart;
                        p.End_Date__c = PreviousWeekEnd;                  
                    }
                } else {
                    if (value == label.Planned) {                   
                        p.Start_Date__c = PreviousMonthLastMonday ;
                        p.End_Date__c = PreviousMonthEnd;                   
                                     
                    }
                    if (value == label.Actual) {
                        p.Start_Date__c = PreviousMonthLastMonday;
                        p.End_Date__c = PreviousMonthEnd;              
                    }               
                    }

                }
            else if (wp.TimeType == 'Month') {      
            
                if (value == label.Planned) {
                    p.Start_Date__c = CurrentMonthStart;
                    p.End_Date__c = CurrentMonthEnd; 
                             
                }
                if (value == label.Actual) {
                    p.Start_Date__c = PreviousMonthStart;
                    p.End_Date__c = PreviousMonthEnd;  
               
                }               
            }

            p.Time_Type__c = wp.TimeType;
            P.Data_Type__c = value;
            system.debug('ps' + p);
            planningStatistics.add(p);

        }
        System.debug('Plannning statistic' + planningStatistics.Size() + planningStatistics);

        if (value != label.Actual && oppLinSchdlst != null && oppLinSchdlst.size() > 0) {
            for (Opportunitylineitemschedule opscl: oppLinSchdlst) {
                if (!oppLinSchdlstset.contains(opscl.id)) oppLinSchdlstdel.add(opscl);
                oppLinSchdlstset.add(opscl.id);

            }
            delete oppLinSchdlstdel;
        }


        if (!planningStatistics.isempty()) insert planningStatistics;

    }


    public void updateOpportunityData() {

        List < TimeEntry__c > timeEntries = new List < TimeEntry__c > ();
        Set < id > timeEntryIds = new Set < id > ();
        //if (dayOfWeek == label.Dayofweek)     {
        if (dayOfWeek == runTime.Dayofweek__c) {

            timeEntries = [Select id, Opportunity_Product_ID__c, Date__c, Time__c from TimeEntry__c
            where Date__c >= :PreviousWeekStart and Date__c <= :PreviousWeekEnd and Billable__c  = true  order by Date__c ASC];

        }

        //if (d.day() == Integer.valueof(label.DateofMonth) && dayOfWeek != 'sunday') {
        if (d.day() == runTime.DateofMonth__c && dayOfWeek != 'sunday') {
            timeEntries = [Select id, Opportunity_Product_ID__c, Date__c, Time__c from TimeEntry__c
            where Date__c >= :PreviousMonthLastMonday and Date__c <= :PreviousMonthEnd and Billable__c  = true order by Date__c ASC];
        }

        for (TimeEntry__c entry: timeEntries) {
            timeEntryIds.add(entry.Opportunity_Product_ID__c);
        }

        Map < id, OpportunityLineItem > managedOppLineItemsMap = new Map < id, OpportunityLineItem > ([Select id from OpportunityLineItem where Managed_by_PSO_Tool__c = true
        and id in : timeEntryIds and Opportunity.Name != : SPECIAL_OPPORTUNITY]);


        List < OpportunityLineItemSchedule > schedules = new List < OpportunityLineItemSchedule > ();
        Map < String, TimeEntry__c > timeEntriesMap = new Map < String, TimeEntry__c > ();

        if (timeEntries != null && timeEntries.size() > 0) {

            for (TimeEntry__c entry: timeEntries) {
                if (entry.Opportunity_Product_ID__c != null && entry.Date__c != null) {
                    if (timeEntriesMap.get(entry.Opportunity_Product_ID__c + '' + entry.Date__c) == null) {
                        if (managedOppLineItemsMap.containsKey(entry.Opportunity_Product_Id__c)) {
                            timeEntriesMap.put(entry.Opportunity_Product_ID__c + '' + entry.Date__c, entry);
                        }
                    } else if (timeEntriesMap.get(entry.Opportunity_Product_ID__c + '' + entry.Date__c) != null) {
                        TimeEntry__c toBeUpdatedEntry = timeEntriesMap.get(entry.Opportunity_Product_ID__c + '' + entry.Date__c);
                        toBeUpdatedEntry.Time__c = toBeUpdatedEntry.Time__c + entry.Time__c;
                        if (managedOppLineItemsMap.containsKey(entry.Opportunity_Product_Id__c)) {
                            timeEntriesMap.put(entry.Opportunity_Product_ID__c + '' + entry.Date__c, toBeUpdatedEntry);
                        }
                    }
                }
            }

            List < TimeEntry__c > updatedTimeEntries = timeEntriesMap.values();

            for (TimeEntry__c entry: updatedTimeEntries) {
                OpportunityLineItemSchedule schedule = new OpportunityLineItemSchedule();
                schedule.OpportunityLineItemId = entry.Opportunity_Product_ID__c;
                schedule.Quantity = entry.Time__c / 8;
                schedule.ScheduleDate = entry.Date__c;
                schedule.Type = 'Quantity';
                system.debug('os' + schedule);
                schedules.add(schedule);

            }
        }

        if (schedules.size() > 0) {
            System.debug('### ' + schedules);
            insert schedules;
        }
    }

    public void CalculateValues(OpportunityLineItem OppLineItm, String TimeType, Boolean IsWeeklyUpdateInMonth) {
        Wrapper w = new Wrapper();
        w.Oppline = OppLineItm;
        Decimal Qty = 0;
        for (OpportunityLineItemSchedule a: OppLineItm.OpportunityLineItemSchedules) {
            Qty += a.Quantity;

        }

        w.Quantity = Qty;
        w.Revenue = OppLineItm.UnitPrice * Qty;
        w.TimeType = TimeType;
        w.IsWeeklyUpdateInMonth = IsWeeklyUpdateInMonth;
        Lstwrap.add(w);

    }

    List < Wrapper > Lstwrap = new List < Wrapper > ();
    public class Wrapper {
        public OpportunitylineItem OppLIne {
            get;
            set;
        }
        Public Decimal Quantity {
            get;
            set;
        }
        Public Decimal Revenue {
            get;
            set;
        }
        public String TimeType {
            get;
            set;
        }
        public Boolean IsWeeklyUpdateInMonth {
            get;
            set;
        }

    }

}