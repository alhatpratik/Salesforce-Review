public class JobTriggerHelper {
    
    
    public void checkForJobActiveOrInactive(List<Job_Pratik__c> jobList){
        
        for(Job_Pratik__c job : jobList)
        {
            if(job.Active__c==true)
            {
                job.Id.addError('This Job is active and cannot be deleted');
            }
        }
        
    }
    
    public void updateActiveFieldOnIncreasingPositions(List<Job_Pratik__c> newJobList){
        
        for(Job_Pratik__c iNewJob : newJobList)
        {
            if(iNewJob.Total_positions__c > iNewJob.Hired_Applicants__c+1)
            {
                iNewJob.Active__c = true;
            }
        }
    }
}