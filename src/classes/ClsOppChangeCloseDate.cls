// /* **************************************************************
// Creater: Alexander Erdikler - YOUR SL
// Description: This will change the close date of the selected Opportunity
//				on Visualforce Page Change_Opportunity_Close_Date.page
//				and the ServiceDate of Products, with Schedules, if configured.
//				To run this class, you have to enable Schedules on Opportunity Products
// Testclass: testclass is included in this file
// Apex Class Access: please allow all Profiles/People who need access to the close date,
//				access to this apex_class and the visualforce page Change_Opportunity_Close_Date.page
// Last modified by: Alexander Erdikler
// Last modified date: 2012-11-09
// Latests changes: short and meaningful description of the last changes (Why and What)
// ************************************************************** */


public with sharing class ClsOppChangeCloseDate {
	private ApexPages.StandardController stdCtrl;
	private Date oldDate;
	private Integer difDate;
	public OpportunityProductWrapper oppWrapper {get;set;}

	public ClsOppChangeCloseDate(ApexPages.StandardController std){
		stdCtrl=std;
		oppWrapper = new OpportunityProductWrapper();
	}

	public class OpportunityProductWrapper{
		public Opportunity oneOpp {get;set;}
		public List<OpportunityLineItem> listOppProds {get; set;}
		public List<OpportunityLineItemSchedule> listOppSchedules {get;set;}
		public Boolean bHasSchedule = false;
		private Boolean bOrgHasSchedule = false;
		public Boolean bHasOpportunityLineItem  = false;

		public OpportunityProductWrapper(){
			Opportunity oneOpp = new Opportunity();
			List<OpportunityLineItem> listOppProds = new List<OpportunityLineItem>();
			List<OpportunityLineItemSchedule> listOppSchedules = new List<OpportunityLineItemSchedule>();
			doesOrgHasScheduleEnable();
		}

		private void doesOrgHasScheduleEnable(){
			Map<String, Schema.SObjectType> mapSchemaTypes = new Map<String, Schema.SObjectType>();
			mapSchemaTypes = Schema.getGlobalDescribe();
			for(Schema.Sobjecttype s : mapSchemaTypes.values()){
				if(s.getDescribe().getName() == 'OpportunityLineItemSchedule'){
					bOrgHasSchedule = true;
				}
			}
		}// END private void doesOrgHasScheduleEnable()
	}

	public void init(){
		if(String.isBlank(stdCtrl.getId())){
			oppWrapper.oneOpp = new Opportunity(Name = 'please open this page from a current Opportunity', CloseDate = System.today());
		}else{
			oppWrapper.oneOpp = [SELECT Id, Name, CloseDate, HasOpportunityLineItem, Managed_by_PSO_Tool__c FROM Opportunity WHERE Id = :stdCtrl.getId()];
            showMessageIfOpportunityIsManagedByPsoTool(oppWrapper.oneOpp.Managed_by_PSO_Tool__c);
			oppWrapper.bHasOpportunityLineItem = oppWrapper.oneOpp.HasOpportunityLineItem;
			if(oppWrapper.bHasOpportunityLineItem){
				// We assume, that the this Org has Quantity Schedule available
					oppWrapper.listOppProds = [	SELECT Id, ServiceDate, PricebookEntryId,
												OpportunityId, HasSchedule, HasRevenueSchedule, HasQuantitySchedule
												FROM OpportunityLineItem WHERE OpportunityId =: oppWrapper.oneOpp.Id];

				Set<Id> setOLitemIDs = new Set<Id>();
				for(OpportunityLineItem o : oppWrapper.listOppProds){
					if(o.HasSchedule){
						oppWrapper.bHasSchedule = true;
					}
					setOLitemIDs.add(o.Id);
				}// END for(OpportunityLineItem o : oppWrapper.listOppProds)
				if(oppWrapper.bHasSchedule){
					oppWrapper.listOppSchedules = [
											SELECT Type, ScheduleDate, OpportunityLineItemId, Id
											FROM OpportunityLineItemSchedule
											WHERE OpportunityLineItemId IN: setOLitemIDs];
				}// END if(oppWrapper.bHasSchedule)
			}// END if(oppWrapper.bHasOpportunityLineItem)
		}// END if(String.isNotBlank(stdCtrl.getId()))
		oldDate = oppWrapper.oneOpp.CloseDate;
	} // end init();

	// Step 1
	public Pagereference  savenewdate(){
		difDate = oldDate.daysBetween(oppWrapper.oneOpp.CloseDate);
		if(difDate != 0){
			//oppWrapper.oneOpp.CloseDate = oppWrapper.oneOpp.CloseDate;
			update oppWrapper.oneOpp;
		}
		if(oppWrapper.bHasOpportunityLineItem && difDate != 0){
			for(OpportunityLineItem o : oppWrapper.listOppProds){
				if(o.ServiceDate != NULL){
					o.ServiceDate = o.ServiceDate.addDays(difDate);
				}
			}
			update oppWrapper.listOppProds;
		}

		if(oppWrapper.bHasSchedule && difDate != 0){
			for(OpportunityLineItemSchedule os : oppWrapper.listOppSchedules){
				os.ScheduleDate = os.ScheduleDate.addDays(difDate);
			}
			update oppWrapper.listOppSchedules;
		}

		PageReference pageRef = new ApexPages.StandardController(oppWrapper.oneOpp).view();
		pageRef.setRedirect(true);
		return pageRef;
	}


    static testMethod void myTest() {

        Account testaccount = new Account (Name = 'TestAccount');
        insert testaccount;

        // onedate
        Date onedate = Date.valueOf('2009-04-04');

        // testopportunity
        Opportunity testopportunity = new Opportunity (Name = 'TestOpp',
        							StageName = 'Prospecting',
        							CloseDate = onedate,
        							AccountId = testaccount.Id);
        insert testopportunity;

		// pb = standart Pricebook
		Pricebook2 pb =[select name,isactive from Pricebook2 where isStandard=true];
		/*if(!pb.isactive){
		pb.isactive=true;
		Database.update(pb);
		}*/

		// stage = OpportunityStage for Masterlabel
		OpportunityStage stage=[select Masterlabel from OpportunityStage where Masterlabel != '' limit 1];

		// opp = Opportunity
		Opportunity opp = new Opportunity();
		opp.Name='TestOpp';
		opp.AccountID=testaccount.id;
		opp.CloseDate = onedate;
		opp.StageName=stage.masterlabel;
		opp.Pricebook2Id=pb.id;
		insert opp;

		// testproduct p = Product
		Product2 p = new Product2();
		p.Name='TestProd';
		p.IsActive = true;
		p.CanUseQuantitySchedule = true;
		//p.CanUseRevenueSchedule
		insert p;

		// sumTotalPrice = double
		double sumTotalPrice = 2.0;

		// SumOfPhase = double
		double SumOfPhase = 0.0;

		//pbe = pricebook entry
		PricebookEntry pbe=new PricebookEntry();
		pbe.Pricebook2Id=pb.id;
		pbe.Product2Id=p.id;
		pbe.UnitPrice = sumTotalPrice;
		pbe.IsActive=true;
		insert pbe;

		// oli = OpportunityLineItem
		OpportunityLineItem oli = new OpportunityLineItem();
		oli.OpportunityId = opp.Id;
		oli.PricebookEntryId = pbe.Id;
		oli.ServiceDate = onedate;
		oli.Quantity = 2.0;
		oli.TotalPrice = oli.Quantity * sumTotalPrice;
		insert oli;
		oli = [SELECT Id, HasSchedule, HasQuantitySchedule, OpportunityId, PricebookEntryId, ServiceDate, Quantity, TotalPrice FROM OpportunityLineItem WHERE OpportunityId =: opp.Id LIMIT 1];

		// olis = OpportunityLineItemSchedule
		OpportunityLineItemSchedule olis = new OpportunityLineItemSchedule(
		Type='Quantity',
		Quantity = 1,
		OpportunityLineItemId = oli.Id,
		ScheduleDate=onedate
		);
		insert olis;

		//user
		Profile admin = [select id, name, PermissionsModifyAllData from Profile where PermissionsModifyAllData = TRUE LIMIT 1];
    	User testusers = [select email, id, name, ProfileId from user where isActive=true and ProfileId= :admin.Id LIMIT 1];

		// generate page
    	PageReference pageRef = Page.Change_Opportunity_Close_Date;
    	pageRef.getParameters().put('id', opp.id);
    	Test.setCurrentPage(pageRef);

		ApexPages.Standardcontroller controller = New ApexPages.StandardController(opp);
        ClsOppChangeCloseDate ext = new ClsOppChangeCloseDate(controller);
        ext.init();
        String nextPage = controller.save().getUrl();
        string testOppId = '/' + opp.Id;
        // Verify that page fails without parameters
        System.assertEquals( testOppId.substring(0,16),  nextPage.substring(0,16));

        ext.oppWrapper.oneOpp.CloseDate = onedate.addDays(10);
        ext.savenewdate();
        System.assert(ext.difDate == 10);
        system.assert(ext.oldDate == onedate);
        system.assert(ext.oppWrapper.oneOpp.Id == opp.Id);
        system.assert(ext.oppWrapper.listOppProds[0].ServiceDate == onedate.addDays(10));
        system.assert(ext.oppWrapper.listOppSchedules[0].ScheduleDate == onedate.addDays(10));

    // ***************************************************************************************
    // test again, without scheduling
        delete olis;

        // opp = Opportunity
		opp = new Opportunity();
		opp.Name='TestOpp';
		opp.AccountID=testaccount.id;
		opp.CloseDate = onedate;
		opp.StageName=stage.masterlabel;
		opp.Pricebook2Id=pb.id;
		insert opp;

		// testproduct p = Product
		p = new Product2();
		p.Name='TestProd';
		p.IsActive = true;
		p.CanUseQuantitySchedule = true;
		//p.CanUseRevenueSchedule
		insert p;

		// sumTotalPrice = double
		sumTotalPrice = 2.0;

		// SumOfPhase = double
		SumOfPhase = 0.0;

		//pbe = pricebook entry
		pbe=new PricebookEntry();
		pbe.Pricebook2Id=pb.id;
		pbe.Product2Id=p.id;
		pbe.UnitPrice = sumTotalPrice;
		pbe.IsActive=true;
		insert pbe;

		// oli = OpportunityLineItem
		oli = new OpportunityLineItem();
		oli.OpportunityId = opp.Id;
		oli.PricebookEntryId = pbe.Id;
		oli.ServiceDate = onedate;
		oli.Quantity = 2.0;
		oli.TotalPrice = oli.Quantity * sumTotalPrice;
		insert oli;
		oli = [SELECT Id, HasSchedule, HasQuantitySchedule, OpportunityId, PricebookEntryId, ServiceDate, Quantity, TotalPrice FROM OpportunityLineItem WHERE OpportunityId =: opp.Id LIMIT 1];



        pageRef.getParameters().put('id', opp.id);
    	Test.setCurrentPage(pageRef);

		controller = New ApexPages.StandardController(opp);
        ext = new ClsOppChangeCloseDate(controller);
        ext.init();
        nextPage = controller.save().getUrl();
        testOppId = '/' + opp.Id;

        // Verify that page does not fail without parameters
        System.assertEquals( testOppId.substring(0,16),  nextPage.substring(0,16));
        ext.oppWrapper.oneOpp.CloseDate = onedate.addDays(20);
        ext.savenewdate();
        System.assert(ext.difDate == 20);
        system.assert(ext.oldDate == onedate);
        system.assert(ext.oppWrapper.oneOpp.Id == opp.Id);
        system.assert(ext.oppWrapper.listOppProds[0].ServiceDate == onedate.addDays(20));


    // ***************************************************************************************
    // test page without Opportunity
    	Opportunity opp2 = New Opportunity();
        controller = New ApexPages.StandardController(opp2);
        ext = new ClsOppChangeCloseDate(controller);
        ext.init();

        System.assertEquals(ext.oppWrapper.oneOpp.Name, 'TestOpp');

    } // end testmethod

    private void showMessageIfOpportunityIsManagedByPsoTool(Boolean is_managed_by_pso_tool){
        if(is_managed_by_pso_tool)
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.INFO, 'The opportunity is managed by PSO Tool. This functionality is not available for such opportunities'));
    }

    public PageReference redirectToOpportunityView(){
        PageReference opportunity_line_item_page = new ApexPages.StandardController(oppWrapper.oneOpp).view();
        opportunity_line_item_page.setRedirect(true);
        return opportunity_line_item_page;
    }
}