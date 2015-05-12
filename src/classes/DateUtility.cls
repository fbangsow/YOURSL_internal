public with sharing class DateUtility {

    public static Date getFirstDayForWeekNumberAndYear(Integer year, Integer weekNumber){
        Date newYear = Date.newInstance(year, 1, 1);
        Date newYearsWeekStart = newYear.toStartofWeek();
        Date firstDayOfWeek = newYearsWeekStart.addDays(7 * (weekNumber-1));
        return firstDayOfWeek;
    }
}