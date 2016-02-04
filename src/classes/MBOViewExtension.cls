public without sharing class MBOViewExtension {
    private User SubjectUser;
    public SetOfMBO CurrentGoals {public get; private set;}

    public MBOViewExtension(ApexPages.StandardController StdController) {
        Id user_id = ApexPages.currentPage().getParameters().get('sfdc.userId');
        ApexPages.currentPage().getParameters().put('id',user_id);
        SubjectUser = (User)StdController.getRecord();
        String current_year_like_condition = String.valueOf(Date.today().Year()) + '%';
        List<Ziel__c> current_mbos = [SELECT Id, MBO_Quartal__c,
                        MBO_1__c, MBO_1_Beschreibung__c, MBO_1_Gewichtung_in_Prozent__c, MBO_1_Ergebnis__c,
                        MBO_2_Kurzbeschreibung__c, MBO_2_Langbeschreibung__c, MBO_2_Wichtung_in_Prozent__c, MBO_2_Ergebnis__c,
                        MBO_3_Kurzbeschreibung__c, MBO_3_Beschreibung__c, MBO_3_Gewichtung__c, MBO_3_Ergebnis__c,
                        MBO_4_Kurzbeschreibung__c, MBO_4_Beschreibung__c, MBO_4_Gewichtung_in_Prozent__c, MBO_4_Ergebnis__c
        FROM Ziel__c WHERE Contact__c =: SubjectUser.Contact_ID__c AND MBO_Quartal__c LIKE :current_year_like_condition];
        CurrentGoals = getGoals(current_mbos);
        if(CurrentGoals.MBOs.isEmpty())
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No MBO\'s assigned yet.'));
    }

    private SetOfMBO getGoals(List<Ziel__c> current_mbos){
        SetOfMBO set_of_mbo = new SetOfMBO();
        Date today = Date.today();
        for(Ziel__c mbo: current_mbos){
            String quater_dates_of_mbo = mbo.MBO_Quartal__c.substring((mbo.MBO_Quartal__c.indexOf('(')+1), mbo.MBO_Quartal__c.indexOf(')'));
            String quater_start_date_string = quater_dates_of_mbo.left(8);
            List<String> quater_start_date_components = quater_start_date_string.split('\\.');
            Date quater_start_date = Date.newInstance(Integer.valueOf('20' + quater_start_date_components.get(2)), Integer.valueOf(quater_start_date_components.get(1)), Integer.valueOf(quater_start_date_components.get(0)));
            String quater_end_date_string = quater_dates_of_mbo.right(8);
            List<String> quater_end_date_components = quater_end_date_string.split('\\.');
            Date quater_end_date = Date.newInstance(Integer.valueOf('20' + quater_end_date_components.get(2)), Integer.valueOf(quater_end_date_components.get(1)), Integer.valueOf(quater_end_date_components.get(0)));
            if(today <= quater_end_date && today >= quater_start_date){
                set_of_mbo.CurrentQuarter = mbo.MBO_Quartal__c;
                set_of_mbo.MBOs = new List<MBO>();
                if(String.isNotEmpty(mbo.MBO_1_Beschreibung__c))
                    set_of_mbo.MBOs.add(new MBO(mbo.MBO_1__c, mbo.MBO_1_Beschreibung__c, mbo.MBO_1_Gewichtung_in_Prozent__c, mbo.MBO_1_Ergebnis__c));
                if(String.isNotEmpty(mbo.MBO_2_Langbeschreibung__c))
                    set_of_mbo.MBOs.add(new MBO(mbo.MBO_2_Kurzbeschreibung__c, mbo.MBO_2_Langbeschreibung__c, mbo.MBO_2_Wichtung_in_Prozent__c, mbo.MBO_2_Ergebnis__c));
                if(String.isNotEmpty(mbo.MBO_3_Beschreibung__c))
                    set_of_mbo.MBOs.add(new MBO(mbo.MBO_3_Kurzbeschreibung__c, mbo.MBO_3_Beschreibung__c, mbo.MBO_3_Gewichtung__c, mbo.MBO_3_Ergebnis__c));
                if(String.isNotEmpty(mbo.MBO_4_Beschreibung__c))
                    set_of_mbo.MBOs.add(new MBO(mbo.MBO_4_Kurzbeschreibung__c, mbo.MBO_4_Beschreibung__c, mbo.MBO_4_Gewichtung_in_Prozent__c, mbo.MBO_4_Ergebnis__c));
            }
        }
        return set_of_mbo;
    }

    public class MBO{
        public String ShortDescription {public get; private set;}
        public String LongDescription {public get; private set;}
        public Decimal WeightOfMBO {public get; private set;}
        public Decimal PercentsAchieved {public get; private set;}

        public MBO(String short_description, String long_description, Decimal weight_of_mbo, Decimal percents_achieved){
            ShortDescription = short_description;
            LongDescription = long_description;
            WeightOfMBO = weight_of_mbo;
            if(percents_achieved != null)
                PercentsAchieved = percents_achieved;
            else
                PercentsAchieved = 0;
        }
    }

    public class SetOfMBO{
        public String CurrentQuarter {public get; private set;}
        public List<MBO> MBOs {public get; private set;}

        public SetOfMBO(){
            MBOs = new List<MBO>();
        }
    }
}