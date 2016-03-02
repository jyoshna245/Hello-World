public class RFA_VCC07_RFA_History{
//Protected Members
    private static final DescribeSObjectResult oSomeObjectSchema = Schema.SObjectType.RFA__c;
    private static final Map<string, Schema.SObjectField> mapFields = oSomeObjectSchema.fields.getMap();
    
    //Properties
    public Id SomeObjectId {get;set;}
    public integer PageSize {get;set;}
    public boolean AllowShowMore {get;set;}
    
    public List<RFAObjectHistory> SomeObjectHistories {
        get { return getRFAObjectHistory(SomeObjectId); }
    }
    
    //Constructors
    
    /**
     * Default Constructor
     */
    public RFA_VCC07_RFA_History() {
        PageSize = 100;   
        AllowShowMore = true;
    }
    
    //Public Methods
    public void showMore() {
        PageSize += 100;
    }
    
    //Public  Methods
    
    /**
     * Returns SomeObject History records associated to the current SomeObject
     *
     * @param   SomeObjectId     the SomeObject__c record id to retrieve
     * @return  a list of RFAObjectHistory objects
     */
    public List<RFAObjectHistory> getRFAObjectHistory(Id SomeObjectId) {
        List<RFAObjectHistory> listRFAObjectHistory = new List<RFAObjectHistory>();
        
        if (SomeObjectId != null) {
            DateTime dLastCreatedDate = null;
            
            integer limitPlusOne = PageSize + 1;
            
            List<RFA__History> listEntityHistory = [SELECT Id, Field, NewValue, OldValue, CreatedDate, CreatedById, CreatedBy.Name FROM RFA__History WHERE ParentId = :SomeObjectId ORDER BY CreatedDate DESC, Id DESC LIMIT :limitPlusOne];
            AllowShowMore = (listEntityHistory.size() == limitPlusOne);
             
            for (RFA__History oHistory : listEntityHistory) {
                RFAObjectHistory oRFAObjectHistory = new RFAObjectHistory(oHistory);
                
                if (mapFields.containsKey(oHistory.Field)) {
                    oRFAObjectHistory.FieldLabel = mapFields.get(oHistory.Field).getDescribe().Label;
                }
                                    
                if (dLastCreatedDate == oHistory.CreatedDate) {
                    oRFAObjectHistory.ShowDateAndUser = false;
                }
                else {
                    oRFAObjectHistory.ShowDateAndUser = true;
                }
                
                listRFAObjectHistory.add(oRFAObjectHistory);
                dLastCreatedDate = oHistory.CreatedDate;
                
                if (listRFAObjectHistory.size() == PageSize) break;
            }
        }
        
        return listRFAObjectHistory;
    }
    
    //Internal Classes

    /**
     * Data structure representing a SomeObject History record for display
     */
    public class RFAObjectHistory {
        //Properties
        public boolean ShowDateAndUser {get;set;}
        public string FieldLabel {get;set;}
        public RFA__History History {get; private set;}
        
        public string ActionFormat {
            get { return getActionFormat(); }
        }
        
        public RFAObjectHistory(RFA__History oHistory) {
            History = oHistory;
        }
        
        //Constructors
        public RFAObjectHistory() {
            showDateAndUser = true;
        }
        
        //Public Methods
        Public string getActionFormat() {
            string sActionFormat = '';
            
            if (History != null) {
                sActionFormat = 'Record {0}.';
                
                if (History.newValue != null && History.oldValue == null) {
                    sActionFormat = 'Changed <strong>{1}</strong> to <strong>{3}</strong>.';    
                }
                else if (History.newValue != null && History.oldValue != null) {
                    sActionFormat = 'Changed <strong>{1}</strong> from {2} to <strong>{3}</strong>.';   
                }
                else if (History.Field != null && History.Field.equalsIgnoreCase('created')) {
                    sActionFormat = 'Created.';
                }
            }
            
            return sActionFormat;
        }
    }

}