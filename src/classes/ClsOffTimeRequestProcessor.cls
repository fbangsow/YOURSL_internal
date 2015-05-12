public with sharing class ClsOffTimeRequestProcessor {
	
	public Map<String,Product2>        mapProducts         {get;set;}
	public Map<Id,OpportunityLineItem> mapOppLineItems     {get;set;}
	public Map<Id,User>                users               {set;get;}
	public Map<Id,PricebookEntry>      pricebookEntry      {set;get;}
	public Map<Id,Opportunity>         opportunity         {set;get;}
	public Map<Id,Contact>             contacts            {set;get;}
	public String             		   requestToProduct    {set;get;}
	public static final String DEFAULT_UNIT_VALUE = 'Manntag(e)';

	public static Map<String, String> mapRequestTypeToProduct = new Map<String, String> {
		'Holiday Request/Urlaubsantrag' => 'Urlaub',
		'Sickness Notification/Krankmeldung' => 'Krankheit',
		'Trainings & Coachings/Fortbildungen' => 'Fortbildungen',
		'Parental Leave/Elternzeit' => 'Elternzeit'
	};

    public static Map<String, String> mapRequestTypeToRequestDescription = new Map<String, String> {
		'Holiday Request/Urlaubsantrag' => 'Holiday',
		'Sickness Notification/Krankmeldung' => 'Sick Leave',
		'Trainings & Coachings/Fortbildungen' => 'Trainings',
		'Parental Leave/Elternzeit' => 'Parental Leave'
	};
	
	public ClsOffTimeRequestProcessor(List<Time_Off_Request__c> listToBeProcessed) {
 
		this.mapProducts = new Map<String,Product2>();

		For(Product2 prod :  [SELECT Id,Name FROM Product2
												WHERE Name = 'Krankheit'
												OR Name    = 'Urlaub'
												OR Name    = 'Elternzeit'
												or Name    = 'Fortbildungen'
												]){
			this.mapProducts.put(prod.Name, prod);
		}
		this.mapOppLineItems = new Map<Id,OpportunityLineItem>();
		//get all related Opportunities

		List<OpportunityLineItem> listNewOppLineItems = new List<OpportunityLineItem>();
        this.pricebookEntry = new Map<Id,PricebookEntry>(); 

        For(PricebookEntry pBEntry :  [SELECT Id,Name,Product2Id, Pricebook2Id FROM PricebookEntry])
        {
                this.pricebookEntry.put(pBEntry.Id, pBEntry);
        }

	    this.opportunity = new Map<Id,Opportunity>();
        For(Opportunity opp :  [SELECT Id, Name, OwnerId,CloseDate, Pricebook2.Name FROM Opportunity])
	    {
			this.opportunity.put(opp.Id, opp);// Temporarlly its the opp is depends on the owner
	    }
 
	    this.users = new Map<Id,User>([SELECT Id, Name, FirstName,LastName  FROM User]); 
	    this.contacts = new Map<Id,Contact>([SELECT Id, FirstName,LastName, Account.Id  FROM Contact]); 
		for(Time_Off_Request__c request : listToBeProcessed){
			requestToProduct = mapRequestTypeToProduct.get(request.Type__c);
			if(this.mapProducts.get(requestToProduct) != null){ // Get the related product which is related to reuest type 
                //Get the User from request Contact
                User oppOwner;
                For( User user : this.users.values())
                {
                	// Check if the request contact name is equal to user name 
                	if(contacts.get(request.Employee__c).FirstName == user.FirstName && contacts.get(request.Employee__c).LastName == user.LastName ){
                     	oppOwner = user;
                	}
                }
                Opportunity oppToLink = getOpportunity(Integer.valueOf(request.Year__c),oppOwner.Id);
                if(oppToLink == null ) 
                    request.addError('Please create an opportunity for the selected year Or check if the selected employee has more than one user');
                else {
                    PricebookEntry priceEntry = getPriceBookEntry(this.mapProducts.get(this.requestToProduct).Id,getOpportunity(Integer.valueOf(request.Year__c),oppOwner.Id).Pricebook2Id);
                    if(priceEntry != null) {
                        if(!String.isBlank(request.Monday__c)){
                            listNewOppLineItems.add(getOpportunityLineItem(request, oppOwner.Id, request.Monday__c, 0));
                        }
                        if(!String.isBlank(request.Tuesday__c)){
                            listNewOppLineItems.add(getOpportunityLineItem(request, oppOwner.Id, request.Tuesday__c, 1));
                        }
                        if(!String.isBlank(request.Wednesday__c)){
                            listNewOppLineItems.add(getOpportunityLineItem(request, oppOwner.Id, request.Wednesday__c, 2));
                        }
                        if(!String.isBlank(request.Thursday__c)){
                            listNewOppLineItems.add(getOpportunityLineItem(request, oppOwner.Id, request.Thursday__c, 3));
                        }
                        if(!String.isBlank(request.Friday__c)){
                            listNewOppLineItems.add(getOpportunityLineItem(request, oppOwner.Id, request.Friday__c, 4));
                        }
                    }
                }
			}
		}

		if(listNewOppLineItems.size() > 0){
			insert listNewOppLineItems;
			// as for simulation use debug
			System.debug('simulation : new item have been created');
		}

	}

	private OpportunityLineItem getOpportunityLineItem(Time_Off_Request__c request, String ownerId, String quantity, Integer dayOfAWeek){
		    OpportunityLineItem newOpportunityLineItem = new OpportunityLineItem();
			newOpportunityLineItem.PricebookEntryId =  getPriceBookEntry(this.mapProducts.get(this.requestToProduct).Id,getOpportunity(Integer.valueOf(request.Year__c),ownerId).Pricebook2Id).Id;//this.pricebookEntry.get(this.mapProducts.get(this.requestToProduct).Id).Id;
			newOpportunityLineItem.OpportunityId = getOpportunity(Integer.valueOf(request.Year__c),ownerId).Id;
			newOpportunityLineItem.Quantity = Decimal.valueOf(quantity.replace(',', '.'));
			newOpportunityLineItem.TotalPrice = 0;
	        newOpportunityLineItem.ServiceDate = DateUtility.getFirstDayForWeekNumberAndYear(Integer.valueOf(request.Year__c),Integer.valueOf(request.Calendar_Week__c)).addDays(dayOfAWeek);
			newOpportunityLineItem.Description = mapRequestTypeToRequestDescription.get(request.Type__c);
			newOpportunityLineItem.Contact__c = request.Employee__c;
			newOpportunityLineItem.Unit__c = DEFAULT_UNIT_VALUE;
			newOpportunityLineItem.Sub_Unternehmen__c =contacts.get(request.Employee__c).Account.Id;
		    return newOpportunityLineItem;
	}

	private Opportunity getOpportunity (Integer year, String ownerId){

		for(Opportunity opp : this.opportunity.values()){
            System.debug('### = opp.Name ' + opp.Name + ' opp.OwnerId == ownerId ' + (opp.OwnerId == ownerId)  + ' opp.CloseDate.year() == year ' + (opp.CloseDate.year() == year));
			if(opp.CloseDate.year() == year && opp.OwnerId == ownerId && opp.Name.startsWith('° '))
                return opp;

		}
		return null;

	}

	private PricebookEntry getPriceBookEntry (String prodName, String priceBookId){
		
		for(PricebookEntry priceBookIntry : this.pricebookEntry.values())
		{

			if( priceBookIntry.PriceBook2Id == priceBookId && priceBookIntry.Product2Id == prodName)
			{
			    return priceBookIntry;
			}
		}
		return null;

	}
}