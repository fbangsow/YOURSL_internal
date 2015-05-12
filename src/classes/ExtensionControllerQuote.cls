public class ExtensionControllerQuote {
        
        public List<QuoteLineItem> QuoteLineItemsSorted {get; set;}
        public Quote selectedQuote;

    public void init(){

        QuoteLineItemsSorted = new List<QuoteLineItem>();
        QuoteLineItemsSorted = 
            [           Select o.New_Section_Headline__c, 
                    o.Sort_Order__c, 
                    o.QuotePhase__c, 
                    o.Quantity, 
                    o.Einheit__c, 
                    o.PricebookEntry.Name, 
                    o.PricebookEntryId, 
                    o.Product_lineitem_description__c, 
                    o.QLI_Explanation_of_Singleprice__c,
                    o.UnitPrice, 
                    o.Description, 
                    o.TotalPrice
                   From QuoteLineItem o 
                   Where o.QuoteId =: ApexPages.currentpage().getParameters().get('id')
                   ORDER BY Sort_Order__c ASC limit 100
            ];

    }

    public ExtensionControllerQuote(ApexPages.StandardController cont)
    {
                System.Debug('cont: ' + cont);
        selectedQuote = (Quote)cont.getRecord();
    } // end constructor
} // end class