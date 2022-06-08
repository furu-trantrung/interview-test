@RestResource(urlMapping='/Contact/*')
global class RestfulWebService {
    @HttpPost
    global static void upsertContacts() {
        String body = RestContext.request.requestBody.toString();
		system.debug(body);
        List<Contact> contacts = (List<Contact>) JSON.deserialize(body, List<Contact>.class);
        system.debug(contacts);
        RestResponse standardResponse = RestContext.response;
        try{
            upsert contacts;
            standardResponse.responseBody = blob.valueOf('success');
        } catch(Exception e){
            standardResponse.statusCode = 500;
            standardResponse.responseBody = blob.valueOf(JSON.serializePretty(e.getMessage()));
        }
    }
}