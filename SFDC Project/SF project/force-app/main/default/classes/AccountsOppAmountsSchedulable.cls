global  class AccountsOppAmountsSchedulable implements Schedulable {
    global void execute(SchedulableContext sc){
        AccountsOppAmountsBatch batch = new AccountsOppAmountsBatch();
        Database.executeBatch(batch);
    }
}