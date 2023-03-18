@isTest
public class TestPrimaryContact {
    
    @isTest static void testHasPrimaryContactTrigger(){
        
        // Create an Account without primary contacts
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        // Create a Contact with the same Account, should be valid
        Contact validCon = new Contact(FirstName = 'John', LastName = 'Doe',Is_Primary_Contact__c = true, AccountId = acc.Id);
        insert validCon;
        // Create a Contact with the same Account and Is_Primary_Contact__c = true, should fail
        Contact invalidCon1 = new Contact(FirstName = 'Jane', LastName = 'Doe', AccountId = acc.Id, Is_Primary_Contact__c = true);
        
        // Create a Contact with a different Account, should be valid
        Account otherAcc = new Account(Name = 'Other Account');
        insert otherAcc;
        Contact existingCont=new Contact(FirstName = 'J', LastName = 'D', AccountId = otherAcc.Id);
        insert existingCont;
        Contact validCon2 = new Contact(FirstName = 'Bob', LastName = 'Smith',Is_Primary_Contact__c = true, AccountId = otherAcc.Id);
        
        // Insert the contacts
        List<Contact> contacts = new List<Contact>{ invalidCon1, validCon2};
            
            Test.startTest();
        try {
            insert new List<Contact>{ invalidCon1, validCon2};
                } catch (DMLException e) {
                    // Assert that the expected error message is captured
                    System.assertEquals('Cannot create Contact as parent Account already has a primary Contact.', e.getDmlMessage(0));
                }
        
        Test.stopTest();
        Contact[] updatedContacts = [SELECT Account.Name FROM Contact WHERE Account.Name='Test Account'];
        System.assertEquals(1, updatedContacts.size());
        Contact[] updatedContacts2 = [SELECT Is_Primary_Contact__c, Account.Name FROM Contact WHERE Account.Name='Other Account' AND Is_Primary_Contact__c=true];
        System.assertEquals(1, updatedContacts.size());
        
    }
}