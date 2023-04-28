trigger CandidateTrigger on Candidate_Pratik__c (before insert,after insert) {
    
    Candidate_PratikHelper candidate = new Candidate_PratikHelper();
    
    if(Trigger.isBefore && Trigger.isInsert)
    {
       	/*While creating a record in a Candidate if ‘Expected Salary’ field blank,
       	 * show error message for that field as “Expected Salary field is missing”.
			Use addError() method.*/
        
        candidate.showErrorOnExpectedSalaryField(Trigger.new);
        
        /*If Candidate is applying for a job whose status is ‘Not Active’(deactivate job).
         * Candidate should get an error, “This Job is not active.
		 * You cannotapply for this job.*/
        
        candidate.checkForJobActiveOrInactive(Trigger.new);
        
        /*Question 5When the number of Candidates hired equals the number of Positions,
         * Job should be deactivated so no more candidates can apply for that job.
         * Once the number of positions of Job is equal to the number of hired candidates an 
         * email to be sent to a manager of job has a message, “All required candidate has been hired for this job on {{Job Last Modified Date}}”.
		 * Use library class Messaging.SingleEmailMessage*/
        candidate.checkForApplicantsAndHiredCandidate(Trigger.new);
        
    }

    if(Trigger.isAfter && Trigger.isInsert)
    {
        /*Question 3After inserting a new Candidate record, candidate may
        insert invalid date in the field “Application Date”. Write a trigger
		so that every time a new candidate record is inserted, an “Application Date” field have a value as 
		system generated CreatedDate field of that record only and not using any Date functions.*/
        
        candidate.dateCheckAndcSetApplicationDate(Trigger.new);
        
    }

}