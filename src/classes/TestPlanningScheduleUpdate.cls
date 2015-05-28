@isTest(SeeAllData = True)
public class TestPlanningScheduleUpdate {

    static {


        PlanningScheduleUpdate__c runTime = PlanningScheduleUpdate__c.getValues('PlanningScheduleUpdate');

        Date d = System.today();
        Datetime dt = (DateTime) d;
        String dayOfWeek = dt.format('EEEE');
        runTime.DateofMonth__c = d.day();
        runTime.Dayofweek__c = dayOfWeek;

        upsert runTime;
    }

    public static testMethod void firstTest() {
        Date serviceDate = system.today();
        //inserting account   
        Account acc = new Account();
        acc.Name = 'Naveen';
        acc.Type = 'Client';
        insert acc;

        Contact Con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Test';
        con.email = 'test@test.com';
        con.phone = '1234567890';
        insert con;

        //inserting opportunity
        Opportunity opp = new Opportunity();
        opp.Name = 'Test123';
        opp.CloseDate = System.today();
        opp.AccountId = acc.Id;
        opp.StageName = 'New';
        opp.Managed_by_PSO_Tool__c = true;
        insert opp;

        //Insert Products
        Product2 prod = new Product2(Name = 'Project Manager', Family = 'Add-On', CanUseQuantitySchedule = true, IsActive = true);
        insert prod;

        //Fetching PricebookId
        Id pricebookId = Test.getStandardPricebookId();

        //Inserting Pricebook Entry
        PricebookEntry standardPrice = new PricebookEntry(
        Pricebook2Id = pricebookId, Product2Id = prod.Id,
        UnitPrice = 10000, IsActive = true);
        insert standardPrice;

        Pricebook2 customPB = new Pricebook2(Name = 'Custom Pricebook', isActive = true);
        insert customPB;

        PricebookEntry customPrice = new PricebookEntry(
        Pricebook2Id = customPB.Id, Product2Id = prod.Id,
        UnitPrice = 12000, IsActive = true);
        insert customPrice;

        OpportunityLineItem acccobj = new OpportunityLineItem(OpportunityId = opp.id, Description = 'This is a test descriptiion', Quantity = 3, UnitPrice = 5000, ServiceDate = serviceDate, PricebookEntryId = customPrice.id);
        insert acccobj;

        Planning_statistics__c pst = new Planning_statistics__c();
        pst.OpportunityLineItemId__c = acccobj.id;

        pst.Start_Date__c = System.today();
        pst.End_Date__c = System.today() + 1;
        insert pst;

        TimeEntry__c timeEntr = new TimeEntry__c();
        timeEntr.name = 'Test';
        timeEntr.Time__c = 2.00;
        timeEntr.Opportunity__c = opp.id;
        timeEntr.Opportunity_Product_ID__c = acccobj.id;
        timeEntr.Contact__c = con.id;
        timeEntr.Date__c = system.today();

        insert timeEntr;

        OpportunityLineItemSchedule schedule = new OpportunityLineItemSchedule();
        schedule.OpportunityLineItemId = acccobj.Id;
        schedule.ScheduleDate = SYSTEM.TODAY();
        schedule.Quantity = 1;
        schedule.Type = 'Quantity';

        OpportunityLineItemSchedule secondSchedule = new OpportunityLineItemSchedule();
        IF(secondSchedule.ScheduleDate != SYSTEM.TODAY()) {

            secondSchedule.OpportunityLineItemId = acccobj.Id;
            secondSchedule.ScheduleDate = SYSTEM.TODAY();
            secondSchedule.Quantity = 1;
            secondSchedule.Type = 'Quantity';

        }

        OpportunityLineItemSchedule thirdSchedule = new OpportunityLineItemSchedule();

        thirdSchedule.OpportunityLineItemId = acccobj.Id;
        thirdSchedule.ScheduleDate = SYSTEM.TODAY();
        thirdSchedule.Quantity = 0.5;
        thirdSchedule.Type = 'Quantity';

        insert new List < Sobject > {
            schedule, secondSchedule, thirdSchedule
        };
		
        PlanningScheduleUpdate firstPlanning = new PlanningScheduleUpdate();	

    }
    
    public static testMethod void weeklyTest(){
        PlanningScheduleUpdate secondPlanning = new PlanningScheduleUpdate('2015/05/10',true,false);
     }
    
     public static testMethod void monthlyTest(){
        PlanningScheduleUpdate thirdPlanning = new PlanningScheduleUpdate('2015/05/01',false,true);
    }

}