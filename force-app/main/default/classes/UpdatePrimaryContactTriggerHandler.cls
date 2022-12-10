public class UpdatePrimaryContactTriggerHandler{
    public static void updateContactWithPrimaryPhone(Map<Id, Contact> newContactsMap, Map<Id, Contact> oldContactsMap){
        Map<Id, List<Contact>> categorizedNewContactMap = FetchNewContactsCategorizedByIds.newContactsCategorizedByIds(newContactsMap.values());
        Map<Id, List<Contact>> categorizedOldContactMap = FetchNewContactsCategorizedByIds.oldcontactsCategorizedByIdsFromMap(oldContactsMap.values());
        List<Contact> contactList = [SELECT AccountId, FirstName, Primary_Contact_Phone__c, 
        Is_Primary_Contact__c FROM Contact WHERE AccountId IN :categorizedNewContactMap.keySet()];

        List<Contact> contactListToUpdate = new List<Contact>();
        Map<Id,Contact> contactMapToUpdate = new Map<Id,Contact>();

        for(Id categorizedAccountId : categorizedNewContactMap.keySet()){
            for(Contact triggerNewContact : categorizedNewContactMap.get(categorizedAccountId)){
                for(Contact triggerOldContact : categorizedOldContactMap.get(triggerNewContact.Id)){
                    for(Contact currentContact : contactList){
                        if(triggerNewContact.Is_Primary_Contact__c != triggerOldContact.Is_Primary_Contact__c 
                        && triggerNewContact.Is_Primary_Contact__c == true 
                        && currentContact.AccountId == triggerNewContact.AccountId){
                            currentContact.Primary_Contact_Phone__c = triggerNewContact.Primary_Contact_Phone__c;
                            if(!contactMapToUpdate.containsKey(currentContact.Id)){
                                contactMapToUpdate.put(currentContact.Id, currentContact);
                            }
                        }
                        else if(triggerNewContact.Primary_Contact_Phone__c != triggerOldContact.Primary_Contact_Phone__c
                        && triggerNewContact.Is_Primary_Contact__c == true
                        && currentContact.AccountId == triggerNewContact.AccountId){
                            currentContact.Primary_Contact_Phone__c = triggerNewContact.Primary_Contact_Phone__c;
                            if(!contactMapToUpdate.containsKey(currentContact.Id)){
                                contactMapToUpdate.put(currentContact.Id, currentContact);
                            }
                        }
                    }
                }
            }
        }
        contactListToUpdate = contactMapToUpdate.values();
        Database.SaveResult[] resultList = Database.update(contactListToUpdate, false);
    }
}
