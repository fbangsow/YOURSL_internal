@isTest
public class UserUtility {

    public static User createNewUser(String profile_name)
    {
        String profile_id_for_test_users = [SELECT Id FROM Profile WHERE Name = : profile_name].Id;
        return generateUserForProfileId(profile_id_for_test_users);
    }

    private static User generateUserForProfileId(String profile_id)
    {
        String unique_name = generateUniqueName();
        return new User(Alias = 'Alias',
            FirstName = 'Steve',
            LastName = 'John',
            ProfileId = profile_id,
            Email= unique_name +'@testorg.com',
            EmailEncodingKey='UTF-8',
            LocaleSidKey='de',
            TimeZoneSidKey='Europe/Berlin',
            LanguageLocaleKey='de',
            UserName = unique_name + '@test.com');
    }

    private static String generateUniqueName()
    {
        String org_id = userInfo.getOrganizationId();
        String date_string = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer random_int = Integer.valueOf(Math.rint(math.random()*1000000));
        return org_id + date_string + random_int;
    }
}