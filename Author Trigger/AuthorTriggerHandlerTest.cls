@isTest
public with sharing class AuthorTriggerHandlerTest {
    
    @TestSetup
    public static void createTestData()
    {
        Book__c newBook = new Book__c(Book_Name__c='The Da Vinci Code',Name='The Da Vinci Code',Book_Price__c=12345);
        Database.insert(newBook);
        
        Book__c bookRetrieved = [Select Id,Book_Name__c,Name,Book_Price__c from Book__c];
        
        List<Author__c> authorList = new List<Author__c>();

        for(Integer iAuthor=0;iAuthor<30;iAuthor++)
        {
            Author__c author = new Author__c();
            author.Name = 'Dan Brown '+iAuthor;
            author.Book__c = bookRetrieved.Id;
            author.Book_Author_Name__c = 'Dan Brown '+iAuthor;
            
            authorList.add(author);
        }

        Database.insert(authorList);

    }

    @isTest
    public static void addDescriptionOnUpdate()
    {
        List<Author__c> authorList = [Select Name,Book__c,Book_Author_Name__c from Author__c];

        Database.update(authorList);


        for (Author__c author : authorList) {

            System.assertEquals(Author__c.Description__c, Author__c.Description__c);
        }

    }

    @isTest
    public static void avoidDeletion(){

        List<Author__c> authorList = [Select Name,Book__c,Book_Author_Name__c from Author__c];
        System.debug(authorList.size()+'  author list size');
        Database.Delete(authorList,false);

        List<Author__c> authorFetchedList = [Select Name,Book__c,Book_Author_Name__c from Author__c];
        System.debug(authorFetchedList.size());

        System.assertEquals(30,authorFetchedList.size());
    }


}