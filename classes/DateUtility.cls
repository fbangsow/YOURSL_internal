public with sharing class DateUtility {

    /*public static Date getFirstDayForWeekNumberAndYear(Integer year, Integer weekNumber){
        Date newYear = Date.newInstance(year, 1, 1);
        Date newYearsWeekStart = newYear.toStartofWeek();
        Date firstDayOfWeek = newYearsWeekStart.addDays(7 * (weekNumber-1));
        return firstDayOfWeek;
    }*/
    public static Date getFirstDayForWeekNumberAndYear(Integer year, Integer weekNumber){
        Date newYear = Date.newInstance(year, 1, 1);
		DateTime newYear1 = DateTime.newInstance(year, 1, 1);
		String dayName = newYear1.format('EEEE');
		system.debug('$$$$$$$$dayName'+dayName);

		Date newYearsWeekStart;
		Date firstDayOfWeek;
		if(dayName == 'Friday'){
            newYearsWeekStart = newYear.addDays(3+(7*(weekNumber-1)));
		}else
		if(dayName == 'Satarday'){
    		 newYearsWeekStart = newYear.addDays(2+(7*(weekNumber-1)));
		}else
		if(dayName == 'Sunday'){
    		 newYearsWeekStart = newYear.addDays(1+(7*(weekNumber-1)));
        }else if(dayName == 'Thursday') {
           newYearsWeekStart = newYear.addDays(4+(7*(weekNumber-2)));
        }
		else if(dayName == 'Wednesday') {
           newYearsWeekStart = newYear.addDays(5+(7*(weekNumber-2)));
        }
		else if(dayName == 'Tuesday') {
           newYearsWeekStart = newYear.addDays(6+(7*(weekNumber-2)));
        }
		else if(dayName == 'Monday') {
           newYearsWeekStart = newYear.addDays(7+(7*(weekNumber-2)));
        }
        return newYearsWeekStart;
    }
}