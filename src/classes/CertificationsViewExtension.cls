public with sharing class CertificationsViewExtension {
    public User SubjectUser {public get; private set;}
    public List<Certification__c> Certifications {public get; private set;}

    public CertificationsViewExtension(ApexPages.StandardController StdController) {
        Id user_id = ApexPages.currentPage().getParameters().get('sfdc.userId');
        ApexPages.currentPage().getParameters().put('id',user_id);
        SubjectUser = (User)StdController.getRecord();
        if(SubjectUser != null && SubjectUser.Contact_ID__c != null)
            Certifications = [SELECT Certification_Type__r.Badge__c FROM Certification__c WHERE Contact__c =: SubjectUser.Contact_ID__c AND Status__c = 'Passed'];
    }
}