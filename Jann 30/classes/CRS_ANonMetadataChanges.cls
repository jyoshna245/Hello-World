/*
Non-Metadata Configuration Changes
This document outlines changes that have been made to the system that cannot be propagated via Force.com metadata API

Date - Enter the date that the changes was made(YYYY-MM-DD)
Changed by - Name of developer/admin
References  -   Reference to task in Jira and/or business requirements and/or design description.
Steps   -   Brief description of what was changed


--------------------------------------------------------------------------------
Date: 2012-09-26
Changed By: Vasili Kalanchuk
References: Custom Lookup Screens - https://jira.epam.com/jira/browse/TCCCCRS-20
Steps: 
1. Get file from SVN: "/Documents/Data/CRS Lookups Settings.csv"
2. Import it to the SF environment for "CRS Custom Lookup Settings" (CRS_LookupSettings__c) settings object.


--------------------------------------------------------------------------------
Date: 2012-10-08
Changed By: Ivan Tsitulenka
References: Populate Public Groups - https://jira.epam.com/jira/browse/TCCCCRS-6
Steps: 
1. Get file from SVN: "/Documents/Data/CRS PublicGroupMapping.csv"
2. Import it to the SF environment


--------------------------------------------------------------------------------
Date: 2012-10-08
Changed By: Vitaly
References: Configure Home Page Layout for Approval Processes - https://jira.epam.com/jira/browse/TCCCCRS-24
Steps: 
1. Go to Setup -> Customize -> Home -> Home Page Layouts
2. Edit Home Page Layout Assignment.
3. Set 'CRS Home Page + Dashboards' layout for 'CRS Business Admin' profile,
   'CRS Home Page' for all other 'CRS *' profiles. 
4. Save changes.


--------------------------------------------------------------------------------
Date: 2012-10-09
Changed By: Vasili Kalanchuk
References: When user selects a Beverage Product that contains "Live Positively" 
or "All Products - General Communications" – auto-populate some fields 
https://jira.epam.com/jira/browse/TCCCCRS-10
https://jira.epam.com/jira/browse/TCCCCRS-11

Steps: 
1. Get file from SVN: "/Documents/Data/CRS Product-dependent fields.csv"
2. Import it to the SF environment for CRS_ProductDependentFieldsSetup__c settings.
3. (Important!) Check for correspondence of this custom settings to real seed data.
   Do not change settinngs names! If needed, manually adjust (copy-paste) right names values.


--------------------------------------------------------------------------------
Date: 2012-10-29
Changed By: Vasili Kalanchuk
References: "Add New" tab for Flavor and Product. Configure email, to which notifications will be sent.
https://jira.epam.com/jira/browse/TCCCCRS-41
https://jira.epam.com/jira/browse/TCCCCRS-123 

Steps: 
1. Go to Setup -> Develop -> Custom Settings -> CRS Name-Value Setup (manage link);
2. Create new record with Name="BusinessAdminEmail" (Do not change it!) and appropriate Value. 
Notifications will be sent to specified email address.


--------------------------------------------------------------------------------
Date: 2012-10-30
Changed By: Vitaly Baturchik
References: hardcoded ids of jQuery library and object prefix 

Steps: 
1. Open CRS tab. URL will be something like '/a06/o'. Where first three letters are id prefix of CRS object. PLease remember them.
2. Go to Setup -> Customize -> Home -> Home Page Components. 
3. Edit 'CRS Area' component and check 'Show HTML' check box.
4. Find 'if ('a06'==objectPefix){' and replace 'a06' by id prefix your remembered in the first step.
5. Save.


--------------------------------------------------------------------------------
Date: 2012-10-31
Changed By: Vitaly
References: Configure Approval Processes - https://jira.epam.com/jira/browse/TCCCCRS-24, 50, 51, 53
It is required to create 13 Approvals Processes. Here are steps for all of them:

0. Go to Setup -> Create -> Workflow & Approvals -> Approval Processes
Click Create New Approval Process -> Use Jump Start Wizard

1.1 Create Approval #1
Name: Step1.1-BU Legal
Entry Criteria: CRS Status EQUALS Draft
Select Approver: Let the submitter choose the approver manually.
Click Save.
Activate Approval.

1.2.
Add Existing Field Update 'CRS_Status_New_Submission' to the 'Initial Submission Actions'
Add Existing Field Updates 'CRS Next Approver Field SRA' and 'CRS_internalStatus2_Next' to the 'Final Approval Actions'
Add Existing Field Update 'CRS_Status_Rejected' to the 'Final Rejection Actions'
Add Existing Field Updates 'CRS_Status_Draft' and 'CRS_internalStatus2_NotStarted' to the 'Recall Actions'


2.1 Create Approval #2
Name: Step1.2-Field SRA
Entry Criteria:   (CRS: CRS Status EQUALS New Submission) and (CRS: Internal Status EQUALS Field SRA Approver) and 
    (CRS: Record Type EQUALS CRS submission) and (CRS: Process Flow NOT EQUAL TO Full Review Coke Branded Product) and 
    (CRS: Process Flow NOT EQUAL TO Notification)
Select Approver: Let the submitter choose the approver manually.
Click Save.
Activate Approval.

2.2.
Add Existing Field Update 'CRS_Status_InProcess' to the 'Initial Submission Actions'
Add Existing Field Update 'CRS_internalStatus2_Wait2' to the 'Final Approval Actions'
Add Existing Field Update 'CRS_Status_Rejected' to the 'Final Rejection Actions'
Add Existing Field Updates 'CRS_Status_New_Submission' and 'CRS_internalStatus2_NotStarted' to the 'Recall Actions'


3.1 Create Approval #3
Name: Step1.2-Field SRA gvw
Entry Criteria: (CRS: CRS Status EQUALS New Submission) AND (CRS: Internal Status EQUALS Field SRA Approver) AND 
    (CRS: Record Type EQUALS glaceau vitaminwater CRS)
Select Approver: Let the submitter choose the approver manually.
Click Save.
Activate Approval.

3.2.
Add Existing Field Update 'CRS_Status_InProcess' to the 'Initial Submission Actions'
Add Existing Field Update 'CRS_internalStatus2_Next' and 'CRS Next Approver Corp Food Law' to the 'Final Approval Actions'
Add Existing Field Update 'CRS_Status_Rejected' to the 'Final Rejection Actions'
Add Existing Field Updates 'CRS_Status_New_Submission' and 'CRS_internalStatus2_NotStarted' to the 'Recall Actions'


4.1. Create Approval #4
Name: Step1.2-Field SRA Coke Branded
Entry Criteria: (CRS: CRS Status EQUALS New Submission) AND (CRS: Internal Status EQUALS Field SRA Approver) AND
     (CRS: Process Flow EQUALS Full Review Coke Branded Product)
Select Approver: Let the submitter choose the approver manually.
Click Save.
Activate Approval.

4.2.
Add Existing Field Update 'CRS_Status_InProcess' to the 'Initial Submission Actions'
Add Existing Field Update 'CRS_internalStatus2_Next' and 'CRS Next Approver Corp Food Law' to the 'Final Approval Actions'
Add Existing Field Update 'CRS_Status_Rejected' to the 'Final Rejection Actions'
Add Existing Field Updates 'CRS_Status_New_Submission' and 'CRS_internalStatus2_NotStarted' to the 'Recall Actions'


5.1. Create Approval #5
Name: CRS: Step1.2-Field SRA Notification
Entry Criteria: (CRS: CRS Status EQUALS New Submission) AND (CRS: Internal Status EQUALS Field SRA Approver)
 AND (CRS: Record Type EQUALS CRS submission) AND (CRS: Process Flow EQUALS Notification)
Select Approver: Let the submitter choose the approver manually.
Click Save.
Activate Approval.

5.2.
Add Existing Field Update 'CRS_Status_InProcess' to the 'Initial Submission Actions'
Add Existing Field Update 'CRS_Status_Approved' to the 'Final Approval Actions'
Add Existing Field Update 'CRS_Status_Rejected' to the 'Final Rejection Actions'
Add Existing Field Updates 'CRS_Status_New_Submission' and 'CRS_internalStatus2_NotStarted' to the 'Recall Actions'


6.1. Create Approval #6
Name: Step2.1-Corporate Formula Governance
Entry Criteria: (CRS: Send Corp Form Gov EQUALS Yes) AND (CRS: CRS Status EQUALS In Process) AND 
    (CRS: Internal Status EQUALS Corp Formula Govern Approver)
Select Approver: Let the submitter choose the approver manually.
Click Save.
Activate Approval.

6.2.
Add Existing Field Updates 'CRS Next Approver Corp Food Law' and 'CRS_internalStatus2_Next' to the 'Final Approval Actions'
Add Existing Field Update 'CRS_Status_Rejected' to the 'Final Rejection Actions'
Add Existing Field Updates 'CRS_internalStatus2_NotStarted' to the 'Recall Actions'


7.1. Create Approval #7
Name: Step2.2-Corporate Food Law
Entry Criteria: (CRS: CRS Status EQUALS In Process) AND (CRS: Internal Status EQUALS Corporate Food Law Approver) AND 
    (CRS: Process Flow NOT EQUAL TO Full Review Coke Branded Product)
Select Approver: Let the submitter choose the approver manually.
Click Save.
Activate Approval.

7.2.
Add Existing Field Updates 'CRS Next Approver Corp SRA' and 'CRS_internalStatus2_Next' to the 'Final Approval Actions'
Add Existing Field Update 'CRS_Status_Rejected' to the 'Final Rejection Actions'
Add Existing Field Updates 'CRS_internalStatus2_NotStarted' to the 'Recall Actions'


8.1. Create Approval #8
Name: Step2.2-Corporate Food Law Coke Branded
Entry Criteria: (CRS: CRS Status EQUALS In Process) AND (CRS: Internal Status EQUALS Corporate Food Law Approver)
     AND (CRS: Process Flow EQUALS Full Review Coke Branded Product)
Select Approver: Let the submitter choose the approver manually.
Click Save.
Activate Approval.

8.2.
Add Existing Field Update 'CRS Next Approver Corp Formula Govern' and 'CRS_internalStatus2_Next' to the 'Final Approval Actions'
Add Existing Field Update 'CRS_Status_Rejected' to the 'Final Rejection Actions'
Add Existing Field Updates 'CRS_internalStatus2_NotStarted' to the 'Recall Actions'


9.1. Create Approval #9
Name: Step2.3-Corporate SRA
Entry Criteria: (CRS: CRS Status EQUALS In Process) AND (CRS: Internal Status EQUALS Corporate SRA Approver)
    AND (CRS: Record Type EQUALS CRS submission)
Select Approver: Let the submitter choose the approver manually.
Click Save.
Activate Approval.

9.2.
Add Existing Field Update 'CRS_internalStatus2_Wait2' to the 'Final Approval Actions'
Add Existing Field Update 'CRS_Status_Rejected' to the 'Final Rejection Actions'
Add Existing Field Updates 'CRS_internalStatus2_NotStarted' to the 'Recall Actions'


10.1. Create Approval #10
Name: Step2.3-Corporate SRA gvw
Entry Criteria: (CRS: CRS Status EQUALS In Process) AND (CRS: Internal Status EQUALS Corporate SRA Approver)
    AND (CRS: Record Type EQUALS glaceau vitaminwater CRS)
Select Approver: Let the submitter choose the approver manually.
Click Save.
Activate Approval.

10.2.
Add Existing Field Update 'CRS_internalStatus2_Wait2' to the 'Final Approval Actions'
Add Existing Field Update 'CRS_Status_Rejected' to the 'Final Rejection Actions'
Add Existing Field Updates 'CRS_internalStatus2_NotStarted' to the 'Recall Actions'


11.1. Create Approval #11
Name: Step2.3-Corp Form Govern Coke Branded
Entry Criteria: (CRS: CRS Status EQUALS In Process) AND (CRS: Internal Status EQUALS Corp Formula Govern Approver)
     AND (CRS: Process Flow EQUALS Full Review Coke Branded Product)
Select Approver: Let the submitter choose the approver manually.
Click Save.
Activate Approval.

11.2. 
Add Existing Field Update 'CRS_internalStatus2_Wait2' to the 'Final Approval Actions'
Add Existing Field Update 'CRS_Status_Rejected' to the 'Final Rejection Actions'
Add Existing Field Update 'CRS_internalStatus2_NotStarted' to the 'Recall Actions'


12.1. Create Approval #12
Name: Step3.1-VP Science
Entry Criteria: (CRS: CRS Status equals In Process) and (CRS: Internal Status equals VP-Chief Sc and Reg Officer)
Select Approver: Let the submitter choose the approver manually.
Click Save.
Activate Approval.

12.2.
Add Existing Field Updates 'CRS_Status_Approved' to the 'Final Approval Actions'
Add Existing Field Update 'CRS_Status_Rejected' to the 'Final Rejection Actions'
Add Existing Field Updates 'CRS_internalStatus2_NotStarted' to the 'Recall Actions'


13.1. Create Approval #13
Name: Step3.1-VP Science Division Coke Branded
Entry Criteria: (CRS: CRS Status EQUALS In Process) and (CRS: Internal Status EQUALS VP-Science Division)
Select Approver: Let the submitter choose the approver manually.
Click Save.
Activate Approval.

13.2.
Add Existing Field Update 'CRS_Status_Approved' to the 'Final Approval Actions'
Add Existing Field Update 'CRS_Status_Rejected' to the 'Final Rejection Actions'
Add Existing Field Update 'CRS_internalStatus2_NotStarted' to the 'Recall Actions'


14. For CRS Approval Processes assign 'CRS Assign Approval' email template to the 'Approval Assignment Email Template'
15. For Step3.1-VP Science assign 'CRS Assign Approval with Comment' email template
--------------------------------------------------------------------------------
Date: 2012-10-31
Changed By: Vasili Kalanchuk
References: When doing User Lookup for List of Approvers, the list should be filtered to only show names of users
who have CRS&gvwCRS or subordinate role hierarchy (or system administrator or CRS business admin profile)
https://jira.epam.com/jira/browse/TCCCCRS-171

Steps: 
1. Go to Setup -> Develop -> Custom Settings -> CRS Name-Value Setup (manage link);
2. Create (or edit if exist) records: 
    a) Name="ApproversTopRoleApiName", Value="CRS_gvwCRS"
    b) Name="SystemAdminProfileApiName", Value="System Administrator"
    c) Name="BusinessAdminProfileApiName", Value="CRS Business Admin"
    
Names should be exactly the same as specified here.
Values should match existing in the application items with right meaning. 
--------------------------------------------------------------------------------
Date: 2012-10-31
Changed By: Ivan Tsitulenka
References: Count review days in "MTR Day Count" of CRS  
https://jira.epam.com/jira/browse/TCCCCRS-97

Steps: 
1. Go to Setup -> Develop -> Apex Classes -> Schedule Apex (command button);
2. Fill fields:
    a) Job Name = CRS Weekdays Events
    b) Apex Class = CRS_WeekdaysEvents
    c) Frequency = Weekly
    d) Recurs every week on - Check Monday - Friday
    e) End = "01/01/2100"
    f) Preferred Start Time = 12:00 AM 

Before deploy:
1. Go to Setup -> Monitoring -> Scheduled Jobs
2. Delete "CRS Every Day Events" job

--------------------------------------------------------------------------------
Date: 2012-11-2
Changed By: Ivan Tsitulenka
References: hardcoded ids of jQuery library and object prefix 

Steps: 
1. Open CRS Review tab. URL will be something like '/a0o/o'. Where first three letters are id prefix of CRS Review object. Please remember them.
2. Go to Setup -> Customize -> Home -> Home Page Components. 
3. Edit 'CRS Area' component and check 'Show HTML' check box.
4. Find 'if ('a0o'==objectPefix){' and replace 'a0o' by id prefix your remembered in first step.
5. Save.


--------------------------------------------------------------------------------
Date: 2012-11-5
Changed By: Vitaly Baturchik
References: TCCCCRS-190 Allow Submitter to recall Approval Process 

For all 13 approval processes check 'Allow Submitters to Recall Approval Requests'.

--------------------------------------------------------------------------------
Date: 2012-11-6
Changed By: Ivan Tsitulenka
References: Delete CRS records on January 1, if they are older than 10 years  
https://jira.epam.com/jira/browse/TCCCCRS-18

Steps: 
1. Go to Setup -> Develop -> Apex Classes -> Schedule Apex (command button);
2. Fill fields:
    a) Job Name = CRS New Year Events
    b) Apex Class = CRS_NewYearEvents
    c) Frequency = Monthly
    d) Chouse "On day 1 of every month"
    e) End = "01/01/2100"
    f) Preferred Start Time = 12:00 AM 

Before deploy:
1. Go to Setup -> Monitoring -> Scheduled Jobs
2. Delete "CRS New Year Events" job

--------------------------------------------------------------------------------
Date: 2012-11-06
Changed By: Vasili Kalanchuk
References: hardcoded ids of jQuery library and object prefix 

Steps: 
1. Find out id prefixes of "CRS Attachment" (CRS_ContentWrapper__c) and "CRS Review Attachment" (CRS_CRSReviewContentWrapper__c)
   objects.
2. Go to Setup -> Customize -> Home -> Home Page Components. 
3. Edit 'CRS Area' component and check 'Show HTML' check box.
4. Find 'if ('a0A'==objectPefix || 'a0I'==objectPefix)' and replace 'a0A' and 'a0I' by id prefixes 
   of CRS Attachment (CRS_ContentWrapper__c) and CRS Review Attachment (CRS_CRSReviewContentWrapper__c)
   objects respectively.
5. Save.

--------------------------------------------------------------------------------
Date: 2012-11-13
Changed By: Vitaly Baturchik
References: TCCCCRS-229 Allow all CRS users to submit for approval

For all Approval Proccesses:
1. Open Approval and Edit "Initial Submitters".
2. Add three CRS roles to Allowed Submitters and Save. 

--------------------------------------------------------------------------------
Date: 2012-11-17
Changed By: George Huene
RE: Content Library access

Steps:
1. Make sure Content is enabled in the Org (Setup | App Setup | Salesforce CRM Content | "Enabled")
2. User detail must have "Salesforce CRM Content User" checkbox = true
3. Go to Library tab as SysAdmin/BusAdmin, and add the following Content Libraries:

(a) CRS Document Library - CRS Toolkit, Training Guide, Substantiation Resources, Description of Claim Types, Approved Messaging, Training Slides
    Group: CRS Business Admin = Author
    Group: CRS Corporate Level = Author
    Group: CRS Users = Viewer
(b) CRS Help/FAQ Library - Answers to frequently asked questions about CRS Application
    Group: CRS Business Admin = Author
    Group: CRS Corporate Level = Author
    Group: gvwCRS Corporate Level = Author  
    Group: CRS Users = Viewer
    Group: gvwCRS Users = Viewer
(c) CRS Review Library - General guidance documents
    Group: CRS Business Admin = Author
    Group: CRS Corporate Level = Author
    Group: CRS Review Only = Viewer
(d) gvwCRS Document Library - CRS Toolkit, Training Guide, Substantiation Resources, Description of Claim Types, Approved Messaging, Training Slides
    Group: CRS Business Admin = Author
    Group: gvwCRS Corporate Level = Author
    Group: gvwCRS Users = Viewer
(e) gvwCRS Review Library - General guidance documents
    Group: CRS Business Admin = Author
    Group: gvwCRS Corporate Level = Author
    Group: CRS Review Only = Viewer

--------------------------------------------------------------------------------
Date: 2012-11-19
Changed By: Vitaly Baturchik
References: Unlock Approvals, if next step for approval need to be selected - https://jira.epam.com/jira/browse/TCCCCRS-256

1. Unlock 'Final Approval Actions' for Approvals: 
Step1.2-Field SRA, 
Step2.3-Corporate SRA, 
Step2.3-Corporate SRA gvw,
Step2.3-Corp Form Govern Coke Branded

--------------------------------------------------------------------------------
Date: 2012-11-26
Changed By: Ivan Tsitulenka
References: Help FAQ for CRS

1. Go to tab "Libraries"
2. Swich "CRS Help/FAQ Library" Library
3. Copy Id from URL (part after "selectedWorkspaceId=").
4. Go to Setup -> Create -> Objects -> CRS
5. Open on edit custom button "Help FAQ"
6. Find "searchWorkspaceIds=%5B%22058K00000004GdH%22%5D" and replace all beetwen %5B%22 and "%22%5D" 
    by Id that your copy earlier 

--------------------------------------------------------------------------------
Date: 2012-12-05
Changed By: Vasili Kalanchuk
References: Dossier Template Link - https://jira.epam.com/jira/browse/TCCCCRS-301 

Steps: 
1. Go to Setup -> Customize -> Home -> Home Page Components. 
2. Edit 'CRS Area' component and check 'Show HTML' check box.
3. Find '/sfc/#version?selectedDocumentId=069K00000008u7e' and replace value for selectedDocumentId parameter
with correct Id of Dossier template document.
4. Save.

================================================================================
PROFILES MANUAL SETUP
--------------------------------------------------------------------------------
Date: 2012-11-09
Changed By: Vitaly Baturchik
References: Check 'API Enabled' permission - https://jira.epam.com/jira/browse/TCCCCRS-218

Steps: Check 'API Enabled' permission for all User Profiles.

--------------------------------------------------------------------------------
Date: 2012-11-16
Changed By: Andrei Soika
References: Setup view of top navigation - https://jira.epam.com/jira/browse/TCCCCRS-257

Steps:
For "System Administrator" profile:
Select apps which you need in "Custom App Settings" section.

For others profile:
Select only "CRS Approval" app in "Custom App Settings" section.

And for each user should be unchecked "Accessibility Mode" in "General Information" section. (This state on default.)

--------------------------------------------------------------------------------
Date: 2012-11-22
Changed By: Vasili Kalanchuk
References: https://jira.epam.com/jira/browse/TCCCCRS-254

Steps:
For all "CRS..." Profiles select "Default On" tab setting for Library.

--------------------------------------------------------------------------------
Date: 2012-12-04
Changed By: Vasili Kalanchuk
References: https://jira.epam.com/jira/browse/TCCCCRS-298

Steps:
For 3 "CRS...Standard User" Profiles uncheck "View Setup and Configuration" permission. 

================================================================================

--------------------------------------------------------------------------------
Date: 2012-11-22
Changed By: Andrei Soika
References: Users (exsept BA and SA) do not have permissions to dashboards. - https://jira.epam.com/jira/browse/TCCCCRS-284

Open the edit page CRS_Dashboards. Change the value in the "View Edit Page as" user with license "Salesforce Platform".

--------------------------------------------------------------------------------
Date: 2013-03-25
Changed By: Ivan Tsitulenka
References: Custom Sidebar Components dont show on all pages

Steps:
1. Go to Setup -> Customize -> User Interface
2. Check "Show Custom Sidebar Components on All Pages" in section Sidebar.
3. Save. 

--------------------------------------------------------------------------------

Date: 2013-04-03
Changed By: Ivan Tsitulenka
References: 1800 - CRS Business Admin Rights  

Steps: 
1. Go to Setup -> Develop -> Apex Classes -> Schedule Apex (command button);
2. Fill fields:
    a) Job Name = CRS Every Day Events
    b) Apex Class = CRS_EveryDayEvents
    c) Frequency = Weekly
    d) Recurs every week on - Check all days
    e) End = "01/01/2100"
    f) Preferred Start Time = 12:00 AM 

Before deploy:
1. Go to Setup -> Monitoring -> Scheduled Jobs
2. Delete "CRS Every Day Events" job


--------------------------------------------------------------------------------

Date: 2013-06-21
Changed By: Ivan Tsitulenka

-----For production only!!!-----

Steps: 
1. Go to Setup -> Customize -> Users -> Page Layouts;
2. Click Edit link for CRS User Layout
3. Add custom link "Edit Agents" to "Edit RFA Agent Details" section

*/
@isTest
global class CRS_ANonMetadataChanges {

}