public class Candidate_PratikHelper {
    
    public void showErrorOnExpectedSalaryField(List<Candidate_Pratik__c> candidateList)
    {
        for(Candidate_Pratik__c candidate : candidateList)
        {
            if(candidate.Expected_Salary__c ==null)
            {
                candidate.Expected_Salary__c.addError('Expected Salary field is missing');            
            }
           
        }
    }
    
    public void checkForJobActiveOrInactive(List<Candidate_Pratik__c> candidateList)
    {

        List <Job_Pratik__c> jobList = [Select Id,Name,Active__c from Job_Pratik__c];
        
        Map<Id,Job_Pratik__c> jobMap = new Map<Id,Job_Pratik__c>();
        
        for(Job_Pratik__c job : jobList)
        {
            jobMap.put(job.Id,job);
        }
        
        
        for(Candidate_Pratik__c candidate : candidateList)
        {
			Id job = candidate.Job_Pratik__c;
            Job_Pratik__c jobPratik = jobMap.get(job);
            
            if(jobPratik.Active__c==false){
                candidate.Id.addError('This job Field is Not Active');
            }
            
        }
        
    }

    public void dateCheckAndcSetApplicationDate(List<Candidate_Pratik__c> candidateList)
    {
        List<Candidate_Pratik__c> updateCandidateList = new List<Candidate_Pratik__c>();

        for(Candidate_Pratik__c candidate : candidateList){
            Date dateInstance = Date.newInstance(candidate.CreatedDate.year(),candidate.CreatedDate.month(),candidate.CreatedDate.day());
            System.debug(dateInstance);

            Candidate_Pratik__c newCandidate = new Candidate_Pratik__c(Id=candidate.ID,Application_Date__c=dateInstance);
            
            updateCandidateList.add(newCandidate);
        }

        Database.update(updateCandidateList);
    }
    
    
    public void checkForApplicantsAndHiredCandidate(List<Candidate_Pratik__c> newCandidateList)
    {
        List<Job_Pratik__c> jobListForMap = [select RecordTypeId,Name,Total_positions__c,Hired_Applicants__c,Manager__r.Email,LastModifiedDate from Job_Pratik__c];
        List<Job_Pratik__c> jobListToUpdate = new List<Job_Pratik__c>();
        Map<Id,Job_Pratik__c> jobMap = new Map<Id,Job_Pratik__c>();
        
        if(jobListForMap != null)
        {
            for(Job_Pratik__c job : jobListForMap)
            {
                jobMap.put(job.Id,job);
            }
            //System.debug('------------'+jobMap);
        }

        for(Candidate_Pratik__c candidate : newCandidateList)
        {
            Id jobId = candidate.Job_Pratik__c;
            Job_Pratik__c job = jobMap.get(jobId);

            System.debug(job.Hired_Applicants__c+' --- Hired Applicants ::: Total Positions '+job.Total_positions__c);

            if(((job.Hired_Applicants__c+1) == job.Total_positions__c))
            {
                job.Active__c = false;
                jobListToUpdate.add(job);
                EmailMissionSpecialist emailMission = new EmailMissionSpecialist();
                emailMission.sendMail(job.Manager__r.Email, 'Regarding hired Candidate', 'All required candidate has been hired for this job on '+job.LastModifiedDate);
            }
        }

        Database.update(jobListToUpdate,false);
    }

    


}