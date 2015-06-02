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
    public Date CurrentMonthFirstSunday { get;set;}
    public Boolean IsMonthChangeinWeekPlanned {get;set;}
    public Boolean IsMonthChangeinWeekActual {get;set;}


    public PlanningScheduleUpdate() {

        getDatesForCalculation(d);
        populateStatisticsData('Planned', false, false);
        updateOpportunityData(false, false);
        populateStatisticsData('Actual', false, false);
    }

    public PlanningScheduleUpdate(String selectedDate, Boolean isWeeklyManualRun, Boolean isMonthlyManualRun) {

        String[] myDateOnly = selectedDate.split(' ');
        String[] strDate = myDateOnly[0].split('/');
        Integer myIntDate = integer.valueOf(strDate[1]);
        Integer myIntMonth = integer.valueOf(strDate[0]);
        Integer myIntYear = integer.valueOf(strDate[2]);
        Date dateValue = Date.newInstance(myIntYear, myIntMonth, myIntDate);

        getDatesForCalculation(dateValue);
        populateStatisticsData('Planned', isWeeklyManualRun, isMonthlyManualRun);
        updateOpportunityData(isWeeklyManualRun, isMonthlyManualRun);
        populateStatisticsData('Actual', isWeeklyManualRun, isMonthlyManualRun);
    }


    public void getDatesForCalculation(Date dateValue) {

        PreviousWeekStart = dateValue.toStartOfWeek() - 7;
        PreviousWeekEnd = dateValue.toStartOfWeek() - 1;
        CurrentWeekStart = dateValue.toStartOfWeek();
        CurrentWeekEnd = dateValue.toStartOfWeek() + 6;
        IsMonthChangeinWeekPlanned = false;
        IsMonthChangeinWeekActual = false;

        Integer prevmonth = 0;
        Integer nxtmonth = 0;
        Integer currentmonth = 0;
        Integer y = dateValue.year();
        Integer m = dateValue.month();
        Integer dy;
        Integer currentday;
        Integer nxtdy;
        Integer year = y;
        prevmonth = m - 1;
        nxtmonth = m + 1;
        currentmonth = m;
        PreviousMonthStart = date.newinstance(year, prevmonth, 1);
        CurrentMonthStart = date.newInstance(year, currentmonth, 1);

        dy = Date.daysinmonth(y, prevmonth) - 1;
        currentday = Date.daysInMonth(y, currentmonth) - 1;
        nxtdy = Date.daysinmonth(y, nxtmonth) - 1;

        PreviousMonthEnd = date.newinstance(year, prevmonth, 1 + dy);
        CurrentMonthEnd = date.newInstance(year, currentmonth, 1 + currentday);
        if (m == 12) {
            PreviousMonthStart = date.newinstance(year, prevmonth, 1);
            PreviousMonthEnd = date.newinstance(year, prevmonth, 1 + dy);
            CurrentMonthStart = date.newInstance(year, currentmonth, 1);
            CurrentMonthEnd = date.newInstance(year, currentmonth, 1 + currentday);
            year = y + 1;
            nxtdy = Date.daysinmonth(y, nxtmonth) - 1;
        }
        if (PreviousWeekStart.month() != PreviousWeekEnd.month()) {
            IsMonthChangeinWeekActual = true;
        }
        if (CurrentWeekStart.month() != CurrentWeekEnd.month()) {
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

    public void populateStatisticsData(String value, Boolean isWeeklyManualRun, Boolean isMonthlyManualRun) {

        List < OpportunityLineItem > OppLineItem = new List < OpportunityLineItem > ();
        List < OpportunityLineItemSchedule > OppLineItemSchedule = new List < OpportunityLineItemSchedule > ();
        List < Planning_statistics__c > Planningstatistics = new List < Planning_statistics__c > ();
        List < OpportunityLineItemSchedule > OppLineQuantity = new List < OpportunityLineItemSchedule > ();
        Set < Id > OppLineItemId = new Set < Id > ();
        List < OpportunityLineItemSchedule > oppLinSchdlst = new List < OpportunityLineItemSchedule > ();
        List < OpportunityLineItemSchedule > oppLinSchdlstdel = new List < OpportunityLineItemSchedule > ();
        Set < Id > oppLinSchdlstset = new set < Id > ();

        //Queries OLIS records which needs to deleted and stores in a list.
        if ((dayOfWeek == runTime.Dayofweek__c && value == label.Planned) || (isWeeklyManualRun && !isMonthlyManualRun)) {

            if (!IsMonthChangeinWeekActual) {
                for (OpportunityLineItemSchedule OppLineItemSchdl: [SELECT Id, OpportunityLineItem.Contact__r.Id,
                OpportunityLineItem.unitprice, CreatedDate, OpportunityLineItemId,
                OpportunityLineItem.OpportunityId, ScheduleDate, SystemModstamp, Type, Quantity
                FROM OpportunityLineItemSchedule where Description != 'UNPLANNED'
                and ScheduleDate >= : PreviousWeekStart and ScheduleDate <= : PreviousWeekEnd and OpportunityLineItem.Managed_by_PSO_Tool__c = true
                and OpportunityLineItem.Opportunity.Name != : SPECIAL_OPPORTUNITY order by ScheduleDate ASC]) {
                    oppLinSchdlst.add(OppLineItemSchdl);
                }
            } else {
                for (OpportunityLineItemSchedule OppLineItemSchdl: [SELECT Id, OpportunityLineItem.Contact__r.Id,
                OpportunityLineItem.unitprice, CreatedDate, OpportunityLineItemId,
                OpportunityLineItem.OpportunityId, ScheduleDate, SystemModstamp, Type, Quantity
                FROM OpportunityLineItemSchedule where Description != 'UNPLANNED'
                and ScheduleDate >= : CurrentMonthStart and ScheduleDate <= : PreviousWeekEnd and OpportunityLineItem.Managed_by_PSO_Tool__c = true
                and OpportunityLineItem.Opportunity.Name != : SPECIAL_OPPORTUNITY order by ScheduleDate ASC]) {
                    oppLinSchdlst.add(OppLineItemSchdl);
                }
            }
        }

        //Weekly logic 
        if (dayOfWeek == runTime.Dayofweek__c || (isWeeklyManualRun && !isMonthlyManualRun)) {
            Lstwrap = new List < Wrapper > ();
            if (value == label.Planned) {

                if (!IsMonthChangeinWeekPlanned) getLineItemRecords(CurrentWeekStart, CurrentWeekEnd, 'Planned', 'Week', false);
                else getLineItemRecords(CurrentWeekStart, CurrentMonthEnd, 'Planned', 'Week', false);
            }
            if (value == label.Actual) {

                if (!IsMonthChangeinWeekActual) getLineItemRecords(PreviousWeekStart, PreviousWeekEnd, 'Actual', 'Week', false);
                else getLineItemRecords(CurrentMonthStart, PreviousWeekEnd, 'Actual', 'Week', false);
            }
        }
        //Monthly logic
        if (d.day() == runTime.DateofMonth__c || (!isWeeklyManualRun && isMonthlyManualRun)) {
            system.debug('In month logic');
            if (dayOfWeek != 'Monday') Lstwrap = new List < Wrapper > ();

            if (Value == label.Planned) {

                getLineItemRecords(CurrentMonthStart, CurrentMonthEnd, 'Planned', 'Month', false);
            }

            if (Value == label.Actual) {

                getLineItemRecords(PreviousMonthStart, PreviousMonthend, 'Actual', 'Month', false);
            }

            if (dayOfWeek != 'Sunday' && dayOfWeek != 'Monday') {

                if (value == label.Planned) {

                    for (OpportunityLineItemSchedule OppLineItemSchdl: [SELECT Id FROM OpportunityLineItemSchedule
                    where Description != 'UNPLANNED'
                    and ScheduleDate >= : PreviousMonthLastMonday and ScheduleDate <= : PreviousMonthEnd
                    and OpportunityLineItem.Managed_by_PSO_Tool__c = true
                    and OpportunityLineItem.Opportunity.Name != : SPECIAL_OPPORTUNITY order by ScheduleDate ASC]) {

                        oppLinSchdlst.add(OppLineItemSchdl);
                    }
                }

                if (value == label.Actual) {

                    getLineItemRecords(PreviousMonthLastMonday, PreviousMonthend, 'Actual', 'Week', true);
                }

                if (value == label.Planned) {

                    getLineItemRecords(CurrentMonthStart, CurrentMonthFirstSunday, 'Planned', 'Week', true);
                }
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
                        if (!IsMonthChangeinWeekPlanned) {
                            p.Start_Date__c = CurrentWeekStart;
                            p.End_Date__c = CurrentWeekEnd;
                        } else {
                            p.Start_Date__c = CurrentWeekStart;
                            p.End_Date__c = CurrentMonthEnd;
                        }
                    }
                    if (value == label.Actual) {
                        if (!IsMonthChangeinWeekActual) {
                            p.Start_Date__c = PreviousWeekStart;
                            p.End_Date__c = PreviousWeekEnd;
                        } else {
                            p.Start_Date__c = CurrentMonthStart;
                            p.End_Date__c = PreviousWeekEnd;
                        }
                    }
                } else {
                    if (value == label.Planned) {
                        p.Start_Date__c = CurrentMonthStart;
                        p.End_Date__c = CurrentMonthFirstSunday;

                    }
                    if (value == label.Actual) {
                        p.Start_Date__c = PreviousMonthLastMonday;
                        p.End_Date__c = PreviousMonthEnd;
                    }
                }

            } else if (wp.TimeType == 'Month') {

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
            planningStatistics.add(p);

        }

        if (value != label.Actual && oppLinSchdlst != null && oppLinSchdlst.size() > 0) {
            for (Opportunitylineitemschedule opscl: oppLinSchdlst) {
                if (!oppLinSchdlstset.contains(opscl.id)) oppLinSchdlstdel.add(opscl);
                oppLinSchdlstset.add(opscl.id);

            }
            delete oppLinSchdlstdel;
        }


        if (!planningStatistics.isempty()) insert planningStatistics;

    }


    public void updateOpportunityData(Boolean isWeeklyManualRun, Boolean isMonthlyManualRun) {

        List < TimeEntry__c > timeEntries = new List < TimeEntry__c > ();
        Set < id > timeEntryIds = new Set < id > ();
        if (dayOfWeek == runTime.Dayofweek__c || (isWeeklyManualRun && !isMonthlyManualRun)) {

            if (!IsMonthChangeinWeekActual) {
                timeEntries = [Select id, Opportunity_Product_ID__c, Date__c, Time__c from TimeEntry__c
                where Date__c >= : PreviousWeekStart and Date__c <= : PreviousWeekEnd and Billable__c = true order by Date__c ASC];
            } else {
                timeEntries = [Select id, Opportunity_Product_ID__c, Date__c, Time__c from TimeEntry__c
                where Date__c >= : CurrentMonthStart and Date__c <= : PreviousWeekEnd and Billable__c = true order by Date__c ASC];
            }

        }

        if ((d.day() == runTime.DateofMonth__c && dayOfWeek != 'monday') || (!isWeeklyManualRun && isMonthlyManualRun)) {
            timeEntries = [Select id, Opportunity_Product_ID__c, Date__c, Time__c from TimeEntry__c
            where Date__c >= : PreviousMonthLastMonday and Date__c <= : PreviousMonthEnd and Billable__c = true order by Date__c ASC];
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

        if (!schedules.isempty()) {
            insert schedules;
        }
    }

    public void getLineItemRecords(Date StartDate, Date EndDate, String DataType, String TimeType, Boolean IsWeeklyUpdateInMonth) {

        if (TimeType == 'Week') {
            if (!IsWeeklyUpdateInMonth) {
                if (DataType == label.Planned) {
                    if (!IsMonthChangeinWeekPlanned) Delete[Select ID from Planning_statistics__C where Time_Type__c = 'Week'
                    and Data_Type__c = 'Planned'
                    and Start_Date__c <= : CurrentWeekEnd and Start_Date__c >= : CurrentWeekStart];
                    else Delete[Select ID from Planning_statistics__C where Time_Type__c = 'Week'
                    and Data_Type__c = 'Planned'
                    and Start_Date__c <= : CurrentMonthEnd and Start_Date__c >= : CurrentWeekStart];
                }
                if (DataType == label.Actual) {
                    if (!IsMonthChangeinWeekActual) Delete[Select ID from Planning_statistics__C where Time_Type__c = 'Week'
                    and Data_Type__c = 'Actual'
                    and Start_Date__c <= : PreviousWeekEnd and Start_Date__c >= : PreviousWeekStart];
                    else Delete[Select ID from Planning_statistics__C where Time_Type__c = 'Week'
                    and Data_Type__c = 'Actual'
                    and Start_Date__c <= : PreviousWeekEnd and Start_Date__c >= : CurrentMonthStart];
                }
            } else {
                if (DataType == label.Planned) {
                    Delete[Select ID from Planning_statistics__C where Time_Type__c = 'Week'
                    and Data_Type__c = 'Planned'
                    and Start_Date__c <= : CurrentMonthFirstSunday and Start_Date__c >= : CurrentMonthStart];
                }
                if (DataType == label.Actual) {
                    Delete[Select ID from Planning_statistics__C where Time_Type__c = 'Week'
                    and Data_Type__c = 'Actual'
                    and Start_Date__c <= : PreviousMonthEnd and Start_Date__c >= : PreviousMonthLastMonday];
                }
            }
        }

        if (TimeType == 'Month' && DataType == label.Planned) {
            Delete[Select ID from Planning_statistics__C where Time_Type__c = 'Month'
            and Data_Type__c = 'Planned'
            and Start_Date__c <= : CurrentMonthEnd and Start_Date__c >= : CurrentMonthStart];
            Delete[Select ID from Planning_statistics__C where Time_Type__c = 'Week'
            and Data_Type__c = 'Planned'
            and Start_Date__c <= : CurrentMonthFirstSunday and Start_Date__c >= : CurrentMonthStart];
        }
        if (TimeType == 'Month' && DataType == label.Actual) {
            Delete[Select ID from Planning_statistics__C where Time_Type__c = 'Month'
            and Data_Type__c = 'Actual'
            and Start_Date__c <= : PreviousMonthEnd and Start_Date__c >= : PreviousMonthStart];
            Delete[Select ID from Planning_statistics__C where Time_Type__c = 'Week'
            and Data_Type__c = 'Actual'
            and Start_Date__c <= : PreviousMonthEnd and Start_Date__c >= : PreviousMonthLastMonday];
        }

        for (OpportunityLineItem OppLineItm: [Select Id, Name, ListPrice, UnitPrice, (Select Id, Quantity from OpportunityLineItemSchedules where Description != 'UNPLANNED'
        and ScheduleDate >= : StartDate and ScheduleDate <= : EndDate order by ScheduleDate ASC) from opportunitylineItem
        where Managed_by_PSO_Tool__c = true and OpportunityLineItem.Opportunity.Name != : SPECIAL_OPPORTUNITY]) {
            if (OppLineItm.OpportunityLineItemSchedules.size() > 0) {
                calculateValues(OppLineItm, TimeType, IsWeeklyUpdateInMonth);
            }
        }
    }

    public void calculateValues(OpportunityLineItem OppLineItm, String TimeType, Boolean IsWeeklyUpdateInMonth) {
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