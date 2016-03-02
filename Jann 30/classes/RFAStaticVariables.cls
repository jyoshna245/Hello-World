/****************************************************************************************************************************************
****************************************************************************************************************************************    
*  Class            : RFAStaticVariables
*  Author           : Infosys
*  Version History  : 1.0
*  Creation         : 18/11/2015
*  Description      : This Class is for storing global constants which are referred in multiple classes.

****************************************************************************************************************************************
****************************************************************************************************************************************/
public with sharing class RFAStaticVariables {
    
    public static Boolean skiplevel=false;
    public static Boolean  doskiplevelProcess=false;
    public static String level ='';
    public Static String ApproverRecType='Approver';
    public Static String InfoCopyRecType='Info Copy Only';
    public Static Map<String, String> pcPreviousLevelMap = new Map<String, String>{
              'Business Unit' =>'Key Operations'    ,
                   'Group' => 'Business Unit',
                    'Corporate'=>'Group',
                  'Executive' =>   'Corporate',
                  'Senior Executive'  =>  'Executive'
    };
     public Static String Level1 ='Key Operations';
    public Static String Level6 ='Senior Executive';
}