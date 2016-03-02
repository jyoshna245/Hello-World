/**
* Author,email :     Madel Pascua , mpascua@coca-cola.com
* Date Create  :     Sept 23, 2013
* Description  :     Contains helper methods for Test Classes
*
* REVISION HISTORY
*
* Author,email :
* Date Revised :
* Description  :
*
**/

@isTest //(SeeAllData=true)
public class GS1_TestHelper {
   public static final string REQUEST_PALLET = 'Pallet - Promotion - Amount';
   public static final string REQUEST_CUDU = 'CU/DU - Promotion - Amount'; 
   public static final string REQUEST_CUDU_OTHER = 'CU/DU - Promotion - Quantity'; 
   public static final string REQUEST_CUDU_QUANT = 'CU/DU - Promotion - Other'; 
   
   public class CodeGenerator {
       Set<String> codes = new Set<String>();
       public string generateCode() {
            Integer l=10, u=99;
            String tmp; 
            tmp = String.valueOf(System.currentTimeMillis()) + String.valueOf( getRndInt(l,u));
            while (codes.contains(tmp)) {
                tmp = String.valueOf(System.currentTimeMillis()) + String.valueOf( getRndInt(l,u));
            }
            
            codes.add(tmp);
            return tmp;
       }
       public Integer getRndInt (Integer lower, Integer upper)
       {
            return Math.round((Math.random() * (upper - lower)) + lower);
       }        
   }     
    
   public static List<GS1_Request__c> createRequest(Integer count, String recTypeName) {
       List<GS1_Request__c> recs = new List<GS1_Request__c>();
       List<GS1_Country__c> countries;
       List<GS1_Trademark__c> trademarks;
       List<GS1_Flavour__c> flavours;
       List<GS1_Unit__c> units;
       List<GS1_Unit_Capacity__c> caps;
       List<GS1_Material__c> materials;
       List<GS1_Design__c> designs;
       List<GS1_Multipack__c> multipacks;
       List<GS1_Multipack_Value__c> upps;
       List<GS1_BBN__c> bbns;
       List<GS1_Pallet_Design__c> pdesigns;
       List<GS1_Pallet_Material__c> pmaterials;
       List<GS1_Promo_Other__c> promos;
       List<GS1_Currency__c> currs;
       List<GS1_Promo_Free_Product__c> fprods;
       
       Id rtId;
       
       try {
           GS1_AuthorProfile__c au = GS1_TestHelper.createAuthor(System.UserInfo.getUserId());
           if (au == null) {
               au = [select active__c from GS1_AuthorProfile__c where User__c = : System.UserInfo.getUserId() limit 1];
               if (au != null ) {
                   if (!au.active__c) {
                       au.active__c = true;
                       update au;
                   }
               }
           }
       } catch (Exception e) {}
       
       if (recTypeName == GS1_TestHelper.REQUEST_CUDU || recTypeName == GS1_TestHelper.REQUEST_PALLET || recTypeName == GS1_TestHelper.REQUEST_CUDU_QUANT || recTypeName == GS1_TestHelper.REQUEST_CUDU_OTHER) {
           Map<String,Schema.RecordTypeInfo> rtMapByName = GS1_Request__c.sObjectType.getDescribe().getRecordTypeInfosByName();
           rtId =  rtMapByName.get(recTypeName).getRecordTypeId();                  
       } else {
            return recs;
       }
       
       countries = GS1_TestHelper.createCountry(1);
       trademarks = GS1_TestHelper.createTrademark(1);
       flavours = GS1_TestHelper.createFlavour(trademarks[0], 1);
       units = GS1_TestHelper.createUnitOfMeasurement(1);
       caps = GS1_TestHelper.createUnitOfMeasurementCapacity(units[0], 1);
       materials = GS1_TestHelper.createMaterial(1);
       designs = GS1_TestHelper.createDesign(materials[0], 1);
       multipacks = GS1_TestHelper.createMultipack(1);
       upps = GS1_TestHelper.createMultipackValue(multipacks[0], 1);
       bbns = GS1_TestHelper.createBBN(flavours[0], 1);
       pmaterials = GS1_TestHelper.createPalletMaterial(1);
       pdesigns = GS1_TestHelper.createPalletDesign(pMaterials[0], 1);
       promos = GS1_TestHelper.createPromoOthers(1);
       currs = GS1_TestHelper.createCurrency(1);
       fprods = GS1_TestHelper.createPromoFreeProduct(1);
       
       for (Integer i=1; i<=count; i++) {
           GS1_Request__c req = new GS1_Request__c();
           req.RecordTypeId = rtId;
           req.Country__c = countries[0].id;
           req.Trademark__c = flavours[0].trademark__c;
           req.Flavour__c = flavours[0].id;
           req.Unit__c = units[0].id;
           req.Capacity__c = caps[0].id;           
           req.RequestedByUserId__c = system.Userinfo.getUserId();
           req.Multipack__c = multipacks[0].id;
           req.Units_Pack__c = upps[0].id;
           req.Packs_Case__c = 10;
           req.Material__c = materials[0].id;
           req.design__c = designs[0].id;
           req.promo_other__c = promos[0].id;
           req.promo_currency__c = currs[0].id;
           req.promo_amount__c = 1000;
           req.Promo_Quantity__c = fprods[0].id;
           recs.add(req);
           
           if (recTypeName == GS1_TestHelper.REQUEST_CUDU || recTypeName == GS1_TestHelper.REQUEST_CUDU_OTHER || recTypeName == GS1_TestHelper.REQUEST_CUDU_QUANT) {
            req.BBN__c = bbns[0].id;
           } else if (recTypeName == GS1_TestHelper.REQUEST_PALLET ) {
            req.Pallet_Material__c = pmaterials[0].id;
            req.Pallet_Design__c = pdesigns[0].id;
           }
       }
       
       if (recs.size()>0) {
           insert recs;
       }
       
       return recs;
   }    
   
   public static List<GS1_EAN__c> createBarcodes(boolean cudu, boolean promo, long rangeStart, long rangeEnd) {
        GS1_EAN_CodeGenCtrl generator = new GS1_EAN_CodeGenCtrl();
        List<GS1_EAN__c> recs = new List<GS1_EAN__c>();
        List<String> codes = generator.generateEAN(rangeStart, rangeEnd);
        
        if (codes != null && codes.size() > 0) {
            for (String c : codes) {
                GS1_EAN__c bc = new GS1_EAN__c();
                bc.Property_2__c = cudu ? 'CU/DU' : 'Pallet'; 
                bc.Property_3__c = promo ? 'Promo' : 'Normal';
                bc.Name = c;
                bc.Status__c = 'Free';
                bc.Freed__c = false;
                
                recs.add(bc);
            }               
        }
        
        if (recs.size() > 0) {
            insert recs;
        }
        return recs;
   }
   
   public static GS1_AuthorProfile__c createAuthor(Id userId) {
        GS1_AuthorProfile__c rec = new GS1_AuthorProfile__c();
        rec.User__c = userId;
        try {
            insert rec;
            return rec;
        }
        catch (Exception ex){
            return null;
        }
   }   
   
   public static GS1_CountryAuthor__c createCountryAuthor(Id cId, Id auId) {
        GS1_CountryAuthor__c rec = new GS1_CountryAuthor__c();
        rec.AuthorProfile__c = auId;
        rec.Country__c = cId;
        
        try {
            insert rec;
            return rec;
        }
        catch (Exception ex){
            return null;
        }        
   }
   
   public static List<GS1_Country__c> createCountry(Integer count) {
        List<GS1_Country__c> recs = new List<GS1_Country__c>();
        String code;
        
        GS1_TestHelper.CodeGenerator cg = new GS1_TestHelper.CodeGenerator();
        
        for (Integer i=1; i<=count; i++) {
            code = cg.generateCode(); 
            GS1_Country__c rec = new GS1_Country__c();
            rec.Code__c = code;
            rec.name = 'Test -' + code;
            
            recs.add(rec);              
        }
        
        if (recs.size() > 0) {
            insert recs;
        }
        return recs;   
   }
   
   public static List<GS1_Trademark__c> createTrademark(Integer count) {
        List<GS1_Trademark__c> recs = new List<GS1_Trademark__c>();
        String code;
        
        GS1_TestHelper.CodeGenerator cg = new GS1_TestHelper.CodeGenerator();
        
        for (Integer i=1; i<=count; i++) {
            code = cg.generateCode(); 
            GS1_Trademark__c rec = new GS1_Trademark__c();
            rec.Code__c = code;
            rec.name = 'Test -' + code;
            
            recs.add(rec);              
        }
        
        if (recs.size() > 0) {
            insert recs;
        }
        return recs;        
   }
   
   public static List<GS1_Flavour__c> createFlavour( GS1_Trademark__c tm, Integer count) {
        List<GS1_Flavour__c> recs = new List<GS1_Flavour__c>();
        String code;
        
        GS1_TestHelper.CodeGenerator cg = new GS1_TestHelper.CodeGenerator();
        
        for (Integer i=1; i<=count; i++) {
            code = cg.generateCode(); 
            GS1_Flavour__c rec = new GS1_Flavour__c();
            rec.Code__c = code;
            rec.name = 'Test -' + code;
            rec.Trademark__c = tm.id;
            
            recs.add(rec);              
        }
        
        if (recs.size() > 0) {
            insert recs;
        }
        return recs;            
   }
   
   public static List<GS1_Material__c> createMaterial(Integer count) {
        List<GS1_Material__c> recs = new List<GS1_Material__c>();
        String code;
        
        GS1_TestHelper.CodeGenerator cg = new GS1_TestHelper.CodeGenerator();
        
        for (Integer i=1; i<=count; i++) {
            code = cg.generateCode(); 
            GS1_Material__c rec = new GS1_Material__c();
            rec.Code__c = code;
            rec.name = 'Test -' + code;
            
            recs.add(rec);              
        }
        
        if (recs.size() > 0) {
            insert recs;
        }
        return recs;        
   }
   
   public static List<GS1_Design__c> createDesign( GS1_Material__c mat, Integer count) {
        List<GS1_Design__c> recs = new List<GS1_Design__c>();
        String code;
        
        GS1_TestHelper.CodeGenerator cg = new GS1_TestHelper.CodeGenerator();
        
        for (Integer i=1; i<=count; i++) {
            code = cg.generateCode(); 
            GS1_Design__c rec = new GS1_Design__c();
            rec.Code__c = code;
            rec.name = 'Test -' + code;
            rec.Material__c = mat.id;
            
            recs.add(rec);              
        }
        
        if (recs.size() > 0) {
            insert recs;
        }
        return recs;            
   }
   
   public static List<GS1_Multipack__c> createMultipack(Integer count) {
        List<GS1_Multipack__c> recs = new List<GS1_Multipack__c>();
        String code;
        
        GS1_TestHelper.CodeGenerator cg = new GS1_TestHelper.CodeGenerator();
        
        for (Integer i=1; i<=count; i++) {
            code = cg.generateCode(); 
            GS1_Multipack__c rec = new GS1_Multipack__c();
            rec.Code__c = code;
            rec.name = 'Test -' + code;
            rec.UnitType__c = 'D';
            recs.add(rec);              
        }
        
        if (recs.size() > 0) {
            insert recs;
        }
        return recs;        
   }   
   
   public static List<GS1_Multipack_Value__c> createMultipackValue( GS1_Multipack__c mp, Integer count) {
        List<GS1_Multipack_Value__c> recs = new List<GS1_Multipack_Value__c>();
        //String code;
        
        for (Integer i=1; i<=count; i++) {
            //code = GS1_TestHelper.generateUniqueCode(); 
            GS1_Multipack_Value__c rec = new GS1_Multipack_Value__c();
            rec.name = String.valueOf(i);
            rec.Multipack__c = mp.id;
            
            recs.add(rec);              
        }
        
        if (recs.size() > 0) {
            insert recs;
        }
        return recs;
   }   

   public static List<GS1_Unit__c> createUnitOfMeasurement(Integer count) {
        List<GS1_Unit__c> recs = new List<GS1_Unit__c>();
        String code;
        
        GS1_TestHelper.CodeGenerator cg = new GS1_TestHelper.CodeGenerator();
        
        for (Integer i=1; i<=count; i++) {
            code = cg.generateCode(); 
            GS1_Unit__c rec = new GS1_Unit__c();
            rec.Code__c = code;
            rec.name = 'Test -' + code;
            
            recs.add(rec);              
        }
        
        if (recs.size() > 0) {
            insert recs;
        }
        return recs;        
   }   
   
   public static List<GS1_Unit_Capacity__c> createUnitOfMeasurementCapacity( GS1_Unit__c unit, Integer count) {
        List<GS1_Unit_Capacity__c> recs = new List<GS1_Unit_Capacity__c>();
        
        for (Integer i=1; i<=count; i++) { 
            GS1_Unit_Capacity__c rec = new GS1_Unit_Capacity__c();
            rec.name = String.valueOf(i*10);
            rec.Unit__c = unit.id;
            
            recs.add(rec);              
        }
        
        if (recs.size() > 0) {
            insert recs;
        }
        return recs;            
   }
   
   public static List<GS1_Pallet_Material__c> createPalletMaterial(Integer count) {
        List<GS1_Pallet_Material__c> recs = new List<GS1_Pallet_Material__c>();
        String code;
        
        GS1_TestHelper.CodeGenerator cg = new GS1_TestHelper.CodeGenerator();
        
        for (Integer i=1; i<=count; i++) {
            code = cg.generateCode(); 
            GS1_Pallet_Material__c rec = new GS1_Pallet_Material__c();
            rec.Code__c = code;
            rec.name = 'Test -' + code;
            
            recs.add(rec);              
        }
        
        if (recs.size() > 0) {
            insert recs;
        }
        return recs;        
   }
   
   public static List<GS1_Pallet_Design__c> createPalletDesign( GS1_Pallet_Material__c mat, Integer count) {
        List<GS1_Pallet_Design__c> recs = new List<GS1_Pallet_Design__c>();
        String code;
        
        GS1_TestHelper.CodeGenerator cg = new GS1_TestHelper.CodeGenerator();
        
        for (Integer i=1; i<=count; i++) {
            code = cg.generateCode(); 
            GS1_Pallet_Design__c rec = new GS1_Pallet_Design__c();
            rec.Code__c = code;
            rec.name = 'Test -' + code;
            rec.Pallet_Material__c = mat.id;
            
            recs.add(rec);              
        }
        
        if (recs.size() > 0) {
            insert recs;
        }
        return recs;            
   }      

   public static list<GS1_BBN__c> createBBN( GS1_Flavour__c flv, Integer count) {
        List<GS1_BBN__c> recs = new List<GS1_BBN__c>();
        String code;
        
        GS1_TestHelper.CodeGenerator cg = new GS1_TestHelper.CodeGenerator();
        
        for (Integer i=1; i<=count; i++) {
            code = cg.generateCode(); 
            GS1_BBN__c rec = new GS1_BBN__c();
            rec.Code__c = code;
            rec.name = 'Test -' + code;
            rec.Trademark__c = flv.trademark__c;
            rec.Flavour__c = flv.id;
            rec.BBNSuccessiveNumber__c = code + '10';
                                
            recs.add(rec);              
        }
        
        if (recs.size() > 0) {
            insert recs;
        }
        return recs;                
   }
   
   public static List<GS1_Currency__c> createCurrency(Integer count) {
        List<GS1_Currency__c> recs = new List<GS1_Currency__c>();
        String code;
        
        GS1_TestHelper.CodeGenerator cg = new GS1_TestHelper.CodeGenerator();
        
        for (Integer i=1; i<=count; i++) {
            code = cg.generateCode(); 
            GS1_Currency__c rec = new GS1_Currency__c();
            rec.Code__c = code;
            rec.name = 'Test -' + code;
            
            recs.add(rec);              
        }
        
        if (recs.size() > 0) {
            insert recs;
        }
        return recs;        
   }   
    
   public static List<GS1_Promo_Free_Product__c> createPromoFreeProduct(Integer count) {
        List<GS1_Promo_Free_Product__c> recs = new List<GS1_Promo_Free_Product__c>();
        String code;
        
        GS1_TestHelper.CodeGenerator cg = new GS1_TestHelper.CodeGenerator();
        
        for (Integer i=1; i<=count; i++) {
            code = cg.generateCode(); 
            GS1_Promo_Free_Product__c rec = new GS1_Promo_Free_Product__c();
            rec.name = 'Test -' + code;
            
            recs.add(rec);              
        }
        
        if (recs.size() > 0) {
            insert recs;
        }
        return recs;        
   }       
    
   public static List<GS1_Promo_Other__c> createPromoOthers(Integer count) {
        List<GS1_Promo_Other__c> recs = new List<GS1_Promo_Other__c>();
        String code;
        
        GS1_TestHelper.CodeGenerator cg = new GS1_TestHelper.CodeGenerator();
        
        for (Integer i=1; i<=count; i++) {
            code = cg.generateCode(); 
            GS1_Promo_Other__c rec = new GS1_Promo_Other__c();
            rec.name = 'Test -' + code;
            
            recs.add(rec);              
        }
        
        if (recs.size() > 0) {
            insert recs;
        }
        return recs;        
   }
   
   public static User createTestUser() {
        Profile f = [select id from Profile where name='GS1 Admin (Salesforce)' limit 1];
        User testUser = new User();
        testUser.Alias = 'testUser';
        testUser.ProfileId = f.id;
        testUser.Username = 'testuser1234@qwerty1' + String.valueOf(System.currentTimeMillis()) + '.com.ph.xx';
        testUser.LastName = 'test123';
        testUser.Email = testUser.Username;
        //testUser.CurrencyIsoCode = 'USD';
        testUser.TimeZoneSidKey = 'GMT';
        testUser.LocaleSidKey = 'en_US';
        testUser.EmailEncodingKey = 'ISO-8859-1';
        testUser.LanguageLocaleKey = 'en_US';       
        
        insert testUser;
        return testUser;    
   }
   
}