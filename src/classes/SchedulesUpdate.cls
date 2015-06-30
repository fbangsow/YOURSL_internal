public class SchedulesUpdate implements Schedulable {

    public void execute(SchedulableContext SC) {
        StatisticsCalculator.getInstance(Date.today(), true).createStatistics();
    }
}