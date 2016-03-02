/**********************************************************************************
 Author        :  Infosys
 Date          :  Sep 22, 2015
 Purpose       :  Controller class for VF page 
***********************************************************************************/
public with sharing class CW_ImageAttachController {
    
  //=================================Page variables===============================================//    
  public Blob fileContent{get;set;}
  public String fileName{get;set;}
  public String contentType {get; set;}
  //==================================Private variables===========================================//  
  private Id ParentId{get;set;}
  public String parentName{get;set;}
  private STring fieldName{get;set;}
  
  //==============================================================================================//
  // Constructor: Intialize variables and fetch data.
  //==============================================================================================//
  public CW_ImageAttachController(){
    ParentId = System.currentPageReference().getParameters().get('Id');
    parentName = System.currentPageReference().getParameters().get('Name');
    fieldName =  System.currentPageReference().getParameters().get('fieldName');
  }

  //==============================================================================================//
  // Save uploaded Attachment
  //==============================================================================================//
  public void uploadImage(){
    try{
      //Insert Attachment      
      if(validateInput()){
        Attachment a = new Attachment(Body=this.fileContent, Name=this.fileName, ParentId=this.ParentId, Description=this.fileName,
                               ContentType= this.contentType);
        insert a;
        
        if(fieldName != null){
            //assign a.id to specified field on parent object
            Schema.SObjectType sObjType = parentId.getSObjectType();
            sObject sobj = sObjType.newSObject(ParentId); 
            sobj.put(fieldName, a.id);
            update sobj;
        }
      
        
        Apexpages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Successfully uploaded the attached image.'));
      }         
    }catch(Exception Ex){       
        Apexpages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Error occured while uploading the Image.'+Ex.getMessage()));
    }
    //Clear upload for limited view state issue.
    fileContent = null;
    fileName = '';
  }
  
  //==============================================================================================//
  // Validate input for Attachment Save
  //==============================================================================================//
  public boolean validateInput(){
    boolean isValid = true;
    if(this.fileContent == null){
        system.debug('Pri 1');
        isValid = false;
        Apexpages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please select a valid file.'));
    }
    if(this.parentName == null){
        system.debug('Pri 2');
        Apexpages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please provide the \'Name\' parameter in url for attachment.'));
      isValid = false;
    }
    if(this.ParentId == null){
      system.debug('Pri 3');
      Apexpages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please provide the \'Id\' parameter in url for attachment(ParentId).'));
      isValid = false;
    }
    return isValid;
  }
}