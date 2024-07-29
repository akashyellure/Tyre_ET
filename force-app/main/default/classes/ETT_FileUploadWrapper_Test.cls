@isTest
public class ETT_FileUploadWrapper_Test {

    static TestMethod void fileUploadWrapper_TestClass(){
        
        ETT_FileUploadWrapper obj = new ETT_FileUploadWrapper();
        
        String myBase64String = EncodingUtil.base64Encode(Blob.valueof('test string '));
        
        obj.strFileName = 'testImg.png';
        obj.fileSourceType = 'test';
        obj.strFileType = 'image/png';
        obj.strBase64Data = myBase64String;
        
    }
    
}