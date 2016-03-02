public class MD_Clientprojectedvaluereport
{
    public List<QuoteLineItem> listMediaItem{get;set;} 
    public List<QuoteLineItem> listECAItem{get;set;} 
    public List<QuoteLineItem> listDataItem{get;set;} 
    public List<QuoteLineItem> listAllItem{get;set;} 
    public String oppName{get;set;}
    public User clientLead{get;set;}
    public String clientLeadName{get;set;}
    public User mediaDeskLead{get;set;}
    public String mediaDeskLeadName{get;set;}
    //public Date launchDate{get;set;}
    //public Date endDate{get;set;}
    public Quote quote{get;set;}  
    public Quote quote2{get;set;} 
    public Quote quoteThumbnail{get;set;} 
    public Decimal totalEstimatedValue{get;set;}
    public String totalEstimatedValueString{get;set;}
    //public Decimal totalEstimatedCost{get;set;}
    //public String totalEstimatedCostString{get;set;}
    public Decimal totalInternalCost{get;set;}
    public String totalInternalCostString{get;set;}
    public Decimal totalDelCost{get;set;}
    public String totalDelCostString{get;set;}
    public Decimal totalCredit{get;set;}
    public Decimal totalProductivity{get;set;}
    public String totalProductivityString{get;set;}
    public Decimal totalCoProductivity{get;set;}
    public String totalCoProductivityString{get;set;}
    public Date minStartDate{get;set;}
    public Date maxEndDate{get;set;}
    public String imageURL{get;set;} // Variable for Image insertion
    public ApexPages.StandardController cont;
    
    public Decimal mediaValueClientReport{get;set;}
    public String mediaValueClientReportString{get;set;}
    public Decimal capabilitiesValueClientReport{get;set;}
    public String capabilitiesValueClientReportString{get;set;}
    public Decimal DataValueClientReport{get;set;}
    public String DataValueClientReportString{get;set;}
    public Decimal impressionsValueClientReport{get;set;}
    public String impressionsValueClientReportString{get;set;}
    
    public MD_Clientprojectedvaluereport(ApexPages.StandardController controller) 
    {
        cont = controller;
        imageURL='/servlet/servlet.FileDownload?file=';    
        quote2 = (Quote)controller.getRecord();
        quote = [select id, Name, OpportunityId from Quote where id =: quote2.id];
        quoteThumbnail = [SELECT Id, Account.Thumbnail_Image_Id__c,Opportunity.Probability FROM quote where id =: quote2.id];
        if(quoteThumbnail != null)
            imageURL='/servlet/servlet.FileDownload?file=' + quoteThumbnail.Account.Thumbnail_Image_Id__c;  
        listMediaItem = new List<QuoteLineItem>();
        listECAItem = new List<QuoteLineItem>();
        listDataItem = new List<QuoteLineItem>();
        totalEstimatedValue = 0;
        totalProductivity=0;
        totalInternalCost=0;
        totalDelCost=0;
        totalCredit=0;
        mediaValueClientReport = 0;
        capabilitiesValueClientReport = 0;
        DataValueClientReport = 0;
        impressionsValueClientReport = 0;
        
        if(quote.id != null) 
        {
            Opportunity opp = [select id,Name,Client_Lead__c,ownerId from Opportunity where id =: quote.OpportunityId];
            oppName = opp.Name;
            List<User> user1 = new List<User>();
            user1 = [select Name from User where id =: opp.Client_Lead__c];
            if(user1 != null && user1.size() != 0)
            {
                clientLead = user1.get(0);
                clientLeadName = clientLead.Name;
            }
            List<User> user2 = new List<User>();            
            user2 = [select Name from User where id =: opp.ownerId];
            if(user2 != null && user2.size() != 0)
            {
                mediaDeskLead = user2 .get(0);
                mediaDeskLeadName = mediaDeskLead.Name;
            }
            listAllItem = [select id, Product2id, Product2.Name, Description, Start_Date__c, End_Date__c, Est_Impressions__c, Credits__c, Fair_Market_Value_Price__c,Internal_Cost__c,Delivery_Cost__c,Product_Category__c  from QuoteLineItem where QuoteId =: quote.id];
            listMediaItem = [select id, Product2id, Product2.Name, Description, Start_Date__c, End_Date__c, Est_Impressions__c, Credits__c, Fair_Market_Value_Price__c,Internal_Cost__c,Delivery_Cost__c,Product_Category__c  from QuoteLineItem where (QuoteId =: quote.id AND Product_Category__c = 'Media')];
            listECAItem = [select id, Product2id, Product2.Name, Description, Start_Date__c, End_Date__c, Est_Impressions__c, Credits__c, Fair_Market_Value_Price__c,Internal_Cost__c,Delivery_Cost__c,Product_Category__c  from QuoteLineItem where (QuoteId =: quote.id AND  Product_Category__c ='Capability')];
            listDataItem = [select id, Product2id, Product2.Name, Description, Start_Date__c, End_Date__c, Est_Impressions__c, Credits__c, Fair_Market_Value_Price__c,Internal_Cost__c,Delivery_Cost__c,Product_Category__c  from QuoteLineItem where (QuoteId =: quote.id AND  Product_Category__c ='Data')];
            for(QuoteLineItem quo : listAllItem)
            {
                if(quo.Fair_Market_Value_Price__c != null)
                {
                    totalEstimatedValue += quo.Fair_Market_Value_Price__c;
                }
                
                if(quo.Internal_Cost__c != null)
                {
                totalInternalCost += quo.Internal_Cost__c;
                }
                
                if(quo.Delivery_Cost__c != null)
                {
                totalDelCost += quo.Delivery_Cost__c;
                }
                
                if(quo.Credits__c != null)
                {
                totalCredit += quo.Credits__c;
                }
            }
            
            totalProductivity = totalEstimatedValue - totalInternalCost;
            totalCoProductivity = (totalEstimatedValue + totalCredit - totalDelCost) * quoteThumbnail.Opportunity.Probability;
            
            if(totalEstimatedValue == 0 || totalEstimatedValue == 0.00)
                totalEstimatedValue = null;   
            if(totalEstimatedValue != null)
                totalEstimatedValueString = '$'+String.valueOf(totalEstimatedValue);
            else
                totalEstimatedValueString = null;
                
                
            if(totalInternalCost == 0 || totalInternalCost == 0.00)
                totalInternalCost = null;   
            if(totalInternalCost != null)
                totalInternalCostString = '$'+String.valueOf(totalInternalCost);
            else
                totalInternalCostString = null;     
                
                
            if(totalProductivity == 0 || totalProductivity == 0.00)
                totalProductivity = null;   
            if(totalEstimatedValue != null)
                totalProductivityString = '$'+String.valueOf(totalProductivity);
            else
                totalProductivityString = null;    
                
             if(totalDelCost == 0 || totalDelCost == 0.00)
                totalDelCost = null;   
            if(totalDelCost != null)
                totalDelCostString = '$'+String.valueOf(totalDelCost);
            else
                totalDelCostString = null;
                
             if(totalCoProductivity == 0 || totalCoProductivity == 0.00)
                totalCoProductivity = null;   
            if(totalCoProductivity != null)
                totalCoProductivityString = '$'+String.valueOf(totalCoProductivity);
            else
                totalCoProductivityString = null;   
                
             
                
                
            List<Date> startDateList = new List<Date>();
            List<Date> endDateList = new List<Date>();
            for(QuoteLineItem quo : listAllItem)
            {
                if(quo.Start_Date__c != null)
                    startDateList.add(quo.Start_Date__c);
                if(quo.End_Date__c != null)
                    endDateList.add(quo.End_Date__c);
            }
            if(startDateList != null && startDateList.size() != 0)
            {
                startDateList.sort();
                minStartDate = startDateList.get(0);
            }
            if(endDateList != null && endDateList.size() != 0)
            {           
                endDateList.sort();
                maxEndDate = endDateList.get(endDateList.size()-1);
            }
            for(QuoteLineItem quo : listMediaItem)
            {
                if(quo.Fair_Market_Value_Price__c != null)
                    mediaValueClientReport += quo.Fair_Market_Value_Price__c;
                if(quo.Est_Impressions__c != null)
                    impressionsValueClientReport += quo.Est_Impressions__c;
            }
            if(mediaValueClientReport != 0 || mediaValueClientReport != 0.00)
                mediaValueClientReportString = '$'+String.valueOf(mediaValueClientReport);
            if(impressionsValueClientReport != 0 || impressionsValueClientReport != 0.00)
                impressionsValueClientReportString = '$'+String.valueOf(impressionsValueClientReport);
            for(QuoteLineItem quo : listECAItem)
            {
                if(quo.Fair_Market_Value_Price__c != null)
                    capabilitiesValueClientReport += quo.Fair_Market_Value_Price__c;
            }
            if(capabilitiesValueClientReport != 0 || capabilitiesValueClientReport != 0.00)
                capabilitiesValueClientReportString = '$'+String.valueOf(capabilitiesValueClientReport);
            for(QuoteLineItem quo : listDataItem)
            {
                if(quo.Fair_Market_Value_Price__c != null)
                    DataValueClientReport += quo.Fair_Market_Value_Price__c;
            }
            if(DataValueClientReport != 0 || DataValueClientReport != 0.00)
                DataValueClientReportString = '$'+String.valueOf(DataValueClientReport);
            
        }
    }
    
    public PageReference save()
    {
       
        try
        {
        PageReference pdfPage = Page.MD_ClientprojectedvaluereportPDF;
        pdfPage.getParameters().put('id',quote.id);
        Blob pdfBlob = pdfPage.getContent();
        Attachment a = new Attachment(parentId = quote.id, name=quote.name + '.pdf', body = pdfBlob);
        insert a;
        }
        catch(Exception e){}   
        return cont.view();
    }
    
    
    public PageReference saveInternalReport()
    {
        try
        {
        PageReference pdfPage = Page.MD_InternalReportPDF;
        pdfPage.getParameters().put('id',quote.id);
        Blob pdfBlob = pdfPage.getContent();
        Attachment a = new Attachment(parentId = quote.id, name=quote.name + '.pdf', body = pdfBlob);
        insert a;
        }
        catch(Exception e){}
        return cont.view();
    }
    
    
    public PageReference saveTeamReport()
    {
        try
        {
        PageReference pdfPage = Page.MD_TeamReportPDF;
        pdfPage.getParameters().put('id',quote.id);
        Blob pdfBlob = pdfPage.getContent();
        Attachment a = new Attachment(parentId = quote.id, name=quote.name + '.pdf', body = pdfBlob);
        insert a;
        }
        catch(Exception e){}
        return cont.view();
    }
    
    
    
    
    
    
    
}