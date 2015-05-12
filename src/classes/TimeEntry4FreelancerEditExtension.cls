// /* **************************************************************
// Creater: Chris Sandra Schautt
// Description: This class is an extension for a Visualforcepage to update or delete timeentries for freelancer
//              this page is used in a site                
//                              
//                               
// Page: TimeEntryEditPageForFreelance
// Testclass: 
// Triggers: TimeEntryTrigger
// Apex Class Access: no limitations/Profilenames
// Last modified by: Chris Sandra Schautt
// Last modified date: 31.10.2013
// Latests changes: change the selectedContact lists
// ************************************************************** */

public with sharing class TimeEntry4FreelancerEditExtension {
        // class variables
        public Map<String,String> mapParameters{get;set;}
        public TimeEntry__c objTimeEntry {get;set;}
        public Id idTimeEntry{get;set;}
        public Id selectedContact{get;set;}
        public Map<id,OpportunityLineItem> mapOpportuntiyLineItem4User{get;set;}
        
        //return values from selectOptions
         public String selectedTask{get;set;}
         
        // boolean for setting the pageblocks
        public Boolean bIsEdit{get;set;}
        public Boolean bIsView{get;set;}
        
        
   //------------------------------------- Constructor  -------------------------------------
        public TimeEntry4FreelancerEditExtension( ApexPages.StandardController controller){
                this.objTimeEntry = new TimeEntry__c();
                mapOpportuntiyLineItem4User = new Map<id,OpportunityLineItem>();
                PageReference pageRef = new PageReference('www.google.com');
                pageRef= ApexPages.currentPage();
		        mapParameters = new Map<String, String>();
		        mapParameters = pageRef.getParameters();
		        idTimeEntry = mapParameters.get('eid');
		        if(mapParameters.get('edit')=='true'){
		        	this.bIsEdit =true ;
		        	this.bIsView = false;
		        }else if(mapParameters.get('edit')=='false'){
		        	this.bIsEdit =false;
		        	this.bIsView = true;
		        }else{
		        	objTimeEntry.addError('There is a Problem in the System, please contact your Administrator');
		        } 
                try{
                        objTimeEntry = [SELECT Id, Name, Opportunity__c,Opportunity__r.Name, Opportunity_Product_Name__c , Contact__c, Contact__r.Name,  Time__c,  Date__c,  Billable__c,  Description__c FROM TimeEntry__c WHERE Id=:idTimeEntry ];
                        selectedContact = objTimeEntry.Contact__c;
                }catch(System.DmlException ex){
                        objTimeEntry.addError('There is a Problem in the System, please contact your Administrator');
                        ApexPages.addMessages(ex);
                }// end try
                
                
        }// end Methode
        
     // methode to get back to the time entry edit Page   
     public PageReference addNewTime(){
     			try{
                        objTimeEntry = [SELECT Id, Name, Opportunity__c,Opportunity__r.Name, Opportunity_Product_Name__c , Contact__c, Contact__r.Name,  Time__c,  Date__c,  Billable__c,  Description__c FROM TimeEntry__c WHERE Id=:objTimeEntry.Id ];
                        selectedContact = objTimeEntry.Contact__c;
                }catch(System.DmlException ex){
                        objTimeEntry.addError('There is a Problem in the System, please contact your Administrator');
                        ApexPages.addMessages(ex);
                }// end try
     			PageReference timeEntryPage = new ApexPages.Pagereference('http://beyondfuturetrends.force.com/TimeEntryForFreelancer?fid='+ objTimeEntry.Contact__c );
                //timeEntryPage.setRedirect(true);
                return timeEntryPage;
     }
     
     // mathode to get to the edit mode
     public PageReference myCancelEdit(){
     			try{
                        objTimeEntry = [SELECT Id, Name, Opportunity__c,Opportunity__r.Name, Opportunity_Product_Name__c , Contact__c, Contact__r.Name,  Time__c,  Date__c,  Billable__c,  Description__c FROM TimeEntry__c WHERE Id=:objTimeEntry.Id ];
                        selectedContact = objTimeEntry.Contact__c;
                }catch(System.DmlException ex){
                        objTimeEntry.addError('There is a Problem in the System, please contact your Administrator');
                        ApexPages.addMessages(ex);
                }// end try
     			PageReference timeEntryPage = new ApexPages.Pagereference('http://beyondfuturetrends.force.com/TimeEntryEdit?eid='+ objTimeEntry.Id+'&edit=false' );
               // timeEntryPage.setRedirect(true);
              
                //return timeEntryPage;
                return timeEntryPage;
     }
     
     //method to update the timeentry
     public PageReference mySave(){
     		try{
     			update this.objTimeEntry;
     		}catch(DMLException e){
	     		objTimeEntry.addError('There is a Problem in the System, you cannot change this Time Entry. Please contact your Administrator');
	            ApexPages.addMessages(e);	
     		}	
     			try{
                        objTimeEntry = [SELECT Id, Name, Opportunity__c,Opportunity__r.Name, Opportunity_Product_Name__c , Contact__c, Contact__r.Name,  Time__c,  Date__c,  Billable__c,  Description__c FROM TimeEntry__c WHERE Id=:objTimeEntry.Id ];
                        selectedContact = objTimeEntry.Contact__c;
                }catch(System.DmlException ex){
                        objTimeEntry.addError('There is a Problem in the System, please contact your Administrator');
                        ApexPages.addMessages(ex);
                }// end try
     			PageReference timeEntryPage = new PageReference('http://beyondfuturetrends.force.com/TimeEntryEdit?eid='+ objTimeEntry.Id+'&edit=false' );
                //timeEntryPage.setRedirect(true);
                return timeEntryPage;
                
     }// end methode  mySave
     
     
     // method to set edit
      public PageReference myEdit(){
      	this.bIsEdit = true;
        this.bIsView = false;
      	PageReference timeEntryPage = new PageReference('http://beyondfuturetrends.force.com/TimeEntryEdit?eid='+ objTimeEntry.Id+'&edit=true' );
      	return timeEntryPage;
      }
      
      // method to delete the time entry
      public PageReference myDelete(){
      	this.bIsEdit = false;
        this.bIsView = false;
        try{
        	delete this.objTimeEntry;
        }catch(DMLException e){
        	objTimeEntry.addError('There is a Problem in the System, you cannot delete this Time Entry. Please contact your Administrator');
            ApexPages.addMessages(e);
        }
        PageReference timeEntryPage = new PageReference('http://beyondfuturetrends.force.com/TimeEntryForFreelancer?fid='+ selectedContact );
        //timeEntryPage.setRedirect(true);
        //return timeEntryPage;
        return timeEntryPage;
      	
      }// end public PageReference myDelete()
        /*
         // fill global variable Maps with Opps and OLIs
    	public void selectOppsAndLineItems4User(){

	        Date dateNotOlderThanLastMonth = System.today().addDays(-10);
	        dateNotOlderThanLastMonth = dateNotOlderThanLastMonth.addMonths(-1);
	        
	        Date dateNotMoreThanSixMonthInFuture = System.today();
	        dateNotMoreThanSixMonthInFuture = dateNotMoreThanSixMonthInFuture.addMonths(6);
	        
	        System.debug('@@@@@@@@ DEBUG SELECTEDCONTACT: '+selectedContact);
	        try{
	            mapOpportuntiyLineItem4User = new Map<Id,OpportunityLineItem>([
	                                                    SELECT Id, OpportunityId, Contact__c, PricebookEntry.Name,
	                                                    PricebookEntry.Product2Id,
	                                                    ServiceDate, CreatedDate, Unit__c,
	                                                    Quantity,Total_booked_days__c,
	                                                    Total_Booked_Unbillable__c,
	                                                    Total_Realization__c,
	                                                    Total_Booked_Hours_billable__c,
	                                                    UnitPrice,
	                                                    Quantity_in_Hours__c
	                                                    FROM OpportunityLineItem 
	                                                    WHERE Leistung_erbracht__c =: false 
	                                                    AND Unit__c =: 'Manntag(e)'
	                                                    AND Opportunity.IsWon = true
	                                                    AND OpportunityId =: objTimeEntry.Opportunity__c
	                                                    AND Contact__c =: selectedContact
	                                                    AND ServiceDate >: dateNotOlderThanLastMonth
	                                                    AND ServiceDate <: dateNotMoreThanSixMonthInFuture
	                                                    ORDER BY ServiceDate]);
	                                                    
	                                                    
	            //System.debug('### Datevariable not older  '+dateNotOlderThanLastMonth);
	            //System.debug('### Datevariable future  '+dateNotMoreThanSixMonthInFuture);
	            
	        }catch(DmlException ex){objTimeEntry.addError('Sorry, no Task assigned to you');ApexPages.addMessages(ex);}
	        
	                
	        List<OpportunityLineItem> listOppLIs = new List<OpportunityLineItem>();
	        
	        listOppLIs = mapOpportuntiyLineItem4User.values();
	        List<Id> listOppIds = new List<Id>();
	       // for(Integer i=0;i<listOppLIs.size();i++){
	       //     listOppIds.add(listOppLIs[i].OpportunityId);
	       // }
	       // System.debug('############ Opp Id List' + listOppIds.size().format() );
	        //mapOpportuntiy4User = new Map<Id,Opportunity>([SELECT Id, Name, CloseDate,ForeCastCategoryName FROM Opportunity WHERE Id IN: listOppIds ORDER BY Name]);
	   
	    }// END public selectOppsAndLineItems()
        */
}