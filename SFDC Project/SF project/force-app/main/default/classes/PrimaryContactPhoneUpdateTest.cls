@isTest
public class PrimaryContactPhoneUpdateTest {
    
    @isTest static void testPrimaryContactPhoneUpdate(){
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        Contact contact1 = new Contact(FirstName = 'Jj', LastName = 'Dd', AccountId = acc.Id);
        insert contact1;
        
        Account acc2 = new Account(Name = 'Test Account 2');
        insert acc2;
        
        Contact contact2 = new Contact(FirstName = 'Bb', LastName = 'Cc', AccountId = acc2.Id, Primary_Contact_Phone__c='000');
        insert contact2;
        
        Contact contact3=new Contact(FirstName = 'Aa', LastName = 'Ff', AccountId = acc.Id, Is_Primary_Contact__c = true,
                                     Primary_Contact_Phone__c='555');
        
        Contact getContact=[Select Primary_Contact_Phone__c from Contact where Primary_Contact_Phone__c='000' ];
        getContact.Primary_Contact_Phone__c='111';
       
       Contact contact4=new Contact(FirstName = 'Ss', LastName = 'Nn', AccountId = acc2.Id, Is_Primary_Contact__c = true,
                                     Primary_Contact_Phone__c='222');
        
        
        Test.startTest();
        try {
            insert contact4;
                } catch (DMLException e) {
                    // Assert that the expected error message is captured
                    System.assertEquals('Error updating contact:', e.getDmlMessage(0));
                }
        
        insert contact3;
        update getContact; 
        Test.stopTest();
        
        Contact[] insertedContact = [SELECT Account.Name, Primary_Contact_Phone__c FROM Contact WHERE Account.Name='Test Account'];
        System.assertEquals('555', insertedContact.get(0).Primary_Contact_Phone__c);
        Contact[] updatedContact = [SELECT Account.Name,Primary_Contact_Phone__c FROM Contact WHERE Account.Name='Test Account 2'];
        System.assertEquals('111', updatedContact.get(0).Primary_Contact_Phone__c);
        //Contact[] errorContact = [SELECT Account.Name, Primary_Contact_Phone__c FROM Contact WHERE Account.Name='Test Account'];
        
        
        
    }
}