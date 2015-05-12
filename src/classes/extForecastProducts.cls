public class extForecastProducts

{

// define variable
public Id LeistungErbrachtEditableUser = '00520000000kBMB'; //sb - 00520000000kBMB (Thorsten Köhler), pro - 005D0000001uudT (Liba Schneider)
public Produkt_Ressourcen_Forecast__c ForecastProducts;
public List<Produkt_Ressourcen_Forecast__c> lstForecastProducts {get; set;}
public Opportunity ForecastProductsNew {get; set;}

private String sortDirection = 'ASC';
private String sortExp = 'Forecast_Product__c';
private String oppId;

public boolean isLeistungErbrachtEditable{get; set;}

public String sortExpression {
	get {return sortExp;}
    set  {
    	if (value == sortExp)
        	sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
       	else
         	sortDirection = 'ASC';
       	sortExp = value;
	}
}

public String getSortDirection() {
    //if not column is selected 
	if (sortExpression == null || sortExpression == '')
      return 'ASC';
    else
     return sortDirection;
}

public void setSortDirection(String value) {  
   sortDirection = value;
}

public PageReference ViewData() {
   //build the full sort expression
   string sortFullExp = sortExpression  + ' ' + sortDirection;
      
       //query the database based on the sort expression
	lstForecastProducts = Database.query('SELECT Id,From__c ,Forecast_Amount__c ,Name , Contact__c, Cost__c, Cost_Type__c, Forecast_Product__c,ID__c, Forecast_Quantity__c, Forecast_Unit__c, Leistung_erbracht__c, Mitarbeiter_Rolle__c, Opportunity_Line_Item_Id__c, Opportunity_TS_BETA__c, Product__c, Product_Code__c, Profitability__c, Quantity__c, Sales_Price__c, SFDC_Lizenz_Preis__c, Subunternehmen_a__c, To__c, Total_Cost__c, Total_Margin__c, Total_Price__c, Unit__c, OpportunityID__c' +
     						' FROM Produkt_Ressourcen_Forecast__c ' +
     						' WHERE OpportunityID__c = \'' + oppId + '\'' +
     						' ORDER BY ' + sortFullExp);       
     return null;
}

public extForecastProducts(ApexPages.StandardSetController controller)
{
	if(System.Userinfo.getuserid() == LeistungErbrachtEditableUser) {
     	isLeistungErbrachtEditable = true;
	} else {
     	isLeistungErbrachtEditable = false;
	}
     this.ForecastProducts= (Produkt_Ressourcen_Forecast__c)controller.getRecord();
     // get Oppty Id from field in custom object where current id matches, if oppId is null, then you have to query for that field but it should be populated
     //this Line return null because of the StandartController , Variable Change to String , Id Variable are always using the 18 digit ID
     oppId = ForecastProducts.OpportunityID__c;
     //ID Get from URL
     if(oppId == null) {
        oppId = ApexPages.currentPage().getParameters().get('Id');
     }
    
     System.debug('###' + oppId);
     
     ForecastProductsNew = loadOpportunity(oppId);
     //Added missing Fields
     /*lstForecastProducts = [SELECT Id,From__c ,Forecast_Amount__c ,Name , Contact__c, Cost__c, Cost_Type__c, Forecast_Product__c,ID__c, Forecast_Quantity__c, Forecast_Unit__c, Leistung_erbracht__c, Mitarbeiter_Rolle__c, Opportunity_Line_Item_Id__c, Opportunity_TS_BETA__c, Product__c, Product_Code__c, Profitability__c, Quantity__c, Sales_Price__c, SFDC_Lizenz_Preis__c, Subunternehmen_a__c, To__c, Total_Cost__c, Total_Margin__c, Total_Price__c, Unit__c, OpportunityID__c
     FROM Produkt_Ressourcen_Forecast__c
     WHERE OpportunityID__c =: oppId];*/
     string sortFullExp = sortExpression  + ' ' + sortDirection;
     lstForecastProducts = Database.query('SELECT Id,From__c ,Forecast_Amount__c ,Name , Contact__c, Cost__c, Cost_Type__c, Forecast_Product__c,ID__c, Forecast_Quantity__c, Forecast_Unit__c, Leistung_erbracht__c, Mitarbeiter_Rolle__c, Opportunity_Line_Item_Id__c, Opportunity_TS_BETA__c, Product__c, Product_Code__c, Profitability__c, Quantity__c, Sales_Price__c, SFDC_Lizenz_Preis__c, Subunternehmen_a__c, To__c, Total_Cost__c, Total_Margin__c, Total_Price__c, Unit__c, OpportunityID__c' +
     						' FROM Produkt_Ressourcen_Forecast__c ' +
     						' WHERE OpportunityID__c = \'' + oppId + '\'' +
     						' ORDER BY ' + sortFullExp); 
     System.debug('###' + lstForecastProducts.size());
}

private Opportunity loadOpportunity(Id i)
{
     try
     {
          // add whatever fields you need to this query
          return [Select Id, Name From Opportunity Where Id =: i];
     }
     catch (Exception e)
     {
          return new Opportunity();
     }
}

public PageReference save() {
	update lstForecastProducts;
	return (new ApexPages.StandardController(ForecastProductsNew)).view();
}


    public static testmethod void test()
    {
        //-*-*-*-*-*-*-*-*-*-
        // A C C O U N T
        //-*-*-*-*-*-*-*-*-*-
        Account acc = new Account(name='test');
        insert acc;
        

        //-*-*-*-*-*-*-*-*-*-
        // C O N T A C T
        //-*-*-*-*-*-*-*-*-*-
        Contact c = new Contact(LastName='test',AccountId=acc.Id);
        insert c;
        


        //-*-*-*-*-*-*-*-*-*-
        // O P P O R T U N I T Y
        //-*-*-*-*-*-*-*-*-*-
        Opportunity o = new Opportunity(AccountId=acc.Id,name='test',stageName='Open', CloseDate=Date.newInstance(2006,10,10));
        insert o;

        
        Produkt_Ressourcen_Forecast__c prf = new Produkt_Ressourcen_Forecast__c();
        //prf.OpportunityID__c = String.valueof(o.Id).substring(0,15); 
        prf.Opportunity_TS_BETA__c = o.Id; 
        insert prf;
        List<Produkt_Ressourcen_Forecast__c> lstprf = new List<Produkt_Ressourcen_Forecast__c>();
        lstprf.add(prf);
        ApexPages.StandardSetController testcon = new ApexPages.StandardSetController(lstprf);
        
        PageReference pageRef = Page.ProductResourceForecast;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',o.Id);
        
        extForecastProducts tstcls = new extForecastProducts(testcon);
        tstcls.save();
        
        tstcls.getSortDirection();
        tstcls.sortExpression = 'Forecast_Product__c';
        tstcls.setSortDirection('DESC');
        tstcls.ViewData();
        
    }
}