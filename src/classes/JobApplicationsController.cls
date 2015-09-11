public without sharing class JobApplicationsController {
    public Map<Id, Position__c> IdToOpenPositions {public get; private set;}
    public String SelectedPosition {public get; public set;}
    public Job_Application__c Application {public get; public set;}
    public Attachment Picture {public get; public set;}
    public Attachment CurriculumVitae {public get; public set;}
    public Attachment CoverLetter {public get; public set;}
    public Attachment OtherFile {public get; public set;}
    public Boolean BeforeInsert {public get; private set;}
    public Boolean ConfirmationCheckbox {public get; public set;}

    public JobApplicationsController() {
        initiateVariablesForApplying();
        IdToOpenPositions = new Map<Id, Position__c> ([SELECT Id, Functional_Area__c, Job_Title__c, Job_Description__c, Responsibilities__c, Skills_Required__c, Educational_Requirements__c
                            FROM Position__c WHERE Approval_Status__c = 'Approved' AND Status__c = 'Hiring']);
        if(String.isNotEmpty(ApexPages.currentPage().getParameters().get('SelectedPosition'))){
            SelectedPosition = ApexPages.currentPage().getParameters().get('SelectedPosition');

        } else
            SelectedPosition = null;
    }

    public List<SelectOption> getAvailablePositions(){
        List<SelectOption> open_positions = new List<SelectOption>();
        open_positions.add(new SelectOption('default', 'Please choose'));
        for(Position__c position: IdToOpenPositions.values()){
            open_positions.add(new SelectOption(position.Id, position.Functional_Area__c + ': ' + position.Job_Title__c));
        }
        return open_positions;
    }

    public Position__c getSelectedPositionObject(){
        return IdToOpenPositions.get(SelectedPosition);
    }

    public PageReference apply(){
        PageReference apply_page = Page.ApplyForJob;
        apply_page.getParameters().put('SelectedPosition', SelectedPosition);
        return apply_page;
    }

    private void initiateVariablesForApplying(){
        Application = new Job_Application__c();
        Picture = new Attachment();
        CurriculumVitae = new Attachment();
        CoverLetter = new Attachment();
        OtherFile = new Attachment();
        BeforeInsert = true;
        ConfirmationCheckbox = false;
    }

    public PageReference submit(){
        if(inputsAreValid()){
            insertApplication();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,getEnglishConfirmationText()));
            BeforeInsert = false;
            return ApexPages.currentPage();
        }
        else{
            cleanViewStateFromFiles();
            return ApexPages.currentPage();
        }
    }

    private Boolean inputsAreValid(){
        Boolean is_valid = true;
        is_valid &= isPositionSelected();
        //is_valid &= isPictureAttached();
        is_valid &= isPictureSmallEnough();
        is_valid &= isCVAttached();
        is_valid &= isCVSmallEnough();
        is_valid &= isCoverLetterSmallEnough();
        is_valid &= isOtherFileSmallEnough();
        is_valid &= isConfirmationCheckboxTicked();
        return is_valid;
    }

    private Boolean isPositionSelected(){
        if(!(SelectedPosition != null && SelectedPosition != 'default' && IdToOpenPositions.containsKey(SelectedPosition))){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select position'));
            return false;
        }
        return true;
    }

    private Boolean isPictureAttached(){
        if(!(Picture != null && Picture.BodyLength > 0)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please upload your picture'));
            return false;
        }
        return true;
    }

    private Boolean isPictureSmallEnough(){
        if(Picture != null && Picture.BodyLength > 500000){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Size of your picture should be less than 45Kb'));
            Picture.Body = null;
            return false;
        }
        return true;
    }

    private Boolean isCVAttached(){
        if(!(CurriculumVitae != null && CurriculumVitae.BodyLength > 0 && CurriculumVitae.Body != null)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please upload your CV'));
            return false;
        }
        return true;
    }

    private Boolean isCVSmallEnough(){
        if(CurriculumVitae.BodyLength > 5000000){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Size of your CV document should be less than 5Mb'));
            return false;
        }
        return true;
    }

    private Boolean isCoverLetterSmallEnough(){
        if(CoverLetter != null && CoverLetter.BodyLength > 5000000){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Size of your Cover Letter document should be less than 5Mb'));
            return false;
        }
        return true;
    }

    private Boolean isOtherFileSmallEnough(){
        if(OtherFile != null && OtherFile.BodyLength > 5000000){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Size of your Other File document should be less than 5Mb'));
            return false;
        }
        return true;
    }

    private Boolean isConfirmationCheckboxTicked(){
        if(ConfirmationCheckbox == false){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You have to tick the confirmation checkbox'));
            return false;
        }
        return true;
    }

    private void cleanViewStateFromFiles(){
        if(Picture != null)
            Picture.Body = null;
        if(CurriculumVitae != null)
            CurriculumVitae.Body = null;
        if(CoverLetter != null)
            CoverLetter.Body = null;
        if(OtherFile != null)
            OtherFile.Body = null;
    }

    @TestVisible private void insertApplication(){
        Application.Position__c = SelectedPosition;
        Application.Picklist__c = '05 New';
        insert Application;
        insertPicture();
        insertCV();
        insertCoverLetterIfExists();
        insertOtherFileIfExists();
    }

    private void insertPicture(){
        if(Picture.BodyLength >0){
            Picture.ParentId = Application.Id;
            insert Picture;
            Picture.Body = null;
            Application.Picture__c = '<img src="/servlet/servlet.FileDownload?file=' + Picture.Id + '"></img>';
            update Application;
        }
    }

    private void insertCV(){
        if(CurriculumVitae.BodyLength > 0){
            CurriculumVitae.ParentId = Application.Id;
            insert CurriculumVitae;
            CurriculumVitae.Body = null;
        }
    }

    private void insertCoverLetterIfExists(){
        if(CoverLetter.BodyLength > 0){
            CoverLetter.ParentId = Application.Id;
            insert CoverLetter;
            CoverLetter.Body = null;
        }
    }

    private void insertOtherFileIfExists(){
        if(OtherFile.BodyLength > 0){
            OtherFile.ParentId = Application.Id;
            insert OtherFile;
            OtherFile.Body = null;
        }
    }

    @TestVisible private String getEnglishConfirmationText(){
        return 'Dear applicant, ' +
                'thank you for your interest in YOUR SL. We will check your application and get back to you shortly. ' +
                'Kind regards ' +
                'YOUR SL HR Team';

    }

    public String getAcknowledgeCheckboxText(){
        return 'By checking this box you make the following warranties and give your consents as described below:';
    }

    public String getAcknowledgeText(){
        return ' YOUR SL collects your personal data for the purposes of managing YOUR SL’s recruitment related activities as well as for organizational planning purposes. Consequently, YOUR SL may use your personal data in relation to the evaluation and selection of applicants including for example setting up and conducting interviews and tests, evaluating the results thereto and as is otherwise needed in the recruitment processes. YOUR SL does not disclose your personal data to unauthorized third parties.';
    }

    public List<SelectOption> getCandidateSourceOptions(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult source_describe = Job_Application__c.Candidate_Source__c.getDescribe();
        List<Schema.PicklistEntry> values_describe = source_describe.getPicklistValues();
        for( Schema.PicklistEntry entry : values_describe)
            options.add(new SelectOption(entry.getLabel(), entry.getValue()));
        options.add(0, new SelectOption('default', 'Please choose'));
        return options;
    }

}