public class GPL {
	
	public static string padIntegerWithZero(integer i) {
		if(i < 10) {return '0' + string.valueof(i);}
		else {return string.valueof(i);}
	}
	
	public static string padDoubleWithZero(Double d) {
		if(d < 10) {return '0' + string.valueof(d);}
		else {return string.valueof(d);}
	}
	
	//get the closest Monday (in the past)
	public static Date getMonday(Date curDate) {
		while(getDayOfTheWeek(curDate) != 'Monday') {
			curDate = curDate.addDays(-1);
		}
		
		return curDate;
	}	
		
	public static string getDayOfTheWeek(Date dateToFormat) {
		String dayOfWeekString = '';
		Integer day = dateToFormat.day();
		Integer month = dateToFormat.month();
	
		//Get last two digits of year
		Integer twoDigitYear = dateToFormat.year() - 2000;
	
		//Get first two digits of year
		String centuryYear = String.valueOf(dateToFormat.year());
		centuryYear = centuryYear.substring(0,2);
		Integer centuryYearInt = Integer.valueOf(centuryYear);
	
		//Centuries: c = 2(3 - (century mod 4))
		//century = last two numbers of the year
		Integer modYear = math.mod(centuryYearInt, 4);
		modYear = 3 - modYear;
		Integer century = 2 * modYear;
		System.debug('Century: ' + century);
	
		//Years: y = year + (year / 4)
		Integer years = twoDigitYear + (twoDigitYear / 4);
	
		//Months (check if leap year)
		Integer monthResult = 0;
	
		if(month == 1)
		{
			if(math.mod(dateToFormat.year(), 4) == 0)
				monthResult = 6;	//leap year
			else
				monthResult = 0;	//not leap year
		}
		else if(month == 2)
		{
			if(math.mod(dateToFormat.year(), 4) == 0)
				monthResult = 2;	//leap year
			else
				monthResult = 3;	//not leap year
		}
		else if(month == 3)
			monthResult = 3;
		else if(month == 4)
			monthResult = 6;
		else if(month == 5)
			monthResult = 1;
		else if(month == 6)
			monthResult = 4;
		else if(month == 7)
			monthResult = 6;
		else if(month == 8)
			monthResult = 2;
		else if(month == 9)
			monthResult = 5;
		else if(month == 10)
			monthResult = 0;
		else if(month == 11)
			monthResult = 3;
		else if(month == 12)
			monthResult = 5;
	
		//Calculate Running Total
		Integer runningTotal = century + years + monthResult + day;
	
		//Calculate mod of week
		Integer dayOfWeek = math.mod(runningTotal, 7);
	
		//Day of Week Table
		if(dayOfWeek == 0) {
			dayOfWeekString = 'Sunday';
		}
		else if(dayOfWeek == 1) {
			dayOfWeekString = 'Monday';
		}
		else if(dayOfWeek == 2) {
			dayOfWeekString = 'Tuesday';
		}
		else if(dayOfWeek == 3) {
			dayOfWeekString = 'Wednesday';
		}
		else if(dayOfWeek == 4) {
			dayOfWeekString = 'Thursday';
		}
		else if(dayOfWeek == 5) {
			dayOfWeekString = 'Friday';
		}
		else if(dayOfWeek == 6) {
			dayOfWeekString = 'Saturday';
		}
	
		return dayOfWeekString;
	}
	
	static testMethod void test() {
		padIntegerWithZero(1);
		getMonday(Date.today());
		
		system.assertEquals(getDayOfTheWeek(Date.valueOf('2011-5-30')), 'Monday');
		system.assertEquals(getDayOfTheWeek(Date.valueOf('2011-4-5')), 'Tuesday');
		system.assertEquals(getDayOfTheWeek(Date.valueOf('2011-3-2')), 'Wednesday');
		system.assertEquals(getDayOfTheWeek(Date.valueOf('2011-2-3')), 'Thursday');
		system.assertEquals(getDayOfTheWeek(Date.valueOf('2011-1-7')), 'Friday');
		system.assertEquals(getDayOfTheWeek(Date.valueOf('2010-12-4')), 'Saturday');
		system.assertEquals(getDayOfTheWeek(Date.valueOf('2010-11-7')), 'Sunday');
		
	}
	
}