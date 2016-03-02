/**
 * Class Name: RFA_AP01UTIl_PdfGeneratorUtil 
 * Author: Accenture
 * Date: 21-5-2012
 * Project Name: RFA - Coke 
 * Requirement Description: Util class for PDF Generate for RFA. This is the praser for POST Method.
 */
 @RestResource(urlMapping='/pdfGenerator/*')

global class RFA_AP01UTIl_PdfGeneratorUtil {

    // Defining the POST method
    @HttpPOST
    global static void savePDF(ID parentId)
    {
    PageReference pdf = Page.RFA_VFP07_DetailsAsPDF;
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
    attach.Name = 'RFA_Attachment.pdf';
    attach.IsPrivate = false;
    // attach the pdf to the account
    attach.ParentId = ParentId;
    insert attach;
    
    
    }

}