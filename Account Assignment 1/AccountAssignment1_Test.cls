@isTest
public with sharing class AccountAssignment1_Test {
    public AccountAssignment1_Test() {

    }

    @testSetup
    public static void createTestData()
    {
        List<Account> accountList = new List<Account>();
        
        for(Integer iAccount=0;iAccount<30;iAccount++)
        {
            Account accInstance = new Account(Name='Atlantic pvt ltd '+iAccount);
            accInstance.BillingCity='Pune '+iAccount;
        	accInstance.BillingPostalCode='123456 '+iAccount;
        	accInstance.BillingState='Maharashtra '+iAccount;
        	accInstance.BillingCountry='India '+iAccount;
            //accInstance.AnnualRevenue=60000;
            accInstance.Phone='1234'+iAccount;
            accountList.add(accInstance);
            
        }
  		
        Database.SaveResult [] result = Database.insert(accountList,false);
    }
    
    @isTest
    public static void billingAddressToShippingAddressTest()
    {
        List<Account> accountList = new List<Account>();
        
        for(Integer iAccount=0;iAccount<30;iAccount++)
        {
            Account accInstance = new Account(Name='Atlantic pvt ltd '+iAccount);
            accInstance.BillingCity='Pune '+iAccount;
        	accInstance.BillingPostalCode='123456 '+iAccount;
        	accInstance.BillingState='Maharashtra '+iAccount;
        	accInstance.BillingCountry='India '+iAccount;
            
            accountList.add(accInstance);
            
        }
  	
        Database.SaveResult [] result = Database.insert(accountList,false);
        
        List<Account> insertedAccountList = [Select Id,Name,ShippingCity,ShippingPostalCode,ShippingState,ShippingCountry,BillingCity,BillingPostalCode,BillingState,BillingCountry from Account];

        for(Account iAccount : insertedAccountList)
        {
            System.assertEquals(iAccount.ShippingCity,iAccount.BillingCity);
            System.assertEquals(iAccount.ShippingPostalCode,iAccount.BillingPostalCode);
            System.assertEquals(iAccount.ShippingState,iAccount.BillingState);
            System.assertEquals(iAccount.ShippingCountry,iAccount.BillingCountry);
        }

    }
    
    @isTest
    public static void engineeringToFinanceTest()
    {       
        List<Account> setupAccountsList = [Select Id,Name,Industry,Active__c from Account];
        
        List<Account> updateAccountList = new List<Account>();
        
        for(Account iAccount : setupAccountsList)
        {
            iAccount.Industry='Finance';
            updateAccountList.add(iAccount);
        }
        
        Database.SaveResult [] result = Database.update(updateAccountList,false);
        
		List<Account> updatedAccountList = [Select Id,Name,Industry,Active__c from Account];
       
        for(Account iAccount: updatedAccountList)
        {
            System.assertEquals('true',iAccount.Active__c );
        }
        
    }
    
    
     @isTest
    public static void accountActiveAndNoAssociatedOpportunity()
    {
        List<Account> setupAccountsList = [Select Id,Name,Industry,Active__c from Account];
        
        List<Account> updateAccountList = new List<Account>();
        
        for(Account iAccount : setupAccountsList)
        {
            iAccount.Industry='Finance';
            updateAccountList.add(iAccount);
        }
        
        Database.SaveResult [] result = Database.update(updateAccountList,false);
        
		List<Account> updatedAccountList = [Select Id,Name,Industry,Active__c from Account];
        
        Database.delete(updatedAccountList, false);
        
        List<Account> deletedAccountList = [Select Id,Name,ShippingCity,ShippingPostalCode,ShippingState,ShippingCountry,BillingCity,BillingPostalCode,BillingState,BillingCountry from Account];

        System.assertEquals(deletedAccountList.size(), updatedAccountList.size());
        
        for(Account accountInstance : updatedAccountList)
        {
            System.assertEquals('true',accountInstance.Active__c);
        }
    }
       


    @isTest
    public static void activeAccountAndHavingAssociatedOpportunityTest()
    {
        List<Account> insertedAccountList = [Select Id,Name,ShippingCity,ShippingPostalCode,ShippingState,ShippingCountry,BillingCity,BillingPostalCode,BillingState,BillingCountry from Account];
    	List<Opportunity> opportunityList = new List<Opportunity>();
        List<Account> updateAccountList = new List<Account>();

        Date dateInstance = Date.today();
        Integer iOpportunity = 1;
            
        for(Account iAccount : insertedAccountList)
        {
            iAccount.Active__c ='true';

            Opportunity opportunityInstance = new Opportunity(Name='new opportunity'+iOpportunity,StageName='Prospecting',CloseDate=dateInstance);
            opportunityInstance.AccountId = iAccount.Id;
            opportunityList.add(opportunityInstance);
            
            iOpportunity++;

            updateAccountList.add(iAccount);
        }
    
        Database.update(updateAccountList);
        Database.insert(opportunityList,false);
        Database.delete(insertedAccountList,false);
        
        List<Account> deletedAccountList = [Select Id,Name,ShippingCity,ShippingPostalCode,ShippingState,ShippingCountry,BillingCity,BillingPostalCode,BillingState,BillingCountry from Account];
        
        System.assertEquals(deletedAccountList.size(), insertedAccountList.size());
        
        Map<Id,Opportunity> opportunityMap = new Map<Id,Opportunity>();

        List<Opportunity> fetchedOpportunityList = [Select Name,StageName,CloseDate,AccountId from Opportunity];

        for(Opportunity itrOpportunity : fetchedOpportunityList)
        {
            opportunityMap.put(itrOpportunity.AccountId, itrOpportunity);
        }

        for(Account iAccount : updateAccountList)
        {
            Opportunity opportunityInstance = opportunityMap.get(iAccount.Id);
            System.assertEquals(iAccount.Id,opportunityInstance.AccountId);
            System.assertEquals('true',iAccount.Active__c);
        }

    }



    @isTest
    public static void noActiveAccountButHavingAssociatedOpportunityTest()
    {
        List<Account> insertedAccountList = [Select Id,Name,ShippingCity,ShippingPostalCode,ShippingState,ShippingCountry,BillingCity,BillingPostalCode,BillingState,BillingCountry from Account];
    	List<Opportunity> opportunityList = new List<Opportunity>();
        
        Date dateInstance = Date.today();
        Integer iOpportunity = 1;
            
        for(Account iAccount : insertedAccountList)
        {
            Opportunity opportunityInstance = new Opportunity(Name='new opportunity'+iOpportunity,StageName='Prospecting',CloseDate=dateInstance);
            opportunityInstance.AccountId = iAccount.Id;
            opportunityList.add(opportunityInstance);
            
            iOpportunity++;
        }
    
        Database.insert(opportunityList,false);
        
        Database.delete(insertedAccountList,false);
        
        List<Account> deletedAccountList = [Select Id,Name,ShippingCity,ShippingPostalCode,ShippingState,ShippingCountry,BillingCity,BillingPostalCode,BillingState,BillingCountry from Account];
        
        System.assertEquals(deletedAccountList.size(), insertedAccountList.size());
        
        Map<Id,Opportunity> opportunityMap = new Map<Id,Opportunity>();

        List<Opportunity> fetchedOpportunityList = [Select Name,StageName,CloseDate,AccountId from Opportunity];

        for(Opportunity itrOpportunity : fetchedOpportunityList)
        {
            opportunityMap.put(itrOpportunity.AccountId, itrOpportunity);
        }

        for(Account iAccount : insertedAccountList)
        {
            Opportunity opportunityInstance = opportunityMap.get(iAccount.Id);
            System.assertEquals(iAccount.Id,opportunityInstance.AccountId);
        }

    }
    
    @isTest
    public static void noActiveAccountAndNoAnyOpportunity()
    {
        List<Account> setupAccountsList = [Select Id,Name,Industry,Active__c from Account];
        Database.delete(setupAccountsList);
        
        List<Account> deletedAccountsList = [Select Id,Name,Industry,Active__c from Account];

        System.assertEquals(0, deletedAccountsList.size());

    }



	@isTest
	public static void accountRevenueTest()
    {
		List<Account> accountList = new List<Account>();
        
        for(Integer iAccount=0;iAccount<30;iAccount++)
        {
            Account accInstance = new Account(Name='Blue Ocean');
            accInstance.BillingCity='Pune '+iAccount;
        	accInstance.BillingPostalCode='123456 '+iAccount;
        	accInstance.BillingState='Maharashtra '+iAccount;
        	accInstance.BillingCountry='India '+iAccount;
            accInstance.AnnualRevenue=60000;
            accInstance.Phone='1234'+iAccount;
            accountList.add(accInstance);
            
        }
  	
        Database.insert(accountList,false);    
        
        List<Account> accountDataList = [Select Id,Name,ShippingCity,ShippingPostalCode,ShippingState,ShippingCountry,BillingCity,BillingPostalCode,BillingState,BillingCountry from Account where Name='Blue Ocean'];
    	
        List<Task> tasksList = [Select Subject,WhatId,Status,ActivityDate from Task];
        
        
        
        
        System.debug(tasksList.size()+' ------------ Task List Size');
        System.debug(accountDataList.size()+' --------- Account List Size');
        
        Map<Id,Account> accountMap = new Map<Id,Account>();
        
        for(Account iAccount : accountDataList)
        {
            accountMap.put(iAccount.Id,iAccount);
        }

        
        
        for (Task iTask : tasksList) {
            
            System.debug(iTask.WhatId+'--------------------------what ID');
            //System.debug(accountInstance.Id+'--------------------account ID ');
           
            Account accountInstance = accountMap.get(iTask.WhatId);
            System.debug(iTask.WhatId+'--------------------------what ID');
        	System.debug(accountInstance.Id+'--------------------account ID ');
            System.assertEquals( iTask.WhatId, accountInstance.Id);
			
        }
		
    }
  
    
    @isTest
    public static void accountPhoneUpdateAlsoUpdateContactPhone()
    {
        List<Account> setupAccountDataList = [Select Id,Name,ShippingCity,ShippingPostalCode,ShippingState,ShippingCountry,BillingCity,BillingPostalCode,BillingState,BillingCountry,Phone from Account];
    	List<Account> updateAccountList = new List<Account>();
        List<Contact> contactsList = new List<Contact>();

        Map<Integer,Account> accountMap = new Map<Integer,Account>();
        Integer keyValue = 1;
        
        for (Account iAccount : setupAccountDataList) {

            iAccount.Phone='96385'+keyValue;
            updateAccountList.add(iAccount);
            accountMap.put(keyValue, iAccount);
            keyValue++;
        }

        Integer getAccountValue = 1;

        for (Integer iContact=0;iContact < 30;iContact++) {
            
            Contact contactInstance = new Contact(LastName='Hrithik '+iContact);
            Account accInstance = accountMap.get(getAccountValue);
            contactInstance.AccountId=accInstance.Id;
            contactsList.add(contactInstance);
            getAccountValue++;
        }

        Database.insert(contactsList);

        Database.update(updateAccountList);

        List<Account> updatedAccountList = [Select Id,Name,ShippingCity,ShippingPostalCode,ShippingState,ShippingCountry,BillingCity,BillingPostalCode,BillingState,BillingCountry,Phone from Account];

        List<Contact> updatedContactsList = [Select LastName,Phone,HomePhone,OtherPhone,AccountId from Contact];

        Map<Id,Contact> updatedContactMap = new Map<Id,Contact>();

        for(Contact iContact : updatedContactsList)
        {
            updatedContactMap.put(iContact.AccountId, iContact);
        }
        
        for(Account accInstance : updatedAccountList)
        {
            Contact contactInstance = updatedContactMap.get(accInstance.Id);
            if(contactInstance != null)
            {
                System.assertEquals(contactInstance.Phone, accInstance.Phone);
                System.assertEquals(contactInstance.HomePhone, accInstance.Phone);
            }
            
        }

    }

    @isTest
	public static void sendEmailOnAccountDelete()
    {
        List<Account> accountList = [Select Name,BillingCity,BillingPostalCode,BillingState,BillingCountry from Account];
        List<Contact> contactList = new List<Contact>();
        List<Account> accountListToDelete = new List<Account>();
        
        for(Integer iContact=0;iContact<10;iContact++)
        {
            Contact contactInstance = new Contact(LastName='Kapoor');
            contactInstance.Email='alhatpratik95@gmail.com';
            contactInstance.AccountId = accountList.get(iContact).Id;
            accountListToDelete.add(accountList.get(iContact));
            contactList.add(contactInstance);
        }
        
        Database.insert(contactList,false);
        
        List<Contact> contactRetrievedlist = [Select LastName,Email,AccountId from Contact];
        
        Database.delete(accountListToDelete,false);
        
        
        
        
        
        
        
        
    }
    
}