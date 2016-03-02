public class RFA_AP19_RFAValidationException extends Exception{
	
	
	String errType {private get; private set;}
	String errMsg {private get; set;}
    List<String> errMessages {private get; private set;}
 

    public RFA_AP19_RFAValidationException(Set<String> errSet) {
    	errMessages = new List<String>();        
        errMessages.addAll(errSet);
        System.debug('\n Error messages :'+errMessages);
    }
    
    public List<String> getMessages() {
        return (errMessages != null ? errMessages : new List<String>());
    }
    
    public Integer getNumValDMl()
    {
    	return errMessages.size();
    }
    
    public String getValExMessages(Integer index)
    {
    	return (errMessages != null ? errMessages[index] : '');
    }
    
    public String getSerializedErrMsg()
    {
    	errMsg = 'Error: Missing or Invalid Data for Required Fields (*)' + '\n' + '\n';
    	Integer index = 1;
    	for(String err : getMessages())
    	{
    		errMsg = errMsg + String.valueOf(index) + '.' + ' ' +  err + '\n';
    		index = index + 1;
    	} 
    	return errMsg;
    }
}