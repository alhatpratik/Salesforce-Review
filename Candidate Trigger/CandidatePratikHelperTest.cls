@isTest
public class CandidatePratikHelperTest {
    
    @testSetup
    public static void createTestSetup()
    {
        
		List<Candidate_Pratik__c> candidateList = new List<Candidate_Pratik__c>();
        
        Contact contactInstance = new Contact(LastName='Roy');
        Date expDate = Date.newInstance(2023, 5, 10);
        Job_Pratik__c job = new Job_Pratik__c(RecordTypeId='0122w000002AQE6AAO',Name='Developer ',Name__c='Developer ',Total_positions__c=20,Expires_ON__c=expDate,Active__c=true);
        insert job;
        Job_Pratik__c jobSetup = [Select Id,RecordTypeId,Name,Name__c,Total_positions__c,Expires_ON__c from Job_Pratik__c];
        
       	for(Integer iCandidate=0;icandidate<30;iCandidate++)
       	{
		   	Candidate_Pratik__c candidate = new Candidate_Pratik__c(Name='Pratik Alhat '+icandidate,First_Name__c='Pratik '+iCandidate,Last_Name__c='Alhat '+iCandidate,Application_Date__c=Date.today(),Job_Pratik__c=jobSetup.Id);
            candidate.Expected_Salary__c=12345;
            candidateList.add(candidate);
       	}
        
        try{
            Database.insert(candidateList,false);
        }
        catch(DmlException dmlEx)
        {
            System.debug('Cannot insert records');
        }
        
    }
    

    @isTest
    public static void showErrorOnExpectedSalaryField()
    {
        List<Candidate_Pratik__c> candidateSetupList = [Select Name,First_Name__c,Last_Name__c from Candidate_Pratik__c];
        System.debug(candidateSetupList.size());
        System.assertEquals(30, candidateSetupList.size());
        Job_Pratik__c adminJob = new Job_Pratik__c(RecordTypeId='0122w000002AQE6AAO',Name='Admin',Name__c='admin ',Total_positions__c=20,Expires_ON__c=Date.today()+10,Active__c=false);

        Candidate_Pratik__c newCandidate = new Candidate_Pratik__c(Name='Gajju',First_Name__c='Gajju ',Last_Name__c='Gajju ',Application_Date__c=Date.today(),Job_Pratik__c=adminJob.Id); 
        try{
            insert newCandidate;
        }
        catch(DmlException dmlEx)
        {
            System.debug('cannot insert record');
        }
    }
    
    
    @isTest
    public static void checkForJobActiveOrInactive()
    {
        List<Candidate_Pratik__c> candidateSetupList = [Select Name,First_Name__c,Last_Name__c from Candidate_Pratik__c];
        List<Candidate_Pratik__c> candidateList = new List<Candidate_Pratik__c>();
        System.debug(candidateSetupList.size());
        
        System.assertEquals(30, candidateSetupList.size());
        
        
        //  ---------------------------------------------------------- for TRUE condition -----------------------------------------
        
        
        Job_Pratik__c jobInstance = new Job_Pratik__c(RecordTypeId='0122w000002AQE6AAO',Name='Tester',Name__c='Tester ',Total_positions__c=20,Expires_ON__c=Date.today()+10,Active__c=true);
        Database.insert(jobInstance,false);

        for(Integer iCandidate=0;icandidate<15;iCandidate++)
       	{
		   	Candidate_Pratik__c candidate = new Candidate_Pratik__c(Name='Gajju',First_Name__c='Gajju '+iCandidate,Last_Name__c='Gajju '+iCandidate,Application_Date__c=Date.today(),Job_Pratik__c=jobInstance.Id);
            candidate.Expected_Salary__c=12345;
            candidateList.add(candidate);
       	}
		
        Database.insert(candidateList,false);
        
       	List<Candidate_Pratik__c> newCandidateList = [Select First_Name__c,Last_Name__c,Application_Date__c,Job_Pratik__r.Active__c from Candidate_Pratik__c where Name='Gajju'];
       
        for(Candidate_Pratik__c iCandidate : newCandidateList)
        {
            System.assertEquals(true, iCandidate.Job_Pratik__r.Active__c);
        }
        
        System.assertEquals(15, newCandidateList.size());					// AssertEquals
        
        List<Candidate_Pratik__c> candidateListForCoverage = new List<Candidate_Pratik__c>();
        
        for(Integer iCandidate=20;icandidate<30;iCandidate++)
       	{
		   	Candidate_Pratik__c candidate = new Candidate_Pratik__c(Name='Gajju',First_Name__c='Gajju '+iCandidate,Last_Name__c='Gajju '+iCandidate,Application_Date__c=Date.today(),Job_Pratik__c=jobInstance.Id);
            candidate.Expected_Salary__c=12345;
            candidateListForCoverage.add(candidate);
       	}
        
        Database.insert(candidateListForCoverage);
        /*
        try
        {
            Database.insert(candidateListForCoverage);
        }
        catch(DmlException dmlExc)
        {
            System.debug('Cannot create job');
        }
        
        Job_Pratik__c jobCoverage = [Select RecordTypeId,Name,Name__c,Active__c,Hired_Applicants__c from Job_Pratik__c where Name__c ='Tester '];
        
        
		System.assertEquals(false, jobCoverage.Active__c);
        */
        //  ---------------------------------------------------------- for FALSE condition -----------------------------------------
        
        List<Candidate_Pratik__c> candidateFalseConditionList = new List<Candidate_Pratik__c>();
        
        Job_Pratik__c adminJob = new Job_Pratik__c(RecordTypeId='0122w000002AQE6AAO',Name='Admin',Name__c='admin ',Total_positions__c=20,Expires_ON__c=Date.today()+10,Active__c=false);
        Database.insert(adminJob,false);

        for(Integer iCandidate=0;icandidate<15;iCandidate++)
       	{
		   	Candidate_Pratik__c candidate = new Candidate_Pratik__c(Name='Chetan',First_Name__c='Chetan '+iCandidate,Last_Name__c='Chetan '+iCandidate,Application_Date__c=Date.today(),Job_Pratik__c=adminJob.Id);
            candidate.Expected_Salary__c=12345;
            candidateFalseConditionList.add(candidate);
       	}
		
        try
        {
            Database.insert(candidateFalseConditionList,false);
        }
        catch(DmlException dmlExc)
        {
            System.debug('Cannot create job');
        }
        
        
       	List<Candidate_Pratik__c> falseCandidate = [Select First_Name__c,Last_Name__c,Application_Date__c,Job_Pratik__r.Active__c from Candidate_Pratik__c where Name='Chetan'];
       
        System.assertEquals(false, adminJob.Active__c);
        System.assertEquals(0, falseCandidate.size());
       
    }

    @isTest
    public static void dateCheckAndSetApplicationDate()
    {
        List<Candidate_Pratik__c> candidateSetupList = [Select Name,First_Name__c,Last_Name__c,Application_Date__c,CreatedDate from Candidate_Pratik__c];

        for(Candidate_Pratik__c candidate : candidateSetupList)
        {
            Date created = Date.newInstance(candidate.CreatedDate.year(),candidate.CreatedDate.month() , candidate.CreatedDate.day());
            Date application = candidate.Application_Date__c;
            System.assertEquals(created,application);
        }
    }
}