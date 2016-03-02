/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : ITPR_Validator_cls
 *  Author           : Infosys
 *  Version History  : 1.0
 *  Creation         : 16/03/2014
 *  Assumptions      : N/A 
 *  Description      : This class returns the static variable which is used to handle triggering on ITPR object.                                   
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
global class ITPR_Validator_cls{

    private static boolean blnAlreadyDone = false; //variable declaration and initialization
 
    //returns false
    public static boolean hasAlreadyDone(){ 
        return blnAlreadyDone;
    }
    //returns true
    public static void setAlreadyDone() {  
        blnAlreadyDone = true;
    }
 
}
/*********************************************END*****************************************************************************************************************/