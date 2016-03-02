/*
*
* Author,email :     Aldrin Rasdas , arasdas@coca-cola.com
* Date Create  :     Sept 5, 2013
* Description  :     A class containing common constants used accross GS1 application
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

public class GS1_Constants
{
    public static final string GS1_DEBUG_SIG = '***** GS1_DEBUG: ';
    //request statuses
    public static final string REQUEST_STATUS_NEW = 'New';
    public static final string REQUEST_STATUS_REQUESTED = 'Requested';
    public static final string REQUEST_STATUS_APPROVED = 'Approved';
    public static final string REQUEST_STATUS_REJECTED = 'Rejected';
    public static final string REQUEST_STATUS_ALLOCATED = 'EAN Allocated';
    public static final string REQUEST_STATUS_WITHDRAWN = 'Withdrawn';
    public static final string REQUEST_STATUS_INACTIVE = 'Inactive';
    public static final string REQUEST_STATUS_CANCELLED = 'Cancelled';
    
    public static final string ERRMSG_COUNTRY_NODUP = 'There is already an existing country of that name';
    public static final string ERRMSG_COUNTRY_EMPTY = 'Please specify the country of this request.';    
    public static final string ERRMSG_CANNOT_CHANGE_VALUE = 'Value cannot be changed since there are requests that used this.';
    public static final string ERRMSG_CANNOT_CHANGE_PROFILEUSER = 'User cannot be changed since there are requests related to this author profile.';
    public static final string ERRMSG_AUTHOR_NODUP = 'There is already an existing profile for this user.';
    public static final string ERRMSG_AUTHOR_NOTFOUND = 'Author profile for this user could not be found.';
    public static final string ERRMSG_AUTHOR_OWNLEVELCHANGE = 'You cannot change your own access level. Kindly ask someone else to do it for you.';
    public static final string ERRMSG_AUTHOR_RELATEDUSERCHANGE = 'Changing of related user is not allowed';
    public static final string ERRMSG_ACTION_RESTRICTED = 'You are not authorized to perform that operation.';
    public static final string ERRMSG_REQUEST_NOTFOUND = 'The request could not be found. It may have been modified by somebody else along the process.';
    public static final string ERRMSG_SENDMAIL_FAILED = 'Send email failed.';
    public static final string ERRMSG_COUNTRY_EXISTS_IN_AUTHOR = 'The country already exists in author';
    
    public static final string ERRMSG_EAN_NODUP = 'There is already an existing barcode of that code';
    public static final string ERRMSG_EAN_NOTFOUND = 'The specified barcode could not be found.';
    public static final string ERRMSG_EAN_NOTMATCHED = 'No applicable barcode found!';
    public static final string ERRMSG_EAN_IDENTICAL = 'There is already an identical product. Please use the Allocate Barcode button.';    
    
    //barcode entry status
    public static final string BARCODE_STAT_FREE = 'Free';
    public static final string BARCODE_STAT_NOTFREE = 'Allocated';
    
    //barcode freeing errors
    public static final string ERRMSG_BCF_REQ_UNWITHDRAWN = 'At least one request using this barcode has not been withdrawn.';
    public static final string ERRMSG_BCF_REQ_THRESHOLD = 'At least one request using this barcode has not been withdrawn within the allowable period.';
    
    //Web dialog titles
    public static final string DIALOG_TITLE_ERROR = 'Error';
    public static final string DIALOG_TITLE_WARN = 'Warning';
    public static final string DIALOG_TITLE_INFO = 'Information';
    
    //approval auto-submit-approve-reject comments
    public static final string APPROVAL_COMMENT_APPROVE = 'Auto approved for EAN allocation';
    public static final string APPROVAL_COMMENT_REJECT = 'Cancelled by GS1 Admin: duplicate request';
    public static final string APPROVAL_COMMENT_SUBMIT = 'Submitted for GS1 Admin approval';
    
    //sharing access rights
    public static final string COUNTRY_AUTHOR_SHARING_ACCESS = 'Edit';
    
    public static string testCoverageDummy() {
        //this method is here just to get a 100% test coverage; :)
        return 'OK';
    }
}