// /* **************************************************************
// Creater: Chis Sandra Schautt
// Description: This Trigger is used to create Order Letter Products and Order Letter Contact Roles.
//              After inserting an Order Letter, if the Parent Opportunity  has OpportunityLineItem 
//              and OpportunityContactRole
//              they have to be clone as OrderLetterProducts and Order LetterContactRoles.
// HelpClass:  None
// Testclass: OrderLetter_ExtensionTest 
// Apex Class Access: no limitations/Profilenames
// Last modified by: Chris Sandra Schautt
// Last modified date: 28.03.2013
// Latests changes: add comments
// ************************************************************** */
trigger Employee_Utilization_AI_AU on Employee_Utilization__c (before insert, before update) {

    Map<Id,Contact> psoMember = new  Map<Id,Contact>([SELECT Id, Name, FirstName, LastName FROM Contact WHERE PSO_Member__c=:true]);
    TimeEntry__c [] listTimeEntries = new List<TimeEntry__c>();

    
    Employee_Utilization__c []  listEmUt = Trigger.new;
    // set list from Monday to fiday
    Date [] weekdaies= new List<Date>();
    
    if (trigger.isInsert){
        
        // set the PSO Ressource in the Object
        for(Integer i=0; i< listEmUt.size(); i++){
            if(psoMember.get(listEmUt[i].Contact__c)!=null){
            	listEmUt[i].Date_Monday__c = listEmUt[i].Date_Monday__c.toStartOfWeek();
                listEmUt[i].PSO_Ressource__c = psoMember.get(listEmUt[i].Contact__c).Name;
                listEmUt[i].Name2__c = listEmUt[i].Name;
            }// end if
        }// End for(Integer i=0; i< listEmUt; i++)
        
        weekdaies.add(listEmUt[0].Date_Monday__c);
	    weekdaies.add(listEmUt[0].Date_Tuesday__c);
	    weekdaies.add(listEmUt[0].Date_Wednesday__c);
	    weekdaies.add(listEmUt[0].Date_Thursday__c);
	    weekdaies.add(listEmUt[0].Date_friday__c);
    }// End if (trigger.isInsert && trigger.isUpdate)
    
    
    else if(trigger.isUpdate){
        // set the PSO Ressource in the Object
        for(Integer i=0; i< listEmUt.size(); i++){
        	listEmUt[i].Date_Monday__c = listEmUt[i].Date_Monday__c.toStartOfWeek();
        	
            if(psoMember.get(listEmUt[i].Contact__c)!=null){
            	
                listEmUt[i].PSO_Ressource__c = psoMember.get(listEmUt[i].Contact__c).Name;
                
            }// end if
            weekdaies.add(listEmUt[0].Date_Monday__c);
    		weekdaies.add(listEmUt[0].Date_Tuesday__c);
    		weekdaies.add(listEmUt[0].Date_Wednesday__c);
    		weekdaies.add(listEmUt[0].Date_Thursday__c);
    		weekdaies.add(listEmUt[0].Date_friday__c);
            if(listEmUt[i].Date_Monday__c!=null){
            	listEmUt[i].KW__c = getCalendarWeek(listEmUt[i].Date_Monday__c);
            	listEmUt[i].Year__c = listEmUt[i].Date_Monday__c.year();
            	listEmUt[i].Month__c = listEmUt[i].Date_Monday__c.Month();
                listEmUt[i].Name = 'KW'+ listEmUt[i].KW__c + '_'+listEmUt[i].Year__c + '_' + psoMember.get(listEmUt[i].Contact__c).FirstName+ '_' +psoMember.get(listEmUt[i].Contact__c).LastName;
            	listEmUt[i].Name2__c = listEmUt[i].Name;
            }// end If
        }// End for(Integer i=0; i< listEmUt; i++)
        
        // set the TimEntry
        try{
            listTimeEntries= [SELECT Time__c, Opportunity_Product__c, Opportunity__c,Name, IsDeleted, Id, 
                                Contact__c, Billable__c,Date__c
                                FROM TimeEntry__c WHERE Date__c IN:weekdaies AND IsDeleted=: false AND Contact__c IN:psoMember.values()And Billable__c=true];
            
            }catch(QueryException ex){
                ApexPages.addMessages(ex);
        }// end try
        
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
    }// else if(trigger.isUpdate)
    
    
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
    
}// end Trigger