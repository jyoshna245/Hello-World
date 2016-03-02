/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFAGlobalConstants
 *  Author           : Accenture
 *  Version History  : 3.0
 *  Creation         : 05/14/2012
 *  Assumptions      : N/A
 *  Description      : Class for storing global constants which are referrenced in multiple classes.
                                    
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
public with sharing class RFAGlobalConstants {
    
    public static final String CASH_SPENT_ADDITIONAL_YEARS = Label.RFA_CL070;
    
    public static final String EXCEPTION_LIST_ORDER = Label.RFA_CL061;
    
    public static final String EXCEPTION_NO_APPROVERS = Label.RFA_CL062;
    
    public static final String EXCEPTION_NO_APPROVERS_REVIEWERS = Label.RFA_CL063;
    
    public static final String APPROVER_RECORDTYPE = Label.RFA_CL064;
    
    public static final String PC_USERTYPE_LC=Label.RFA_CL065;
    
    public static final String PC_USERTYPE_Viewer=Label.RFA_CL066;
    
    public static final String PC_USERTYPE_RFCViewer=Label.RFA_CL067;
    
    public static final String PROCESS_IN_PROGRESS = Label.RFA_CL068;
    
    public static final String PROCESS_COMPLETED = label.RFA_CL069;
    
    public static final String PROCESS_PENDING_RECOMMENDATION = Label.RFA_CL056; 
    
    public static final String EXCEPTION_PROCESSHASBEEN_SUBMITTED = Label.RFA_CL071;
    
    public static final String RECORDTYPE_INFOONLY = Label.RFA_CL072;
    
    public static final String RECORDTYPE_CO_CREATOR = Label.RFA_CL073;
    
    public static final String RECORDTYPE_PRIMARY_POC = Label.RFA_CL074;

    public static final String RECORDTYPE_GENERAL_REQUEST = Label.RFA_CL122;

    public static final String RECORDTYPE_SMALL_PROJECT_REQUEST = Label.RFA_CL050;
    
    public static final String RECORDTYPE_CAPITAL_PROJECT_REQUEST = Label.RFA_CL051;
    
    /* for Policy Exemption request FR1.11 Q3 release RLC */
    public static final String RECORDTYPE_POLICY_EXEMPTION_REQUEST = Label.RFA_FR_1_11;
   
    
    public static final String RECORDTYPE_CAPPR_REQUEST = 'CAPPr Request';
    
    public static final String RECORDTYPE_GROUP_CONSOLIDATED_PLAN = 'Group Consolidated Capital Plan';
    
    public static final String ROWCAUSE_LABEL_LC = Label.RFA_CL075;

    public static final String ROWCAUSE_REQUESTER = Label.RFA_CL076;
    
    public static final String INSUFFICIENT_PERMISSION = Label.RFA_CL077;
    
    public static final String INSUFFICIENT_EDIT_PERMISSION = Label.RFA_CL099;
    
    public static final String EXCEPTION_HIGHER_LEVEL = Label.RFA_CL078;
    
    public static final String EXCEPTION_NOT_PART_OF_PC = Label.RFA_CL079;
    
    public static final String RFA_CIRCULATION_STAGE = Label.RFA_CL041;
    
    public static final String RFA_POST_CIRCULATION_STAGE = Label.RFA_CL039;
    
    public static final String RFA_PRE_CIRCULATION_STAGE = Label.RFA_CL038;
    
    public static final String RETURN_TO_SENDER = Label.RFA_CL040;
    
 //   public static final String RETURN_TO_SENDER2 = Label.RFA_CL2_00; //added by Roy for Correct Email template
    
    public static final String POST_CIRCULATION = Label.RFA_CL039;
    
    public static final String PRE_CIRCULATION = Label.RFA_CL038;
    
    public static final String PROCESS_NOT_COMPLETED = Label.RFA_CL080;
    
    public static final String TEMPLATE_PRE_CIRCULATION = Label.RFA_CL044;
    
    public static final String TEMPLATE_RETURN_TO_SENDER = Label.RFA_CL049;
    
    public static final String TEMPLATE_RFA_RESUMED_FROM_RETURNTOSENDER = Label.RFA_CL093;
    
    public static final String PENDING_BOARD_REVIEW = Label.RFA_CL008;
    
    public static final String CAPITAL_MGMT_HOLD = Label.RFA_CL007;
    
    public static final String RFA_STAGE_CLOSED = Label.RFA_CL081;
    
    public static final String RFA_STAGE_APPROVED = Label.RFA_CL082;
    
    public static final String RFA_STAGE_REJECTED = Label.RFa_CL059;
    
    public static final String RFA_STAGE_DRAFT = Label.RFA_CL083;
    
    public static final String TCCC_HQ_NAME = Label.RFA_CL084;
    
    public static final String SEND_TO_PRE_CIRCULATION=Label.RFA_CL085;
    
    public static final String CURRENT_DOMAIN_NAME = Label.RFA_CL026;
    
    public static Map<String, Map<String, RecordType>> RECORDTYPESMAP = 
        RFA_Util_RecordTypeHelper.createRecordTypesMap(
                new String[]{
                        Schema.sObjectType.RFAUserRole__c.getName(), 
                        Schema.Sobjecttype.RFA__c.getName()
                        }, 
                new String[]{
                        RFAGlobalConstants.APPROVER_RECORDTYPE,
                        RFAGlobalConstants.RECORDTYPE_CO_CREATOR,
                        RFAGlobalConstants.RECORDTYPE_INFOONLY,
                        RFAGlobalConstants.RECORDTYPE_PRIMARY_POC,
                        RFAGlobalConstants.RECORDTYPE_CAPITAL_PROJECT_REQUEST,
                        RFAGlobalConstants.RECORDTYPE_CAPPR_REQUEST,
                        RFAGlobalConstants.RECORDTYPE_GROUP_CONSOLIDATED_PLAN,
                        RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST,
                        RFAGlobalConstants.RECORDTYPE_GENERAL_REQUEST,
                        RFAGlobalConstants.RECORDTYPE_POLICY_EXEMPTION_REQUEST /*FR1.1*/
                        }
        );
    
     public static final Map<Integer, String> ORDERED_LEVEL_MAP = new Map<Integer, String>{
        1 => '1. Key Operations',
        2 => '2. Business Unit',
        3 => '3. Group',
        4 => '4. Corporate',
        5 => '5. Executive',
        6 => '6. Senior Executive'
     }; 
     
     public static final Map<String, Integer> LEVEL_ORDER_MAP = new Map<String, Integer>{
        '1. Key Operations' => 1,
        '2. Business Unit' => 2,
        '3. Group' => 3,
        '4. Corporate' => 4,
        '5. Executive' => 5,
        '6. Senior Executive' => 6
     };
    
    public static final Map<String, String> LEVEL_ABBR_MAP = new Map<String, String>{
        '1. Key Operations'     => 'KO',
        '2. Business Unit'      => 'BU',
        '3. Group'              => 'Group',
        '4. Corporate'          => 'Corporate',
        '5. Executive'          => 'Exec',
        '6. Senior Executive'   => 'Sr.Exec'
    };
    
    public static boolean isBlank(String str) {
        return str == null || str.trim() == null || str.trim().length() == 0;
    }
}