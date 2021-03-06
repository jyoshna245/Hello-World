/**
 * Copyright (c) 2012, FinancialForce.com, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *      this list of conditions and the following disclaimer in the documentation
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors
 *      may be used to endorse or promote products derived from this software without
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/


//Generated by wsdl2apex

/*
 * WARNING: Parts of this file have been manually edited post generation by the WSDL2Apex tool,
 *          please review the readme at https://github.com/financialforcedev/apex-mdapi for more information
 */

public class MetadataService {
	public class DebuggingInfo_element {
        public String debugLog;
        private String[] debugLog_type_info = new String[]{'debugLog','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'debugLog'};
    }
    public class CallOptions_element {
        public String client;
        private String[] client_type_info = new String[]{'client','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'client'};
    }
     public class LogInfo {
        public String category;
        public String level;
        private String[] category_type_info = new String[]{'category','http://soap.sforce.com/2006/04/metadata','LogCategory','1','1','false'};
        private String[] level_type_info = new String[]{'level','http://soap.sforce.com/2006/04/metadata','LogCategoryLevel','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'category','level'};
    }
     public class DebuggingHeader_element {
        public MetadataService.LogInfo[] categories;
        public String debugLevel;
        private String[] categories_type_info = new String[]{'categories','http://soap.sforce.com/2006/04/metadata','LogInfo','0','-1','false'};
        private String[] debugLevel_type_info = new String[]{'debugLevel','http://soap.sforce.com/2006/04/metadata','LogType','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'categories','debugLevel'};
    }
     public class retrieve_element {
        public MetadataService.RetrieveRequest retrieveRequest;
        private String[] retrieveRequest_type_info = new String[]{'retrieveRequest','http://soap.sforce.com/2006/04/metadata','RetrieveRequest','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'retrieveRequest'};
    }
     public class RetrieveRequest {
        public Double apiVersion;
        public String[] packageNames;
        public Boolean singlePackage;
        public String[] specificFiles;
        public MetadataService.Package_x unpackaged;
        private String[] apiVersion_type_info = new String[]{'apiVersion','http://www.w3.org/2001/XMLSchema','double','1','1','false'};
        private String[] packageNames_type_info = new String[]{'packageNames','http://www.w3.org/2001/XMLSchema','string','0','-1','false'};
        private String[] singlePackage_type_info = new String[]{'singlePackage','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] specificFiles_type_info = new String[]{'specificFiles','http://www.w3.org/2001/XMLSchema','string','0','-1','false'};
        private String[] unpackaged_type_info = new String[]{'unpackaged','http://soap.sforce.com/2006/04/metadata','Package','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'apiVersion','packageNames','singlePackage','specificFiles','unpackaged'};
    }
       public class Package_x {
        public String apiAccessLevel;
        public String description;
        public String namespacePrefix;
        public MetadataService.ProfileObjectPermissions[] objectPermissions;
        public String postInstallClass;
        public String setupWeblink;
        public MetadataService.PackageTypeMembers[] types;
        public String uninstallClass;
        public String version;
        private String[] apiAccessLevel_type_info = new String[]{'apiAccessLevel','http://soap.sforce.com/2006/04/metadata','APIAccessLevel','0','1','false'};
        private String[] description_type_info = new String[]{'description','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] namespacePrefix_type_info = new String[]{'namespacePrefix','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] objectPermissions_type_info = new String[]{'objectPermissions','http://soap.sforce.com/2006/04/metadata','ProfileObjectPermissions','0','-1','false'};
        private String[] postInstallClass_type_info = new String[]{'postInstallClass','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] setupWeblink_type_info = new String[]{'setupWeblink','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] types_type_info = new String[]{'types','http://soap.sforce.com/2006/04/metadata','PackageTypeMembers','0','-1','false'};
        private String[] uninstallClass_type_info = new String[]{'uninstallClass','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] version_type_info = new String[]{'version','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'apiAccessLevel','description','namespacePrefix','objectPermissions','postInstallClass','setupWeblink','types','uninstallClass','version'};
    }
     public class ProfileObjectPermissions {
        public Boolean allowCreate;
        public Boolean allowDelete;
        public Boolean allowEdit;
        public Boolean allowRead;
        public Boolean modifyAllRecords;
        public String object_x;
        public Boolean viewAllRecords;
        private String[] allowCreate_type_info = new String[]{'allowCreate','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] allowDelete_type_info = new String[]{'allowDelete','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] allowEdit_type_info = new String[]{'allowEdit','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] allowRead_type_info = new String[]{'allowRead','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] modifyAllRecords_type_info = new String[]{'modifyAllRecords','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] object_x_type_info = new String[]{'object','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] viewAllRecords_type_info = new String[]{'viewAllRecords','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'allowCreate','allowDelete','allowEdit','allowRead','modifyAllRecords','object_x','viewAllRecords'};
    }
     public class PackageTypeMembers {
        public String[] members;
        public String name;
        private String[] members_type_info = new String[]{'members','http://www.w3.org/2001/XMLSchema','string','0','-1','false'};
        private String[] name_type_info = new String[]{'name','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'members','name'};
    }
    public class retrieveResponse_element {
        public MetadataService.AsyncResult result;
        private String[] result_type_info = new String[]{'result','http://soap.sforce.com/2006/04/metadata','AsyncResult','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
     public class AsyncResult {
        public Boolean checkOnly;
        public Boolean done;
        public String id;
        public String message;
        public Integer numberComponentErrors;
        public Integer numberComponentsDeployed;
        public Integer numberComponentsTotal;
        public Integer numberTestErrors;
        public Integer numberTestsCompleted;
        public Integer numberTestsTotal;
        public String state;
        public String stateDetail;
        public DateTime stateDetailLastModifiedDate;
        public String statusCode;
        private String[] checkOnly_type_info = new String[]{'checkOnly','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] done_type_info = new String[]{'done','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] id_type_info = new String[]{'id','http://soap.sforce.com/2006/04/metadata','ID','1','1','false'};
        private String[] message_type_info = new String[]{'message','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] numberComponentErrors_type_info = new String[]{'numberComponentErrors','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        private String[] numberComponentsDeployed_type_info = new String[]{'numberComponentsDeployed','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        private String[] numberComponentsTotal_type_info = new String[]{'numberComponentsTotal','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        private String[] numberTestErrors_type_info = new String[]{'numberTestErrors','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        private String[] numberTestsCompleted_type_info = new String[]{'numberTestsCompleted','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        private String[] numberTestsTotal_type_info = new String[]{'numberTestsTotal','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        private String[] state_type_info = new String[]{'state','http://soap.sforce.com/2006/04/metadata','AsyncRequestState','1','1','false'};
        private String[] stateDetail_type_info = new String[]{'stateDetail','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] stateDetailLastModifiedDate_type_info = new String[]{'stateDetailLastModifiedDate','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        private String[] statusCode_type_info = new String[]{'statusCode','http://soap.sforce.com/2006/04/metadata','StatusCode','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'checkOnly','done','id','message','numberComponentErrors','numberComponentsDeployed','numberComponentsTotal','numberTestErrors','numberTestsCompleted','numberTestsTotal','state','stateDetail','stateDetailLastModifiedDate','statusCode'};
    }
      public class update_element {
        public MetadataService.UpdateMetadata[] UpdateMetadata;
        private String[] UpdateMetadata_type_info = new String[]{'UpdateMetadata','http://soap.sforce.com/2006/04/metadata','UpdateMetadata','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'UpdateMetadata'};
    }
      public class UpdateMetadata {
        public String currentName;
        public MetadataService.Metadata metadata;
        private String[] currentName_type_info = new String[]{'currentName','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] metadata_type_info = new String[]{'metadata','http://soap.sforce.com/2006/04/metadata','Metadata','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'currentName','metadata'};
    }
    public virtual class Metadata {
        public String fullName;
        private String[] fullName_type_info = new String[]{'fullName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'fullName'};
    }
    public class MetadataPort {
        public String endpoint_x;
        {
          URL baseUrl = URL.getSalesforceBaseUrl();
          endpoint_x = baseUrl.toExternalForm() + '/services/Soap/m/28.0';
        }
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public MetadataService.SessionHeader_element SessionHeader;
        public MetadataService.DebuggingInfo_element DebuggingInfo;
        public MetadataService.CallOptions_element CallOptions;
        public MetadataService.DebuggingHeader_element DebuggingHeader;
        private String SessionHeader_hns = 'SessionHeader=http://soap.sforce.com/2006/04/metadata';
        private String DebuggingInfo_hns = 'DebuggingInfo=http://soap.sforce.com/2006/04/metadata';
        private String CallOptions_hns = 'CallOptions=http://soap.sforce.com/2006/04/metadata';
        private String DebuggingHeader_hns = 'DebuggingHeader=http://soap.sforce.com/2006/04/metadata';
        private String[] ns_map_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata', 'MetadataService'};
        public MetadataService.AsyncResult retrieve(MetadataService.RetrieveRequest retrieveRequest) {
            MetadataService.retrieve_element request_x = new MetadataService.retrieve_element();
            MetadataService.retrieveResponse_element response_x;
            request_x.retrieveRequest = retrieveRequest;
            Map<String, MetadataService.retrieveResponse_element> response_map_x = new Map<String, MetadataService.retrieveResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/2006/04/metadata',
              'retrieve',
              'http://soap.sforce.com/2006/04/metadata',
              'retrieveResponse',
              'MetadataService.retrieveResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }


        public MetadataService.AsyncResult[] updateMetadata(MetadataService.UpdateMetadata[] UpdateMetadata) {
            MetadataService.update_element request_x = new MetadataService.update_element();
            MetadataService.updateResponse_element response_x;
            request_x.UpdateMetadata = UpdateMetadata;
            Map<String, MetadataService.updateResponse_element> response_map_x = new Map<String, MetadataService.updateResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/2006/04/metadata',
              'update',
              'http://soap.sforce.com/2006/04/metadata',
              'updateResponse',
              'MetadataService.updateResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
    }
     public class updateResponse_element {
        public MetadataService.AsyncResult[] result;
        private String[] result_type_info = new String[]{'result','http://soap.sforce.com/2006/04/metadata','AsyncResult','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
  public class SessionHeader_element {
        public String sessionId;
        private String[] sessionId_type_info = new String[]{'sessionId','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'sessionId'};
    }
  public class Picklist {
        public String controllingField;
        public MetadataService.PicklistValue[] picklistValues;
        public Boolean sorted;
        private String[] controllingField_type_info = new String[]{'controllingField','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] picklistValues_type_info = new String[]{'picklistValues','http://soap.sforce.com/2006/04/metadata','PicklistValue','0','-1','false'};
        private String[] sorted_type_info = new String[]{'sorted','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'controllingField','picklistValues','sorted'};
    }
  public class CustomField extends Metadata {
      public String type = 'CustomField';
      public String fullName;
        public Boolean caseSensitive;
        public String customDataType;
        public String defaultValue;
        public String deleteConstraint;
        public Boolean deprecated;
        public String description;
        public String displayFormat;
        public Boolean escapeMarkup;
        public String externalDeveloperName;
        public Boolean externalId;
        public String formula;
        public String formulaTreatBlanksAs;
        public String inlineHelpText;
        public Boolean isFilteringDisabled;
        public Boolean isNameField;
        public Boolean isSortingDisabled;
        public String label;
        public Integer length;
        public String maskChar;
        public String maskType;
        public MetadataService.Picklist picklist;
        public Boolean populateExistingRows;
        public Integer precision;
        public String referenceTo;
        public String relationshipLabel;
        public String relationshipName;
        public Integer relationshipOrder;
        public Boolean reparentableMasterDetail;
        public Boolean required;
        public Boolean restrictedAdminField;
        public Integer scale;
        public Integer startingNumber;
        public Boolean stripMarkup;
        public String summarizedField;
        public MetadataService.FilterItem[] summaryFilterItems;
        public String summaryForeignKey;
        public String summaryOperation;
        public Boolean trackFeedHistory;
        public Boolean trackHistory;
        public String type_x;
        public Boolean unique;
        public Integer visibleLines;
        public Boolean writeRequiresMasterRead;
    private String[] type_att_info = new String[]{'xsi:type'};
    private String[] fullName_type_info = new String[]{'fullName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] caseSensitive_type_info = new String[]{'caseSensitive','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] customDataType_type_info = new String[]{'customDataType','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] defaultValue_type_info = new String[]{'defaultValue','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] deleteConstraint_type_info = new String[]{'deleteConstraint','http://soap.sforce.com/2006/04/metadata','DeleteConstraint','0','1','false'};
        private String[] deprecated_type_info = new String[]{'deprecated','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] description_type_info = new String[]{'description','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] displayFormat_type_info = new String[]{'displayFormat','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] escapeMarkup_type_info = new String[]{'escapeMarkup','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] externalDeveloperName_type_info = new String[]{'externalDeveloperName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] externalId_type_info = new String[]{'externalId','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] formula_type_info = new String[]{'formula','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] formulaTreatBlanksAs_type_info = new String[]{'formulaTreatBlanksAs','http://soap.sforce.com/2006/04/metadata','TreatBlanksAs','0','1','false'};
        private String[] inlineHelpText_type_info = new String[]{'inlineHelpText','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] isFilteringDisabled_type_info = new String[]{'isFilteringDisabled','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] isNameField_type_info = new String[]{'isNameField','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] isSortingDisabled_type_info = new String[]{'isSortingDisabled','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] label_type_info = new String[]{'label','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] length_type_info = new String[]{'length','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        private String[] maskChar_type_info = new String[]{'maskChar','http://soap.sforce.com/2006/04/metadata','EncryptedFieldMaskChar','0','1','false'};
        private String[] maskType_type_info = new String[]{'maskType','http://soap.sforce.com/2006/04/metadata','EncryptedFieldMaskType','0','1','false'};
        private String[] picklist_type_info = new String[]{'picklist','http://soap.sforce.com/2006/04/metadata','Picklist','0','1','false'};
        private String[] populateExistingRows_type_info = new String[]{'populateExistingRows','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] precision_type_info = new String[]{'precision','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        private String[] referenceTo_type_info = new String[]{'referenceTo','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] relationshipLabel_type_info = new String[]{'relationshipLabel','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] relationshipName_type_info = new String[]{'relationshipName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] relationshipOrder_type_info = new String[]{'relationshipOrder','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        private String[] reparentableMasterDetail_type_info = new String[]{'reparentableMasterDetail','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] required_type_info = new String[]{'required','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] restrictedAdminField_type_info = new String[]{'restrictedAdminField','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] scale_type_info = new String[]{'scale','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        private String[] startingNumber_type_info = new String[]{'startingNumber','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        private String[] stripMarkup_type_info = new String[]{'stripMarkup','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] summarizedField_type_info = new String[]{'summarizedField','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] summaryFilterItems_type_info = new String[]{'summaryFilterItems','http://soap.sforce.com/2006/04/metadata','FilterItem','0','-1','false'};
        private String[] summaryForeignKey_type_info = new String[]{'summaryForeignKey','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] summaryOperation_type_info = new String[]{'summaryOperation','http://soap.sforce.com/2006/04/metadata','SummaryOperations','0','1','false'};
        private String[] trackFeedHistory_type_info = new String[]{'trackFeedHistory','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] trackHistory_type_info = new String[]{'trackHistory','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] type_x_type_info = new String[]{'type','http://soap.sforce.com/2006/04/metadata','FieldType','1','1','false'};
        private String[] unique_type_info = new String[]{'unique','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] visibleLines_type_info = new String[]{'visibleLines','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        private String[] writeRequiresMasterRead_type_info = new String[]{'writeRequiresMasterRead','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'fullName','caseSensitive','customDataType','defaultValue','deleteConstraint','deprecated','description','displayFormat','escapeMarkup','externalDeveloperName','externalId','formula','formulaTreatBlanksAs','inlineHelpText','isFilteringDisabled','isNameField','isSortingDisabled','label','length','maskChar','maskType','picklist','populateExistingRows','precision','referenceTo','relationshipLabel','relationshipName','relationshipOrder','reparentableMasterDetail','required','restrictedAdminField','scale','startingNumber','stripMarkup','summarizedField','summaryFilterItems','summaryForeignKey','summaryOperation','trackFeedHistory','trackHistory','type_x','unique','visibleLines','writeRequiresMasterRead'};
    }
  public class FilterItem {
        public String field;
        public String operation;
        public String value;
        public String valueField;
        private String[] field_type_info = new String[]{'field','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] operation_type_info = new String[]{'operation','http://soap.sforce.com/2006/04/metadata','FilterOperation','1','1','false'};
        private String[] value_type_info = new String[]{'value','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] valueField_type_info = new String[]{'valueField','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'field','operation','value','valueField'};
    }

  public class PicklistValue extends Metadata {
    public String type = 'PicklistValue';
    public String fullName;
        public Boolean allowEmail;
        public Boolean closed;
        public String color;
        public String[] controllingFieldValues;
        public Boolean converted;
        public Boolean cssExposed;
        public Boolean default_x;
        public String description;
        public String forecastCategory;
        public Boolean highPriority;
        public Integer probability;
        public String reverseRole;
        public Boolean reviewed;
        public Boolean won;
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] allowEmail_type_info = new String[]{'allowEmail','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] closed_type_info = new String[]{'closed','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] color_type_info = new String[]{'color','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] controllingFieldValues_type_info = new String[]{'controllingFieldValues','http://www.w3.org/2001/XMLSchema','string','0','-1','false'};
        private String[] converted_type_info = new String[]{'converted','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] cssExposed_type_info = new String[]{'cssExposed','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] default_x_type_info = new String[]{'default','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] description_type_info = new String[]{'description','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] forecastCategory_type_info = new String[]{'forecastCategory','http://soap.sforce.com/2006/04/metadata','ForecastCategories','0','1','false'};
        private String[] highPriority_type_info = new String[]{'highPriority','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] probability_type_info = new String[]{'probability','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        private String[] reverseRole_type_info = new String[]{'reverseRole','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] reviewed_type_info = new String[]{'reviewed','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] won_type_info = new String[]{'won','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'allowEmail','closed','color','controllingFieldValues','converted','cssExposed','default_x','description','forecastCategory','highPriority','probability','reverseRole','reviewed','won'};
    }

     public class RecordTypePicklistValue {
        public String picklist;
        public MetadataService.PicklistValue[] values;
        private String[] picklist_type_info = new String[]{'picklist','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] values_type_info = new String[]{'values','http://soap.sforce.com/2006/04/metadata','PicklistValue','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'picklist','values'};
    }
     public class RecordType extends Metadata {
      public String type = 'RecordType';
        public String fullName;
        public Boolean active;
        public String businessProcess;
        public String description;
        public String label;
        public MetadataService.RecordTypePicklistValue[] picklistValues;
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] active_type_info = new String[]{'active','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] businessProcess_type_info = new String[]{'businessProcess','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] description_type_info = new String[]{'description','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] label_type_info = new String[]{'label','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] picklistValues_type_info = new String[]{'picklistValues','http://soap.sforce.com/2006/04/metadata','RecordTypePicklistValue','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'active','businessProcess','description','label','picklistValues'};
    }



    }