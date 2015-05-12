// /* **************************************************************
// Creater: Chis Sandra Schautt
// Description: This class is the Extension for the Visualforce Page Employee_UT_Edit_Page. 
//				Every week all PSO Member has to create their own Employee Utilization Obj and list their planed billable and unbillable hours
//				for the next week. This Obj has also the timeentries for that week, so we can compare the planed Vs. billed Hours.
//				All Employee Utilization Obj and timeEntries from all Contacts with checkbox PSO Member checked are selected and listed
//				in the page. 
// Page: 
// Testclass: Employee_Utilization_Test
// Triggers: Employee_Utilization_AI_AU
// Apex Class Access: no limitations/Profilenames
// Last modified by: Chris Sandra Schautt
// Last modified date: 12.06.2013
// Latests changes: 28.03.2013 create the Controller
//					12.06.2013 change the obj. all unpillable planed field are also shown it the Page and the Maximum available h
// ************************************************************** */


public with sharing class Employee_Utilization_Edit_Extension {
	
	// Dates to select
	public Date date1{get;set;}
	public Date date2{get;set;}
	public Date date3{get;set;}
	public Date date4{get;set;}
	public Date date5{get;set;}
	public Date date6{get;set;}
	public Date date7{get;set;}
	public Date date8{get;set;}
	public Date date9{get;set;}
	
	// KWs to select
	public Integer dateKW1{get;set;}
	public Integer dateKW2{get;set;}
	public Integer dateKW3{get;set;}
	public Integer dateKW4{get;set;}
	public Integer dateKW5{get;set;}
	public Integer dateKW6{get;set;}
	public Integer dateKW7{get;set;}
	public Integer dateKW8{get;set;}
	public Integer dateKW9{get;set;}
	
	 // contactlist and the currentcontact
	private Map<Id,Contact> mapContacts{get;set;}
	private Contact currentcontact = new Contact();
	private Contact objSelectedContact = new Contact();
    public Contact [] listContact{get;set;}
    public ApexPages.Standardcontroller ctrl;
	public Employee_Utilization__c  thisEmUtObj{get;set;}
    
    // selected values
    public String selectedContact{get;set;}
    public String selectedDate{get;set;}
    private List<SelectOption> optionListSelectedUserNames;
    
    // this values will select the right view for single users 
    // or Managers
    public Boolean bUserView{get;set;}
    public Id idCurrentUser {get;set;}
    
    // exceptionclass
    public class MyException extends Exception{}
     //Exception 
     MyException myEx;
    
    
    // constructor
    public Employee_Utilization_Edit_Extension(ApexPages.StandardController thedeliveredcontroller){
    	thisEmUtObj = new Employee_Utilization__c();
    	thisEmUtObj.Planed_Monday__c= 0.0;
    	thisEmUtObj.Planed_Tuesday__c = 0.0;
    	thisEmUtObj.Planed_Wednesday__c = 0.0;
    	thisEmUtObj.Planed_Thursday__c = 0.0;
    	thisEmUtObj.Planed_Friday__c = 0.0;
    	thisEmUtObj.Maximum_hours_in_week__c = 40.0;
    	thisEmUtObj.Project_on_Monday__c ='';
    	thisEmUtObj.Project_on_Tuesday__c ='';
    	thisEmUtObj.Project_on_Wednesday__c ='';
    	thisEmUtObj.Project_on_Thursday__c ='';
    	thisEmUtObj.Project_on_Friday__c ='';
    	
    	
    	thisEmUtObj.Planed_unbillable_hours_on_Friday__c = 0.0; 
    	thisEmUtObj.Planed_unbillable_hours_on_Monday__c = 0.0;
		thisEmUtObj.Planed_unbillable_hours_on_Thursday__c=0.0; 
		thisEmUtObj.Planed_unbillable_hours_on_Tuesday__c = 0.0;
		thisEmUtObj.Planed_unbillable_hours_on_Wednesday__c = 0.0; 
		thisEmUtObj.Unbillable_Project_on_Friday__c='';
		thisEmUtObj.Unbillable_Project_on_Monday__c='';
		thisEmUtObj.Unbillable_Project_on_Thursday__c='';
		thisEmUtObj.Unbillable_Project_on_Tuesday__c = '';
		thisEmUtObj.Unbillable_Project_on_Wednesday__c = '';
    	
        User currentuser = [SELECT Id, Contact_ID__c,ProfileId FROM User WHERE Id =: System.UserInfo.getUserId()];
   		
   		try{
            currentcontact = [SELECT Id, Name, FirstName, LastName FROM Contact WHERE Id =: currentuser.Contact_ID__c LIMIT 1];
            //objTimeEntry.Contact__c = currentcontact.Id;
            System.debug('@@@ DEBUG currentContact:'+currentcontact.Name);
        }catch(System.DmlException ex){thisEmUtObj.addError('Sorry, for you is no contact created');ApexPages.addMessages(ex);}
        selectedContact = currentContact.Id;
        selectContacts();
        setDates();
    }// end constructor
    
    public void setDates(){
    	// 4 weeks in the past and five weeks in the future
    	date5= System.today().toStartOfWeek();
    	date6= date5.addDays(7).toStartOfWeek();
    	date7= date6.addDays(7).toStartOfWeek();
    	date8= date7.addDays(7).toStartOfWeek();
    	date9= date8.addDays(7).toStartOfWeek();
    	date4= date5.addDays(-6).toStartOfWeek();
    	date3= date4.addDays(-6).toStartOfWeek();
    	date2= date3.addDays(-6).toStartOfWeek();
    	date1= date2.addDays(-6).toStartOfWeek();
    	
    	
    	dateKW1 = getCalendarWeek(date1);
    	dateKW2 = getCalendarWeek(date2);
    	dateKW3 = getCalendarWeek(date3);
    	dateKW4 = getCalendarWeek(date4);
    	dateKW5 = getCalendarWeek(date5);
    	dateKW6 = getCalendarWeek(date6);
    	dateKW7 = getCalendarWeek(date7);
    	dateKW8 = getCalendarWeek(date8);
    	dateKW9 = getCalendarWeek(date9);	
    }
    //fill global variable Map with contacts
    public void selectContacts(){

    	Profile currentUserAdminProfile = [SELECT Id,Name FROM Profile WHERE Id =: System.UserInfo.getProfileId()];
    	System.debug('@@@@@ PROFILE: '+currentUserAdminProfile.Name);
    	if (currentUserAdminProfile.Name.contains('administrator') ||  currentUserAdminProfile.Name.contains('Administrator')|| currentUserAdminProfile.Name.contains('YOUR SL Assistenz')){    	
    	
	    	listContact =[SELECT Id,Name, FirstName, LastName
	    					FROM Contact WHERE
	    					PSO_Member__c=:true];
	    	
	    	mapContacts = new Map<Id,Contact>([
	    							SELECT Id,Name, FirstName, LastName
	    							FROM Contact WHERE
	    					PSO_Member__c=:true]);
    	}else{
    		User currentUser = [SELECT Id,Contact_ID__c FROM User WHERE Id =: System.UserInfo.getUserId()];
    		mapContacts = new Map<Id,Contact>([
    							SELECT Id,Name, FirstName, LastName
    							FROM Contact WHERE
    							Id =: currentUser.Contact_ID__c AND PSO_Member__c=:true
			]);    		
    		
    	}//END if (currentUserAdminProfile.Name.contains('Adminstrator'))
    	
    }// end methode selectContacts
    
    
    //fill dropdown list with contact
    public List<SelectOption> getSelectedContactList(){
    	List<SelectOption> options = new List<SelectOption>();
    	
    	if(mapContacts.isEmpty() == false){
    		//options.add(new SelectOption('current', ' '+System.UserInfo.getName()));
    		for(Contact c : mapContacts.values()){
    			options.add(new SelectOption(c.Id,c.Name));
    		}
    	}else{
    		options.add(new SelectOption('nocontact','No contact found!'));
    	}
    	SelectOptionSorter.doSort(options, SelectOptionSorter.FieldToSort.Label);

    	return options;
    	
    }// End public List<SelectOption> getSelectedContactList
    
    //fill dropdown list with contact
    public List<SelectOption> getSelectedDateList(){
    	List<SelectOption> options = new List<SelectOption>();
    		//'nocontact','No contact found!'
    			options.add(new SelectOption('5','KW'+dateKW5+' - Start on '+date5.day()+'.'+date5.month()+'.'+date5.year()));
    			options.add(new SelectOption('noDate','-----------------------------------'));
    			options.add(new SelectOption('1','KW'+dateKW1+' - Start on '+date1.day()+'.'+date1.month()+'.'+date1.year()));
    			options.add(new SelectOption('2','KW'+dateKW2+' - Start on '+date2.day()+'.'+date2.month()+'.'+date2.year()));
    			options.add(new SelectOption('3','KW'+dateKW3+' - Start on '+date3.day()+'.'+date3.month()+'.'+date3.year()));
    			options.add(new SelectOption('4','KW'+dateKW4+' - Start on '+date4.day()+'.'+date4.month()+'.'+date4.year()));
    			options.add(new SelectOption('noDate','-----------------------------------'));
    			options.add(new SelectOption('6','KW'+dateKW6+' - Start on '+date6.day()+'.'+date6.month()+'.'+date6.year()));
    			options.add(new SelectOption('7','KW'+dateKW7+' - Start on '+date7.day()+'.'+date7.month()+'.'+date7.year()));
    			options.add(new SelectOption('8','KW'+dateKW8+' - Start on '+date8.day()+'.'+date8.month()+'.'+date8.year()));
    			options.add(new SelectOption('9','KW'+dateKW9+' - Start on '+date9.day()+'.'+date9.month()+'.'+date9.year()));
    	

    	return options;
    	
    }// End public List<SelectOption> getSelectedContactList
    
    
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
	
	public PageReference save1(){
		// new EmUT to for insert
		Employee_Utilization__c new_EmUT = new Employee_Utilization__c( Planed_Monday__c = thisEmUtObj.Planed_Monday__c,
																		Planed_Tuesday__c = thisEmUtObj.Planed_Tuesday__c,
																		Planed_Wednesday__c = thisEmUtObj.Planed_Wednesday__c,
																		Planed_Thursday__c = thisEmUtObj.Planed_Thursday__c,
																		Planed_Friday__c = thisEmUtObj.Planed_Friday__c,
																		Project_on_Monday__c = thisEmUtObj.Project_on_Monday__c,
																		Project_on_Tuesday__c = thisEmUtObj.Project_on_Tuesday__c,
																		Project_on_Wednesday__c = thisEmUtObj.Project_on_Wednesday__c,
																		Project_on_Thursday__c = thisEmUtObj.Project_on_Thursday__c,
																		Project_on_Friday__c = thisEmUtObj.Project_on_Friday__c,
																		Maximum_hours_in_week__c = thisEmUtObj.Maximum_hours_in_week__c,
																		Planed_unbillable_hours_on_Friday__c = thisEmUtObj.Planed_unbillable_hours_on_Friday__c, 
    																	Planed_unbillable_hours_on_Monday__c = thisEmUtObj.Planed_unbillable_hours_on_Monday__c,
																		Planed_unbillable_hours_on_Thursday__c = thisEmUtObj.Planed_unbillable_hours_on_Thursday__c, 
																		Planed_unbillable_hours_on_Tuesday__c = thisEmUtObj.Planed_unbillable_hours_on_Tuesday__c,
																		Planed_unbillable_hours_on_Wednesday__c = thisEmUtObj.Planed_unbillable_hours_on_Wednesday__c, 
																		Unbillable_Project_on_Friday__c = thisEmUtObj.Unbillable_Project_on_Friday__c,
																		Unbillable_Project_on_Monday__c = thisEmUtObj.Unbillable_Project_on_Monday__c,
																		Unbillable_Project_on_Thursday__c = thisEmUtObj.Unbillable_Project_on_Thursday__c,
																		Unbillable_Project_on_Tuesday__c = thisEmUtObj.Unbillable_Project_on_Tuesday__c,
																		Unbillable_Project_on_Wednesday__c = thisEmUtObj.Unbillable_Project_on_Wednesday__c
		);
		// set the contact of the new EmUT
		if(selectedContact!= 'nocontact'){
			new_EmUT.Contact__c = selectedContact;
			try{
				objSelectedContact = mapContacts.get(selectedContact);
			}catch(System.ListException ex){
    			ApexPages.addMessages(ex);
    			return null;
			}//end Try
		}else{
				myEx = new MyException();
    			myEx.setMessage('Please select a Contact');
    			//ApexPages.addMessage(myEx.getMessage());
    			return null;
		}// end if(selectedContact!= 'nocontact')
		
		
		// set The Date Fields
		if(selectedDate!='noDate'&& selectedDate!= null){
			if(selectedDate== '1'){
				new_EmUT.KW__c = dateKW1;
				new_EmUT.Year__c = date1.year();
				new_EmUT.Month__c = date1.month();
				new_EmUT.Date_Monday__c = date1;
				new_EmUT.Name = 'KW:'+dateKW1+'_'+date1.year()+'_'+objSelectedContact.FirstName+'_'+objSelectedContact.LastName;
			}else if (selectedDate== '2'){
				new_EmUT.KW__c = dateKW2;
				new_EmUT.Year__c = date2.year();
				new_EmUT.Month__c = date2.month();
				new_EmUT.Date_Monday__c = date2;
				new_EmUT.Name = 'KW:'+dateKW2+'_'+date2.year()+'_'+objSelectedContact.FirstName+'_'+objSelectedContact.LastName;	
			}else if (selectedDate== '3'){
				new_EmUT.KW__c = dateKW3;
				new_EmUT.Year__c = date3.year();
				new_EmUT.Month__c = date3.month();
				new_EmUT.Date_Monday__c = date3;
				new_EmUT.Name = 'KW:'+dateKW3+'_'+date3.year()+'_'+objSelectedContact.FirstName+'_'+objSelectedContact.LastName;	
			}else if (selectedDate== '4'){
				new_EmUT.KW__c = dateKW4;
				new_EmUT.Year__c = date4.year();
				new_EmUT.Month__c = date4.month();
				new_EmUT.Date_Monday__c = date4;
				new_EmUT.Name = 'KW:'+dateKW4+'_'+date4.year()+'_'+objSelectedContact.FirstName+'_'+objSelectedContact.LastName;	
			}else if (selectedDate== '5'){
				new_EmUT.KW__c = dateKW5;
				new_EmUT.Year__c = date5.year();
				new_EmUT.Month__c = date5.month();
				new_EmUT.Date_Monday__c = date5;
				new_EmUT.Name = 'KW:'+dateKW5+'_'+date5.year()+'_'+objSelectedContact.FirstName+'_'+objSelectedContact.LastName;	
			}else if (selectedDate== '6'){
				new_EmUT.KW__c = dateKW6;
				new_EmUT.Year__c = date6.year();
				new_EmUT.Month__c = date6.month();
				new_EmUT.Date_Monday__c = date6;
				new_EmUT.Name = 'KW:'+dateKW6+'_'+date6.year()+'_'+objSelectedContact.FirstName+'_'+objSelectedContact.LastName;	
			}else if (selectedDate== '7'){
				new_EmUT.KW__c = dateKW7;
				new_EmUT.Year__c = date7.year();
				new_EmUT.Month__c = date7.month();
				new_EmUT.Date_Monday__c = date7;
				new_EmUT.Name = 'KW:'+dateKW7+'_'+date7.year()+'_'+objSelectedContact.FirstName+'_'+objSelectedContact.LastName;	
			}else if (selectedDate== '8'){
				new_EmUT.KW__c = dateKW8;
				new_EmUT.Year__c = date8.year();
				new_EmUT.Month__c = date8.month();
				new_EmUT.Date_Monday__c = date8;
				new_EmUT.Name = 'KW:'+dateKW8+'_'+date8.year()+'_'+objSelectedContact.FirstName+'_'+objSelectedContact.LastName;	
			}else if (selectedDate== '9'){
				new_EmUT.KW__c = dateKW9;
				new_EmUT.Year__c = date9.year();
				new_EmUT.Month__c = date9.month();
				new_EmUT.Date_Monday__c = date9;
				new_EmUT.Name = 'KW:'+dateKW9+'_'+date9.year()+'_'+objSelectedContact.FirstName+'_'+objSelectedContact.LastName;	
			}// end if(selectedDate== '1')
		}else{
			
				myEx = new MyException();
    			myEx.setMessage('Please select a KW');
    			ApexPages.addMessages(myEx);
    			return null;
		}// end if(selectedDate!='no Date')
		
		if(new_EmUT.Name!=null && new_EmUT.Date_Monday__c != null && new_EmUT.Contact__c != null){
			try{
				insert new_EmUT;
			}catch(DmlException dex){
				
				ApexPages.addMessages(dex);
			}// Endtry
			 PageReference utPage = new ApexPages.StandardController(new_EmUT).view();
        	utPage.setRedirect(true);
        	return utPage;
		}else{
			
			myEx = new MyException();
    		myEx.setMessage('Please check the insert items');
    		ApexPages.addMessages(myEx);
    		return null;
			
		}// end if(new_EmUT.Name!=null&& new_EmUT.Date_Monday__c != null && new_EmUT.Contact__c != 0)
			myEx = new MyException();
    		myEx.setMessage('Please check the insert items');
    		ApexPages.addMessages(myEx);
    		return null;
	}// end methode save1()	

}