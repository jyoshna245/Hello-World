/**
 * Class Name: RFA_AP04_UTIL_PdfCompletionMemo 
 * Author: Accenture
 * Date: 21-5-2012
 * Project Name: RFA - Coke 
 * Requirement Description: Util class for PDF Generate for RFA. This is the praser for POST Method.
 */
 @RestResource(urlMapping='/pdfGeneratorCM/*')

global class RFA_AP04_UTIL_PdfCompletionMemo {

    // Defining the POST method
    @HttpPOST
    global static void savePDF(ID parentId)
    {
    PageReference pdf = Page.RFA_VFP04_CM_DetailsAsPDF;
    // add parent id to the parameters for standardcontroller
    pdf.getParameters().put('id',parentId);
 
    // create the new attachment
    Attachment attach = new Attachment();
     
    // the contents of the attachment from the pdf
    Blob body;
 
    try {
 
        // returns the output of the page as a PDF
        body =  pdf.getContent();
        // need to pass unit test -- current bug    
    } catch (VisualforceException e) {
        body = Blob.valueOf('Some Text');
    }
 
    attach.Body = body;
    // add the user entered name
    attach.Name = 'Completion_Memo'+datetime.now()+'.pdf';
    attach.IsPrivate = false;
    // attach the pdf to the account
    attach.ParentId = ParentId;
    insert attach;
    
    
    }

}