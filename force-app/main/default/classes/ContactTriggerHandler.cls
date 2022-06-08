public class ContactTriggerHandler {
    public static void handleAfterInsert(List<Contact> contacts){
        submitApprovalRequest(contacts);
    }
    
    private static void submitApprovalRequest(List<Contact> contacts){
		List<Approval.ProcessSubmitRequest> reqs = new List<Approval.ProcessSubmitRequest>();
        System.debug(contacts);
        for(Contact ct: contacts){
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitting request for approval.');
            req.setObjectId(ct.Id);
            req.setSubmitterId(ct.OwnerId);
            req.setProcessDefinitionNameOrId('Allow_Active_Contact');
            reqs.add(req);
        }
        List<Approval.ProcessResult> result = Approval.process(reqs, false);
    }
    
    public static void handleAfterUpdate(Map<Id, Contact> oldContactMap, List<Contact> newContacts){
        Set<Id> accIdsToUpdate = new Set<Id>();
        for(Contact ct: newContacts){
            if(String.isBlank(ct.AccountId)) continue;
            if(ct.Active__c == oldContactMap.get(ct.Id).Active__c) continue;
            accIdsToUpdate.add(ct.AccountId);
        }
        system.debug(accIdsToUpdate);
        if(!accIdsToUpdate.isEmpty()){
            updateTotalContactsOfAccount(accIdsToUpdate);
        }
    }
    
    private static void updateTotalContactsOfAccount(Set<Id> accIds){
        List<Account> accs = [SELECT Id, (SELECT Id FROM Contacts WHERE Active__c = TRUE) FROM Account WHERE Id IN: accIds];
        for(Account acc: accs){
            acc.TotalContacts__c = acc.Contacts.size();
        }
        update accs;
    }
    
    public static void handleAfterDelete(List<Contact> oldContacts){
        Set<Id> accIdsToUpdate = new Set<Id>();
        for(Contact ct: oldContacts){
            if(String.isBlank(ct.AccountId)) continue;
            if(!ct.Active__c) continue;
            accIdsToUpdate.add(ct.AccountId);
        }
        if(!accIdsToUpdate.isEmpty()){
            updateTotalContactsOfAccount(accIdsToUpdate);
        }
    }
}