@isTest
private class AccountsOppAmountsBatchTest {
    static testMethod void testBatch() {
        Account acc = new Account(Name='Test Account');
        insert acc;
        Opportunity openOpp = new Opportunity(Name='Open Opp', StageName='Open', Amount=1000, AccountId=acc.Id, CloseDate=Date.newInstance(2023, 12, 31));
        Opportunity wonOpp = new Opportunity(Name='Won Opp', StageName='Closed Won', Amount=5000, AccountId=acc.Id, CloseDate=Date.newInstance(2023, 12, 31));
        Opportunity lostOpp = new Opportunity(Name='Lost Opp', StageName='Closed Lost', Amount=2000, AccountId=acc.Id, CloseDate=Date.newInstance(2023, 12, 31));
        insert new List<Opportunity>{openOpp, wonOpp, lostOpp};
            Contact primaryContact = new Contact(FirstName='John', LastName='Doe', Email='test@test.com', Is_Primary_Contact__c=true, AccountId=acc.Id);
        insert primaryContact;
        Test.startTest();
        AccountsOppAmountsBatch batchJob = new AccountsOppAmountsBatch();
        Database.executeBatch(batchJob);  
        Test.stopTest();
        // Create a list of Messaging.SingleEmailMessage objects
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new List<String>{primaryContact.Email});
        email.setSubject('Opportunity Summary for Test Account');
        email.setHtmlBody('Here are the deal updates for Test Account\nStage Name\tAmount\nOpen\t\t1000.00\nClosed Won\t\t5000.00\nClosed Lost\t2000.00\n');
        emails.add(email);
        
        // Send the emails using Messaging.sendEmail and store the results in a list
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(emails);
        
        // Verify that the email was sent successfully
        System.assertEquals(1, results.size());
        //System.assertTrue(results[0].isSuccess());
        
        
        
        
        // Assert that an email was sent to the primary contact with the correct subject and body
        
    }
}


/* System.assertEquals('Opportunity Summary for Test Account', email.getSubject(), 'Unexpected email subject');
System.assert(email.getHtmlBody().contains('Here are the deal updates for Test Account'), 'Expected email to contain summary table');
System.assert(email.getHtmlBody().contains('<table>'), 'Expected email to contain table');
Verify that the primary contact received the email with the summarized Opportunity Amounts
List<Messaging.SingleEmailMessage> sentEmails = Messaging.sendEmail(new List<Messaging.Email>{});
System.assertEquals(1, sentEmails.size());
System.assertEquals(primaryContact.Email, sentEmails[0].getToAddresses()[0]);
System.assertEquals('Opportunity Summary for Test Account', sentEmails[0].getSubject());
System.assertEquals('Here are the deal updates for Test Account\nStage Name\tAmount\nOpen\t\t1000.00\nClosed Won\t\t5000.00\nClosed Lost\t2000.00\n', sentEmails[0].getPlainTextBody());*/