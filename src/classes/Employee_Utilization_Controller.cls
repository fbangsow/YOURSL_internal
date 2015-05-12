// /* **************************************************************
// Creater: Chis Sandra Schautt
// Description: This class is the Controller for the Visualforce Page OrderLetterSet. 
//				Every week all PSO Member has to create their own Employee Utilization Obj and list their planed billable hours
//				for the next week. This Obj has also the timeentries for that week, so we can compare the planed Vs. billed Hours.
//				All Employee Utilization Obj and timeEntries from all Contacts with checkbox PSO Member checked are selected and listed
//				in the page. 
// Page: 
// Testclass: Employee_Utilization_Test
// Triggers: Employee_Utilization_AI_AU
// Apex Class Access: no limitations/Profilenames
// Last modified by: Chris Sandra Schautt
// Last modified date: 28.03.2013
// Latests changes: create the Controller
// ************************************************************** */



public with sharing class Employee_Utilization_Controller{
    
    //Dates the current day and the beginning of the current Date
    public Date todayDate {get;set;}
    public Date startDate{get;set;}
    public Date tuesdayDate{get;set;}
    public Date wednesdayDate{get;set;}
    public Date thursdayDate{get;set;}
    public Date fridayDate{get;set;}
    public Date [] weekdaies{get;set;}
    public Integer kalenderWeek{get;set;}
    public PageReference thepage{get;set;}
    
    // HeaderValues
    public String planedMonday{get;set;}
    public String planedTuesday{get;set;}
    public String planedWednesday{get;set;}
    public String planedThursday{get;set;}
    public String planedFriday{get;set;}
    public String planedKWday{get;set;}
    
    public String billedMonday{get;set;}
    public String billedTuesday{get;set;}
    public String billedWednesday{get;set;}
    public String billedThursday{get;set;}
    public String billedFriday{get;set;}
    public String billedKWday{get;set;}
    
    public String unbillableMonday{get;set;}
    public String unbillableTuesday{get;set;}
    public String unbillableWednesday{get;set;}
    public String unbillableThursday{get;set;}
    public String unbillableFriday{get;set;}
    
    public String projectMonday{get;set;}
    public String projectTuesday{get;set;}
    public String projectWednesday{get;set;}
    public String projectThursday{get;set;}
    public String projectFriday{get;set;}
    public String leer{get;set;}
    
    
    // contactlist and the currentcontact
    public Contact [] listContact{get;set;}
    public Contact dummyContact {get;set;}
	
    // the list of TimeEntry for all PSO Member for the given week and the 
    public TimeEntry__c objTimeEntry {get;set;}
    TimeEntry__c [] listTimeEntries{get;set;}
    // the list of  Employee Utilization of the PSO Members for the given week
    public Employee_Utilization__c [] listEmUt{get;set;}
    public Employee_Utilization__c  sumEmUtObj{get;set;}
    public Employee_Utilization__c  thisEmUtObj{get;set;}
    
    // values for the sum
    public String sumname{get;set;}
    public String sumcomplet{get;set;}
    public double sumcompletMonday{get;set;}
    public double sumcompletWednesday{get;set;}
    public double sumcompletTuesday{get;set;}
    public double sumcompletThursday{get;set;}
    public double sumcompletFriday{get;set;}
    
    public double sumunbillableMonday{get;set;}
    public double sumunbillableWednesday{get;set;}
    public double sumunbillableTuesday{get;set;}
    public double sumunbillableThursday{get;set;}
    public double sumunbillableFriday{get;set;}
    
    public double sumplanedMonday{get; set;}
    public double sumbilledMonday{get; set;}
    public double sumplanedTuesday{get; set;}
    public double sumbilledTuesday{get; set;}
    public double sumplanedWednesday{get; set;}
    public double sumbilledWednesday{get; set;}
    public double sumplanedThursday{get; set;}
    public double sumbilledThursday{get; set;}
    public double sumbilledFriday{get; set;}
    public double sumplanedFriday{get; set;}
    public double sumPlanedweek{get; set;}
    public double sumBilledweek{get; set;}
    public double maxMonday{get;set;}
    public double maxTuesday{get;set;}
    public double maxWednesday{get;set;}
    public double maxThursday{get;set;}
    public double maxFriday{get;set;}
    public double maxcompletMonday{get;set;}
    public double maxcompletTuesday{get;set;}
    public double maxcompletWednesday{get;set;}
    public double maxcompletThursday{get;set;}
    public double maxcompletFriday{get;set;}
    
    // table Auswertung
    public double maxWertPlaned{get;set;}
    public double maxwertBilled{get;set;}
    
    public double auslastungPlened{get;set;}
    public double auslastungBilled{get;set;}
    
    
   
    
    // Controller
    public Employee_Utilization_Controller(){
    	todayDate = System.today();
    	
    	weekdaies = new List<Date>();
    	listTimeEntries= new List<TimeEntry__c>();
    	listEmUt = new List<Employee_Utilization__c>();	
    	thisEmUtObj = new	Employee_Utilization__c(Date_Monday__c=System.today().toStartOfWeek());
    	startDate= thisEmUtObj.Date_Monday__c.toStartOfWeek();
    	fridayDate = startDate.addDays(4);
    	listContact =[SELECT Id,Name, FirstName, LastName
    				FROM Contact WHERE
    				PSO_Member__c=:true];
    	sumname = 'Summe';
    	leer = '';
    	sumcomplet = '-';
    	mySetnull();
    	fillWeekdaies();
    	fillHeader();
    	fillListTimeEntries();
    	fillListEmUt();
    	fillSumObj();
    	
    	
    }// End Controller
    
    public void fillHeader(){
   		planedMonday='billable';
    	planedTuesday='billable';
   		planedWednesday='billable';
    	planedThursday='billable';
   		planedFriday='billable';
    	planedKWday='KW '+kalenderWeek +' planned';
    
    	billedMonday='billed ';
    	billedTuesday='billed ';
   		billedWednesday='billed ';
    	billedThursday='billed ';
     	billedFriday='billed ';
    	billedKWday=' billed';
    
   	 	unbillableMonday= 'unbillable ';
    	unbillableTuesday= 'unbillable ';
     	unbillableWednesday= 'unbillable ';
		unbillableThursday= 'unbillable ';
   		unbillableFriday= 'unbillable ';
   		
   		projectMonday= 'Mo. '+startDate.day()+'.'+startDate.month()+'. Project';
    	projectTuesday='Di. '+startDate.addDays(1).day()+'.'+startDate.addDays(1).month()+'. Project';
   		projectWednesday='Mi.'+ startDate.addDays(2).day() +'.'+startDate.addDays(2).month()+'. Project';
    	projectThursday='Do. '+startDate.addDays(3).day()+'.'+startDate.addDays(3).month()+'. Project';
   		projectFriday='Fr. '+startDate.addDays(4).day()+'.'+startDate.addDays(4).month()+'. Project';
    	
    }// End Methode public void fillHeader()
    
    
    
    
    // Methode to calculate the Kalenderweek
    private Integer getCalendarWeek(Date theDate){
        //Date baseDate = Date.newInstance(2006,1,1);
        //return Math.Mod((baseDate.daysBetween(theDate))/7,52)+1;
        
        //return Math.Mod(Math.round((theDate.dayOfYear()/7)+1),52)+1;
        //return Math.Mod(Math.round((theDate.dayOfYear()/7)),52)+1;
        datetime dt;
        //dt = dt.newInstance(theDate, Time.newInstance(12, 0, 0, 0));
        dt = datetime.newInstance(theDate, Time.newInstance(12, 0, 0, 0));
        //return Math.round(theDate.dayOfYear()/7);
        return integer.valueof(dt.Format('w'));
        //return Math.ceil((Double)(theDate.dayOfYear()) / 7).intValue();
    } // END private Integer getCalendarWeek(Date theDate)
    
    
    
    // methode to fill the week list (list of Dates from startDate,Monday to Friday)
    public void fillWeekdaies(){
    	Date tempDate= date.newInstance(startDate.year(), startDate.month(), startDate.day());
    	weekdaies.add(tempDate);
    	for( Integer i = 1;i<5; i++){
    		tempDate= startDate.addDays(i);
    		weekdaies.add(tempDate);
    	}// end for( Integer i = 1;i<5; i++)
    	tuesdayDate=weekdaies[1];
    	wednesdayDate=weekdaies[2];
    	thursdayDate=weekdaies[3];
    	kalenderWeek= getCalendarWeek(startDate);
    }// End Methode fillWeekdaies()
   
    //Methode to fill the list of TimeEntries
	public void fillListTimeEntries(){
     	try{
     		listTimeEntries= [SELECT Time__c, Opportunity_Product__c, Opportunity__c,Name, IsDeleted, Id, 
     							Contact__c, Billable__c, Date__c
     							FROM TimeEntry__c WHERE Date__c IN:weekdaies AND IsDeleted=: false AND Contact__c IN:listContact And Billable__c=true];
     		
     		}catch(QueryException ex){
            	ApexPages.addMessages(ex);
        }// end try
 	}// end Mthode fillListTimeEntries()
 	
 	
 	// methode to fill the list of Employee Utilization
 	public void fillListEmUt(){
 	
 		// Select the Employee Utalization for the given week
    	try{
    		
    		listEmUt = [SELECT KW__c, Year__c, Month__c, Planed_Week__c,Planed_Wednesday__c, Planed_Tuesday__c, 
    						Project_on_Monday__c, Project_on_Tuesday__c, Project_on_Wednesday__c,
							Project_on_Thursday__c, Project_on_Friday__c, Planed_Thursday__c,
    						Planed_Monday__c, Planed_Friday__c, PSO_Ressource__c, Name, Id,
 							Date_Wednesday__c, Date_Tuesday__c, Date_Thursday__c, Date_Monday__c, Date_Friday__c, Contact__c,
 							Completeness_Wednesday__c,Completeness_Tuesday__c,Completeness_Thursday__c,Completeness_Monday__c,
 							Completeness_Friday__c,Billed_on_Wednesday__c,Billed_on_Tuesday__c,Billed_on_Thursday__c,
  							Billed_on_Monday__c,Billed_on_Friday__c, Billed_Hour_in_Week__c, Maximum_hours_in_week__c,
  							Planed_unbillable_hours_on_Friday__c, Planed_unbillable_hours_on_Monday__c,
							Planed_unbillable_hours_on_Thursday__c, Planed_unbillable_hours_on_Tuesday__c,
							Planed_unbillable_hours_on_Wednesday__c, Unbillable_Project_on_Friday__c,
							Unbillable_Project_on_Monday__c, Unbillable_Project_on_Thursday__c,
							Unbillable_Project_on_Tuesday__c, Unbillable_Project_on_Wednesday__c, Weekly_Auslastung__c 
  							FROM Employee_Utilization__c WHERE Date_Monday__c=: startDate];
    		
    	}catch(QueryException ex){
            ApexPages.addMessages(ex);
        }// End try
        
        // Set the billed Hours 0 because we need du calculate new
        if(listEmUt.size()>0){
        	for(Employee_Utilization__c tempEmUt:listEmUt){
        		tempEmUt.Billed_on_Monday__c = 0;
        		tempEmUt.Billed_on_Tuesday__c = 0;
        		tempEmUt.Billed_on_Wednesday__c = 0;
        		tempEmUt.Billed_on_Thursday__c = 0;
        		tempEmUt.Billed_on_Friday__c = 0;
        	}// End for(Employee_Utilization__c tempEmUt:listEmUt)
        
        
        
	        // Set the billed Hours
	        if(listTimeEntries.size()>0){
		        for(TimeEntry__c tempTimeEntry:listTimeEntries){
		        	for(Employee_Utilization__c tempEmUt:listEmUt){
		        		if(tempTimeEntry.Contact__c==tempEmUt.Contact__c){
		        			if(tempTimeEntry.Date__c == weekdaies[0]){
		        				tempEmUt.Billed_on_Monday__c = tempEmUt.Billed_on_Monday__c+ tempTimeEntry.Time__c;
		        			}else if(tempTimeEntry.Date__c == weekdaies[1]){
		        				tempEmUt.Billed_on_Tuesday__c = tempEmUt.Billed_on_Tuesday__c+ tempTimeEntry.Time__c;
		        			}else if(tempTimeEntry.Date__c == weekdaies[2]){
		        				tempEmUt.Billed_on_Wednesday__c = tempEmUt.Billed_on_Wednesday__c+tempTimeEntry.Time__c;
		        			}else if(tempTimeEntry.Date__c == weekdaies[3]){
		        				tempEmUt.Billed_on_Thursday__c= tempEmUt.Billed_on_Thursday__c+ tempTimeEntry.Time__c;
		        			}else if(tempTimeEntry.Date__c == weekdaies[4]){
		        				tempEmUt.Billed_on_Friday__c = tempEmUt.Billed_on_Friday__c + tempTimeEntry.Time__c;
		        			}// End if(tempTimeEntry.Date__c == weekdaies[0])
		        		}// End if(tempTimeEntry.Contact__c==tempEmUt)
		        	}// End for(Employee_Utilization__c tempEmUt:listEmUt)
		        }// End for(TimeEntry__c tempTimeEntry:listTimeEntries)
	        }// End if(listTimeEntries.size()>0)
        }// End if(listEmUt.size()>0)
        
 	}// End Methode fillListEmUt()
 	
 
 	// methode to fill the sum values
 	
 	public void fillSumObj(){
 		
 		if(listEmUt.size()>0){
 			for(Employee_Utilization__c tempUt:listEmUt){
 				sumplanedMonday	= sumplanedMonday + tempUt.Planed_Monday__c;
 				sumunbillableMonday = sumunbillableMonday + tempUt.Planed_unbillable_hours_on_Monday__c;	
 				sumbilledMonday = sumbilledMonday + tempUt.Billed_on_Monday__c;
 				sumplanedTuesday = sumplanedTuesday + tempUt.Planed_Tuesday__c;	
 				sumbilledTuesday= sumbilledTuesday + tempUt.Billed_on_Tuesday__c;
 				sumunbillableTuesday = sumunbillableTuesday + tempUt.Planed_unbillable_hours_on_Tuesday__c;
 				sumplanedWednesday = sumplanedWednesday + tempUt.Planed_Wednesday__c;
 				sumbilledWednesday = sumbilledWednesday + tempUt.Billed_on_Wednesday__c;
 				sumunbillableWednesday = sumunbillableWednesday + tempUt.Planed_unbillable_hours_on_Wednesday__c; 
 				sumplanedThursday = sumplanedThursday +tempUt.Planed_Thursday__c;
 				sumbilledThursday = sumbilledThursday + tempUt.Billed_on_Thursday__c;
 				sumunbillableThursday = sumunbillableThursday + tempUt.Planed_unbillable_hours_on_Thursday__c;
 				sumplanedFriday = sumplanedFriday + tempUt.Planed_Friday__c;
 				sumbilledFriday = sumbilledFriday + tempUt.Billed_on_Friday__c;
 				sumunbillableFriday = sumunbillableFriday + tempUt.Planed_unbillable_hours_on_Friday__c;
 				sumPlanedweek = sumPlanedweek + tempUt.Planed_Week__c;
 				sumBilledweek = sumBilledweek +tempUt.Billed_Hour_in_Week__c;
 				maxWertPlaned = maxWertPlaned + tempUt.Maximum_hours_in_week__c;
 				maxwertBilled = maxwertBilled + tempUt.Maximum_hours_in_week__c;
 				
 			}//end for(Employee_Utilization__c tempUt:listEmUt)
 				
 				/*
 				// set the maximum hours on 
 				maxMonday = listEmUt.size()*8;
    			maxTuesday = listEmUt.size()*8;
    			maxWednesday = listEmUt.size()*8;
    			maxThursday = listEmUt.size()*8;
    			maxFriday = listEmUt.size()*8;
	 			if(sumplanedMonday>0){
	 				sumcompletMonday = math.roundToLong((sumbilledMonday/sumplanedMonday)*100);
	 				maxcompletMonday = math.roundToLong((sumbilledMonday/maxMonday)*100);
	 				
	 			}
	 			if(sumplanedTuesday>0){
 					sumcompletTuesday = math.roundToLong((sumbilledTuesday/sumplanedTuesday)*100);
 					maxcompletTuesday = math.roundToLong((sumbilledTuesday/maxTuesday)*100);
	 			}
	 			if(sumplanedWednesday>0){
 					sumcompletWednesday = math.roundToLong((sumbilledWednesday/sumplanedWednesday)*100);
 					maxcompletWednesday = math.roundToLong((sumbilledWednesday/maxWednesday)*100);

	 			}
	 			if(sumplanedThursday>0){
 					sumcompletThursday = math.roundToLong((sumbilledThursday/sumplanedThursday)*100);
  					maxcompletThursday = math.roundToLong((sumbilledThursday/maxThursday)*100);
 					
	 			}
	 			if(sumplanedFriday>0){
 					sumcompletFriday = math.roundToLong((sumbilledFriday/sumplanedFriday)*100);
 					maxcompletFriday = math.roundToLong((sumbilledFriday/maxFriday)*100);
 					
	 			}
	 			
 				maxWertPlaned = listEmUt.size()*40;
 				maxwertBilled = listEmUt.size()*40;	
 				*/
 				if(maxWertPlaned>0){
 					auslastungPlened = math.roundToLong((sumPlanedweek/maxWertPlaned)*100);
 				}
 				if(maxwertBilled >0){
 					auslastungBilled = math.roundToLong((sumBilledweek/maxwertBilled)*100);
 				}
 		}//End if if(listEmUt.size()<0)
 		
 	}
 	public void mySetnull(){
 		sumcompletMonday = 0;
		sumcompletTuesday = 0;
    	sumcompletWednesday = 0;
    	sumcompletThursday = 0;
    	sumcompletFriday = 0;
    	sumunbillableMonday = 0;
		sumunbillableTuesday = 0;
    	sumunbillableWednesday = 0;
    	sumunbillableThursday = 0;
    	sumunbillableFriday = 0;
		sumplanedMonday= 0;
    	sumbilledMonday = 0;
    	sumplanedTuesday = 0; 
    	sumbilledTuesday = 0;
   		sumplanedWednesday = 0;
    	sumbilledWednesday = 0;
    	sumplanedThursday = 0;
    	sumbilledThursday = 0;
    	sumbilledFriday = 0;
    	sumplanedFriday = 0;
   		sumPlanedweek = 0;
    	sumBilledweek = 0;
    	maxWertPlaned = 0;
    	maxwertBilled = 0;
    	maxMonday = 0;
    	maxTuesday = 0;
    	maxWednesday = 0;
    	maxThursday = 0;
    	maxFriday = 0;
    	maxcompletMonday = 0;
		maxcompletTuesday = 0;
    	maxcompletWednesday = 0;
    	maxcompletThursday = 0;
    	maxcompletFriday = 0;
    	auslastungPlened = 0;
    	auslastungBilled = 0;
 		
 	}
 	// action for refesh
	public PageReference myRefresh(){
		startDate = thisEmUtObj.Date_Monday__c.toStartOfWeek();
		fridayDate = startDate.addDays(4);
		mySetnull();
		fillWeekdaies();
		fillListTimeEntries();
		fillListEmUt();
		fillHeader();
		
		
		
		if(this.listEmUt.size()>0){
			try{
				update listEmUt;
			}catch(DmlException dex){
				ApexPages.addMessages(dex);
			}// end try
		}// end if if(this.listEmUt.size()>0)
        try{
    		listEmUt = [Select KW__c, Year__c, Month__c, Planed_Week__c,Planed_Wednesday__c, Planed_Tuesday__c, 
    						Planed_Thursday__c, Planed_Monday__c, Planed_Friday__c, 
    						Project_on_Monday__c, Project_on_Tuesday__c, Project_on_Wednesday__c,
							Project_on_Thursday__c, Project_on_Friday__c, PSO_Ressource__c, Name, Id,
 							Date_Wednesday__c, Date_Tuesday__c, Date_Thursday__c, Date_Monday__c, Date_Friday__c, Contact__c,
 							Completeness_Wednesday__c,Completeness_Tuesday__c,Completeness_Thursday__c,Completeness_Monday__c,
 							Completeness_Friday__c,Billed_on_Wednesday__c,Billed_on_Tuesday__c,Billed_on_Thursday__c,
  							Billed_on_Monday__c,Billed_on_Friday__c, Billed_Hour_in_Week__c, Maximum_hours_in_week__c,
  							Planed_unbillable_hours_on_Friday__c, Planed_unbillable_hours_on_Monday__c,
							Planed_unbillable_hours_on_Thursday__c, Planed_unbillable_hours_on_Tuesday__c,
							Planed_unbillable_hours_on_Wednesday__c, Unbillable_Project_on_Friday__c,
							Unbillable_Project_on_Monday__c, Unbillable_Project_on_Thursday__c,
							Unbillable_Project_on_Tuesday__c, Unbillable_Project_on_Wednesday__c, Weekly_Auslastung__c 
  							FROM Employee_Utilization__c WHERE Date_Monday__c=: startDate];
    		
    	}catch(QueryException ex){
            ApexPages.addMessages(ex);
        }// End try*/
		fillSumObj();

		PageReference currentPage1 = ApexPages.currentPage();
        return null;
	}// End Methode myRefresh()
	
	public PageReference myCancel(){
		return ApexPages.currentPage();
	}// End Methode mycancel
}// End Class