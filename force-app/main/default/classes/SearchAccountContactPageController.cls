public class SearchAccountContactPageController {
    public String name {get;set;}
    public List<ResultWrapper> result {get;set;}
    public void searchAccountContactByName(){
        String accountQuery = 'SELECT Id,Name,Counter__c FROM Account WHERE Name LIKE \'' + this.name + '%\'';   
        List<Account> accs = Database.query(accountQuery);
        String contactQuery = 'SELECT Id,Name,Counter__c FROM Contact WHERE Name LIKE \'' + this.name + '%\'';   
        List<Contact> contacts = Database.query(contactQuery);
        
        List<ResultWrapper> res = new List<ResultWrapper>();
        if(!accs.isEmpty()){
            for(Account acc: accs){
                ResultWrapper rw = new ResultWrapper(acc);
                res.add(rw);
            }
        }
        if(!contacts.isEmpty()){
            for(Contact ct: contacts){
                ResultWrapper rw = new ResultWrapper(ct);
                res.add(rw);
            }
        }
        this.result = res;
    }
    
    @RemoteAction
    public static UpdatedDataWrapper updateCounter(String recordId) {
        UpdatedDataWrapper res = new UpdatedDataWrapper();
        res.isSuccess = true;
        
        System.debug(recordId);
        try{
        	List<Contact> contacts = [SELECT Id, Counter__c FROM Contact WHERE Id =: recordId];
            if(!contacts.isEmpty()){
            	contacts[0].Counter__c++;
                update contacts;
                return res;
            }
            List<Account> accs = [SELECT Id, Counter__c FROM Account WHERE Id =: recordId];
            if(!accs.isEmpty()){
            	accs[0].Counter__c++;
                update accs;
                return res;
            }
            res.isSuccess = false;
            res.message = 'Not found record';
        } catch (Exception e){
            res.isSuccess = false;
            res.message = e.getMessage();
        }
        return res;
    }
    
    public class UpdatedDataWrapper {
        public Boolean isSuccess {get;set;}
        public String message {get;set;}
    }
    
    public class ResultWrapper {
        public String name {get;set;}
        public String id {get;set;}
        public String recordType {get;set;}
        public String link {get;set;}
        public Decimal counter {get;set;}
        public ResultWrapper(Account acc){
            this.name = acc.Name;
            this.id = acc.Id;
            this.recordType = 'Account';
            this.link = '\\' + this.id;
            this.counter = acc.Counter__c;
        }
        public ResultWrapper(Contact ct){
            this.name = ct.Name;
            this.id = ct.Id;
            this.recordType = 'Contact';
            this.link = '\\' + this.id;
            this.counter = ct.Counter__c;
        }
    }
}