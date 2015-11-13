public with sharing class CertificationsViewExtension {
    public User SubjectUser {public get; private set;}
    public List<Certification__c> Certifications {public get; private set;}

    public CertificationsViewExtension(ApexPages.StandardController StdController) {
        Id user_id = ApexPages.currentPage().getParameters().get('sfdc.userId');
        ApexPages.currentPage().getParameters().put('id',user_id);
        SubjectUser = (User)StdController.getRecord();
        List<Certification__c> all_certifications;
        Certifications = new List<Certification__c>();
        if(SubjectUser != null && SubjectUser.Contact_ID__c != null)
            all_certifications = [SELECT Certification_Type__r.Badge__c FROM Certification__c WHERE Contact__c =: SubjectUser.Contact_ID__c AND Status__c = 'Passed'];
        for(Certification__c certification: all_certifications)
            if(certification.Certification_Type__r.Badge__c != null)
                Certifications.add(certification);
        if(Certifications.isEmpty())
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No certifications listed yet.'));
    }
}