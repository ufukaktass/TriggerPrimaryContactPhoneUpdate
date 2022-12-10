public class FetchNewContactsCategorizedByIds {
    public static Map<Id, List<Contact>> categorizedNewContactMap = new Map<Id, List<Contact>>();
    public static Map<Id,List<Contact>> newContactsCategorizedByIds(List<Contact> newContactList){
        for(Contact contact : newContactList){
            if(!categorizedNewContactMap.containsKey(contact.AccountId)){
                categorizedNewContactMap.put(contact.AccountId, new List<Contact>());
            }

            List<Contact> categorizedContactList = categorizedNewContactMap.get(contact.AccountId);

            categorizedContactList.add(contact);
            categorizedNewContactMap.put(contact.AccountId, categorizedContactList);
        }
        return categorizedNewContactMap;
    }

    public static Map<Id, List<Contact>> categorizedOldContactMapFromMap = new Map<Id, List<Contact>>();
    public static Map<Id,List<Contact>> oldcontactsCategorizedByIdsFromMap(List<Contact> oldContactList){
        for(Contact contact : oldContactList){
            if(!categorizedOldContactMapFromMap.containsKey(contact.Id)){
                categorizedOldContactMapFromMap.put(contact.Id, new List<Contact>());
            }

            List<Contact> categorizedContactList = categorizedOldContactMapFromMap.get(contact.Id);

            categorizedContactList.add(contact);
            categorizedOldContactMapFromMap.put(contact.Id, categorizedContactList);
        }
        return categorizedOldContactMapFromMap;
    }
}
