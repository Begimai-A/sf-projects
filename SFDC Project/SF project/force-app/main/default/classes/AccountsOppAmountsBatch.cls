global class AccountsOppAmountsBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Name, (SELECT Id, Amount, StageName FROM Opportunities WHERE StageName IN ('Open', 'Closed Won', 'Closed Lost')) 
            FROM Account 
            WHERE Id IN (SELECT AccountId FROM Opportunity WHERE StageName IN ('Open', 'Closed Won', 'Closed Lost') AND LastModifiedDate = THIS_MONTH)
        ]);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> scope) {
        Map<Id, Map<String, Decimal>> accountOpportunityAmounts = new Map<Id, Map<String, Decimal>>();
        
        for (Account acc : scope) {
            
            Map<String, Decimal> opportunityAmounts = new Map<String, Decimal>{
                    'Open' => 0,
                    'Closed Won' => 0,
                    'Closed Lost' => 0
                    };
                        
                        // Calculate the Opportunity Amounts for each stage
                        for (Opportunity opp : acc.Opportunities) {
                            if (opp.StageName == 'Open') {
                                opportunityAmounts.put('Open', opportunityAmounts.get('Open') + opp.Amount);
                            } else if (opp.StageName == 'Closed Won') {
                                opportunityAmounts.put('Closed Won', opportunityAmounts.get('Closed Won') + opp.Amount);
                            } else if (opp.StageName == 'Closed Lost') {
                                opportunityAmounts.put('Closed Lost', opportunityAmounts.get('Closed Lost') + opp.Amount);
                            }
                        }
            
            accountOpportunityAmounts.put(acc.Id, opportunityAmounts);
        }
        
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
        
        for (Account acc : scope) {
            
            List<Contact> contacts = [SELECT Id, Email FROM Contact WHERE AccountId = :acc.Id AND Is_Primary_Contact__c = true LIMIT 1];
            if (!contacts.isEmpty()) {
                Contact primaryContact = contacts[0];
                if (primaryContact != null && primaryContact.Email != null) {
                    // Create and send email
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setToAddresses(new List<String>{ primaryContact.Email });
                    email.setSubject('Opportunity Summary for ' + acc.Name);
                    email.setPlainTextBody(getOpportunitySummaryTable(acc.Id, acc.Name, accountOpportunityAmounts.get(acc.Id)));                  
                    emailsToSend.add(email);
                }
            }
            
        }
        if (!emailsToSend.isEmpty()) {
            Messaging.sendEmail(emailsToSend);
        }
        
    }            
    
    
    global void finish(Database.BatchableContext bc) {
        
    }
    
    // Helper method to create a table of summarized Opportunity Amounts
    private String getOpportunitySummaryTable(Id accountId, String accountName, Map<String, Decimal> opportunityAmounts) {
        String table = 'Here are the deal updates for ' + accountName + '\n';
        table += 'Stage Name\tAmount\n';
        
        for (String stage : opportunityAmounts.keySet()) {
            table += stage + '\t\t' + String.valueOf(opportunityAmounts.get(stage)) + '\n';
        }
        
        return table;
    }
    
    
}