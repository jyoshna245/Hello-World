@isTest
public class RFA_VCC06_MultiselectController_Test
{

   public static testmethod void RFA_VCC06_Multiselect_Test()
    {
            
    RFA_VCC06_MultiselectController mSelect=new RFA_VCC06_MultiselectController();
    mSelect.rightOptions=new List<SelectOption>();
    mSelect.leftOptions=new List<SelectOption>();
    mSelect.rightOptionsHidden='Test&value';
   
   
    mSelect.leftOptionsHidden='Test&value';
   
    }



}