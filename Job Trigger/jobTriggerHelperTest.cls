@isTest
public class jobTriggerHelperTest {
    
    
    @testSetup
    public static void createTestSetup()
    {
		List<Job_Pratik__c> jobList = new List<Job_Pratik__c>(); 
        Date expDate = Date.newInstance(2023, 5, 10);
        for(Integer iJob=0;iJob<30;iJob++)
        {
            Job_Pratik__c job = new Job_Pratik__c(RecordTypeId='0122w000002AQE6AAO',Name='Developer ',Name__c='Developer ',Expires_ON__c=expDate,Active__c=true);
			jobList.add(job);
        }
        Database.insert(jobList,false);
        System.debug('size -------------'+jobList.size());
    }

    @isTest
    public static void checkForJobActiveOrInactiveOnDeletion()
    {
        
        List<Job_Pratik__c> jobList = new List<Job_Pratik__c>(); 
        Date expDate = Date.newInstance(2023, 5, 10);
        for(Integer iJob=0;iJob<30;iJob++)
        {
            Job_Pratik__c job = new Job_Pratik__c(RecordTypeId='0122w000002AQE6AAO',Name='Atlantic Client',Name__c='Atlantic Client',Expires_ON__c=expDate,Active__c=true,Total_positions__c=20);
			jobList.add(job);
        }
        Database.insert(jobList,false);
        
        List<Job_Pratik__c> jobSetupList = [Select Id,RecordTypeId,Name,Name__c,Total_positions__c,Expires_ON__c,Active__c from Job_Pratik__c where Name='Atlantic Client'];
        System.debug(jobSetupList.size()+' ********SIZE===');
		        
        Database.delete(jobSetupList,false);
        List<Job_Pratik__c> jobAfterDelete = [Select Id,RecordTypeId,Name,Name__c,Total_positions__c,Expires_ON__c,Active__c from Job_Pratik__c];
        
        System.assertEquals(30, jobAfterDelete.size());
        
    }
    
  
    @isTest
    public static void updateActiveFieldOnIncreasingPositions()
    {
        //System.debug('----------------------------- updateActiveFieldOnIncreasingPositions ----------------------');
        Date expDate = Date.newInstance(2023, 5, 10);
        Job_Pratik__c job = new Job_Pratik__c(RecordTypeId='0122w000002AQE6AAO',Name='Trial',Name__c='Developer ',Total_positions__c=5,Expires_ON__c=expDate,Active__c=true);	
        Database.insert(job);
        for(Integer iCandidate=0;icandidate<10;iCandidate++)
        {
            Candidate_Pratik__c candidate = new Candidate_Pratik__c(Name='Pratik Alhat '+icandidate,First_Name__c='Pratik '+iCandidate,Last_Name__c='Alhat '+iCandidate,Application_Date__c=Date.today(),Job_Pratik__c=job.Id);
            candidate.Expected_Salary__c=12345;
            
           try{
            	Database.insert(candidate,false);
        	}
        	catch(DmlException dmlExc)
        	{
            	System.debug('Cannot insert Record');
        	}
        }
        
        Job_Pratik__c jobRetrieved = [Select Id,RecordTypeId,Name,Name__c,Total_positions__c,Expires_ON__c,Active__c,Hired_Applicants__c from Job_Pratik__c where Name = 'Trial'];
        System.debug(jobRetrieved+'----------- Retrieved Job');
		jobRetrieved.Total_positions__c=20;
        Database.update(jobRetrieved);     
        Job_Pratik__c jobRetrievedAfterUpdate = [Select Id,RecordTypeId,Name,Name__c,Total_positions__c,Expires_ON__c,Active__c,Hired_Applicants__c from Job_Pratik__c where Name = 'Trial'];
		System.assertEquals(true, jobRetrievedAfterUpdate.Active__c);
       
    }
    
}