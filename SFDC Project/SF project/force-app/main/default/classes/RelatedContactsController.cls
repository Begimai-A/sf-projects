public class RelatedContactsController {
    
    public list <Contact> conts {get;set;}
    public String searchKey {get;set;}
    public Id selectedContactId {get;set;}
    Public Id accountId{get;set;}
    

    public RelatedContactsController(ApexPages.StandardController sc ) {
    }
    public void search(){
        String accId = ApexPages.currentPage().getParameters().get('id');
        string searchquery='SELECT Id, LastName, Title, Phone, Is_Primary_Contact__c FROM Contact Where Lastname like \'%'+searchKey+'%\' Limit 12';
        conts= Database.query(searchquery);
    }
    public void clear(){
        conts.clear();
    } 
    
    
    
    public PageReference setPrimaryContact() {
        String contactId = ApexPages.currentPage().getParameters().get('newContactId');
        if (contactId == null) {
            return null;
        }
        Contact selectedContact = [SELECT Id, AccountId FROM Contact WHERE Id = :selectedContactId];
        System.debug('Selected Contact: ' + selectedContact);
        if (selectedContact == null) {
            return null;
        }
        List<Contact> allContacts = [SELECT Id, Is_Primary_Contact__c FROM Contact WHERE AccountId = :selectedContact.AccountId];
        System.debug('All Contacts: ' + allContacts);
        
        for(Contact c : allContacts) {
            if(c.Id == selectedContactId) {
                c.Is_Primary_Contact__c = true;
            } else {
                c.Is_Primary_Contact__c = false;
            }
            System.debug('Contact ' + c.Id + ' Is Primary Contact: ' + c.Is_Primary_Contact__c);
        }
        update allContacts;
        search();
        
        return null;
} 
    
}