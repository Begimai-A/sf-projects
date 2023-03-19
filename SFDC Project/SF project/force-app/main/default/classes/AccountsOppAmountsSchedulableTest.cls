@isTest
public class AccountsOppAmountsSchedulableTest {
    public static String CRON_EXP_DAILY = '0 0 10 * * ? *';
    public static String CRON_EXP_WEEKLY = '0 0 13 ? * FRI *';
    public static String CRON_EXP_MONTHLY = '0 0 18 ? * 6L';
    
    @isTest public static void testScheduledJob() {  
        
        Test.startTest();
        
        String jobDailyId = System.schedule('AccountsOppAmountsSchedulableDaily',
                                            CRON_EXP_DAILY, new AccountsOppAmountsSchedulable ());
        String jobWeeklyId = System.schedule('AccountsOppAmountsSchedulableWeekly',
                                             CRON_EXP_WEEKLY, new AccountsOppAmountsSchedulable ());
        String jobMonthlyId = System.schedule('AccountsOppAmountsSchedulableMonthly',
                                              CRON_EXP_MONTHLY, new AccountsOppAmountsSchedulable ());
        
        CronTrigger ctDaily = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                               FROM CronTrigger WHERE id = :jobDailyId];
        CronTrigger ctWeekly = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                                FROM CronTrigger WHERE id = :jobWeeklyId];
        CronTrigger ctMonthly = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                                 FROM CronTrigger WHERE id = :jobMonthlyId];
        
        System.assertEquals(CRON_EXP_DAILY, ctDaily.CronExpression);
        System.assertEquals(CRON_EXP_WEEKLY, ctWeekly.CronExpression);
        System.assertEquals(CRON_EXP_MONTHLY, ctMonthly.CronExpression);
        
        System.assertEquals('2023-03-18 10:00:00', String.valueOf(ctDaily.NextFireTime));
        System.assertEquals('2023-03-24 13:00:00', String.valueOf(ctWeekly.NextFireTime));
        System.assertEquals('2023-03-31 18:00:00', String.valueOf(ctMonthly.NextFireTime));
        
        List<AsyncApexJob> jobsScheduled = [SELECT Id, ApexClassID, ApexClass.Name, Status, JobType 
                                            FROM AsyncApexJob WHERE JobType = 'ScheduledApex' AND 
                                            ApexClass.Name = 'AccountsOppAmountsSchedulable'];
        
        System.assertEquals(3, jobsScheduled.size(), 'expecting one scheduled job');
        for (AsyncApexJob job : jobsScheduled) {
            System.assertEquals('Queued', job.Status);
        }
        
        Test.stopTest();
    }
}