trigger PrimaryContactPhoneUpdateTrigger on Contact (after insert, after update) {
    List<Contact> primaryContacts = new List<Contact>();
    for (Contact con : Trigger.new) {
        if (con.Is_Primary_Contact__c == true) {
            primaryContacts.add(con);
        }
    }
    if (primaryContacts.size() > 0) {
        String primaryContactPhone = primaryContacts[0].Primary_Contact_Phone__c;
        List<Contact> relatedContacts = [SELECT Id, Is_Primary_Contact__c, Primary_Contact_Phone__c FROM Contact WHERE AccountId = :primaryContacts[0].AccountId AND Id != :primaryContacts[0].Id];
        List<Contact> contactsToUpdate = new List<Contact>();
        for (Contact c : relatedContacts) {
            c.Primary_Contact_Phone__c = primaryContactPhone;
              contactsToUpdate.add(c);          
        }
       
       if (contactsToUpdate.size() > 0) {
            Database.SaveResult[] saveResults = Database.update(contactsToUpdate, false);
            for (Database.SaveResult sr : saveResults) {
                if (sr.isSuccess()) {
                    System.debug('Contact updated successfully. Id: ' + sr.getId());
                } else {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('Error updating contact: ' + err.getStatusCode() + ' - ' + err.getMessage());
                    }
                }
            }
        } 
    }
}