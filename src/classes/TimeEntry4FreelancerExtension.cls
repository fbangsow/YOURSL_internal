// /* **************************************************************
// Creater: Alexander Faust, Chris Sandra Schautt
// Description: this class is an extension for a visualforcepage, to create timeentrys or freelancer  
//              
//              
//               
// Page: TimeEntryPageForFreelancer
// Testclass: TimeEntryUserTest
// Triggers: TimeEntryTrigger
// Apex Class Access: no limitations/Profilenames
// Last modified by: Chris Sandra Schautt
// Last modified date: 27.09.2013
// Latests changes: change the selectedContact lists
// ************************************************************** */
public with sharing class TimeEntry4FreelancerExtension {
    //the Id for the current contact
    public String strCurrentContactId{get;set;}
    private Map<String, String>mapParameters{get;set;}
    private Pagereference thepage;
    public Contact currentcontact = new Contact();
    public Contact dummyContact = new Contact();
    public ApexPages.Standardcontroller ctrl;
    
    public class Info{
     public String strId{get;set;}
     public String strLink{get;set;}
     public String strName{get;set;}
     public String strContactId{get;set;}
     public String strContactName{get;set;}
     public String strDescription{get;set;}
     public String strDate{get;set;}
     public String strOpportunityName{get;set;}
     public String strProductName{get;set;}
     public double dTime{get;set;}
     public Boolean billable{get;set;}
     
     public info(){
        strId='NA';
        strLink = 'http://beyondfuturetrends.force.com/TimeEntryEdit?eid=';
        strName='NA';
        strContactId='NA';
        strContactName='NA';
        strDescription='NA';
        strDate='NA';
        strOpportunityName='NA';
        strProductName='NA';
        dTime = 0;
        billable = false;
     }// end constructor
     
     // method to create a table for timentrys
     public void setInfo( TimeEntry__c objTimeEntry){
        strLink = 'http://beyondfuturetrends.force.com/TimeEntryEdit?eid=' + objTimeEntry.Id+'&edit=false';
        strId = objTimeEntry.Id;
        strName = objTimeEntry.Name;
        strContactId=objTimeEntry.Contact__c;
        strContactName=objTimeEntry.Contact__r.Name;
        strDescription=objTimeEntry.Description__c;
        strDate=objTimeEntry.Date__c.day()+'.'+objTimeEntry.Date__c.month()+'.'+objTimeEntry.Date__c.year();
        strOpportunityName=objTimeEntry.Opportunity__r.Name;
        strProductName=objTimeEntry.Opportunity_Product_Name__c;
        dTime = objTimeEntry.Time__c;
        billable = objTimeEntry.Billable__c;
     }// end setInfo
    }// end class info
    
    // this is the record used during entry
    public TimeEntry__c objTimeEntry {get;set;}
    public List<TimeEntry__c> oldTimeEntries {get;set;} 
    public List<Date> objTimeEntryWeekEndStart{get;set;}
    public List<Info> resultList{get;set;}
    Opportunity oppIntern{get;set;}
    
    //return values from selectOptions
    public String selectedOpp{get;set;}
    public String selectedTask{get;set;}
    public String selectedProjectType{get;set;}
    public String selectedContact{get;set;}
    public Boolean billableFlag{get;set;}
    
    private List<SelectOption> optionListSelectedUserNames;
    
    
    // this values will select the right view for single users 
    // or Managers
    public Boolean bUserView{get;set;}
    public Id idCurrentUser {get;set;}
    private Map<Id,Opportunity> mapOpportuntiy4User;
    private Map<Id,OpportunityLineItem> mapOpportuntiyLineItem4User;
    
    /* new requirement:
        Task assigned, Sales Support and Internal are preselections for 
        selected List of Opportunities
        the preselection will be done on page load in the 
        selectOppsAndLineItems() with two more pairs of Opportuntiy Maps
    */
    //private Map<Id,Opportunity> mapOpportuntiyPreSales;
    private Map<Id,OpportunityLineItem> mapOpportuntiyLineItemPreSales;
    private Map<Id,Opportunity> mapOpportuntiyInternal;
    private Map<Id,OpportunityLineItem> mapOpportuntiyLineItemInternal;
    private Map<Id,Contact> mapContacts;
    
    
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
        
    }
    
    
    //fill global variable Map with contacts
    public void selectContacts(){
        //Profile currentUserAdminProfile = [SELECT Id,Name FROM Profile WHERE Id =: System.UserInfo.getProfileId()];
        Profile freelancerProfile = [SELECT Id,Name FROM Profile WHERE Name LIKE:('%Freelancer%') LIMIT 1];

            //fill map with contact from currentuser
            mapContacts = new Map<Id,Contact>([
                                SELECT Id,Name, FirstName, LastName
                                FROM Contact WHERE
                                Id =: strCurrentContactId
                                AND Is_Freelancer__c =: true
            ]);         
            

        
    
    }
    // fill global variable Maps with Opps and OLIs
    public void selectOppsAndLineItemsInternal(){

        Date dateNotOlderThanLastMonth = System.today().addDays(-10);
        dateNotOlderThanLastMonth = dateNotOlderThanLastMonth.addMonths(-1);
        
        Date dateNotMoreThanSixMonthInFuture = System.today();
        dateNotMoreThanSixMonthInFuture = dateNotMoreThanSixMonthInFuture.addMonths(6);
        
        
        try{
            mapOpportuntiyLineItemInternal = new Map<Id,OpportunityLineItem>([
                                                    SELECT Id, OpportunityId, Contact__c, PricebookEntry.Name,
                                                    PricebookEntry.Product2Id,
                                                    ServiceDate, CreatedDate, Unit__c,
                                                    Quantity,Total_booked_days__c,
                                                    Total_Booked_Unbillable__c,
                                                    Total_Realization__c,
                                                    Total_Booked_Hours_billable__c,
                                                    UnitPrice,
                                                    Quantity_in_Hours__c,
                                                    Description
                                                    FROM OpportunityLineItem 
                                                    WHERE Leistung_erbracht__c =: false 
                                                    AND Unit__c =: 'Manntag(e)'
                                                    AND Opportunity.IsWon = true
                                                    AND Contact__c =: dummyContact.Id
                                                    AND Opportunity.Account.Name = 'YOUR SL GmbH'
                                                    AND ServiceDate >: dateNotOlderThanLastMonth
                                                    AND ServiceDate <: dateNotMoreThanSixMonthInFuture
                                                    ORDER BY ServiceDate]);
         
        }catch(DmlException ex){objTimeEntry.addError('Sorry, no Task assigned to you');ApexPages.addMessages(ex);}
        
                
        List<OpportunityLineItem> listOppLIs = new List<OpportunityLineItem>();
        
        listOppLIs = mapOpportuntiyLineItemInternal.values();
        List<Id> listOppIds = new List<Id>();
        for(Integer i=0;i<listOppLIs.size();i++){
            listOppIds.add(listOppLIs[i].OpportunityId);
        }
        System.debug('############ Opp Id List' + listOppIds.size().format() );
        mapOpportuntiyInternal = new Map<Id,Opportunity>([SELECT Id, Name, CloseDate,ForeCastCategoryName FROM Opportunity WHERE Id IN: listOppIds ORDER BY Name]);
    }// END public selectOppsAndLineItemsInternal()
    
    // fill global variable Maps with Opps and OLIs
    /*public void selectOppsAndLineItemsPreSales(){

        Date dateNotOlderThanLastMonth = System.today().addDays(-10);
        dateNotOlderThanLastMonth = dateNotOlderThanLastMonth.addMonths(-1);
        
        Date dateNotMoreThanSixMonthInFuture = System.today();
        dateNotMoreThanSixMonthInFuture = dateNotMoreThanSixMonthInFuture.addMonths(6);
        
        
        try{
            mapOpportuntiyLineItemPreSales = new Map<Id,OpportunityLineItem>([
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
                                                    AND Opportunity.ForecastCategory != 'Omitted'
                                                    AND Contact__c =: dummyContact.Id
                                                    AND Opportunity.Account.Name != 'YOUR SL GmbH'
                                                    AND ServiceDate >: dateNotOlderThanLastMonth
                                                    AND ServiceDate <: dateNotMoreThanSixMonthInFuture
                                                    ORDER BY ServiceDate]);
                                                    
        }catch(DmlException ex){objTimeEntry.addError('Sorry, no Task assigned to you');ApexPages.addMessages(ex);}
        
                
        List<OpportunityLineItem> listOppLIs = new List<OpportunityLineItem>();
        
        listOppLIs = mapOpportuntiyLineItemPreSales.values();
        List<Id> listOppIds = new List<Id>();
        for(Integer i=0;i<listOppLIs.size();i++){
            listOppIds.add(listOppLIs[i].OpportunityId);
        }
        System.debug('############ Opp Id List' + listOppIds.size().format() );
        mapOpportuntiyPreSales = new Map<Id,Opportunity>([SELECT Id, Name, CloseDate,ForeCastCategoryName FROM Opportunity WHERE Id IN: listOppIds ORDER BY Name]);
    }// END public selectOppsAndLineItemsPreSales()
*/

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
                                                    Quantity_in_Hours__c,
                                                    Description
                                                    FROM OpportunityLineItem 
                                                    WHERE Leistung_erbracht__c =: false 
                                                    AND Unit__c =: 'Manntag(e)'
                                                    AND Opportunity.IsWon = true
                                                    //AND Contact__c =: currentcontact.Id
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
        for(Integer i=0;i<listOppLIs.size();i++){
            listOppIds.add(listOppLIs[i].OpportunityId);
        }
        System.debug('############ Opp Id List' + listOppIds.size().format() );
        mapOpportuntiy4User = new Map<Id,Opportunity>([SELECT Id, Name, CloseDate,ForeCastCategoryName 
                                                        FROM Opportunity 
                                                        WHERE Id IN: listOppIds 
                                                        AND (NOT Name  like '%Urlaub%')  
                                                        ORDER BY Name]);
    }// END public selectOppsAndLineItems()
    //  AND (NOT Name  like '%Urlaub%')<--  added by kim
    
    // this is used for a preselection of all Opportunities
    public List<SelectOption> getProjectTypeList(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('toSelect', 'Please select...'));
        options.add(new SelectOption('4User', 'Tasks assigned to me'));
        //options.add(new SelectOption('SalesSupport', 'Sales Support'));
        options.add(new SelectOption('internal', 'Internal'));
        return options;
    }// END public List<SelectOption> getselectedProjectType()
    
    
    public List<SelectOption> getOpportunityList() {
        //selectOppsAndLineItems();
        List<SelectOption> options = new List<SelectOption>();
        
        if(selectedProjectType == 'internal'){
            if(mapOpportuntiyLineItemInternal.isEmpty() == false){
                options.add(new SelectOption('toselect', ' Please select'));
                for(Opportunity opp : mapOpportuntiyInternal.values()){
                    options.add(new SelectOption(opp.Id, opp.Name+' ('+opp.ForeCastCategoryName+')'));
                }
            }else{
                options.add(new SelectOption('noopp', 'No Opportunity assigned'));
            }// END if(mapOpportuntiyLineItem.isEmpty() == false)
            
            
        }/*else if(selectedProjectType == 'SalesSupport'){
            if(mapOpportuntiyLineItemPreSales.isEmpty() == false){
                options.add(new SelectOption('toselect', ' Please select'));
                for(Opportunity opp : mapOpportuntiyPreSales.values()){
                    options.add(new SelectOption(opp.Id, opp.Name+' ('+opp.ForeCastCategoryName+')'));
                }
            }else{
                options.add(new SelectOption('noopp', 'No Opportunity assigned'));
            }// END if(mapOpportuntiyLineItem.isEmpty() == false)
            
            
        }*/
        else if(selectedProjectType == '4User'){
            if(mapOpportuntiyLineItem4User.isEmpty() == false){
                options.add(new SelectOption('toselect', ' Please select'));
                for(Opportunity opp : mapOpportuntiy4User.values()){
                    options.add(new SelectOption(opp.Id, opp.Name+' ('+opp.ForeCastCategoryName+')'));
                }
            }else{
                options.add(new SelectOption('noopp', 'No Opportunity assigned'));
            }// END if(mapOpportuntiyLineItem.isEmpty() == false)
        }// END if(selectedProjectType == 'internal')

        //options.sort();
        SelectOptionSorter.doSort(options, SelectOptionSorter.FieldToSort.Label);
        return options;
    }
    
    public List<SelectOption> getOpportunityLineItemList() {
        List<SelectOption> options = new List<SelectOption>();
        
        
        
        if(selectedProjectType == 'internal'){
            if(mapOpportuntiyLineItemInternal.isEmpty() == false){
                options.add(new SelectOption('toselect', ' Please select'));
                for(OpportunityLineItem oppLI : mapOpportuntiyLineItemInternal.values()){
                    if(String.valueOf(oppLI.OpportunityId) == selectedOpp){
                        //options.add(new SelectOption(oppLI.Id, oppLI.PricebookEntry.Name + ' ' + oppLI.ServiceDate.format()));
                        Decimal dHoursLeft = proofHoursLeft(oppLI);
                        String description = String.isEmpty(oppLI.Description)? '' : trimDescription(oppLI.Description);
                        //options.add(new SelectOption(oppLI.Id, tempDate.month()+' '+oppLI.PricebookEntry.Name + ' ' + oppLI.Quantity +'[E]'+ ' '+oppLI.Total_booked_days__c+' / '+oppLI.Total_Realization__c+' % [B]'+ ' '+oppLI.Total_Booked_Unbillable__c+' [UB]'+' '+tempDate.month()+' '+tempDate.year()));
                        options.add(new SelectOption(oppLI.Id, GPL.padIntegerWithZero(oppLI.ServiceDate.month())
                            +' '+GPL.padDoubleWithZero(Double.valueOf(oppLI.Total_Realization__c)) 
                            + '% '+ +GPL.padDoubleWithZero(Double.valueOf(dHoursLeft.setScale(2)))
                            + ' '+oppLI.PricebookEntry.Name
                            + ' ' +  description
                            ));
                    }
                }
            }else{
                options.add(new SelectOption('noOLI', 'No Task assigned'));
            } // END if(mapOpportuntiyLineItem.isEmpty() == false)

            
        }
        /*else if(selectedProjectType == 'SalesSupport'){
            if(mapOpportuntiyLineItemPreSales.isEmpty() == false){
                options.add(new SelectOption('toselect', ' Please select'));
                for(OpportunityLineItem oppLI : mapOpportuntiyLineItemPreSales.values()){
                    if(String.valueOf(oppLI.OpportunityId) == selectedOpp){
                        //options.add(new SelectOption(oppLI.Id, oppLI.PricebookEntry.Name + ' ' + oppLI.ServiceDate.format()));
                        Decimal dHoursLeft = proofHoursLeft(oppLI);
                        
                        //options.add(new SelectOption(oppLI.Id, tempDate.month()+' '+oppLI.PricebookEntry.Name + ' ' + oppLI.Quantity +'[E]'+ ' '+oppLI.Total_booked_days__c+' / '+oppLI.Total_Realization__c+' % [B]'+ ' '+oppLI.Total_Booked_Unbillable__c+' [UB]'+' '+tempDate.month()+' '+tempDate.year()));
                        options.add(new SelectOption(oppLI.Id, GPL.padIntegerWithZero(oppLI.ServiceDate.month())+' '+GPL.padDoubleWithZero(Double.valueOf(oppLI.Total_Realization__c)) + '% '+ +GPL.padDoubleWithZero(Double.valueOf(dHoursLeft.setScale(2)))+ ' '+oppLI.PricebookEntry.Name));
                    }
                }
            }else{
                options.add(new SelectOption('noOLI', 'No Task assigned'));
            } // END if(mapOpportuntiyLineItem.isEmpty() == false)

            
        }*/
        else if(selectedProjectType == '4User'){
            if(mapOpportuntiyLineItem4User.isEmpty() == false){
                options.add(new SelectOption('toselect', ' Please select'));
                for(OpportunityLineItem oppLI : mapOpportuntiyLineItem4User.values()){
                    if(String.valueOf(oppLI.OpportunityId) == selectedOpp){
                        //options.add(new SelectOption(oppLI.Id, oppLI.PricebookEntry.Name + ' ' + oppLI.ServiceDate.format()));
                       Decimal dHoursLeft = proofHoursLeft(oppLI);
                        String description = String.isEmpty(oppLI.Description)? '' : trimDescription(oppLI.Description);
                        //options.add(new SelectOption(oppLI.Id, tempDate.month()+' '+oppLI.PricebookEntry.Name + ' ' + oppLI.Quantity +'[E]'+ ' '+oppLI.Total_booked_days__c+' / '+oppLI.Total_Realization__c+' % [B]'+ ' '+oppLI.Total_Booked_Unbillable__c+' [UB]'+' '+tempDate.month()+' '+tempDate.year()));
                        options.add(new SelectOption(oppLI.Id, GPL.padIntegerWithZero(oppLI.ServiceDate.month())
                            +' '+GPL.padDoubleWithZero(Double.valueOf(oppLI.Total_Realization__c.setScale(2))) 
                            + '% '+ +GPL.padDoubleWithZero(Double.valueOf(dHoursLeft.setScale(2)))
                            + ' '+oppLI.PricebookEntry.Name
                            + ' ' +  description
                            ));
                    }
                }
            }else{
                options.add(new SelectOption('noOLI', 'No Task assigned'));
            } // END if(mapOpportuntiyLineItem.isEmpty() == false)

        }// END if(selectedProjectType == 'internal')
        
        
        
        
        
        
        //options.sort();
        SelectOptionSorter.doSort(options, SelectOptionSorter.FieldToSort.Label);
        return options;
    }// END public List<SelectOption> getOpportunityLineItemList()
    
    public void refresh(){
        selectOppsAndLineItems4User();
    }
    
    private static String trimDescription(String description){
        
        description.replace('(', '');
        description.replace(')', '');
        description.replace('...', '');
        if(description.length() > 50){
            return '(' + description.substring(0, 49) + '...)';
        }else{
            return '(' + description + ')' ;  
        }
    }
    
    // Select the timeentries where date < = 3 Days ago
    public void fillTimeEntryList(){
        oldTimeEntries = new List<TimeEntry__c>();
        try{
            Date dateNotOlderThreeDays = System.Today().toStartOfMonth();
            
            oldTimeEntries = [SELECT Id,Name,Contact__c, Contact__r.Name, Contact__r.LastName, Description__c, Date__c,Opportunity__r.Name, Opportunity_Product_Name__c , IsDeleted, Billable__c, Time__c FROM TimeEntry__c WHERE Contact__c =: selectedContact AND Date__c >=: dateNotOlderThreeDays ORDER BY Date__c ASC];
        }catch(System.DmlException ex){objTimeEntry.addError('Sorry there are no Timeentries for you');ApexPages.addMessages(ex);}
        //sort by Date
                
        // fill the resultlist
        if(oldTimeEntries.size()>0){
            Info objInfo = new Info();
            resultList = new List<Info>();
            for(Integer i=oldTimeEntries.size()-1;i>=0 ;i--){
                objInfo = new Info();
                objInfo.setInfo(oldTimeEntries[i]);
                resultList.add(objInfo);
            }//end for(Integer i=0;i< oldTimeEntries.size();i++)
        }//end if(oldTimeEntries.size()>0)
    }// end public void fillTimeEntryList()
    
    /**** CONSTRUCTOR  ******************************************************************/
    public TimeEntry4FreelancerExtension(ApexPages.StandardController thedeliveredcontroller){
        PageReference pageRef = new PageReference('www.google.com');
        pageRef = ApexPages.currentPage();
        mapParameters = new Map<String, String>();
        mapParameters = pageRef.getParameters();
    
    //check for null/default string
        resultList = new List<Info>();
        strCurrentContactId = mapParameters.get('fid');
        objTimeEntry = (TimeEntry__c)thedeliveredcontroller.getRecord();
        billableFlag = true;
        ctrl = thedeliveredcontroller;
        User currentuser = [SELECT Id, Contact_ID__c,ProfileId FROM User WHERE Id =: System.UserInfo.getUserId()];
        if(strCurrentContactId!=null){
        try{
            currentcontact = [SELECT Id, Name, FirstName, LastName FROM Contact WHERE Id =: strCurrentContactId LIMIT 1];
            dummyContact = [SELECT Id,Name,Firstname,LastName FROM Contact WHERE Lastname = 'All' LIMIT 1];
            //objTimeEntry.Contact__c = currentcontact.Id;
            System.debug('@@@ DEBUG currentContact:'+currentcontact.Name);
        
        selectedContact = currentContact.Id;
        selectContacts();
        selectOppsAndLineItems4User();
        //selectOppsAndLineItemsPreSales();
        selectOppsAndLineItemsInternal();
        fillTimeEntryList();
        }catch(System.DmlException ex){objTimeEntry.addError('Sorry, for you is no contact created');ApexPages.addMessages(ex);}
        }
    }// END public TimeEntry4UserExtension(ApexPages.StandardController thedeliveredcontroller)
    
    public Decimal proofHoursLeft(OpportunityLineItem oppLI){
            Date tempDate = oppLI.ServiceDate;
            
            
            //System.debug('DEBUG BOOKED HOURS '+tempBookedHours);
            
            Decimal dHoursLeft = oppLI.Quantity_in_Hours__c - (oppLI.Total_Booked_Hours_billable__c == null?00.00:oppLI.Total_Booked_Hours_billable__c);
            
             
            if(dHoursLeft < 0){
                dHoursLeft = 0.00;
            }
            return dHoursLeft;
    }
    

    
    
    public PageReference save(){
        //objTimeEntry = (TimeEntry__c) Apexpages.Standardcontroller.getRecord();
        //objTimeEntry = (TimeEntry__c) ctrl.getRecord();
        try{
            TimeEntry__c te_pageValues = (TimeEntry__c)ctrl.getRecord();
        
            System.debug('@@@@ DEBUG BillableFlagSaveAndNew '+billableFlag);
        
            datetime myDate = datetime.now();
            System.debug('@@@@@ DEBUG: '+String.valueOf(selectedOpp).length());                 
            objTimeEntry.Name = myDate.format('yyMMdd-HHmmss');
            TimeEntry__c newTime = new TimeEntry__c (
                Name = objTimeEntry.Name,
                Opportunity__c = selectedOpp,
                //Contact__c = objTimeEntry.Contact__c,
                Contact__c = selectedContact,
                Time__c =  objTimeEntry.Time__c,
                Date__c = objTimeEntry.Date__c,
                //Billable__c = objTimeEntry.Billable__c,            
                Billable__c = billableFlag,
                Description__c = objTimeEntry.Description__c
            );
        
            //insert newTime;
        
//          newTime.Opportunity__c = selectedOpp;
            OpportunityLineItem oneOLI = new OpportunityLineItem();
            if(selectedProjectType == 'internal'){
                oneOLI = mapOpportuntiyLineItemInternal.get(selectedTask);
            }
            /*else if(selectedProjectType == 'SalesSupport'){
                oneOLI = mapOpportuntiyLineItemPreSales.get(selectedTask);
            }*/
            else if(selectedProjectType == '4User'){
                oneOLI = mapOpportuntiyLineItem4User.get(selectedTask);
            }// END if(selectedProjectType == 'internal')
            
            
            newTime.Opportunity_Product_Name__c = oneOLI.PricebookEntry.Name;
            
            PageReference prOLI = new ApexPages.StandardController(oneOLI).view();
            newTime.Opportunity_Product_ID__c = (Id)selectedTask;
            newTime.Daily_Rate__c = oneOLI.UnitPrice;
            
            String sUrlRewrite = System.URL.getSalesforceBaseUrl().getHost();
            // c.cs7.visual.force.com
            sUrlRewrite = 'https://'
                            + sUrlRewrite.substring(2,6) 
                            + 'salesforce.com'
                            + '/'
                            + selectedTask;
            newTime.Opportunity_Product__c  = sUrlRewrite;
            
            //Date bookingDate = oneOLI.ServiceDate;
            
            
            if(newTime.Opportunity__c == null || newTime.Opportunity_Product_ID__c == null){
                newTime.addError('Please select Project and Task!');
            }else if(oneOLI.ServiceDate.month() != Date.today().month() && selectedProjectType == '4User'){
                newTime.addError('Please select a task assigned to the current month.');
            }else{  
                insert newTime;
                //PageReference timeentryPage = new ApexPages.StandardController(objTimeEntry).view();
                //timeentryPage.setRedirect(true);
                //return timeentryPage;
                objTimeEntry = new TimeEntry__c ();
                fillTimeEntryList();
                selectOppsAndLineItems4User();
                //selectOppsAndLineItemsPreSales();
                selectOppsAndLineItemsInternal();
                PageReference timeEntryPage = new ApexPages.Pagereference('http://beyondfuturetrends.force.com/TimeEntryForFreelancer?fid='+ strCurrentContactId );
                //timeEntryPage.setRedirect(true);
                return timeEntryPage;
                                
            }
            
        }catch(System.StringException exString){
            objTimeEntry.addError('Please select a project and task assigned to you.');
        }catch(System.DmlException exDML){
            objTimeEntry.addError(exDML);ApexPages.addMessages(exDML);
        }// END try

        return null;
    }// PageReference save_and_new()
    
     public PageReference myCancel(){
                PageReference timeEntryPage = new ApexPages.Pagereference('http://beyondfuturetrends.force.com/TimeEntryForFreelancer?fid='+ strCurrentContactId );
                timeEntryPage.setRedirect(true);
                return timeEntryPage;
     }
}