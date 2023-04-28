trigger AccountAssignment1 on Account (before insert,before update, before delete,after insert) {
    
    AccountHelper accountHelperObj = new AccountHelper();
   
    
    
    // -------------------------------------------------- QUESTION 1 --------------------------------------------------------------------------------
 
        if(trigger.isBefore && trigger.isInsert)
        {
            accountHelperObj.billingAddressToShippingAddress(trigger.new);
        }

    // -------------------------------------------------- QUESTION 2 AND QUESTION 5 --------------------------------------------------------------------------------
    
    if(trigger.isBefore && trigger.isUpdate)
    {
        accountHelperObj.engineeringToFinance(trigger.new,trigger.old);
        
        accountHelperObj.accountPhoneUpdateContactPhone(trigger.newMap,trigger.oldMap);
       
    }

    
// -------------------------------------------------- QUESTION 3 AND QUESTION 4 --------------------------------------------------------------------------------
    
	if(trigger.isBefore && trigger.isDelete)
    {
    	accountHelperObj.checkActiveStatus(trigger.old);
    }

    
    if(trigger.isAfter && trigger.isInsert)
    {
    	accountHelperObj.annualRevenue(trigger.new);
    }
	
// -------------------------------------------------- QUESTION 6 --------------------------------------------------------------------------------

    if(Trigger.isBefore && Trigger.isDelete)
    {
        accountHelperObj.sendEmailOnAccountDelete(Trigger.oldMap);
    }


}