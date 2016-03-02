/*
*
* Author,email :     Aldrin Rasdas , arasdas@coca-cola.com
* Date Create  :     Sept 5, 2013
* Description  :     A (controller) class used to generate barcodes
*
* REVISION HISTORY
*
* Author,email :
* Date Revised :
* Description  :
*
*
*
*/

public class GS1_EAN_CodeGenCtrl {
    private final integer MAX_RECORDS = 300;
    List<GS1_EAN__c> generatedEANCodes;
    GS1_EAN__c ean;
    
    public long startNum {get; set;}
    public long endNum {get; set;}
    public String shortOrLong {get; private set;}
    public long lastDigit {get; private set;} //for compute check digit
    
    public List<GS1_EAN__c> getEANCodes() {
        return generatedEANCodes;
    }
    
    public GS1_EAN_CodeGenCtrl() {

    }
    
    public GS1_EAN_CodeGenCtrl(ApexPages.StandardController controller) {
        ean = (GS1_EAN__c)controller.getRecord();     
        this.shortOrLong = '(auto: depends on the barcode length)';
    }    
    
    public ApexPages.PageReference goBack() {
        return GS1_CommonFunctions.navigateToRecordList('GS1_EAN__c');
    }
    
    public ApexPages.PageReference startOver() {
        generatedEANCodes = null;
        this.shortOrLong = '(auto: depends on the barcode length)';
        return null;
    }
    
    public ApexPages.PageReference computeCheckDigit() {
        long startLen = 0;
        startLen = String.valueOf(startNum).length();
        
        if (startLen != 7 && startLen != 12) {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Start EAN number should be 7 or 12 digits only.'));            
        }
                
        if (apexPages.getMessages().size()>0) {
            return null;
        }
        
        this.lastDigit = this.generateLastDigit( this.startNum );
        return null;
    }
    
    public ApexPages.PageReference generateEANCodes() {
        long startLen = 0;
        long endLen = 0;
                
        //ensure the length of start and end is equal/same, must be both 7 or 12 digits (not mixed)
        startLen = String.valueOf(startNum).length();
        endLen = String.valueOf(endNum).length();
        
        if (startLen != endLen) {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Start and End of range should be of equal length (7 or 12 digits).'));
        }
        
        if (startLen != 7 && startLen != 12) {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Start of range should be 7 or 12 digits only.'));         
        }
        
        if (endLen != 7 && endLen != 12) {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'End of range should be 7 or 12 digits only.'));
        }
        
        if (endNum < startNum) {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'End of range should not be lower than start of range.'));
        }        
        
        if (apexPages.getMessages().size()>0) {
            return null;
        }
        
        //we could create only upto MAX_RECORDS records at a time...
        long diff = ((endNum - startNum) + 1);        
        if (diff > this.MAX_RECORDS) {//limit 
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Range is limited to ' + String.ValueOf(this.MAX_RECORDS) + '. The entered range would create ' + string.valueOf(diff) + ' records.'));
            return null;
        }
        
        generateEANRecords2();        
        
        if (startLen == 7) {
            this.shortOrLong = 'Short';
        } else if (startLen == 12) {
            this.shortOrLong = 'Long';
        }
        
        return null;
    }
    
    private void generateEANRecords2() {
        if (startNum <= endNum) {
            
            List<String> codes = this.generateEAN(startNum, endNum);
            Map<String, GS1_EAN__c> eanMap = new Map<String, GS1_EAN__c>(); 
            
            if (codes.size()>0) {
                for (GS1_EAN__c ean : [select id,name from GS1_EAN__c where name in :codes]) {
                    eanMap.put(ean.name, ean);
                }
                
                generatedEANCodes = new List<GS1_EAN__c>();
                for (String c : codes) {
                    if (eanMap.get(c) == null) {                    
                        GS1_EAN__c e = new GS1_EAN__c();
                        e.Name = c;
                        //e.Property_1__c = ean.Property_1__c;
                        e.Property_2__c = ean.Property_2__c;
                        e.Property_3__c = ean.Property_3__c;
                        e.Status__c = GS1_Constants.BARCODE_STAT_FREE;
                        
                        generatedEANCodes.add(e);   
                    }                   
                }
                
                if (generatedEANCodes.size()>0) {
                    //insert generatedEANCodes;                
                    
                    try {
                        List<Database.Saveresult> sr = database.insert(generatedEANCodes);
                    } catch (Dmlexception e) {
                        //apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
                    } catch (Exception ex) {
                        //apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ex.getMessage()));
                    }
                    
                } else {
                    generatedEANCodes = null;
                }
                
                if (eanMap.size()>0) {
                    List<String> eans = new List<String>();
                    eans.addAll(eanMap.keySet());
                    
                    if (eanMap.size()==1) {
                        ApexPages.AddMessage(new ApexPages.Message( ApexPages.Severity.INFO,'The following EAN was not inserted because they already exist in the system: ' + String.join(eans,', ')));
                    } else {
                        ApexPages.AddMessage(new ApexPages.Message( ApexPages.Severity.INFO,'The following EANs were not inserted because they already exist in the system: ' + String.join(eans,', ')));
                    }                                           
                }                                       
                
            }           
            
        }       
    }    
        
    public List<String> generateEAN(long rangeStart, long rangeEnd) {
        List<String> ret = new List<String>();
                
        for (long i=rangeStart; i<=rangeEnd; i++) {
            String digit = string.valueOf(i);
            Integer ld = this.generateLastDigit(i);
            if (ld != null){
                digit += String.valueOf(ld);
            }
            
            ret.add(digit);
        }
        
        return ret;
    }
        
    private integer generateLastDigit(long given) {
        String digit = string.valueOf(given);
        integer lastDigit = null;
        integer part1 = 0;
        integer part2 = 0;
        integer len = digit.length();
        
        if (len==7) {
            part1 += integer.valueOf(digit.substring(1-1,1));
            part1 += integer.valueOf(digit.substring(3-1,3));
            part1 += integer.valueOf(digit.substring(5-1,5));
            part1 += integer.valueOf(digit.substring(7-1,7));
            part1 = part1 * 3;
            
            part2 += integer.valueOf(digit.substring(2-1,2));
            part2 += integer.valueOf(digit.substring(4-1,4));
            part2 += integer.valueOf(digit.substring(6-1,6));
            
            lastDigit = math.mod((part1 + part2),10);
            if (lastDigit != 0) {
                lastDigit = 10 - lastDigit;
            }
            
        } else if (len==12) {
            part1 += integer.valueOf(digit.substring(2-1,2));
            part1 += integer.valueOf(digit.substring(4-1,4));
            part1 += integer.valueOf(digit.substring(6-1,6));
            part1 += integer.valueOf(digit.substring(8-1,8));
            part1 += integer.valueOf(digit.substring(10-1,10));
            part1 += integer.valueOf(digit.substring(12-1,12));
            part1 = part1 * 3;
            
            part2 += integer.valueOf(digit.substring(1-1,1));
            part2 += integer.valueOf(digit.substring(3-1,3));
            part2 += integer.valueOf(digit.substring(5-1,5));
            part2 += integer.valueOf(digit.substring(7-1,7));
            part2 += integer.valueOf(digit.substring(9-1,9));
            part2 += integer.valueOf(digit.substring(11-1,11));
            
            lastDigit = math.mod((part1 + part2),10);
            if (lastDigit != 0) {
                lastDigit = 10 - lastDigit;
            }
            
        }       
        
        return lastDigit;
    }
        
}