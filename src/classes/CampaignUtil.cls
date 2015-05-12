public without sharing class CampaignUtil {
	
	public static String getResponseURL(String contactID, String leadID, String campaignID, String pageName, String answer){

		String responseurl = URL.getSalesforceBaseURL().toExternalForm() + '/apex/' + pageName + '/?contactID=' + contactID + '&leadID=' + leadID + '&campaignID=' + campaignID +'&answer='+ answer;

	return responseurl;
	}

	public static void setCampaignMemberURLs(List<CampaignMember> cmList, String pageName){

		for(CampaignMember cm : cmList){
			//cm.MemberID__c = String.valueOf(cm.CampaignID) + String.valueOf(cm.ContactID) + String.valueOf(cm.LeadID);
			cm.AcceptURL__c = getResponseURL(cm.ContactID, cm.LeadID, cm.CampaignId, pageName, 'true');
			cm.DeclineURL__c = getResponseURL(cm.ContactID, cm.LeadID, cm.CampaignId, pageName, 'false');			
		}
	}
    
    public static void createMemberStatus(List<CampaignMember> campaignMembers){
        
        Map<String, CampaignMemberStatus__c> cms = new Map<String, CampaignMemberStatus__c>();
        for(CampaignMember m : campaignMembers){
            CampaignMemberStatus__c st = new CampaignMemberStatus__c();
            st.CampaignMemberID__c = m.ID;
            st.Campaign__c = m.CampaignId;
			st.lead__c = m.LeadId;
            st.contact__c = m.ContactId;
            cms.put(m.ID, st);
        }
        INSERT cms.values();

        for(CampaignMember m : campaignMembers){
			m.CampaignMemberStatus__c = cms.get(m.ID).ID;
        }        
           
    }
    
    public static void deleteMemberStatus(List<CampaignMember> campaignMembers){
        
        List<ID> cmIDs = new List<ID>();
        for(CampaignMember cm : campaignMembers){
            cmIDs.add(cm.ID);
        }
        
        List<CampaignMemberStatus__c> cmToDelete = [SELECT ID FROM CampaignMemberStatus__c WHERE CampaignMemberID__c IN :cmIDs];
        
        if(cmToDelete != null){
            DELETE cmToDelete;
        }
    }


}