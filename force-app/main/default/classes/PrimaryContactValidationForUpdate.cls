public class PrimaryContactValidationForUpdate{
    public static void validationMethodForUpdate(Map<Id, Contact> newContactMap, Map<Id, Contact> oldContactMap){ 
        Map<Id,List<Contact>> categorizedNewContactMap = FetchNewContactsCategorizedByIds.newContactsCategorizedByIds(newContactMap.values());
        Map<Id,List<Contact>> categorizedOldContactMap = FetchNewContactsCategorizedByIds.oldcontactsCategorizedByIdsFromMap(oldContactMap.values());
        
        List<Contact> contactList = [SELECT AccountId, Id, FirstName, Primary_Contact_Phone__c, 
        Is_Primary_Contact__c FROM Contact WHERE AccountId IN :categorizedNewContactMap.keySet()];
        Map<Id,Contact> primaryContactMap = GetPrimaryContactOfAccounts.primaryContacts(contactList);
        
        List<Contact> contactsToUpdate = new List<Contact>();
        for(Id categorizedAccountId : categorizedNewContactMap.keySet()){
            for(Contact triggerNewContact : categorizedNewContactMap.get(categorizedAccountId)){
                for(Contact triggerOldContact : categorizedOldContactMap.get(triggerNewContact.Id)){
                    if(triggerNewContact.Is_Primary_Contact__c == true 
                    && triggerOldContact.Is_Primary_Contact__c == false 
                    && primaryContactMap.containsKey(triggerNewContact.AccountId)){
                        System.debug('Error trigger'+triggerNewContact);
                        triggerNewContact.addError('There is primary contact that already exist.');
                        RecursiveFixer.firstRun = true;
                    }
                }
            }
        }
    }
}
