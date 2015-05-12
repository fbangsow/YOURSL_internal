trigger ReviewUpdateRating on Review__c (before insert, before update) {
	for(Review__c myrev : Trigger.new){
		myrev.Rating__c = 0;
							if(myrev.Rating_Scale_01__c == '1' ||
							   myrev.Rating_Scale_01__c == '2' ||
							   myrev.Rating_Scale_01__c == '3' || 
							   myrev.Rating_Scale_01__c == '4' ||
							   myrev.Rating_Scale_01__c == '5') {
							   	myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_01__c);
							  }

		
							if(myrev.Rating_Scale_02__c == '1' || 
							myrev.Rating_Scale_02__c == '2' ||
							 myrev.Rating_Scale_02__c == '3' || 
							 myrev.Rating_Scale_02__c == '4' ||
							  myrev.Rating_Scale_02__c == '5') {
							  	myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_02__c); 
							  }

		
							if(myrev.Rating_Scale_03__c == '1' || 
							myrev.Rating_Scale_03__c == '2' ||
							 myrev.Rating_Scale_03__c == '3' || 
							 myrev.Rating_Scale_03__c == '4' ||
							  myrev.Rating_Scale_03__c == '5') {
							  	myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_03__c); 
							  }

		
							if(myrev.Rating_Scale_04__c == '1' || 
							myrev.Rating_Scale_04__c == '2' ||
							 myrev.Rating_Scale_04__c == '3' || 
							 myrev.Rating_Scale_04__c == '4' ||
							  myrev.Rating_Scale_04__c == '5') {
							  	myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_04__c); 
							  }

		
							if(myrev.Rating_Scale_05__c == '1' || 
							myrev.Rating_Scale_05__c == '2' ||
							 myrev.Rating_Scale_05__c == '3' || 
							 myrev.Rating_Scale_05__c == '4' ||
							  myrev.Rating_Scale_05__c == '5') {
							  	myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_05__c); 
							  }

		
							if(myrev.Rating_Scale_06__c == '1' || 
							myrev.Rating_Scale_06__c == '2' ||
							 myrev.Rating_Scale_06__c == '3' || 
							 myrev.Rating_Scale_06__c == '4' ||
							  myrev.Rating_Scale_06__c == '5') {
							  	myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_06__c); 
							  }

		
							if(myrev.Rating_Scale_07__c == '1' || 
							myrev.Rating_Scale_07__c == '2' ||
							 myrev.Rating_Scale_07__c == '3' || 
							 myrev.Rating_Scale_07__c == '4' ||
							  myrev.Rating_Scale_07__c == '5') {
							  	myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_07__c); 
							  }

		
							if(myrev.Rating_Scale_08__c == '1' || 
							myrev.Rating_Scale_08__c == '2' ||
							 myrev.Rating_Scale_08__c == '3' || 
							 myrev.Rating_Scale_08__c == '4' ||
							  myrev.Rating_Scale_08__c == '5') {
							  	myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_08__c); 
							  }

		
							if(myrev.Rating_Scale_09__c == '1' || 
							myrev.Rating_Scale_09__c == '2' ||
							 myrev.Rating_Scale_09__c == '3' || 
							 myrev.Rating_Scale_09__c == '4' ||
							  myrev.Rating_Scale_09__c == '5') {
							  	myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_09__c); 
							  }

		
							if(myrev.Rating_Scale_10__c == '1' || 
							myrev.Rating_Scale_10__c == '2' ||
							 myrev.Rating_Scale_10__c == '3' || 
							 myrev.Rating_Scale_10__c == '4' ||
							  myrev.Rating_Scale_10__c == '5') {
							  	myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_10__c); 
							  }

		
							if(myrev.Rating_Scale_11__c == '1' || 
							myrev.Rating_Scale_11__c == '2' ||
							 myrev.Rating_Scale_11__c == '3' || 
							 myrev.Rating_Scale_11__c == '4' ||
							  myrev.Rating_Scale_11__c == '5') {
							  	myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_11__c); 
							  }

		
							if(myrev.Rating_Scale_12__c == '1' || 
							myrev.Rating_Scale_12__c == '2' ||
							 myrev.Rating_Scale_12__c == '3' || 
							 myrev.Rating_Scale_12__c == '4' ||
							  myrev.Rating_Scale_12__c == '5') {
							  	myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_12__c); 
							  }

		
							if(myrev.Rating_Scale_13__c == '1' || 
							myrev.Rating_Scale_13__c == '2' ||
							 myrev.Rating_Scale_13__c == '3' || 
							 myrev.Rating_Scale_13__c == '4' ||
							  myrev.Rating_Scale_13__c == '5') {
							  	myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_13__c); 
							  }

		
							if(myrev.Rating_Scale_14__c == '1' || 
							myrev.Rating_Scale_14__c == '2' ||
							 myrev.Rating_Scale_14__c == '3' || 
							 myrev.Rating_Scale_14__c == '4' ||
							  myrev.Rating_Scale_14__c == '5') {
							  	myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_14__c); 
							  }

		
							if(myrev.Rating_Scale_15__c == '1' || 
							myrev.Rating_Scale_15__c == '2' ||
							 myrev.Rating_Scale_15__c == '3' || 
							 myrev.Rating_Scale_15__c == '4' ||
							  myrev.Rating_Scale_15__c == '5') {
							  	myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_15__c); 
							  }

		
							if(myrev.Rating_Scale_16__c == '1' || 
							myrev.Rating_Scale_16__c == '2' ||
							 myrev.Rating_Scale_16__c == '3' || 
							 myrev.Rating_Scale_16__c == '4' ||
							  myrev.Rating_Scale_16__c == '5') {
							  	myrev.Rating__c = myrev.Rating__c + Double.valueOf(myrev.Rating_Scale_16__c); 
							  }

						if(myrev.Rating__c >0){
							myrev.Rating__c = myrev.Rating__c/16 ;
						}
	}

}