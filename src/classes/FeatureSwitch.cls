public class FeatureSwitch {
    private static Map<String, Boolean> Switches;

    public static Boolean getSwitch(String feature_name){
        createSwitchMapIfNull();
        if(Switches.containsKey(feature_name)){
            return Switches.get(feature_name);
        } 
        else {
            return false;
        }
    }

    @TestVisible private static void enable(String enable_feature){
        createSwitchMapIfNull();
        Switches.put(enable_feature, true);
    }

    @TestVisible private static void disable(String disable_feature){
        createSwitchMapIfNull();
        Switches.put(disable_feature, false);
    }

    private static void createSwitchMapIfNull(){
        if(Switches == null){
            Switches = new Map<String, Boolean>();
            for(Feature_Switch__c feature_switch : [SELECT Name, Is_Enabled__c
                                            FROM Feature_Switch__c]){
                Switches.put(feature_switch.Name, feature_switch.Is_Enabled__c);
            }
        }
    }

    public class FeatureSwitchException extends Exception{}
}