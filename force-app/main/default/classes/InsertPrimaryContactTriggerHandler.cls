public class InsertPrimaryContactTriggerHandler {
    public static void insertContactWithPrimaryPhone(List<Contact> newContactList){
        //Categorize trigger contacts by Ids
        Map<Id, List<Contact>> categorizedNewContactMap = FetchNewContactsCategorizedByIds.newContactsCategorizedByIds(newContactList);
        List<Contact> contactList = [SELECT AccountId, FirstName, Primary_Contact_Phone__c, 
        Is_Primary_Contact__c FROM Contact WHERE AccountId IN :categorizedNewContactMap.keySet()];
        System.debug('newContactList: '+newContactList.size());
        //update current primary contact phone by new contact's primary phone if their ids match.
        for(Id categorizedAccountId : categorizedNewContactMap.keySet()){
            for(Contact triggerNewContact : categorizedNewContactMap.get(categorizedAccountId)){
                for(Contact currentContact : contactList){
                    if(triggerNewContact.Is_Primary_Contact__c == true 
                    && currentContact.AccountId == triggerNewContact.AccountId){
                        currentContact.Primary_Contact_Phone__c = triggerNewContact.Primary_Contact_Phone__c;
                    }
                }
            }
        }
        RecursiveFixer.firstRun = false;
        Database.SaveResult[] results = Database.update(contactList, false);
        
    }
}
