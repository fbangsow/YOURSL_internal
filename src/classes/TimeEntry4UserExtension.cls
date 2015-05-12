// /* **************************************************************
// Creater: Alexander Faust, Alexander Erdikler
// Description: This class is the Controller for the Visualforce Page OrderLetterSet.
//              Every week all PSO Member has to create their own Employee Utilization Obj and list their planed billable hours
//              for the next week. This Obj has also the timeentries for that week, so we can compare the planed Vs. billed Hours.
//              All Employee Utilization Obj and timeEntries from all Contacts with checkbox PSO Member checked are selected and listed
//              in the page.
// Page:
// Testclass: TimeEntryUserTest
// Triggers: TimeEntryTrigger
// Apex Class Access: no limitations/Profilenames
// Last modified by: Chris Sandra Schautt
// Last modified date: 03.09.2013
// Latests changes: Fill Contactoption for Freelancers
// ************************************************************** */



public without sharing class TimeEntry4UserExtension {

    private Pagereference thepage;
    private Contact currentcontact = new Contact();
    private Contact dummyContact = new Contact();
    public ApexPages.Standardcontroller ctrl;

    // this is the record used during entry
    public TimeEntry__c objTimeEntry {get; set;}
    public List<Date> objTimeEntryWeekEndStart {get; set;}
    Opportunity oppIntern {get; set;}

    //return values from selectOptions
    public String selectedOpp {get; set;}
    public String selectedTask {get; set;}
    public String selectedProjectType {get; set;}
    public String selectedContact {get; set;}
    public Boolean billableFlag {get; set;}

    private List<SelectOption> optionListSelectedUserNames;

    //#############################################################################################
    public String productDescription {get; set;}
    //#############################################################################################

    // this values will select the right view for single users
    // or Managers
    public Boolean bUserView {get; set;}
    public Id idCurrentUser {get; set;}
    private Map<Id, Opportunity> mapOpportuntiy4User;
    private Map<Id, OpportunityLineItem> mapOpportuntiyLineItem4User;

    /* new requirement:
        Task assigned, Sales Support and Internal are preselections for
        selected List of Opportunities
        the preselection will be done on page load in the
        selectOppsAndLineItems() with two more pairs of Opportuntiy Maps
    */
    private Map<Id, Opportunity> mapOpportuntiyPreSales;
    private Map<Id, OpportunityLineItem> mapOpportuntiyLineItemPreSales;
    private Map<Id, Opportunity> mapOpportuntiyInternal;
    private Map<Id, OpportunityLineItem> mapOpportuntiyLineItemInternal;
    private Map<Id, Contact> mapContacts;


    //fill dropdown list with contact
    public List<SelectOption> getSelectedContactList() {
        List<SelectOption> options = new List<SelectOption>();

        if (mapContacts.isEmpty() == false) {
            //options.add(new SelectOption('current', ' '+System.UserInfo.getName()));
            for (Contact c : mapContacts.values()) {
                options.add(new SelectOption(c.Id, c.Name));
            }
        } else {
            options.add(new SelectOption('nocontact', 'No contact found!'));
        }
        SelectOptionSorter.doSort(options, SelectOptionSorter.FieldToSort.Label);

        return options;

    }


    //fill global variable Map with contacts
    public void selectContacts() {
        Profile currentUserAdminProfile = [SELECT Id, Name FROM Profile WHERE Id = : System.UserInfo.getProfileId()];
        Profile freelancerProfile = [SELECT Id, Name FROM Profile WHERE Name LIKE:('%Freelancer%') LIMIT 1];

        System.debug('@@@@@ PROFILE: ' + currentUserAdminProfile.Name);
        if (currentUserAdminProfile.Name.contains('administrator') ||  currentUserAdminProfile.Name.contains('Administrator')) {
            //fill mapw with all contacts
            Map<Id, User> mapContactIdsFromUser = new Map<Id, User>(
                [SELECT Contact_ID__c FROM User WHERE IsActive = true AND Contact_ID__c != '' ]
            );

            String sAccountId = [SELECT Id FROM Account WHERE Name = 'YOUR SL GmbH' LIMIT 1].Id;
            List<String> contactIds = new List<String>();
            for (User u : mapContactIdsFromUser.values()) {
                contactIds.add(u.Contact_ID__c);
            }


            mapContacts = new Map<Id, Contact>([
                                                   SELECT Id, Name, FirstName, LastName
                                                   FROM Contact WHERE
                                                   Id IN: contactIds
                                                   OR
                                                   AccountId = : sAccountId
                                               ]);



        } else if (currentUserAdminProfile.Id == freelancerProfile.Id) {
            mapContacts = new Map<Id, Contact>([SELECT Id, Name, FirstName, LastName FROM Contact WHERE Is_Freelancer__c = : true]);
        } else {
            //fill map with contact from currentuser
            User currentUser = [SELECT Id, Contact_ID__c FROM User WHERE Id = : System.UserInfo.getUserId()];
            mapContacts = new Map<Id, Contact>([
                                                   SELECT Id, Name, FirstName, LastName
                                                   FROM Contact WHERE
                                                   Id = : currentUser.Contact_ID__c
                                               ]);

        }//END if (currentUserAdminProfile.Name.contains('Adminstrator'))


    }
    // fill global variable Maps with Opps and OLIs
    public void selectOppsAndLineItemsInternal() {

        Date dateNotOlderThanLastMonth = System.today().addDays(-10);
        dateNotOlderThanLastMonth = dateNotOlderThanLastMonth.addMonths(-1);

        Date dateNotMoreThanSixMonthInFuture = System.today();
        dateNotMoreThanSixMonthInFuture = dateNotMoreThanSixMonthInFuture.addMonths(6);


        try {
            mapOpportuntiyLineItemInternal = new Map<Id, OpportunityLineItem>([
                        SELECT Id, OpportunityId, Contact__c, PricebookEntry.Name,
                        PricebookEntry.Product2Id,
                        ServiceDate, CreatedDate, Unit__c,
                        Quantity, Total_booked_days__c,
                        Total_Booked_Unbillable__c,
                        Total_Realization__c,
                        Total_Booked_Hours_billable__c,
                        UnitPrice,
                        Quantity_in_Hours__c,
                        Description
                        FROM OpportunityLineItem
                        WHERE Leistung_erbracht__c = : false
                        AND Unit__c = : 'Manntag(e)'
                        AND Opportunity.IsWon = true
                                                      AND Contact__c = : dummyContact.Id
                                                              AND Opportunity.Account.Name = 'YOUR SL GmbH'
                                                                      AND ServiceDate > : dateNotOlderThanLastMonth
                                                                      AND ServiceDate < : dateNotMoreThanSixMonthInFuture
                                                                      ORDER BY ServiceDate]);

        } catch (DmlException ex) {
            objTimeEntry.addError('Sorry, no Task assigned to you');
            ApexPages.addMessages(ex);
        }


        List<OpportunityLineItem> listOppLIs = new List<OpportunityLineItem>();

        listOppLIs = mapOpportuntiyLineItemInternal.values();
        List<Id> listOppIds = new List<Id>();
        for (Integer i = 0; i < listOppLIs.size(); i++) {
            listOppIds.add(listOppLIs[i].OpportunityId);
        }
        System.debug('############ Opp Id List' + listOppIds.size().format() );
        mapOpportuntiyInternal = new Map<Id, Opportunity>([SELECT Id, Name, CloseDate, ForeCastCategoryName , Description
                FROM Opportunity
                WHERE Id IN: listOppIds ORDER BY Name]);
    }// END public selectOppsAndLineItemsInternal()

    // fill global variable Maps with Opps and OLIs
    public void selectOppsAndLineItemsPreSales() {

        Date dateNotOlderThanLastMonth = System.today().addDays(-10);
        dateNotOlderThanLastMonth = dateNotOlderThanLastMonth.addMonths(-1);

        Date dateNotMoreThanSixMonthInFuture = System.today();
        dateNotMoreThanSixMonthInFuture = dateNotMoreThanSixMonthInFuture.addMonths(6);


        try {
            mapOpportuntiyLineItemPreSales = new Map<Id, OpportunityLineItem>([
                        SELECT Id, OpportunityId, Contact__c, PricebookEntry.Name,
                        PricebookEntry.Product2Id,
                        ServiceDate, CreatedDate, Unit__c,
                        Quantity, Total_booked_days__c,
                        Total_Booked_Unbillable__c,
                        Total_Realization__c,
                        Total_Booked_Hours_billable__c,
                        UnitPrice,
                        Quantity_in_Hours__c,
                        Description
                        FROM OpportunityLineItem
                        WHERE Leistung_erbracht__c = : false
                                AND Unit__c = : 'Manntag(e)'
                                              AND Opportunity.ForecastCategory != 'Omitted'
                                              AND Contact__c = : dummyContact.Id
                                                      AND Opportunity.Account.Name != 'YOUR SL GmbH'
                                                      AND ServiceDate > : dateNotOlderThanLastMonth
                                                      AND ServiceDate < : dateNotMoreThanSixMonthInFuture
                                                      ORDER BY ServiceDate]);

        } catch (DmlException ex) {
            objTimeEntry.addError('Sorry, no Task assigned to you');
            ApexPages.addMessages(ex);
        }


        List<OpportunityLineItem> listOppLIs = new List<OpportunityLineItem>();

        listOppLIs = mapOpportuntiyLineItemPreSales.values();
        List<Id> listOppIds = new List<Id>();
        for (Integer i = 0; i < listOppLIs.size(); i++) {
            listOppIds.add(listOppLIs[i].OpportunityId);
        }
        System.debug('############ Opp Id List' + listOppIds.size().format() );
        mapOpportuntiyPreSales = new Map<Id, Opportunity>([SELECT Id, Name, CloseDate, ForeCastCategoryName , Description
                FROM Opportunity
                WHERE Id IN: listOppIds
                ORDER BY Name]);
    }// END public selectOppsAndLineItemsPreSales()


    // fill global variable Maps with Opps and OLIs
    public void selectOppsAndLineItems4User() {

        Date dateNotOlderThanLastMonth = System.today().addDays(-10);
        dateNotOlderThanLastMonth = dateNotOlderThanLastMonth.addMonths(-1);

        Date dateNotMoreThanSixMonthInFuture = System.today();
        dateNotMoreThanSixMonthInFuture = dateNotMoreThanSixMonthInFuture.addMonths(6);

        System.debug('@@@@@@@@ DEBUG SELECTEDCONTACT: ' + selectedContact);
        try {
            mapOpportuntiyLineItem4User = new Map<Id, OpportunityLineItem>([
                        SELECT Id, OpportunityId, Contact__c, PricebookEntry.Name,
                        PricebookEntry.Product2Id,
                        ServiceDate, CreatedDate, Unit__c,
                        Quantity, Total_booked_days__c,
                        Total_Booked_Unbillable__c,
                        Total_Realization__c,
                        Total_Booked_Hours_billable__c,
                        UnitPrice,
                        Quantity_in_Hours__c,
                        Description
                        FROM OpportunityLineItem
                        WHERE Leistung_erbracht__c = : false
                        AND Unit__c = : 'Manntag(e)'
                        AND Opportunity.IsWon = true
                                                      //AND Contact__c =: currentcontact.Id
                        AND Contact__c = : selectedContact
                        AND ServiceDate > : dateNotOlderThanLastMonth
                        AND ServiceDate < : dateNotMoreThanSixMonthInFuture
                        ORDER BY ServiceDate]);


            //System.debug('### Datevariable not older  '+dateNotOlderThanLastMonth);
            //System.debug('### Datevariable future  '+dateNotMoreThanSixMonthInFuture);

        } catch (DmlException ex) {
            objTimeEntry.addError('Sorry, no Task assigned to you');
            ApexPages.addMessages(ex);
        }


        List<OpportunityLineItem> listOppLIs = new List<OpportunityLineItem>();

        listOppLIs = mapOpportuntiyLineItem4User.values();
        List<Id> listOppIds = new List<Id>();
        for (Integer i = 0; i < listOppLIs.size(); i++) {
            listOppIds.add(listOppLIs[i].OpportunityId);
        }
        System.debug('############ Opp Id List' + listOppIds.size().format() );
        mapOpportuntiy4User = new Map<Id, Opportunity>([SELECT Id, Name, CloseDate, ForeCastCategoryName, Description
                FROM Opportunity
                WHERE Id IN: listOppIds
                ORDER BY Name]);
    }// END public selectOppsAndLineItems()


    // this is used for a preselection of all Opportunities
    public List<SelectOption> getProjectTypeList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('toSelect', 'Please select...'));
        options.add(new SelectOption('4User', 'Tasks assigned to me'));
        options.add(new SelectOption('SalesSupport', 'Sales Support'));
        options.add(new SelectOption('internal', 'Internal'));
        return options;
    }// END public List<SelectOption> getselectedProjectType()


    public List<SelectOption> getOpportunityList() {
        //selectOppsAndLineItems();
        List<SelectOption> options = new List<SelectOption>();

        if (selectedProjectType == 'internal') {
            if (mapOpportuntiyLineItemInternal.isEmpty() == false) {
                options.add(new SelectOption('toselect', ' Please select'));
                for (Opportunity opp : mapOpportuntiyInternal.values()) {
                    if (String.isEmpty(opp.Description)) {
                        opp.Description = '';
                    }
                    options.add(new SelectOption(opp.Id, opp.Name + ' (' + opp.ForeCastCategoryName + ')' ));
                }
            } else {
                options.add(new SelectOption('noopp', 'No Opportunity assigned'));
            }// END if(mapOpportuntiyLineItem.isEmpty() == false)


        } else if (selectedProjectType == 'SalesSupport') {
            if (mapOpportuntiyLineItemPreSales.isEmpty() == false) {
                options.add(new SelectOption('toselect', ' Please select'));
                for (Opportunity opp : mapOpportuntiyPreSales.values()) {
                    if (String.isEmpty(opp.Description)) {
                        opp.Description = '';
                    }
                    options.add(new SelectOption(opp.Id, opp.Name + ' (' + opp.ForeCastCategoryName + ')' ));
                }
            } else {
                options.add(new SelectOption('noopp', 'No Opportunity assigned'));
            }// END if(mapOpportuntiyLineItem.isEmpty() == false)


        } else if (selectedProjectType == '4User') {
            if (mapOpportuntiyLineItem4User.isEmpty() == false) {
                options.add(new SelectOption('toselect', ' Please select'));
                for (Opportunity opp : mapOpportuntiy4User.values()) {
                    if (String.isEmpty(opp.Description)) {
                        opp.Description = '';
                    }
                    if(!opp.Name.contains('Urlaub')){
                        options.add(new SelectOption(opp.Id, opp.Name + ' (' + opp.ForeCastCategoryName + ')' ));
                    }
                    
                }
            } else {
                options.add(new SelectOption('noopp', 'No Opportunity assigned'));
            }// END if(mapOpportuntiyLineItem.isEmpty() == false)
        }// END if(selectedProjectType == 'internal')

        //options.sort();
        SelectOptionSorter.doSort(options, SelectOptionSorter.FieldToSort.Label);
        return options;
    }

    public List<SelectOption> getOpportunityLineItemList() {
        List<SelectOption> options = new List<SelectOption>();

        if (selectedProjectType == 'internal') {
            if (mapOpportuntiyLineItemInternal.isEmpty() == false) {
                options.add(new SelectOption('toselect', ' Please select'));
                for (OpportunityLineItem oppLI : mapOpportuntiyLineItemInternal.values()) {
                    if (String.valueOf(oppLI.OpportunityId) == selectedOpp) {
                        //options.add(new SelectOption(oppLI.Id, oppLI.PricebookEntry.Name + ' ' + oppLI.ServiceDate.format()));
                        Decimal dHoursLeft = proofHoursLeft(oppLI);
                        String description = String.isEmpty(oppLI.Description)? '' : trimDescription(oppLI.Description);
                        //options.add(new SelectOption(oppLI.Id, tempDate.month()+' '+oppLI.PricebookEntry.Name + ' ' + oppLI.Quantity +'[E]'+ ' '+oppLI.Total_booked_days__c+' / '+oppLI.Total_Realization__c+' % [B]'+ ' '+oppLI.Total_Booked_Unbillable__c+' [UB]'+' '+tempDate.month()+' '+tempDate.year()));
                        options.add(new SelectOption(oppLI.Id, GPL.padIntegerWithZero(oppLI.ServiceDate.month()) 
                            + ' ' + GPL.padDoubleWithZero(Double.valueOf(oppLI.Total_Realization__c)) 
                            + '% ' + +GPL.padDoubleWithZero(Double.valueOf(dHoursLeft.setScale(2))) 
                            + ' ' + oppLI.PricebookEntry.Name
                            + ' ' +  description
                            ));
                    }
                }
            } else {
                options.add(new SelectOption('noOLI', 'No Task assigned'));
            } // END if(mapOpportuntiyLineItem.isEmpty() == false)


        } else if (selectedProjectType == 'SalesSupport') {
            if (mapOpportuntiyLineItemPreSales.isEmpty() == false) {
                options.add(new SelectOption('toselect', ' Please select'));
                for (OpportunityLineItem oppLI : mapOpportuntiyLineItemPreSales.values()) {
                    if (String.valueOf(oppLI.OpportunityId) == selectedOpp) {
                        //options.add(new SelectOption(oppLI.Id, oppLI.PricebookEntry.Name + ' ' + oppLI.ServiceDate.format()));
                        Decimal dHoursLeft = proofHoursLeft(oppLI);
                        String description = String.isEmpty(oppLI.Description)? '' : trimDescription(oppLI.Description);
                        //options.add(new SelectOption(oppLI.Id, tempDate.month()+' '+oppLI.PricebookEntry.Name + ' ' + oppLI.Quantity +'[E]'+ ' '+oppLI.Total_booked_days__c+' / '+oppLI.Total_Realization__c+' % [B]'+ ' '+oppLI.Total_Booked_Unbillable__c+' [UB]'+' '+tempDate.month()+' '+tempDate.year()));
                        options.add(new SelectOption(oppLI.Id, GPL.padIntegerWithZero(oppLI.ServiceDate.month()) 
                            + ' ' + GPL.padDoubleWithZero(Double.valueOf(oppLI.Total_Realization__c)) 
                            + '% ' + +GPL.padDoubleWithZero(Double.valueOf(dHoursLeft.setScale(2))) 
                            + ' ' + oppLI.PricebookEntry.Name
                            + ' ' +  description
                            ));
                    }
                }
            } else {
                options.add(new SelectOption('noOLI', 'No Task assigned'));
            } // END if(mapOpportuntiyLineItem.isEmpty() == false)


        } else if (selectedProjectType == '4User') {
            if (mapOpportuntiyLineItem4User.isEmpty() == false) {
                options.add(new SelectOption('toselect', ' Please select'));
                for (OpportunityLineItem oppLI : mapOpportuntiyLineItem4User.values()) {
                    if (String.valueOf(oppLI.OpportunityId) == selectedOpp) {
                        //options.add(new SelectOption(oppLI.Id, oppLI.PricebookEntry.Name + ' ' + oppLI.ServiceDate.format()));
                        Decimal dHoursLeft = proofHoursLeft(oppLI);

                        //options.add(new SelectOption(oppLI.Id, tempDate.month()+' '+oppLI.PricebookEntry.Name + ' ' + oppLI.Quantity +'[E]'+ ' '+oppLI.Total_booked_days__c+' / '+oppLI.Total_Realization__c+' % [B]'+ ' '+oppLI.Total_Booked_Unbillable__c+' [UB]'+' '+tempDate.month()+' '+tempDate.year()));
                        
                        String description = String.isEmpty(oppLI.Description)? '' : trimDescription(oppLI.Description);

                        options.add(new SelectOption(oppLI.Id, GPL.padIntegerWithZero(oppLI.ServiceDate.month()) 
                            + ' ' + GPL.padDoubleWithZero(Double.valueOf(oppLI.Total_Realization__c.setScale(2))) 
                            + '% ' + +GPL.padDoubleWithZero(Double.valueOf(dHoursLeft.setScale(2))) 
                            + ' ' + oppLI.PricebookEntry.Name
                            + ' ' +  description
                            ));
                    }
                }
            } else {
                options.add(new SelectOption('noOLI', 'No Task assigned'));
            } // END if(mapOpportuntiyLineItem.isEmpty() == false)

        }// END if(selectedProjectType == 'internal')






        //options.sort();
        SelectOptionSorter.doSort(options, SelectOptionSorter.FieldToSort.Label);
        return options;
    }// END public List<SelectOption> getOpportunityLineItemList()

    public void refresh() {
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

    /**** CONSTRUCTOR  ******************************************************************/
    public TimeEntry4UserExtension(ApexPages.StandardController thedeliveredcontroller) {
        objTimeEntry = (TimeEntry__c)thedeliveredcontroller.getRecord();
        billableFlag = true;
        ctrl = thedeliveredcontroller;
        User currentuser = [SELECT Id, Contact_ID__c, ProfileId FROM User WHERE Id = : System.UserInfo.getUserId()];

        try {
            currentcontact = [SELECT Id, Name, FirstName, LastName FROM Contact WHERE Id = : currentuser.Contact_ID__c LIMIT 1];
            dummyContact = [SELECT Id, Name, Firstname, LastName FROM Contact WHERE Lastname = 'All' LIMIT 1];
            //objTimeEntry.Contact__c = currentcontact.Id;
            System.debug('@@@ DEBUG currentContact:' + currentcontact.Name);
        } catch (System.DmlException ex) {
            objTimeEntry.addError('Sorry, for you is no contact created');
            ApexPages.addMessages(ex);
        }
        selectedContact = currentContact.Id;
        selectContacts();
        selectOppsAndLineItems4User();
        selectOppsAndLineItemsPreSales();
        selectOppsAndLineItemsInternal();

    }// END public TimeEntry4UserExtension(ApexPages.StandardController thedeliveredcontroller)

    public Decimal proofHoursLeft(OpportunityLineItem oppLI) {
        Date tempDate = oppLI.ServiceDate;


        //System.debug('DEBUG BOOKED HOURS '+tempBookedHours);

        Decimal dHoursLeft = oppLI.Quantity_in_Hours__c - (oppLI.Total_Booked_Hours_billable__c == null ? 00.00 : oppLI.Total_Booked_Hours_billable__c);


        if (dHoursLeft < 0) {
            dHoursLeft = 0.00;
        }
        return dHoursLeft;
    }

    public PageReference save() {

        try {
            datetime myDate = datetime.now();
            //System.debug('@@@@@ DEBUG: '+String.valueOf(selectedOpp).length());
            objTimeEntry.Name = myDate.format('yyMMdd-HHmmss');
            Contact tempContact = [SELECT Id, FirstName, LastName FROM Contact WHERE Id = : selectedContact];
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



            //newTime.Opportunity__c = selectedOpp;

            OpportunityLineItem oneOLI = new OpportunityLineItem();
            if (selectedProjectType == 'internal') {
                oneOLI = mapOpportuntiyLineItemInternal.get(selectedTask);
            } else if (selectedProjectType == 'SalesSupport') {
                oneOLI = mapOpportuntiyLineItemPreSales.get(selectedTask);
            } else if (selectedProjectType == '4User') {
                oneOLI = mapOpportuntiyLineItem4User.get(selectedTask);
            }// END if(selectedProjectType == 'internal')

            //####################################################################################################
            productDescription = String.valueOf([SELECT Leistungsbeschreibung_del__c FROM OpportunityLineItem WHERE Id = : oneOLI.Id LIMIT 1]);
            //####################################################################################################

            System.debug('@@@@@@@ DEBUG ONEOLI: ' + oneOLI.PricebookEntry.Name);
            newTime.Opportunity_Product_Name__c = oneOLI.PricebookEntry.Name;
            System.debug('@@@@@@@ DEBUG ONEOLI: ' + oneOLI.PricebookEntry.Name);
            PageReference prOLI = new ApexPages.StandardController(oneOLI).view();
            newTime.Opportunity_Product_ID__c = (Id)selectedTask;
            newTime.Daily_Rate__c = oneOLI.UnitPrice;

            String sUrlRewrite = System.URL.getSalesforceBaseUrl().getHost();
            // c.cs7.visual.force.com
            sUrlRewrite = 'https://'
                          + sUrlRewrite.substring(2, 6)
                          + 'salesforce.com'
                          + '/'
                          + selectedTask;
            newTime.Opportunity_Product__c  = sUrlRewrite;

            //Date bookingDate = oneOLI.ServiceDate;  //### LAST MODIFICATION: not allowed to book in another month
            if (newTime.Opportunity__c == null || newTime.Opportunity_Product_ID__c == null) {
                newTime.addError('Please select Project and Task!');
            } else if (oneOLI.ServiceDate.month() != Date.today().month() && selectedProjectType == '4User') {
                newTime.addError('Please select a task assigned to the current month.');
            } else {

                insert newTime;

                //{!$User.FirstName}%20{!$User.LastName}

                Report timeSheetOverviewID = [SELECT Id FROM Report WHERE DeveloperName = 'Time_Sheet_Overview2'];
                String sReportURL = System.URL.getSalesforceBaseUrl().getHost();
                sReportURL = 'https://'
                             + sReportURL.substring(2, 6)
                             + 'salesforce.com'
                             + '/'
                             + timeSheetOverviewID;

                PageReference timeSheetReport = new ApexPages.Pagereference('https://eu1.salesforce.com/00OD0000005aOd9?pv0=' + tempContact.FirstName + '%20' + tempContact.LastName);
                timeSheetReport.setRedirect(true);
                return timeSheetReport;

                /*PageReference timeentryPage = new ApexPages.StandardController(newTime).view();
                timeentryPage.setRedirect(true);
                return timeentryPage;*/

            }

        } catch (System.StringException exString) {
            objTimeEntry.addError('Please select a project and task assigned to you.');
        } catch (System.DmlException exDML) {
            objTimeEntry.addError(exDML); ApexPages.addMessages(exDML);
        }// END try

        PageReference timeentryPage2 = ApexPages.currentPage();
        timeentryPage2.setRedirect(false);
        return null;

    }

    //##########################################################################################
    public void readPD() {
        productDescription = String.valueOf([SELECT Leistungsbeschreibung_del__c FROM OpportunityLineItem WHERE Id = : selectedTask LIMIT 1]);
        productDescription = 'testest';
    }
    //############################################################################################

    /* public PageReference saveAndNew(){
         datetime myDate = datetime.now();
         objTimeEntry = (TimeEntry__c)thedeliveredcontroller.getRecord();
         TimeEntry__c timeEntry = new TimeEntry__c(
             Name = myDate.format('yyMMdd-HHmmss'),
             Opportunity__c = selectedOpp,
             Contact__c = selectedContact,
             Time__c = objTimeEntry.Time__c,
             Date__c = objTimeEntry.Date__c,
             Billable__c = objTimeEntry
         );
     }*/


    public PageReference save_and_new() {
        //objTimeEntry = (TimeEntry__c) Apexpages.Standardcontroller.getRecord();
        //objTimeEntry = (TimeEntry__c) ctrl.getRecord();
        try {
            TimeEntry__c te_pageValues = (TimeEntry__c)ctrl.getRecord();

            System.debug('@@@@ DEBUG BillableFlagSaveAndNew ' + billableFlag);

            datetime myDate = datetime.now();
            System.debug('@@@@@ DEBUG: ' + String.valueOf(selectedOpp).length());
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
            if (selectedProjectType == 'internal') {
                oneOLI = mapOpportuntiyLineItemInternal.get(selectedTask);
            } else if (selectedProjectType == 'SalesSupport') {
                oneOLI = mapOpportuntiyLineItemPreSales.get(selectedTask);
            } else if (selectedProjectType == '4User') {
                oneOLI = mapOpportuntiyLineItem4User.get(selectedTask);
            }// END if(selectedProjectType == 'internal')


            newTime.Opportunity_Product_Name__c = oneOLI.PricebookEntry.Name;

            PageReference prOLI = new ApexPages.StandardController(oneOLI).view();
            newTime.Opportunity_Product_ID__c = (Id)selectedTask;
            newTime.Daily_Rate__c = oneOLI.UnitPrice;

            String sUrlRewrite = System.URL.getSalesforceBaseUrl().getHost();
            // c.cs7.visual.force.com
            sUrlRewrite = 'https://'
                          + sUrlRewrite.substring(2, 6)
                          + 'salesforce.com'
                          + '/'
                          + selectedTask;
            newTime.Opportunity_Product__c  = sUrlRewrite;

            //Date bookingDate = oneOLI.ServiceDate;


            if (newTime.Opportunity__c == null || newTime.Opportunity_Product_ID__c == null) {
                newTime.addError('Please select Project and Task!');
            } else if (oneOLI.ServiceDate.month() != Date.today().month() && selectedProjectType == '4User') {
                newTime.addError('Please select a task assigned to the current month.');
            } else {
                insert newTime;
                /*PageReference timeentryPage = new ApexPages.StandardController(objTimeEntry).view();
                timeentryPage.setRedirect(true);
                return timeentryPage;*/
                PageReference timeEntryPage = ApexPages.currentPage();
                timeEntryPage.setRedirect(true);
                return timeEntryPage;

            }

        } catch (System.StringException exString) {
            objTimeEntry.addError('Please select a project and task assigned to you.');
        } catch (System.DmlException exDML) {
            objTimeEntry.addError(exDML); ApexPages.addMessages(exDML);
        }// END try

        return null;
    }// PageReference save_and_new()

}