@isTest(seeAllData=false)
private class CW_ImageAttachControllerTest 
{
    private static testMethod void validateInputTest() 
    {
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', null);
        ApexPages.currentPage().getParameters().put('parentName', null);
        ApexPages.currentPage().getParameters().put('fieldName', null);
        CW_ImageAttachController cont = new CW_ImageAttachController();
        cont.fileContent = null;
        cont.validateInput();
        Test.stopTest();
        
    }
    
      private static testMethod void uploadImageTest() 
    {
        Id id = 'a0me00000027JOu';
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', id);
        ApexPages.currentPage().getParameters().put('parentName', 'ABCD');
        ApexPages.currentPage().getParameters().put('fieldName', 'ABC');
        CW_ImageAttachController cont = new CW_ImageAttachController();
        String myString = 'StringToBlob';
        Blob myBlob = Blob.valueof(myString);
        cont.fileContent = myBlob;
        cont.parentName = 'ABCD';
        cont.fileName = 'TestFile';
        cont.contentType = 'Image';
        cont.uploadImage();
        Test.stopTest();
        
    }
    
    
}