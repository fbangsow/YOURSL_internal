@isTest
public class CampaignUtilTest {
	
    static testmethod void campaignMembersTest(){
        
        Campaign c = new Campaign();
        c.Name = 'Test';
        INSERT c;
        
        Account acc = new Account();
        acc.Name= 'Test';
        INSERT acc;
        
        Contact con = new Contact();
        con.AccountID = acc.Id;
        con.LastName = 'Test';
        INSERT con;
        
        Lead l = new Lead();
        l.LastName = 'Test';
        l.Company = 'Test';
        l.Source_Campaign__c = c.Id;
        INSERT l;
        
        CampaignMember cmCon = new CampaignMember();
        cmCon.CampaignId = c.Id;
        cmCon.ContactId = con.Id;
        cmCon.Status = 'Sent';
        INSERT cmCon;
        
        CampaignMember cmLead = new CampaignMember();
        cmLead.CampaignId = c.Id;
        cmLead.LeadId = l.Id;
        cmLead.Status = 'Sent';
        INSERT cmLead; 
        
        String str = URL.getSalesforceBaseURL().toExternalForm() + '/apex/Invitation';
        
        PageReference pf1 = new PageReference(str);
        pf1.getParameters().put('contactID', con.ID);       
        pf1.getParameters().put('campaignID', c.ID);        
        pf1.getParameters().put('answer', 'true');
        
        Test.setCurrentPage(pf1);
        
        InvitationController contr = new InvitationController();
        contr.updateStatus();
        
        PageReference pf2 = new PageReference(str);
        pf2.getParameters().put('leadID', l.ID);       
        pf2.getParameters().put('campaignID', c.ID);        
        pf2.getParameters().put('answer', 'false');
        
        Test.setCurrentPage(pf2);
        
        contr = new InvitationController();
        contr.updateStatus();        
        
        List<CampaignMember> membersTodelete = new List<CampaignMember>();
        membersToDelete.add(cmLead);
        membersToDelete.add(cmCon);
        DELETE membersToDelete;
        
    }
    
}