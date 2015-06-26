public class StatisticsCalculator {
    @TestVisible private Boolean IsPlanned;
    @TestVisible private Date WeekStart;
    @TestVisible private Date WeekEnd;
    @TestVisible private Boolean ExtendedContext;
    @TestVisible private Date MonthStart;
    @TestVisible private Date MonthEnd;
    @TestVisible private Date JobDate;
    private final String RUN_DAY = 'Monday';
    private final Boolean IS_NEXT_WEEK_RUN = true;
    public final static String WEEK_TIME_TYPE = 'Week';
    public final static String MONTH_TIME_TYPE = 'Month';
    public final static String ACTUAL_DATA_TYPE = 'Actual';
    public final static String PLANNED_DATA_TYPE = 'Planned';
    private Map <String, Integer> NameToNumberForWeekDays = new Map <String, Integer >{
        'Monday' => 0,
        'Tuesday' => 1,
        'Wednesday' => 2,
        'Thursday' => 3,
        'Friday' => 4,
        'Saturday' => 5,
        'Sunday' => 6};

    private StatisticsCalculator(Date job_date, Boolean is_planned){
        IsPlanned = is_planned;
        JobDate = job_date;
        getDatesForCalculation();
    }

    public static StatisticsCalculator getInstance(Date job_date, Boolean is_planned){
        return new StatisticsCalculator(job_date, is_planned);
    }

    private void getDatesForCalculation() {
        ExtendedContext = (JobDate.day() == 1) ? true : false;
        if(!ExtendedContext && NameToNumberForWeekDays.get(((Datetime)JobDate).format('EEEE'))!=0)
            throw new InvalidDateException('Selected date is not Monday or the first day of a month');
        if(IsPlanned){
            calculateDatesForPlannedContext();
        }
        else {
            calculateDatesForActualContext();
        }
    }

    private void calculateDatesForPlannedContext(){
        Boolean split_week = isSplitWeekForPlanned();
        WeekStart = getPlannedWeekStart(split_week);
        WeekEnd = getPlannedWeekEnd(split_week);
        if(ExtendedContext){
            MonthStart = getPlannedMonthStart();
            MonthEnd = getPlannedMonthEnd();
        }
    }

    private void calculateDatesForActualContext(){
        Boolean split_week = isSplitWeekForActual();
        WeekStart = getActualWeekStart(split_week);
        WeekEnd = getActualWeekEnd(split_week);
        if(ExtendedContext){
            MonthStart = getActualMonthStart();
            MonthEnd = getActualMonthEnd();
        }
    }

    private Boolean isSplitWeekForPlanned(){
        return (JobDate.daysBetween(Date.newInstance(JobDate.year(), JobDate.month(), Date.daysInMonth(JobDate.year(), JobDate.month())))) < (getSplitWeekThreshold()-1) ? true : false;
    }

    private Boolean isSplitWeekForActual(){
        return (JobDate.day() < getSplitWeekThreshold()) ? true : false;
    }

    private Date getPlannedWeekStart(Boolean split_week){
        if(ExtendedContext)
            return JobDate.toStartOfMonth();
        else if(!ExtendedContext && split_week)
            return Date.newInstance(JobDate.year(),JobDate.month(),Date.daysInMonth(JobDate.year(), JobDate.month())).
                                            addDays(-NameToNumberForWeekDays.get(DateTime.newInstance(JobDate.year(),JobDate.month(),Date.daysInMonth(JobDate.year(), JobDate.month())).format('EEEE')));
        else
            return JobDate.addDays(8 - getSplitWeekThreshold());
    }

    private Date getPlannedWeekEnd(Boolean split_week){
        if(ExtendedContext)
            return JobDate.toStartOfMonth().addDays(6 - NameToNumberForWeekDays.get(((Datetime)JobDate).format('EEEE')));
        else if(!ExtendedContext && split_week)
            return Date.newInstance(JobDate.year(), JobDate.month(), Date.daysInMonth(JobDate.year(), JobDate.month()));
        else
            return JobDate.addDays(14 - getSplitWeekThreshold());
    }

    private Date getActualWeekStart(Boolean split_week){
        if(ExtendedContext)
            return JobDate.addDays(-1).toStartOfWeek();
        else if(!ExtendedContext && split_week)
            return JobDate.toStartOfMonth();
        else
            return JobDate.addDays(-(getSplitWeekThreshold() - 1));
    }

    private Date getActualWeekEnd(Boolean split_week){
        if(ExtendedContext)
            return Date.newInstance(JobDate.addDays(-1).toStartOfWeek().year(), JobDate.addDays(-1).toStartOfWeek().month(), Date.daysInMonth(JobDate.addDays(-1).toStartOfWeek().year(), JobDate.addDays(-1).toStartOfWeek().month()));
        else if(!ExtendedContext && split_week)
            return JobDate.toStartOfMonth().addDays(6 - NameToNumberForWeekDays.get(((Datetime)JobDate.toStartOfMonth()).format('EEEE')));
        else
            return JobDate.addDays(-(getSplitWeekThreshold() - 7));
    }

    private Date getPlannedMonthStart(){
        return JobDate.toStartOfMonth();
    }

    private Date getPlannedMonthEnd(){
        return Date.newInstance(JobDate.year(), JobDate.month(), Date.daysInMonth(JobDate.year(), JobDate.month()));
    }

    private Date getActualMonthStart(){
        return JobDate.addDays(-1).toStartOfMonth();
    }

    private Date getActualMonthEnd(){
        return JobDate.addDays(-(getSplitWeekThreshold() - 7));
    }

    private Integer getSplitWeekThreshold(){
        Integer threshold = 1 + NameToNumberForWeekDays.get(RUN_DAY);
        if(IS_NEXT_WEEK_RUN)
            threshold += 7;
            return threshold;
    }

    public void createStatistics(){
        List<RawStatistics> statistics = getStatisticalData(WeekStart, WeekEnd, WEEK_TIME_TYPE, getDataType());
        delete [SELECT Id FROM Planning_Statistics__c WHERE Start_Date__c =: WeekStart AND End_Date__c =: WeekEnd AND Data_Type__c =: getDataType()];
        if(ExtendedContext){
            statistics.addAll(getStatisticalData(MonthStart, MonthEnd, MONTH_TIME_TYPE, getDataType()));
            delete [SELECT Id FROM Planning_Statistics__c WHERE Start_Date__c =: MonthStart AND End_Date__c =: MonthEnd AND Data_Type__c =: getDataType()];
        }
        insertNewEntries(statistics);
        if(IsPlanned)
            prepareDatesForReplacementOfActualsAndCallEraser();
        else
            sendNotification();
    }

    private void prepareDatesForReplacementOfActualsAndCallEraser(){
        calculateDatesForActualContext();
        Database.executeBatch(new PlannedSchedulesEraser(WeekStart, WeekEnd, JobDate));
    }

    @TestVisible private List<RawStatistics> getStatisticalData(Date start_date, Date end_date, String time_type, String data_type){
        List<OpportunitylineItemSchedule> schedules_to_calculate = [SELECT Id, Quantity, OpportunitylineItem.Id, OpportunitylineItem.UnitPrice, OpportunitylineItem.Contact__r.Id
            FROM OpportunityLineItemSchedule
            WHERE Description != :OpportunityLineItemScheduleChangeHandler.UNPLANNED_COMMENT
            AND ScheduleDate >= :start_date
            AND ScheduleDate <= :end_date
            AND OpportunityLineItem.Managed_by_PSO_Tool__c = true
            AND OpportunityLineItem.Opportunity.Name != :(PsoToolController.SPECIAL_OPPORTUNITY + '%')
            AND OpportunityLineItem.Unit__c = 'Manntag(e)'
            ORDER BY ScheduleDate ASC];
        Map<Id, RawStatistics> opp_line_item_id_to_planning_stats = new Map<Id, RawStatistics>();
        for(OpportunityLineItemSchedule schedule : schedules_to_calculate){
            if(!opp_line_item_id_to_planning_stats.containsKey(schedule.OpportunityLineItem.Id))
                opp_line_item_id_to_planning_stats.put(schedule.OpportunityLineItem.Id, createNewRawStatisticsEntry(schedule, time_type, data_type));
            else
                opp_line_item_id_to_planning_stats.get(schedule.OpportunityLineItem.Id).Days += schedule.Quantity;
        }
        return opp_line_item_id_to_planning_stats.values();
    }

    private String getDataType(){
        if(IsPlanned)
            return PLANNED_DATA_TYPE;
        else
            return ACTUAL_DATA_TYPE;
    }

    private RawStatistics createNewRawStatisticsEntry(OpportunityLineItemSchedule schedule, String time_type, String data_type){
        RawStatistics new_entry = new RawStatistics();
        new_entry.ContactId = schedule.OpportunitylineItem.Contact__r.Id;
        new_entry.Days = schedule.Quantity;
        new_entry.SalesPrice = schedule.OpportunitylineItem.UnitPrice;
        new_entry.OpportunityLineItemId = schedule.OpportunitylineItem.Id;
        new_entry.TimeType = time_type;
        new_entry.DataType = data_type;
        if(time_type == WEEK_TIME_TYPE){
            new_entry.StartDate = WeekStart;
            new_entry.EndDate = WeekEnd;
        } else{
            new_entry.StartDate = MonthStart;
            new_entry.EndDate = MonthEnd;
        }
        return new_entry;
    }

    private void insertNewEntries(List<RawStatistics> stats){
        if(!stats.isEmpty()){
            List<Planning_Statistics__c> records_to_insert = new List<Planning_Statistics__c>();
            for(RawStatistics stat: stats)
                records_to_insert.add(getRecordToInsert(stat));
            if(!records_to_insert.isEmpty())
                insert records_to_insert;
        }
    }

    public DatesToBeDisplayed getDatesToBeDisplayed(){
        DatesToBeDisplayed dates_array = new DatesToBeDisplayed();
        Boolean split_week_for_planned = isSplitWeekForPlanned();
        dates_array.PlannedWeekStart = getPlannedWeekStart(split_week_for_planned).format();
        dates_array.PlannedWeekEnd = getPlannedWeekEnd(split_week_for_planned).format();
        Boolean split_week_for_actual = isSplitWeekForActual();
        dates_array.ActualWeekStart = getActualWeekStart(split_week_for_actual).format();
        dates_array.ActualWeekEnd = getActualWeekEnd(split_week_for_actual).format();
        if(ExtendedContext){
            dates_array.PlannedMonthStart = getPlannedMonthStart().format();
            dates_array.PlannedMonthEnd = getPlannedMonthEnd().format();
            dates_array.ActualMonthStart = getActualMonthStart().format();
            dates_array.ActualMonthEnd = getActualMonthEnd().format();
        }
        return dates_array;
    }

    private Planning_Statistics__c getRecordToInsert(RawStatistics stat){
        Planning_Statistics__c new_record = new Planning_Statistics__c();
        new_record.Contact__c = stat.ContactId;
        new_record.Data_Type__c = stat.DataType;
        new_record.Time_Type__c = stat.TimeType;
        new_record.Days__c = stat.Days;
        new_record.Start_Date__c = stat.StartDate;
        new_record.End_Date__c = stat.EndDate;
        new_record.OpportunityLineItemId__c = stat.OpportunityLineItemId;
        new_record.Revenue__c = stat.Days * stat.SalesPrice;
        return new_record;
    }

    private void sendNotification(){
        EmailUtility.getInstance().setSendTo(UserInfo.getUserEmail())
                                    .setCcTo('c.leffin@yoursl.de')
                                    .setReplyTo('no_reply@yoursl.de')
                                    .setSenderDisplayName('PsoTool Team')
                                    .setSubject('Manual Run Completed')
                                    .setHtmlBody(getLetterBody())
                                    .send();
    }

    private String getLetterBody(){
        String body = 'Dear ' + UserInfo.getFirstName() + ',<br><br>';
        body += 'this is a notification that the <a href="https://' + System.URL.getSalesforceBaseUrl().getHost() + '/apex/PsoTable">PSO TOOL</a> has successfully processed the time frame from ' + WeekStart.format() + '-' + WeekEnd.format() + '.<br><br>';
        body += 'If this email is sent on Monday or the first of a month in the morning it is because of an automated scheduled run.<br>';
        body += 'If this email is sent on a different time it is because you have manually started it.<br><br>';
        body += 'Your Salesforce Team.';
        return body;
    }

    public class RawStatistics {
        public Id ContactId;
        public Decimal Days;
        public Decimal SalesPrice;
        public String TimeType;
        public String DataType;
        public Id OpportunityLineItemId;
        public Date StartDate;
        public Date EndDate;
    }

    public class DatesToBeDisplayed {
        public String PlannedWeekStart;
        public String PlannedWeekEnd;
        public String ActualWeekStart;
        public String ActualWeekEnd;
        public String PlannedMonthStart;
        public String PlannedMonthEnd;
        public String ActualMonthStart;
        public String ActualMonthEnd;

        public String JSON(){
            return JSON.serialize(this);
        }
    }

    public class InvalidDateException extends Exception{}
}