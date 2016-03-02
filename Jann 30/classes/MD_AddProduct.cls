/* *************************************************
ClassName: MD_AddProduct
Purpose:  It's a controller class for the VF page: MD_FIND_A_PRODUCT
This class is used to add Granular products to the opportunity. 
*************************************************  */  
public class MD_AddProduct
{
    Public String passingValue{get;set;}
    public String asstName { get; set;}
    public id orgid{get;set;}   
    public List<Opportunity> listPartMarket{get;set;} 
    public List<Product2> listProduct{get;set;} 
    public Opportunity opp{get;set;}   
    public class MyException extends Exception{}
    public List<Product2> filteredproducts{get;set;}
    public String productType{get;set;}
    public String productCategory{get;set;}
    public String dayPart{get;set;}
    public Date startDate{get;set;}
    public Date endDate{get;set;}
    public String noOfSlots{get;set;}
    public String productName{get;set;}
    public Product2 prod{get;set;}
    public List<WrapperForProductsAndCheckbox> listWrap{get;set;}
    public List<Product2> listToBeSentToOpp{get;set;}
    public boolean showField{get;set;} 
    public boolean showField1{get;set;} 
    public boolean showField2{get;set;} 
    public boolean showField3{get;set;}
    public boolean showField4{get;set;}  
    public List<Product2> listECAsset{get;set;} 
    public List<Product2> listDataAsset{get;set;} 
    public List<PricebookEntry> pricebookentries{get;set;} //Satti
    public boolean showAsset{get;set;} 
    public List<Product2> listProductForInsertion{get;set;}
    Id oppId{get;set;}
    public List<Product2> listToBeDeleted{get;set;}
    public String prodName{get;set;}
    public String Measurement{get;set;}
    public Set<Id> setOfSelectedIds{get;set;}    
    public SelectOption[] selectedContacts { get; set; }
    public SelectOption[] allContacts { get; set; }
    public String message { get; set; }
    public list<String> states {get;set;}
    public list<String> states2 {get;set;}
    public list<String> states3 {get;set;}
    List<Product2> products {get;set;}    
    public SelectOption[] selectedDMA { get; set; }
    public SelectOption[] allDMA { get; set; }
    public list<String> dma {get;set;}
    public list<String> dma2 {get;set;}
    public list<String> dma3 {get;set;}
    public list<String> dma4 {get;set;}
    List<Product2> productsForDMA {get;set;}    
    public SelectOption[] selectedZIP { get; set; }
    public SelectOption[] allZIP { get; set; }
    public list<String> zips {get;set;}
    public list<String> zips2 {get;set;}
    public list<String> zips3 {get;set;}
    public list<String> zips4 {get;set;}
    List<Product2> productsForZIP {get;set;}    
    public OpportunityLineItem oppli{get;set;}
    public List<OpportunityLineItem> oppliList{get;set;}    
    public boolean showProduct{get;set;}
    public boolean showLineItem{get;set;}
    public List<PricebookEntry> pbeList{get;set;}
    public List<WrapperForLineItemAndProdName> listWrapLI{get;set;}
    ApexPages.standardController m_sc = null;    
    public integer totalRecs {get;set;}
    private integer index = 0;
    private integer blockSize = 500;       
    
    
   public ApexPages.StandardSetController con
    {
        get
        {
            if(con == null)
            {
                con = new ApexPages.StandardSetController(Database.getQueryLocator([select id,Genre__c, Estimate_Impressions__c , Email__c,Name, Description, Delivery_Cost__c, Internal_Cost__c, Fair_Market_Value_Price__c, Product_Type__c,DMA__c, Day_Part__c, Total_Units__c, Start_Date__c, End_Date__c, Lead_Time__c, Measurement__c  from Product2 where id IN:  setOfSelectedIds LIMIT 10]));
                con.setPageSize(5);
            }
            return con;
        }
        set;
    }  
    
     // Pagination begins
      
 
    public void previous()
    {
        index = index - blockSize;
        fetchproducts();
    }
  
    public void next()
    {
        index = index + blockSize;
        fetchproducts();
    } 
  
    public boolean getprev()
    {
        if(index == 0){
            fetchproducts();
        return true;
        }
        else{
          fetchproducts();
        return false;
        }
    }
  
    public boolean getnxt()
    {
        if((index + blockSize) >= totalRecs){
            fetchproducts();
            return true;
        }
        else{
            fetchproducts();
            return false;
        }
    }        
      
    //Pagination ends  
   
   //Default constructor
    public MD_AddProduct()    
    {  
    showProduct=true;
    showLineItem=false;
    listProduct = new List<Product2>();
    listWrapLI = new List<WrapperForLineItemAndProdName>();
    oppliList = new List<OpportunityLineItem>();
    pbeList = new List<PricebookEntry>();        
    selectedContacts = new List<SelectOption>();
    products = [select state__c from Product2 where state__c !=''];
    Map<String,Product2> uniqueStates = New Map<String,Product2>();
    List<Product2> list1 = new List<Product2>();
    for(Product2 ast :products){
    uniqueStates.put(ast.state__c,ast);
    }
    list1 = uniqueStates.values();
        
        allContacts = new List<SelectOption>();
        for ( Product2 c : list1) {
        allContacts.add(new SelectOption(c.Id, c.State__c));
        }     
        selectedDMA = new List<SelectOption>();
        productsForDMA = [select DMA__c from Product2 where DMA__c !=''];
     
    Map<String,Product2> uniqueDMA = New Map<String,Product2>();
    List<Product2> listDMA = new List<Product2>();
    for(Product2 ast :productsForDMA){
    uniqueDMA.put(ast.DMA__c,ast);
    }
    listDMA = uniqueDMA.values();
        
        allDMA = new List<SelectOption>();
        for ( Product2 c : listDMA) {
        allDMA.add(new SelectOption(c.Id, c.DMA__c));
        }

        selectedZIP = new List<SelectOption>();
        productsForZIP = [select ZIP__c from Product2 where ZIP__c != null];
     
    Map<String,Product2> uniqueZIP = New Map<String,Product2>();
    List<Product2> listZIP = new List<Product2>();
    for(Product2 ast :productsForZIP){
    uniqueZIP.put(ast.ZIP__c,ast);
    }
    listZIP = uniqueZIP.values();
        
        allZIP = new List<SelectOption>();
        for ( Product2 c : listZIP) {
        allZIP.add(new SelectOption(c.Id, c.ZIP__c));
        }            
        prod =  new Product2();
        filteredproducts = new List<Product2>();
        listWrap = new List<WrapperForProductsAndCheckbox>();
        listToBeSentToOpp =  new List<Product2>();
        pricebookentries=new List<PricebookEntry>(); //satti
    }
                
           
    //Parameterized constructor
    public MD_AddProduct(ApexPages.StandardController controller)    
     {  
        
        m_sc = controller;
        oppli=new OpportunityLineItem();
        listWrapLI = new List<WrapperForLineItemAndProdName>();
        pbeList = new List<PricebookEntry>();    
        listProduct = new List<Product2>();
        showProduct=true;
        showLineItem=false;         
        showField=true;  
        showField1=true;
        showField2=true;
        showField3=true;
        showField4=true;         
        showAsset=false;   
        
        
        oppId = ApexPages.currentPage().getParameters().get('id');
        if(oppId == null)
            opp= (Opportunity)controller.getRecord(); 
        else
            opp = [select id, ownerId, CloseDate, Name, StageName, AccountId, Funding_Source__c, Probability from Opportunity where id =: oppId];
        prod =  new Product2();
        filteredproducts = new List<Product2>();
        listWrap = new List<WrapperForProductsAndCheckbox>();
          
      }
      
/* **************************************************************************
ClassName: WrapperForproductsAndCheckbox
Purpose  : Wrapper class for selecting product from MD_FIND_A_PRODUCT page.
**************************************************************************  */
            
      
      public Class WrapperForproductsAndCheckbox
      {
        public Product2 prodInstance{get;set;}
        public boolean checkBox{get;set;}
      }
      
      
/* *************************************************************************
ClassName: WrapperForLineItemAndProdName 
Purpose: Wrapper class for displaying product name for respective OpportunityLineItems.
***************************************************************************  */
     
      public Class WrapperForLineItemAndProdName 
      {
        public OpportunityLineItem oppLineItem{get;set;}
        public String prodName{get;set;}
        public String Measurement{get;set;}
      }
      
             
            
/* *************************************************
MethodName : fetchproducts
Purpose    : Called when clicked on 'Go' button
*************************************************  */
     
      public PageReference fetchproducts()
      { 
      
       message = 'Selected States: ';
       states = new list<string>();
       states2 = new list<string>();
       states3 = new list<string>();
  
        for ( SelectOption so : selectedContacts )
        {
           states.add(so.getLabel());
        }
        
        for ( SelectOption so : selectedContacts )
        {
            states2.add(so.getLabel());
        }
        
        for ( SelectOption so : selectedContacts )
        {
            states3.add(so.getLabel());
        }
        
       message = 'Selected DMA: ';
       dma = new list<string>();
       dma2 = new list<string>();
       dma3 = new list<string>();
       dma4 = new list<string>();
       for ( SelectOption so : selectedDMA )
        {
          dma.add(so.getLabel());
        }
        
        for ( SelectOption so : selectedDMA )
        {
           dma2.add(so.getLabel());
        }
        
        for ( SelectOption so : selectedDMA )
        {
           dma3.add(so.getLabel());
        }
        
        for ( SelectOption so : selectedDMA )
        {
           dma4.add(so.getLabel());
        }
      
       message = 'Selected DMA: ';
       zips = new list<string>();
       zips2 = new list<string>();
       zips3 = new list<string>();
       zips4 = new list<string>();
       for ( SelectOption so : selectedZIP )
        {
          zips.add(so.getLabel());
        }
        
        for ( SelectOption so : selectedZIP )
        {
           zips2.add(so.getLabel());
        }
        
        for ( SelectOption so : selectedZIP )
        {
           zips3.add(so.getLabel());
        }
        
        for ( SelectOption so : selectedZIP )
        {
           zips4.add(so.getLabel());
        }
        
         //Media + CCIV
          Set<String> setOfStates = new Set<String>();
          setOfStates.addAll(states);
          Set<String> setOfDMA = new Set<String>();
          setOfDMA.addAll(dma);
          Set<String> setOfZip = new Set<String>();
          setOfZip.addAll(zips);
          
          //Media + OOH
          Set<String> setOfStates2 = new Set<String>();
          setOfStates2.addAll(states2);
          Set<String> setOfDMA2 = new Set<String>();
          setOfDMA2.addAll(dma2);
          Set<String> setOfZip2 = new Set<String>();
          setOfZip2.addAll(zips2);
          
          //Media + Transit
          Set<String> setOfStates3 = new Set<String>();
          setOfStates3.addAll(states3);
          Set<String> setOfDMA3 = new Set<String>();
          setOfDMA3.addAll(dma3);
          Set<String> setOfZip3 = new Set<String>();
          setOfZip3.addAll(zips3);
          
          //Media + Cinema
          Set<String> setOfDMA4 = new Set<String>();
          setOfDMA4.addAll(dma4);
          Set<String> setOfZip4 = new Set<String>();
          setOfZip4.addAll(zips4);
                            
          system.debug('Inside the fetch Asset');          
          filteredproducts.clear();
          listWrap.clear();
          productType=prod.Product_Type__c;
          productCategory=prod.Product_Category__c;
          dayPart=prod.Day_Part__c;
          startDate=prod.Start_Date__c;
          endDate=prod.End_Date__c;
          noOfSlots=prod.Number_of_Slots__c;
          productName=prodName;
         
                 
         if(productCategory == 'Capability' || productCategory == 'Data' || productCategory == null || productCategory == '' || productCategory == '--None--')
          {
              if(productCategory != null && (productName == null || productName == ''))
                  filteredproducts = [select id,Genre__c,Name,Email__c, Description,Internal_Cost__c,Fair_Market_Value_Price__c,Product_Type__c, Measurement__c from Product2 where Product_Category__c=:productCategory];
              else if(productCategory == null && productName != null)
                  filteredproducts = [select id,Genre__c,Name,Email__c, Description,Internal_Cost__c,Fair_Market_Value_Price__c,Product_Type__c, Measurement__c from Product2 where Name=:productName];
              else if(productCategory != null && productName != null)
                  filteredproducts = [select id,Genre__c,Name,Email__c, Description,Internal_Cost__c,Fair_Market_Value_Price__c,Product_Type__c, Measurement__c from Product2 where (Product_Category__c=:productCategory AND Name=:productName)];
          }   
          if(productCategory == 'Media' && productType == 'CCIV')
          {
            system.debug('inside cciv');
            List<Product2> allproducts = [select id,Name,Genre__c,Product_Category__c,Estimate_Impressions__c ,Email__c, Property__c,Delivery_Cost__c, End_Date__c ,Channel__c ,State__c ,DMA__c ,Zip__c ,Customer_Name__c , Description,Internal_Cost__c,Fair_Market_Value_Price__c,Product_Type__c,Day_Part__c,Start_Date__c, Measurement__c from Product2 where (Product_Type__c = 'CCIV' AND Product_Category__c= 'Media')];
            for(Product2 asset : allproducts)
            {   
                    Integer i = 0;
                    system.debug('asset name a' +asset.Name);
                    if((prod.Day_Part__c != null && asset.Day_Part__c != prod.Day_Part__c) || 
                    (prod.Start_Date__c != null && asset.Start_Date__c != prod.Start_Date__c) || (prod.End_Date__c != null && asset.End_Date__c != prod.End_Date__c) || (prod.Channel__c!= null && asset.Channel__c!= prod.Channel__c) || (prod.Customer_Name__c != null && asset.Customer_Name__c != prod.Customer_Name__c)
                    || (asstName != '' && asset.Name != asstName))
                    {
                        i=1;
                    }
                        if(i != 1)
                    {
                       
                        if(setOfStates.size() == 0 && setOfDMA.size() == 0 && setOfZip.size() == 0)
                            filteredproducts.add(asset);
                        else
                        { 
                            if(setOfStates.contains(asset.State__c) || setOfDMA.contains(asset.DMA__c) || setOfZip.contains(asset.Zip__c))
                                filteredproducts.add(asset);
                        }                  
                    }    
                          }
          }
         if(productType == 'OOH' && productCategory == 'Media')
         
          {
            List<Product2> allproducts = [select id,Product_Category__c,Name,Estimate_Impressions__c , Email__c, End_Date__c , Delivery_Cost__c, Channel__c ,State__c ,DMA__c ,Zip__c ,Customer_Name__c , Description,Internal_Cost__c,Fair_Market_Value_Price__c,Product_Type__c,Day_Part__c,Start_Date__c, Measurement__c from Product2 where (Product_Type__c = 'OOH' AND Product_Category__c= 'Media')];
            for(Product2 asset : allproducts)
            {
                Integer i = 0;
                if((prod.Day_Part__c != null && asset.Day_Part__c != prod.Day_Part__c) || 
                (prod.Start_Date__c != null && asset.Start_Date__c != prod.Start_Date__c) || (prod.End_Date__c != null && asset.End_Date__c != prod.End_Date__c)
                || (asstName != '' && asset.Name != asstName))
                {
                    i=1;
                    
                }
       
                if(i != 1)
                {
                    
                    if(setOfStates.size() == 0 && setOfDMA.size() == 0 && setOfZip.size() == 0)
                    {
                        filteredproducts.add(asset);
                       
                    }
                    else
                    { 
                        if(setOfStates.contains(asset.State__c) || setOfDMA.contains(asset.DMA__c) || setOfZip.contains(asset.Zip__c))
                        {
                            filteredproducts.add(asset);
                            
                        }
                    }                  
                }               
            }
          }
      
          if(productType == 'Transit' && productCategory == 'Media')
          {
           
            List<Product2> allproducts = [select id,Genre__c,Product_Category__c,Name, Email__c, Estimate_Impressions__c , End_Date__c ,Delivery_Cost__c, Channel__c ,State__c ,DMA__c ,Zip__c ,Customer_Name__c , Description,Internal_Cost__c,Fair_Market_Value_Price__c,Product_Type__c, Day_Part__c,Start_Date__c from Product2 where (Product_Type__c = 'Transit' AND Product_Category__c= 'Media')];
            for(Product2 asset : allproducts)
            {
                Integer i = 0;
                if((prod.Day_Part__c != null && asset.Day_Part__c != prod.Day_Part__c) || 
                (prod.Start_Date__c != null && asset.Start_Date__c != prod.Start_Date__c) || (prod.End_Date__c != null && asset.End_Date__c != prod.End_Date__c)
                || (asstName != '' && asset.Name != asstName))
                {
                    i=1;
                }
               
                if(i != 1)
                {
                    
                    if(setOfStates.size() == 0 && setOfDMA.size() == 0 && setOfZip.size() == 0)
                        filteredproducts.add(asset);
                    else
                    { 
                        if(setOfStates.contains(asset.State__c) || setOfDMA.contains(asset.DMA__c) || setOfZip.contains(asset.Zip__c))
                            filteredproducts.add(asset);
                    }                  
                }               
            }
          }       
   
          if(productType == 'Cinema' && productCategory == 'Media')
          {
           
            List<Product2> allproducts = [select id,Product_Category__c,Genre__c, Name, Email__c, Estimate_Impressions__c , End_Date__c ,Delivery_Cost__c, Channel__c ,State__c ,DMA__c ,Zip__c ,Customer_Name__c , Description,Internal_Cost__c,Fair_Market_Value_Price__c,Product_Type__c, Day_Part__c,Start_Date__c, Measurement__c from Product2 where (Product_Type__c = 'Cinema' AND Product_Category__c= 'Media')];
            for(Product2 asset : allproducts)
            {
                Integer i = 0;
                
                if((prod.Day_Part__c != null && asset.Day_Part__c != prod.Day_Part__c) || 
                (prod.Start_Date__c != null && asset.Start_Date__c != prod.Start_Date__c) || (prod.End_Date__c != null && asset.End_Date__c != prod.End_Date__c) || (prod.Genre__c != null && asset.Genre__c != prod.Genre__c) 
                || (asstName != '' && asset.Name != asstName))
                {
                    i=1;
                }
                
                if(i != 1)
                {
                   
                    if(setOfDMA.size() == 0 && setOfZip.size() == 0)
                        filteredproducts.add(asset);
                    else
                    { 
                        if(setOfDMA.contains(asset.DMA__c) || setOfZip.contains(asset.Zip__c))
                            filteredproducts.add(asset);
                    }                  
                }               
            }
          }
          if(productCategory == 'Media' && productType != 'CCIV' && productType != 'Cinema' && productType != 'OOH' && productType != 'Transit')
          {
            List<Product2> allproducts = [select id,Genre__c,Product_Category__c,Name, Email__c, Estimate_Impressions__c , End_Date__c ,Delivery_Cost__c, Channel__c ,State__c ,DMA__c ,Zip__c ,Customer_Name__c , Description,Internal_Cost__c,Fair_Market_Value_Price__c,Product_Type__c, Day_Part__c,Start_Date__c,Measurement__c from Product2];
            for(Product2 asset : allproducts)
            {
                Integer i = 0;
                if((prod.Product_Type__c != null && asset.Product_Type__c != prod.Product_Type__c) || (prod.Day_Part__c != null && asset.Day_Part__c != prod.Day_Part__c) || 
                (prod.Start_Date__c != null && asset.Start_Date__c != prod.Start_Date__c) || (prod.End_Date__c != null && asset.End_Date__c != prod.End_Date__c) || (asstName != '' && asset.Name != asstName))
                {
                    i=1;
                    
                }
                if(i != 1 && asset.Product_Category__c== productCategory)
                {
                    filteredproducts.add(asset);
                                   }
            }
          }
          if((productCategory == '' || productCategory == null || productCategory == '--None--') && (asstName != '' || asstName != null))
          {
            List<Product2> allproducts = [select id,Genre__c,Product_Category__c,Name, Email__c, Estimate_Impressions__c , End_Date__c ,Delivery_Cost__c, Channel__c ,State__c ,DMA__c ,Zip__c ,Customer_Name__c , Description,Internal_Cost__c,Fair_Market_Value_Price__c,Product_Type__c, Day_Part__c,Start_Date__c, Measurement__c from Product2 where Name LIKE: asstName];
            for(Product2 asset : allproducts)
            {
                filteredproducts.add(asset);                    
            }
          }

                   
          Set<ID> setOfIds = new Set<ID>();
          for(Product2 assetIns : filteredproducts)
          {
          
          setOfIds.add(assetIns.Id);      
          
          
          }
          List<Product2> finalList = new List<Product2>();
          finalList = [select id,Genre__c,Product_Category__c,Name, Email__c, Estimate_Impressions__c , End_Date__c ,Delivery_Cost__c, Channel__c ,State__c ,DMA__c ,Zip__c ,Customer_Name__c , Description,Internal_Cost__c,Fair_Market_Value_Price__c,Product_Type__c, Day_Part__c,Start_Date__c, Property__c, Measurement__c from Product2 where id in: setOfIds ORDER BY Channel__c, DMA__c, Genre__c ];
          List<Product2> subItems =new List<Product2>();
          if(finalList.size()>0){     
     integer indexs=0;
          if(finalList.size()<index+blocksize)
          {
          indexs=finalList.size();
          }else{
          indexs=index+blocksize;
          }
          
          
          
          for(integer i=index;i<indexs;i++){
            subItems.add(finalList.get(i));
          }  
          }
          for(Product2 assetIns : subItems)
          {
            WrapperForproductsAndCheckbox wrap =  new WrapperForproductsAndCheckbox();
            wrap.prodInstance = assetIns;
            wrap.checkBox = false;  
            listWrap.add(wrap);
          }       
    
          
          
          
          for(WrapperForproductsAndCheckbox abc : listWrap)
          {
              system.debug('abc.prodInstance.Name####'+abc.prodInstance.Name);
          }

          Set<Product2> setOfSelectedproducts = new Set<Product2>();
          filteredproducts.clear();
          for(Product2 a : setOfSelectedproducts)
          {
            filteredproducts.add(a);
            setOfSelectedIds.add(a.Id);
          }     
   
           return null;
           
      }  
       
      
/* *************************************************
MethodName: selectProducts
Purpose: Called when clicked on 'Select' button
*************************************************  */
           
     public void selectProducts()
     {
        showProduct=false;
        showLineItem=true; 
        system.debug('inside selectProducts'+ listProduct);
    
        showAsset=false; 
        for(WrapperForproductsAndCheckbox wr : listWrap)
        {
            if(wr.checkBox == true)
                listToBeSentToOpp.add(wr.prodInstance);
        }
   
        Set<Id> setOfIds = new Set<Id>();
        for(Product2 idprod : listToBeSentToOpp)
        {
            setOfIds.add(idprod.id);
        }
        List<Product2> listOfproductsForOppPage = [select id, Genre__c, Estimate_Impressions__c , Email__c,Description, Delivery_Cost__c, Internal_Cost__c, Fair_Market_Value_Price__c, Product_Type__c,Name, DMA__c, Day_Part__c, Total_Units__c, Start_Date__c, End_Date__c, Lead_Time__c, Measurement__c  from Product2 where id IN: setOfIds];
        system.debug('listOfproductsForOppPage is '+listOfproductsForOppPage);
        for(Product2 ast : listOfproductsForOppPage)
        {
           
                    listProduct.add(ast);
                    system.debug('Pri test '+ast);
                    
               
        }
        Set<Product2> setProducts = new Set<Product2>();
        
        for(Product2 a1 : listProduct)
        {
            setProducts.add(a1);
        }
        listProduct.clear();
        
        for(Product2 a1 : setProducts)
        {
            
            listProduct.add(a1);
           
        }
        Id opportId = ApexPages.currentPage().getParameters().get('id');
        Opportunity oppForLI = [select id from Opportunity where id =: opportId];
        
    //    List<PricebookEntry> pricebookentries=new List<PricebookEntry>();
         pricebookentries = [select id, UnitPrice,IsActive,Product2Id from PricebookEntry where Product2Id IN:listProduct];   
         System.debug('*******pricebookentries*******'+pricebookentries);
        
        for(Product2 p : listProduct)
        {
            OpportunityLineItem oppLI = new OpportunityLineItem();
            //PricebookEntry priceBookEnt = [select id, UnitPrice,IsActive from PricebookEntry where Product2Id =: p.id];
            System.debug('product id'+p.id);
            
          // PricebookEntry priceBookEnt =pricebookentries.get(p.id);
              PricebookEntry priceBookEnt;
            for (PricebookEntry  pbe : pricebookentries )
            {
               if( pbe.Product2Id == p.id)
               {
                   priceBookEnt = pbe;
                   break;
               }
                
            }
            
            if(!priceBookEnt.IsActive)
            {
                priceBookEnt.IsActive = true;
            }
            pbeList.add(priceBookEnt);
            if(priceBookEnt != null)
            {
                oppLI.UnitPrice = priceBookEnt.UnitPrice;
                            
            }

            oppLI.Opportunity = oppForLI;
            oppLI.OpportunityId = oppForLI.id;
            oppLI.pricebookentryid=priceBookEnt.id;
            WrapperForLineItemAndProdName wrap =  new WrapperForLineItemAndProdName(); 
            wrap.prodName = p.Name;
    /* Kushal */        
            wrap.Measurement = p.Measurement__c;
    /* Kushal */        
            wrap.oppLineItem = oppLI;
            listWrapLI.add(wrap);
        }
        if(pbeList != null && pbeList.size() != 0)
            update pbeList;        
        
        }
                   
      
/* *************************************************
MethodName: renderFields
Purpose: For Rendering fields based on category - type combinations.
*************************************************  */    
     
     public void renderFields()
     {
     
     if(prod.Product_Category__c=='Data'||prod.Product_Category__c=='Capability')
     {
     showField1=false; 
     showField=false; 
     showField2=false;
     showField3=false;  
     showField4=false; 
     }
     else
     {
     showField=true;  
     } 
     }   
     
          
/* *************************************************
MethodName: renderMedia
Purpose:Rendering fields for Media category 
*************************************************  */
         
     public void renderMedia()
     {     
     if(prod.Product_Category__c=='Media' && prod.Product_Type__c=='CCIV') 
     {
      showField1=true; 
      showField2=false; 
      showField3=false; 
      showField4=false; 
          
     }
     else if(prod.Product_Category__c=='Media' && prod.Product_Type__c=='Cinema')
     {
     showField2=true; 
     showField1=false; 
     showField3=false; 
     showField4=false;
     }    
     
     else if(prod.Product_Category__c=='Media' && prod.Product_Type__c=='OOH')
     {
     showField3=true; 
     showField2=false; 
     showField1=false;
     showField4=false; 
     }    
     
     else if(prod.Product_Category__c=='Media' && prod.Product_Type__c=='Transit')
     {
     showField4=true; 
     showField2=false; 
     showField1=false;
     showField3=false;
     }     
          
     else
     {
     showField1=false;  
     showField2=false;
     showField3=false; 
     showField4=false; 
     }     
     
     } 
    
         
/* *************************************************
MethodName: saveOppLineItem
Purpose: Logic for saving OpportunityLineItems
*************************************************  */   
 
    
    public pageReference saveOppLineItem()
    {
        List<OpportunityLineItem> listToInsert = new List<OpportunityLineItem>();
        Id opportId = ApexPages.currentPage().getParameters().get('id');
        Opportunity oppForLI = [select id from Opportunity where id =: opportId];
        for(WrapperForLineItemAndProdName ins : listWrapLI)
        {
                       
            listToInsert.add(ins.oppLineItem);
            system.debug('opp is:'+ins.oppLineItem.Opportunity);
        }
        for(OpportunityLineItem a1 : listToInsert)
        {
            system.debug('a1***'+a1.Opportunity);
        }
        insert listToInsert;
        PageReference pg = new PageReference('/'+opportId);
        return pg;
    }  
    
    
        public void dynamicFetch()
    
    {
    system.debug('Inside fetch');
    if(prod.Product_Category__c=='Data'||prod.Product_Category__c=='Capability')
     {
     showField1=false; 
     showField=false; 
     showField2=false;
     showField3=false;  
     showField4=false; 
     system.debug('Inside if');
     }
     else
     {
     showField=true;  
     system.debug('Inside else');
     } 
     
     
     
     if(prod.Product_Category__c=='Media' && prod.Product_Type__c=='CCIV') 
     {
      showField1=true; 
      showField2=false; 
      showField3=false; 
      showField4=false; 
          
     }
     else if(prod.Product_Category__c=='Media' && prod.Product_Type__c=='Cinema')
     {
     showField2=true; 
     showField1=false; 
     showField3=false; 
     showField4=false;
     }    
     
     else if(prod.Product_Category__c=='Media' && prod.Product_Type__c=='OOH')
     {
     showField3=true; 
     showField2=false; 
     showField1=false;
     showField4=false; 
     }    
     
     else if(prod.Product_Category__c=='Media' && prod.Product_Type__c=='Transit')
     {
     showField4=true; 
     showField2=false; 
     showField1=false;
     showField3=false;
     }     
          
     else
     {
     showField1=false;  
     showField2=false;
     showField3=false; 
     showField4=false; 
     }  
     
    system.debug('passingValue***'+passingValue);
    //List<SelectOption> selectedContacts= new List<SelectOption>();
    
    //States based on Prod Type
    
    selectedContacts = new List<SelectOption>();
    String bind = passingValue;
    products = [select state__c from Product2 where state__c!= null AND Product_Type__c=:bind order by state__c];
    system.debug('***products*****'+products);
    Map<String,Product2> uniqueStates = New Map<String,Product2>();
    List<Product2> list1 = new List<Product2>();
    for(Product2 ast :products){
    uniqueStates.put(ast.state__c,ast);
    }
    list1 = uniqueStates.values();
        
        allContacts = new List<SelectOption>();
        for ( Product2 c : list1) {
        allContacts.add(new SelectOption(c.Id, c.State__c));
        }  
    system.debug('****allContacts******'+allContacts.size());
    
    
    //DMA based on Prod Type
    
     selectedDMA = new List<SelectOption>();
     productsForDMA = [select DMA__c from Product2 where DMA__c !=null AND Product_Type__c=:bind order by DMA__c];
     system.debug('***productsForDMA *****'+productsForDMA);
     
    Map<String,Product2> uniqueDMA = New Map<String,Product2>();
    List<Product2> listDMA = new List<Product2>();
    for(Product2 ast :productsForDMA){
    uniqueDMA.put(ast.DMA__c,ast);
    }
    listDMA = uniqueDMA.values();
        
        allDMA = new List<SelectOption>();
        for ( Product2 c : listDMA) {
        allDMA.add(new SelectOption(c.Id, c.DMA__c));
        }
    
    //ZIP based on Prod Type
        
    selectedZIP = new List<SelectOption>();
    productsForZIP = [select ZIP__c from Product2 where ZIP__c != null AND Product_Type__c=:bind order by ZIP__c] ;
     
    Map<String,Product2> uniqueZIP = New Map<String,Product2>();
    List<Product2> listZIP = new List<Product2>();
    for(Product2 ast :productsForZIP){
    uniqueZIP.put(ast.ZIP__c,ast);
    }
    listZIP = uniqueZIP.values();
        
        allZIP = new List<SelectOption>();
        for ( Product2 c : listZIP) {
        allZIP.add(new SelectOption(c.Id, c.ZIP__c));
    }            
    
    
    
    
    
      
    }   
    }