public with sharing class AccountHelper {
    public AccountHelper() {

    }



    /* -------------------------------------------------- QUESTION 1 --------------------------------------------------------------------------------
     
	 * Write a trigger on Account, when record is inserted in the Account, 
     * account billing address value should be automatically copied into the account shipping address 
     * and industry field values to Engineering.
     * */
     Map<String,TriggerActivationDeactivation__c> mapOfToggle =  TriggerActivationDeactivation__c.getAll();
     public void billingAddressToShippingAddress(List<Account> accountList)
     {
         //if(mapOfToggle.get('secondRecord').isActive__c ==true){
         	for(Account accountInstance : accountList)
         	{
             	accountInstance.ShippingCity = accountInstance.BillingCity;
             	accountInstance.ShippingCountry = accountInstance.BillingCountry;
             	accountInstance.ShippingLatitude =  accountInstance.BillingLatitude;
             	accountInstance.ShippingPostalCode = accountInstance.BillingPostalCode;
             	accountInstance.ShippingState = accountInstance.BillingState;
             
             	accountInstance.Industry = 'Engineering';
         	}
         //}
     }
     
     //----------------------------------------------------- QUESTION 2 -----------------------------------------------------------------------------
     
     /*
      * If the Account field -Industry is updated from Engineering to finance,then set Active field as true.
      * 
      * */
     
     public void engineeringToFinance(List<Account> newAccountList,List<Account> oldAccountList)
     {
         Map<Id,Account> newAccountMap = new Map<Id,Account>();
         // Map<Id,Account> oldAccountMap = new Map<Id,Account>();
         
         for(Account newAccountInstance : newAccountList)
         {
             newAccountMap.put(newAccountInstance.Id,newAccountInstance);
         }
         
         List<Account> updateList = new List<Account>();
         
         for(Account oldAccountInstance : oldAccountList)
         {
             
             if(oldAccountInstance.Industry=='Engineering')
             {
                 Account newAccount = newAccountMap.get(oldAccountInstance.Id);
                 
                 if(newAccount.Industry=='Finance')
                 {
                     newAccount.Active__c='true';
                     //updateList.add(newAccount);
                 }
                 
                 
             }
             
             
         }        
         
         //Database.update(updateList);
         
         //------------------------------------------------------ OLD CODE --------------------------------------------------------------
         /*
         
         for(Account accountNewInstance : newAccountList)
         {
             if(accountNewInstance.Industry == 'Finance')
             {              
                 for(Account accountOldInstance : oldAccountList)
                 {
                     if((accountNewInstance.Id == accountoldInstance.Id) && (accountOldInstance.Industry=='Engineering'))
                     {
                         accountNewInstance.Active__c = 'true';
                     }
                 }
             }
             
         }
 
         */
     }
     
     //----------------------------------------------------QUESTION 3 --- AND --- QUESTION 4 ------------------------------------------------------------------------------
 
     /*
      * If Account is Active,then prevent it from deletion. 
      * If Account has any opportunity associated with it prevent it fromdeletion. 
      * (Use addError() method).
      * 
      */
     
     public void checkActiveStatus(List<Account> accountOldList)
     {
         List<Opportunity> opportunityList = [Select id,AccountId from Opportunity];
         Map<Id,Opportunity> opportunityMap = new Map<Id,Opportunity>();
         
         
         for(Opportunity opportunityInstance : opportunityList)
         {
             opportunityMap.put(opportunityInstance.AccountId, opportunityInstance);
         }
         
         
         for(Account iAccount : accountOldList)
         {
                if(iAccount.Active__c=='true')
                {
                    iAccount.Active__c.addError('Active Account cannot be deleted ... please deactivate the account first in order to delete account');
                }
                 else
                 {
                     Opportunity oppInstance = opportunityMap.get(iAccount.Id);
                     
                     if( oppInstance != null)
                     {
                         iAccount.Id.addError('Account Cannot be deleted because it has associated Opportunity ...');
                     }
                 }
             
         }
         
     }
 
     //---------------------------------------------------- QUESTION 4 Helper Method ------------------------------------------------------------------------------
     
     public void annualRevenue(List<Account> accountList)
     {
         List<Task> taskList = new List<Task>();
         
         for(Account iaccount : accountList)
         {
             if(iAccount.AnnualRevenue >50000)
         	 {
             	Task taskInstance = new Task();
         		taskInstance.Subject = 'Assign all Leads to particular user';
         		taskInstance.WhatId = iAccount.Id;
         		taskInstance.Status='In Progress';
         		Date activitydate = Date.newInstance(2023, 4, 25);
         		taskInstance.ActivityDate = activitydate;
         		
                taskList.add(taskInstance);
         	  } 
         }
         
         Database.insert(taskList,false);

     }
     
     
     //---------------------------------------------------- QUESTION 5 ------------------------------------------------------------------------------
     
     /*
      * Whenever an Account phone is modified then update Contact record with phonefield 
      * (otherphone field with oldvalue and homephone field with new value) associated with Account.  
      * 
      */
     
     public void accountPhoneUpdateContactPhone(Map<Id,Account> accountNewMap, Map<Id,Account> accountOldMap)
     {
      
         List<Contact> contactList = [Select id,FirstName,LastName,AccountId from contact];
         
         System.debug(contactList.size());
         
         for(Contact c : contactList)
         {
             Account newAcc = accountNewMap.get(c.AccountId);
             Account oldAcc = accountOldMap.get(c.AccountId);
             
             if(newAcc != null && oldAcc != null)
             {
                 if(((newAcc.Phone != '' && oldAcc.Phone !='') && (newAcc.Phone!=null && oldAcc.Phone!=null)) || ((newAcc.Phone != '' && newAcc.Phone!=null) && (oldAcc.Phone =='' || oldAcc.Phone==null)))
                 {
                     if(newAcc.Phone != oldAcc.Phone)
                     {
                        c.Phone = newAcc.Phone;
                 		c.OtherPhone = oldAcc.Phone;
                 		c.HomePhone = newAcc.Phone;
                 
                 		update c;
                     }
                 }        
             }
         }

     }
     
     //---------------------------------------------------- QUESTION 6 ------------------------------------------------------------------------------
     
     /*
      * If Account is deleted,then send email (to appropriate email Id where the mail received can be checked).
      */

    public void sendEmailOnAccountDelete(Map<Id,Account> accountMap)
    {
        List<Contact> contactsList = [Select Id, AccountId, Email from Contact];
        List<Messaging.SingleEmailMessage> emails=new List<Messaging.SingleEmailMessage>();
        List<String> emailList=new List<String>();

        for(Contact iContact : contactsList)
        {
            Account acc = accountMap.get(iContact.AccountId);

            if(acc != null)
            {
                if(iContact.Email != null && iContact.Email != '')
                {
                    EmailMissionSpecialist newEmail = new EmailMissionSpecialist();

                    String subject = 'Account Deletion notification';
                    String body = 'Your contact related Account is been deleted';
                    newEmail.sendMail(iContact.Email, subject, body);
                }

            }
            
        }
       
    }

}