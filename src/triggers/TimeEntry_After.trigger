trigger TimeEntry_After on TimeEntry__c (after delete, after insert, after undelete, 
after update) {


    List<id> opportunityLineItemIDNew = new List<Id>();
    List<id> opportunityLineItemIDOld = new List<Id>();
    
    Map<Id, OpportunityLineItem> mapOppLINew;
    Map<Id, OpportunityLineItem> mapOppLIOld;
    OpportunityLineItem oneOLI = new OpportunityLineItem();

    // here we are filling all related Lists for Trigger.new
    if(Trigger.isUpdate || Trigger.isInsert || Trigger.isUnDelete){
        for(TimeEntry__c te : Trigger.new){
        	// collect all related OppLI
            opportunityLineItemIDNew.add(te.Opportunity_Product_ID__c);
            System.debug('@@@@@@@@@@@@@@ DEBUG: Id'+te.Opportunity_Product_ID__c);
        }// END for(TimeEntry__c te : Trigger.new)
        
        if(opportunityLineItemIDNew.size()>0){
            mapOppLINew = new Map<Id, OpportunityLineItem> (
            				[SELECT Id, Total_Booked_Hours_billable__c, Total_booked_hours_non_billable__c 
            				FROM OpportunityLineItem WHERE Id IN: opportunityLineItemIDNew]);
            System.debug('@@@@@@@@@@@@@@ DEBUG: ListSize'+mapOppLINew.size());
        }// END if(opportunityLineItemIDNew.size()>0)
    }// END if(Trigger.isInsert || Trigger.isUpdate || Trigger.isUnDelete)
    
    // here we are filling all related Lists for Trigger.old
    if(Trigger.isUpdate || Trigger.isDelete){
        for(TimeEntry__c te : Trigger.old){
            opportunityLineItemIDOld.add(te.Opportunity_Product_ID__c);
        }
        
        if(opportunityLineItemIDOld.size()>0){
        	mapOppLIOld = new Map<Id, OpportunityLineItem> (
            				[SELECT Id, 
            				Total_Booked_Hours_billable__c,
            				Total_booked_hours_non_billable__c 
            				FROM OpportunityLineItem WHERE Id IN: opportunityLineItemIDOld]);
        }// END if(opportunityLineItemIDNew.size()>0)
    }// END if(Trigger.isUpdate || Trigger.isDelete)
    
    // here we start filling all related fields
    if(Trigger.isInsert || Trigger.isUnDelete){
        if(mapOppLINew.size() > 0) {
        	for(TimeEntry__c te_INSERT : Trigger.new){
        		OpportunityLineItem oneOLI_INS = mapOppLINew.get(te_INSERT.Opportunity_Product_ID__c);
        		if(te_INSERT.Billable__c){
        			if(oneOLI_INS.Total_Booked_Hours_billable__c != null ){
                        Double newTime = oneOLI_INS.Total_Booked_Hours_billable__c + te_INSERT.Time__c;
                        oneOLI_INS.Total_Booked_Hours_billable__c = newTime;
                        
                    }else{
                        oneOLI_INS.Total_Booked_Hours_billable__c = te_INSERT.Time__c;
                    }
        		}else{ // not Billable__c
        			if(oneOLI_INS.Total_booked_hours_non_billable__c != null ){
                        Double newTime = oneOLI_INS.Total_booked_hours_non_billable__c + te_INSERT.Time__c;
                        oneOLI_INS.Total_booked_hours_non_billable__c = newTime;
                    }else{
                        oneOLI_INS.Total_booked_hours_non_billable__c = te_INSERT.Time__c;
                    }
        		}// END if(te.Billable__c)
        		mapOppLINew.put(oneOLI_INS.Id, oneOLI_INS);
        		
        	}// END for(TimeEntry__c te : Trigger.new)
                update mapOppLINew.values();
        }// END if(mapOppLINew.size()>0)
    }//END if(Trigger.isInsert)
    
    
    if(Trigger.isUpdate){
    	
    	if(mapOppLINew.size() > 0) {
        	for(TimeEntry__c te_update : Trigger.new){
        		OpportunityLineItem oneOLI_Update = mapOppLINew.get(te_update.Opportunity_Product_ID__c);
        		if(te_update.Billable__c){
        			if(oneOLI_Update.Total_Booked_Hours_billable__c != null ){
        				
        				if(te_update.Billable__c != trigger.oldMap.get(te_update.Id).Billable__c){//TimeEntry wurde auf Billable gesetzt
        					
        						Double dBillTime  = oneOLI_Update.Total_Booked_Hours_billable__c;
        						dBillTime = dBillTime + Double.valueOf(te_update.Time__c);
        						Double dNonBillTime = oneOLI_Update.Total_Booked_hours_non_billable__c;
        						dNonBillTime = dNonBillTime - Double.valueOf(te_update.Time__c);
        						
        						oneOLI_Update.Total_Booked_Hours_billable__c = dBillTime;
        						oneOLI_Update.Total_booked_hours_non_billable__c = dNonBillTime;
        			
        				} // if(te_update.Billable__c != trigger.oldMap.get(te_update.Id).Billable__c)
        				
        				
	        			if (te_update.Time__c != trigger.oldMap.get(te_update.Id).Time__c ){ // Wenn sich die eingegebene Zeit auf den TimeEntries ändert
	        					Double newTime = Double.valueOf(oneOLI_Update.Total_Booked_Hours_billable__c);
	        					if (te_update.Time__c < trigger.oldMap.get(te_update.Id).Time__c){
	        						Double diff = trigger.oldMap.get(te_update.Id).Time__c - te_update.Time__c;
	        						newTime -= Double.valueOf(diff);
	        					}else{
	        						Double diff = te_update.Time__c -trigger.oldMap.get(te_update.Id).Time__c;
	        						newTime += Double.valueOf(diff);	
	        					}
	    					    oneOLI_Update.Total_Booked_Hours_billable__c = newTime;				
	        			} // END if (te_update.Time__c != trigger.oldMap.get(te_update.Id).Time__c )
                    }else{ //if(oneOLI_Update.Total_Booked_Hours_billable__c != null ){
                    	if(te_update.Billable__c){
                    		//---
            				if(te_update.Billable__c != trigger.oldMap.get(te_update.Id).Billable__c){//TimeEntry wurde auf Billable gesetzt
        						Double dNonBillTime = oneOLI_Update.Total_Booked_hours_non_billable__c;
        						dNonBillTime = dNonBillTime - Double.valueOf(te_update.Time__c);
       						
        						oneOLI_Update.Total_booked_hours_non_billable__c = dNonBillTime;
        						oneOLI_Update.Total_Booked_Hours_billable__c = te_update.Time__c;
        					}else{
        						oneOLI_Update.Total_Booked_Hours_billable__c = te_update.Time__c;
            				}	 // if(te_update.Billable__c != trigger.oldMap.get(te_update.Id).Billable__c)
                    		//---
                    			
                    	}
                        
                    }
        		}else{ // not Billable__c
        			if(oneOLI_Update.Total_booked_hours_non_billable__c != null ){
        				//--
	    				if(te_update.Billable__c != trigger.oldMap.get(te_update.Id).Billable__c){//TimeEntry wurde auf nonBillable gesetzt
        					
    						Double dBillTime  = oneOLI_Update.Total_Booked_Hours_billable__c;
    						dBillTime = dBillTime - Double.valueOf(te_update.Time__c);
    						Double dNonBillTime = oneOLI_Update.Total_Booked_hours_non_billable__c;
    						dNonBillTime = dNonBillTime + Double.valueOf(te_update.Time__c);
    						
    						oneOLI_Update.Total_Booked_Hours_billable__c = dBillTime;
    						oneOLI_Update.Total_booked_hours_non_billable__c = dNonBillTime;
        			
        				} // if(te_update.Billable__c != trigger.oldMap.get(te_update.Id).Billable__c)
        				
        				//--
         				if (te_update.Time__c != trigger.oldMap.get(te_update.Id).Time__c ){ // Wenn sich gebuchte Zeit geändert hat
        					
        					Double newTime = Double.valueOf(oneOLI_Update.Total_booked_hours_non_billable__c);
        					if (te_update.Time__c < trigger.oldMap.get(te_update.Id).Time__c){
        						Double diff = trigger.oldMap.get(te_update.Id).Time__c - te_update.Time__c;
        						newTime -= Double.valueOf(diff);
        					}else{
        						Double diff = te_update.Time__c -trigger.oldMap.get(te_update.Id).Time__c;
        						newTime += Double.valueOf(diff);	
        					}
        					
        					oneOLI_Update.Total_booked_hours_non_billable__c = newTime;
        				}// END if (te_update.Time__c < trigger.oldMap.get(te_update.Id).Time__c)
       				
                    }else{
        				if(te_update.Billable__c != trigger.oldMap.get(te_update.Id).Billable__c){//TimeEntry wurde auf nonBillable gesetzt
							Double dBillTime = oneOLI_Update.Total_Booked_Hours_billable__c;
    						dBillTime = dBillTime - Double.valueOf(te_update.Time__c);
       						
    						oneOLI_Update.Total_Booked_Hours_billable__c = dBillTime;
    						oneOLI_Update.Total_booked_hours_non_billable__c = te_update.Time__c;
        			
    					}else{
    						oneOLI_Update.Total_booked_hours_non_billable__c = te_update.Time__c;	
    					}
                        
                    }
        		}// END if(te.Billable__c)
        		mapOppLINew.put(oneOLI_Update.Id, oneOLI_Update);
        		
        	}// END for(TimeEntry__c te : Trigger.new)
                update mapOppLINew.values();
        }// END if(mapOppLINew.size()>0)
        
        /*
        if(mapOppLINew.size()>0){
        	for(TimeEntry__c teNEW : Trigger.new){
        		OpportunityLineItem oneOLINEW = mapOppLINew.get(teNEW.Opportunity_Product_ID__c);
        		if(teNEW.Billable__c){
        			if(oneOLINEW.Total_Booked_Hours_billable__c != null ){
                        Double newTime = double.valueof(oneOLINEW.Total_Booked_Hours_billable__c) + double.valueof(teNEW.Time__c);
                        oneOLINEW.Total_Booked_Hours_billable__c = double.valueof(newTime);
                    }else{
                        oneOLINEW.Total_Booked_Hours_billable__c = double.valueof(teNEW.Time__c);
                    }
        		}else{ // not Billable__c
        			if(oneOLINEW.Total_booked_hours_non_billable__c != null ){
                        Double newTime = double.valueof(oneOLINEW.Total_booked_hours_non_billable__c) + double.valueof(teNEW.Time__c);
                        oneOLINEW.Total_booked_hours_non_billable__c = double.valueof(newTime);
                    }else{
                        oneOLINEW.Total_booked_hours_non_billable__c = teNEW.Time__c;
                    }
        		}// END if(te.Billable__c)
        		mapOppLINew.put(oneOLINEW.Id, oneOLINEW);
        		//te.addError(' oneOLI.Id ' + String.valueOf(oneOLI.Id));
        		//update oneOLI;
        	}// END for(TimeEntry__c te : Trigger.new)
                update mapOppLINew.values();
                //oneOLI = new OpportunityLineItem();
        }// END if(mapOppLINew.size()>0)
        */

	/*
        if(mapOppLIOld.size()>0){
        	for(TimeEntry__c teOLD : Trigger.old){
        		OpportunityLineItem oneOLIold = mapOppLIOld.get(teOLD.Opportunity_Product_ID__c);
        		if(teOLD.Billable__c){
        			if(oneOLIold.Total_Booked_Hours_billable__c != null){
        				Double newTime = oneOLIold.Total_Booked_Hours_billable__c - teOLD.Time__c;
                        oneOLIold.Total_Booked_Hours_billable__c = newTime;
                    }else{
                        oneOLIold.Total_Booked_Hours_billable__c = 0;
                    }
        		}else{ // not Billable__c
        			if(oneOLIold.Total_booked_hours_non_billable__c != null){
                        Double newTime = oneOLIold.Total_booked_hours_non_billable__c - teOLD.Time__c;
                        oneOLIold.Total_booked_hours_non_billable__c = newTime;
                    }else{
                        oneOLIold.Total_booked_hours_non_billable__c = 0;
                    }
        		}// END if(te.Billable__c)
        		mapOppLIOld.put(oneOLIold.Id, oneOLIold);
        	}// END for(TimeEntry__c te : Trigger.Old)
			update mapOppLIOld.values();
			oneOLI = new OpportunityLineItem();
        }// END if(mapOppLIOld.size()>0)*/
        
    }//END if(Trigger.isUpdate)
    
    if(Trigger.isDelete){
        if(mapOppLIOld.size()>0){
        	for(TimeEntry__c teDEL : Trigger.Old){
        		OpportunityLineItem oneOLI_DEL = mapOppLIOld.get(teDEL.Opportunity_Product_ID__c);
        		if(teDEL.Billable__c){
        			if(oneOLI_DEL.Total_Booked_Hours_billable__c != null ){
                        oneOLI_DEL.Total_Booked_Hours_billable__c -= teDEL.Time__c;
        			}else{
                        oneOLI_DEL.Total_Booked_Hours_billable__c = 0;
                    }
        		}else{ // not Billable__c
        			if(oneOLI_DEL.Total_booked_hours_non_billable__c != null){
                        oneOLI_DEL.Total_booked_hours_non_billable__c -= teDEL.Time__c;
        			}else{
                        oneOLI_DEL.Total_booked_hours_non_billable__c = 0;
                    }
        		}// END if(te.Billable__c)
        		mapOppLIOld.put(oneOLI_DEL.Id, oneOLI_DEL);
        	}// END for(TimeEntry__c te : Trigger.Old)
        	update mapOppLIOld.values();
    	}// END if(mapOppLIOld.size()>0)
    }//END if(Trigger.isDelete)
}// END Trigger