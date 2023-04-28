trigger JobTrigger on Job_Pratik__c (before delete,before update) {

    JobTriggerHelper jobHelper = new JobTriggerHelper();
    
    if(Trigger.isBefore && Trigger.isDelete)
    {
        /*Question 4If Job status is active,
         * it should not get deleted, user should get error 
         * “This Job is active and cannotbe deleted”.
			Use addError() method.*/
        
        jobHelper.checkForJobActiveOrInactive(Trigger.old);
    }


    if(Trigger.isBefore && Trigger.isUpdate)
    {
        /*Question 6   Immediately update Active field of job object to true if it is not activated
		when numberof Positions field in job is updated and higher than numberof Hired applicants.*/
        
        jobHelper.updateActiveFieldOnIncreasingPositions(Trigger.new);
	}
  
}