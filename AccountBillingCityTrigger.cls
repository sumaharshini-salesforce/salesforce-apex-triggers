// Trigger: AccountBillingCityTrigger
// Updates Contact Mailing City when Account Billing City changes

trigger AccountBillingCityTrigger on Account (after update) {
    List<Contact> contactsToUpdate = new List<Contact>();
    for(Account acc : Trigger.new){
        Account oldAcc = Trigger.oldMap.get(acc.Id);
        if(acc.BillingCity != oldAcc.BillingCity){
            for(Contact con : [SELECT Id, MailingCity FROM Contact WHERE AccountId = :acc.Id]){
                con.MailingCity = acc.BillingCity;
                contactsToUpdate.add(con);
            }
        }
    }
    if(!contactsToUpdate.isEmpty()){
        update contactsToUpdate;
    }
}
