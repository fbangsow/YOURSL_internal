Global class SortOppLineItemCls {
    
    webservice static String MRsort(Id oppID)
    {
    	//pull back the OLIs in a specific sort order
    	List<OpportunityLineItem> olis = [Select oli.Id
    			From OpportunityLineItem oli
    			Where oli.OpportunityId = :oppId
    			ORDER BY ServiceDate ASC ];
    	
    	//build the comma separated 15 character OLI Id string to send back
    	String sortedIds = '';					  
    	for(OpportunityLineItem oli : olis)
    	{
    		sortedIds += String.valueOf(oli.Id).substring(0,15) + ',';		
    	} 
    	
    	//remove the last comma
    	sortedIds = sortedIds.substring(0,sortedIds.length() - 1);
    	return sortedIds;
    }

}