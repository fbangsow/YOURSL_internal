trigger CampaignMemberTrigger on CampaignMember (before insert, after delete) {

	if(Trigger.isBefore){
		if(Trigger.isInsert){
			CampaignUtil.setCampaignMemberURLs(Trigger.new, 'InvitationPage');
            CampaignUtil.createMemberStatus(Trigger.new);
		}
	}
    
    if(Trigger.isAfter){
		if(Trigger.isDelete){
            CampaignUtil.deleteMemberStatus(Trigger.old);
        }  
    }

}