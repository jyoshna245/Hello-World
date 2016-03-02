/*
For the Requirement, "You cannot approve it as the RFA is returned back to Submitter"
This class returns value 1 if the user clicks on sent to coordinator button if RFA's Level is 'Return to sender'
and returns 0,otherwise
*/
global class RFA_VFC_RFALevel
{
          webService static Integer checkRFALevel(String RFALevelStage,String labelClicked)
        {
            System.debug('RFA LEVEL STAGE COPY'+RFALevelStage);
            System.debug('labelClicked'+labelClicked); 
            Set<String> sendToButtonList=new Set<String>();
            sendToButtonList.add('Send to '+System.Label.RFA_CL001+' Coordinator');
            sendToButtonList.add('Send to '+System.Label.RFA_CL002+' Coordinator');
            sendToButtonList.add('Send to '+System.Label.RFA_CL003+' Coordinator');
            sendToButtonList.add('Send to '+System.Label.RFA_CL004+' Coordinator');            
            sendToButtonList.add('Send to '+System.Label.RFA_CL005+' Coordinator');            
            sendToButtonList.add('Send to '+System.Label.RFA_CL006+' Coordinator');                        
                                  
            if(RFALevelStage==System.Label.RFA_CL040&&sendToButtonList.contains(labelClicked))
            {
                return 1; 
            } 
        return 0;       
        }  
}