trigger CRS_CRSDossier on CRS_Dossier__c (before update) {
	for(CRS_Dossier__c obj : trigger.new){
		obj.Section_1_1__c = (obj.Section_1_1__c != null) ? obj.Section_1_1__c : 'NA';
		obj.Section_1_2__c = (obj.Section_1_2__c != null) ? obj.Section_1_2__c : 'NA';
		obj.Section_2_0__c = (obj.Section_2_0__c != null) ? obj.Section_2_0__c : 'NA';
		obj.Section_3_0__c = (obj.Section_3_0__c != null) ? obj.Section_3_0__c : 'NA';
		obj.Section_3_1__c = (obj.Section_3_1__c != null) ? obj.Section_3_1__c : 'NA';
		obj.Section_3_2__c = (obj.Section_3_2__c != null) ? obj.Section_3_2__c : 'NA';
		obj.Section_4_1__c = (obj.Section_4_1__c != null) ? obj.Section_4_1__c : 'NA';
		obj.Section_4_2__c = (obj.Section_4_2__c != null) ? obj.Section_4_2__c : 'NA';
		obj.Section_4_3__c = (obj.Section_4_3__c != null) ? obj.Section_4_3__c : 'NA';
		obj.Section_4_4__c = (obj.Section_4_4__c != null) ? obj.Section_4_4__c : 'NA';
		obj.Section_4_5__c = (obj.Section_4_5__c != null) ? obj.Section_4_5__c : 'NA';
		obj.Section_4_6__c = (obj.Section_4_6__c != null) ? obj.Section_4_6__c : 'NA';
		obj.Section_4_7__c = (obj.Section_4_7__c != null) ? obj.Section_4_7__c : 'NA';
		obj.Section_4_8__c = (obj.Section_4_8__c != null) ? obj.Section_4_8__c : 'NA';
		obj.Section_5_1__c = (obj.Section_5_1__c != null) ? obj.Section_5_1__c : 'NA';
		obj.Section_5_2__c = (obj.Section_5_2__c != null) ? obj.Section_5_2__c : 'NA';
		obj.Section_6_1__c = (obj.Section_6_1__c != null) ? obj.Section_6_1__c : 'NA';
		obj.Section_6_2__c = (obj.Section_6_2__c != null) ? obj.Section_6_2__c : 'NA';
		obj.Section_6_3__c = (obj.Section_6_3__c != null) ? obj.Section_6_3__c : 'NA';
		obj.Section_6_4__c = (obj.Section_6_4__c != null) ? obj.Section_6_4__c : 'NA';
		obj.Section_6_5__c = (obj.Section_6_5__c != null) ? obj.Section_6_5__c : 'NA';
		obj.Section_6_6__c = (obj.Section_6_6__c != null) ? obj.Section_6_6__c : 'NA';
		obj.Section_7_1__c = (obj.Section_7_1__c != null) ? obj.Section_7_1__c : 'NA';
		obj.Section_7_2__c = (obj.Section_7_2__c != null) ? obj.Section_7_2__c : 'NA';
		obj.Section_8_0__c = (obj.Section_8_0__c != null) ? obj.Section_8_0__c : 'NA';
		obj.Section_9_0__c = (obj.Section_9_0__c != null) ? obj.Section_9_0__c : 'NA';
		obj.Section_10_1__c = (obj.Section_10_1__c != null) ? obj.Section_10_1__c : 'NA';
		obj.Section_10_2__c = (obj.Section_10_2__c != null) ? obj.Section_10_2__c : 'NA';
		obj.Section_11_0__c = (obj.Section_11_0__c != null) ? obj.Section_11_0__c : 'NA';
	}
}