public class GetPrimaryContactOfAccounts {
    public static Map<Id,Contact> primaryContacts(List<Contact> allContacts) {
        Map<Id, Contact> primaryContactMap = new Map<Id, Contact>();
        for(Contact primaryContact : allContacts){
            if(primaryContact.Is_Primary_Contact__c == true){
                primaryContactMap.put(primaryContact.AccountId, primaryContact);
            }
        }
        return primaryContactMap;
    }
}
