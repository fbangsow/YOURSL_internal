public class QuotePhaseWrapper
{
   public QuotePhase__c quotePhase {get; set;}
   public List<QuoteLineItem> quoteLineItems {get; set;}

   public QuotePhaseWrapper()
   {
      quoteLineItems=new List<QuoteLineItem>();
      quotePhase = new QuotePhase__c();
   }
}