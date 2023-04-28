public class AuthorTriggerHandler {

    
    public void addDescription(List<Author__c> authorsList)
    {
        for (Author__c author : authorsList) 
        {
            author.Description__c = 'USER FIRST NAME : '+UserInfo.getFirstName()+'  LAST NAME: '+UserInfo.getLastName();
        }
    }
    
    public void avoidDeletion(List<Author__c> authorsList)
    {
        for (Author__c author : authorsList) {
            author.Id.addError(' You Can\'t Delete Author' );
        }
    }

}