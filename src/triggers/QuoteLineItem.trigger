trigger QuoteLineItem on QuoteLineItem (after insert) {
	Quote myquote = new Quote();
	//myquote.Id = trigger.new[0].QuoteId;
	Opportunity myopp = new Opportunity();
	myquote = [Select q.Id, q.OpportunityId From Quote q WHERE q.Id =: trigger.new[0].QuoteId ];
	myopp = [Select o.Id From Opportunity o WHERE o.Id =: myquote.OpportunityId];
	//List<OpportunityLineItem> myoli

}