public class RFASharingReasonUtil {

    public static Map<String,String> listAllRFASharingReason()
    {
        Map<String, String> sharingReason = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = RFA__Share.RowCause.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for(Schema.PicklistEntry pe : ple)
        {
            system.debug('label :'+pe.getLabel());
            sharingReason.put(pe.getLabel(),pe.getvalue());
        }
      
            return sharingReason;
    }
}