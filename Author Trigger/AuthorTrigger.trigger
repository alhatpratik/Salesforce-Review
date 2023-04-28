trigger AuthorTrigger on Author__c (before insert, before update, before delete) {
    
    
    	/*
	Populate Description field with the user first name who creates or updates the record by using userInfostandard keyword.
	And also, it does not allow users to delete the record. 
	(Create Author custom object and create custom field Description__c ).
		*/
    
    AuthorTriggerHandler authorHandler = new AuthorTriggerHandler();

    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
    {
        authorHandler.addDescription(Trigger.new);
    }

    if(Trigger.isBefore && Trigger.isDelete)
    {
        authorHandler.avoidDeletion(Trigger.old);
    }

}