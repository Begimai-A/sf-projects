trigger PrimaryContactTrigger on Contact (before insert) {
    if (Trigger.isBefore && Trigger.isInsert) {
        Set<Id> accountIdsWithPrimaryContact = new Set<Id>();
        for (Contact c : [SELECT AccountId FROM Contact WHERE Is_Primary_Contact__c = true]) {
            accountIdsWithPrimaryContact.add(c.AccountId);
        }
        
        for (Contact con : Trigger.new) {
            if (accountIdsWithPrimaryContact.contains(con.AccountId) && con.Is_Primary_Contact__c) {
                con.addError('Cannot create Contact as parent Account already has a primary Contact.');
            }
        }
    }
    /* else if (Trigger.isAfter && Trigger.isUpdate) {
Set<Id> updatedAccountIds = new Set<Id>();
for(Contact con : Trigger.new) {
if(con.Is_Primary_Contact__c && Trigger.oldMap.get(con.Id).Is_Primary_Contact__c != true) {
updatedAccountIds.add(con.AccountId);
}
}

List<Contact> relatedContacts = [SELECT Id, Is_Primary_Contact__c FROM Contact WHERE AccountId IN :updatedAccountIds AND Id != :Trigger.new[0].Id];
for(Contact con : relatedContacts) {
con.Is_Primary_Contact__c = false;
}
update relatedContacts;
}*/
}