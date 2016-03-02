trigger ITPR_FieldsCheck on ITPR__c (before insert, before update) {
   for(ITPR__c ITPRObject : Trigger.new){
     //check for contract value when request type is Change Order
     if(ITPRObject.Request_Type__c == 'Change Order' && ITPRObject.If_Chg_Order_Provide_Orig_Contract_Value__c == null){
        ITPRObject.If_Chg_Order_Provide_Orig_Contract_Value__c.addError('Please provide Original value since you have selected Change Order');
     }
     //check for request type other than RFI/RFP
     if(ITPRObject.Request_Type__c != 'RFI' && ITPRObject.Request_Type__c != 'RFP'){
        if(ITPRObject.Supplier_Name__c == null){
            ITPRObject.Supplier_Name__c.addError('Please enter the name of the Supplier');
        }
        if(ITPRObject.Supplier_Contact_Name__c == null){
            ITPRObject.Supplier_Contact_Name__c.addError('Please enter the contact name of the Supplier');
        }
       /* if(ITPRObject.Supplier_Contact_Phone_Number__c == null){
            ITPRObject.Supplier_Contact_Phone_Number__c.addError('Please enter the contact phone number of the Supplier');
        }*/
        if(ITPRObject.Supplier_Contact_Email__c == null){
            ITPRObject.Supplier_Contact_Email__c.addError('Please enter the contact email of the Supplier');
        }
        if(ITPRObject.Status__c == 'In Process' && ITPRObject.Any_Noteworthy_Exceptional_Risk__c == null){
            ITPRObject.Any_Noteworthy_Exceptional_Risk__c.addError('Any Noteworthy/Exceptional Risk? should be selected');
        }//code to be added
        if(ITPRObject.Status__c == 'In Process' && ITPRObject.Will_Supplier_Retain_Rights_To_New_IP__c == null){
            ITPRObject.Will_Supplier_Retain_Rights_To_New_IP__c.addError('Will Supplier Retain Rights To New IP? should be selected');
        }//code to be added
        
        if(ITPRObject.Status__c == 'In Process' && ITPRObject.Are_There_Fees_For_Early_Termination__c == null){
            ITPRObject.Are_There_Fees_For_Early_Termination__c.addError('Are There Fees For Early Termination? should be selected');
        }//code to be added
        if(ITPRObject.Status__c == 'In Process' && ITPRObject.Expiration_Date__c == null){
            ITPRObject.Expiration_Date__c.addError('Please enter the Expiration date');
        }
     }
     if(ITPRObject.Engagement_Of_A_New_Supplier__c != null && ITPRObject.Engagement_Of_A_New_Supplier__c == 'Yes'){
        if(ITPRObject.New_Supplier_Financial_Analysis_Done__c == null){
            ITPRObject.Engagement_Of_A_New_Supplier__c.addError('Please select a value.');
        }
     }
     if(ITPRObject.Status__c == 'In Process' && (ITPRObject.Request_Type__c == 'COA' || ITPRObject.Request_Type__c == 'Change In Existing Master' || ITPRObject.Request_Type__c == 'New Master')){
        if(ITPRObject.Standard_Indemnifications_Including_IP__c == null){
            ITPRObject.Standard_Indemnifications_Including_IP__c.addError('Please select a value.');
        }
        if(ITPRObject.Are_There_Exceptions_To_LoL__c == null){
            ITPRObject.Are_There_Exceptions_To_LoL__c.addError('Please select a value.');
        }
     }
     
     if(ITPRObject.Request_Type__c == 'NDA'){
        if(ITPRObject.Who_Will_Be_Disclosing_Information__c == null){
            ITPRObject.Who_Will_Be_Disclosing_Information__c.addError('Please select a value.');
        }
        if(ITPRObject.Is_this_NDA_to_be_mutual_or_will_the_com__c == null){
            ITPRObject.Is_this_NDA_to_be_mutual_or_will_the_com__c.addError('Please select a value.');
        }
        if(ITPRObject.If_NDA_Needs_To_Be_Predated_Enter_Date__c == null){
            ITPRObject.If_NDA_Needs_To_Be_Predated_Enter_Date__c.addError('Please enter the date.');
        }
        if(ITPRObject.Supplier_s_Legal_Entity_Name__c == null){
            ITPRObject.Supplier_s_Legal_Entity_Name__c.addError('Please enter the legal entity name of the supplier.');
        }
        if(ITPRObject.State_Or_Country_Of_Formation__c == null){
            ITPRObject.State_Or_Country_Of_Formation__c.addError('Please enter a value.');
        }
        if(ITPRObject.Supplier_Physical_Address__c == null){
            ITPRObject.Supplier_Physical_Address__c.addError('Please enter a value.');
        }
        if(ITPRObject.Addressee_Name__c == null){
            ITPRObject.Addressee_Name__c.addError('Please enter a value.');
        }
        if(ITPRObject.Type_Of_Information__c == null){
            ITPRObject.Type_Of_Information__c.addError('Please enter the type of information.');
        }
        if(ITPRObject.Duration_Of_NDA__c == null){
            ITPRObject.Duration_Of_NDA__c.addError('Please enter a value.');
        }
     }
   }
}