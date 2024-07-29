@isTest
public class ETT_SrabTyreWrapper_test {
    
    @isTest static void myTest() {
        
        //Create Document
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        insert cv;
        
        //Get Content Version
        List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        System.assertEquals(cvList.size(), 1);
        
        //Get Content Documents
        List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        System.assertEquals(cdList.size(), 1);
        
        test.startTest();
        ETT_SrabTyreWrapper objScrabTyre = new ETT_SrabTyreWrapper();
        objScrabTyre.strKey = 'TestStr';
        objScrabTyre.lstDocuments = cdList;
        objScrabTyre.sum();
        test.stopTest();
        
        
        System.debug(objScrabTyre);
    }
    
    /*
    static TestMethod void TyreWrapper_TestClass(){
        ETT_SrabTyreWrapper etsrab=new ETT_SrabTyreWrapper();   //ETT SrabTyre object
        //Test.startTest();
        etsrab.strKey= 'hello';                                 //string
        //insert etsrab;
        //List<string> objSrabTyre = new List<string>();
        
        //objSrabTyre.add('abcd');
        
        List<ContentDocument> objSrabTyre = new List<ContentDocument>();             //list of content document
        //objSrabTyre.add('sample testclass');
        
        //Get Content Documents
        
        List<ContentDocument> DocumentList = new List<ContentDocument>();  //
        
        //List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        //System.assertEquals(cdList.size(), 1);
        
        //Test.stopTest();
        
        
        
    }
    */
    
}