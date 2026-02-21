// Trigger: OpportunityAmountUpdateTrigger
// Updates Account field when Opportunity Amount changes

trigger OpportunityAmountUpdateTrigger on Opportunity (after insert, after update) {
    Set<Id> accountIds = new Set<Id>();
    for(Opportunity opp : Trigger.new){
        if(opp.AccountId != null){
            accountIds.add(opp.AccountId);
        }
    }
    
    Map<Id, Account> accountsToUpdate = new Map<Id, Account>();
    for(Account acc : [SELECT Id, Recent_Opportunity_Amount__c FROM Account WHERE Id IN :accountIds]){
        accountsToUpdate.put(acc.Id, acc);
    }
    
    for(Opportunity opp : Trigger.new){
        if(opp.AccountId != null && accountsToUpdate.containsKey(opp.AccountId)){
            accountsToUpdate.get(opp.AccountId).Recent_Opportunity_Amount__c = opp.Amount;
        }
    }
    
    update accountsToUpdate.values();
}
