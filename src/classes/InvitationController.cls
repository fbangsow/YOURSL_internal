public without sharing class InvitationController {
	

	
	public InvitationController() {
		

	}
    
    public void updateStatus(){
        
		Boolean answer = Boolean.valueOf(Apexpages.currentPage().getParameters().get('answer'));
		//String memberID = Apexpages.currentPage().getParameters().get('memberID');
        String campaignID = Apexpages.currentPage().getParameters().get('campaignID');
        String contactID = Apexpages.currentPage().getParameters().get('contactID');
        String leadID = Apexpages.currentPage().getParameters().get('leadID');

		if(answer != null && campaignID != null){

			//CampaignMember cm = [SELECT ID, Status, CampaignMemberStatus__c FROM CampaignMember WHERE ID = :memberID];
			CampaignMemberStatus__c st;
            
            if(String.isNotBlank(contactId)){
                st = [SELECT ID, Status__c FROM CampaignMemberStatus__c WHERE Campaign__c = :campaignID AND Contact__c = :contactID];
            } else if (String.isNotBlank(leadid)){
                st = [SELECT ID, Status__c FROM CampaignMemberStatus__c WHERE Campaign__c = :campaignID AND Lead__c = :leadID];
            }
             
			if(st!= null) {
				if(answer){
					accept(st);
				} else {
					decline(st);
				}
			}
			

		}        
        
    }

	private void accept(CampaignMemberStatus__c cm) {

		cm.Status__c = 'Accepted';
		UPDATE cm;

	}

	private void decline(CampaignMemberStatus__c cm){

		cm.Status__c = 'Declined';
		UPDATE cm;
		
	}

	

}