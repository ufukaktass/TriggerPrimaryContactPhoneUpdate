public class PrimaryContactValidationForInsert {
    public static void validationMethodForInsert(List<Contact> newContactList){
        //Categorize trigger contacts by Ids
        Map<Id, List<Contact>> categorizedNewContactMap = FetchNewContactsCategorizedByIds.newContactsCategorizedByIds(newContactList);
        List<Contact> contactList = [SELECT AccountId, FirstName, Primary_Contact_Phone__c, 
        Is_Primary_Contact__c FROM Contact WHERE AccountId IN :categorizedNewContactMap.keySet()];
        Map<Id,Contact> primaryContactMap = GetPrimaryContactOfAccounts.primaryContacts(contactList);

        List<Contact> contactsToInsert = new List<Contact>();
        List<Contact> contactsErrorList = new List<Contact>();
        for(Id categorizedAccountId : categorizedNewContactMap.keySet()){
            for(Contact triggerNewContact : categorizedNewContactMap.get(categorizedAccountId)){
                if(triggerNewContact.Is_Primary_Contact__c == true 
                && primaryContactMap.containsKey(triggerNewContact.AccountId)){
                    contactsErrorList.add(triggerNewContact);
                    System.debug('contactsErrorList: '+contactsErrorList);
                }
                else if(triggerNewContact.Is_Primary_Contact__c == true 
                && !primaryContactMap.containsKey(triggerNewContact.AccountId)){
                    contactsToInsert.add(triggerNewContact);
                    System.debug('contactsToInsert: '+contactsToInsert);
                }
            }
        }
        if(!contactsToInsert.isEmpty()){
            //RecursiveFixer.firstRun = true;
            InsertPrimaryContactTriggerHandler.insertContactWithPrimaryPhone(contactsToInsert);
        }
        for(Contact errContact : contactsErrorList){
            errContact.addError('There is primary contact that already exists.');
            RecursiveFixer.firstRun = true;
        }
    }
}
