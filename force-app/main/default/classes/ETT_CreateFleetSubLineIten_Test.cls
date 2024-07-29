@isTest public class ETT_CreateFleetSubLineIten_Test {
    
    @isTest public Static void CodeCoverage(){
        
        Lead lead = new Lead();
        lead.Company = 'test';
        lead.LastName = 'dubai';
       lead.Phone = '98765432';
        insert lead;
        
        Account acc = new Account();
        acc.Name = 'Test account';
        insert acc;
        
        Contact cont = new Contact();
        //cont.Phone = '+971 546789765';
        cont.AccountId = acc.Id;
        cont.LastName = 'devpleena';
        insert cont;
        
        ETT_Fleet_Inspection__c FleetInspection = new ETT_Fleet_Inspection__c();
        FleetInspection.ETT_Account__c = acc.Id;
        FleetInspection.Lead__c = lead.Id;
        insert FleetInspection;
        Test.startTest();
        Fleet_Inspection_Line_Item__c FleetlineItem = new Fleet_Inspection_Line_Item__c();
        FleetlineItem.Fleet_Inspection__c = FleetInspection.id;
        FleetlineItem.ETT_Bad_Reason_Complaint__c = 'Spread/Damaged Cord;Bead Area Flow Crack;Torn Bead;Kinked/Distorted Beads Condition;Bead Deformation;Reinforce / Chafer Separation;Bead Damage From Curbing;Burned Beads;Petro/ Lubricant Damage;'+
            										'Sidewall Separation;Vehicle/Equipment Damage;Sidewall Abrasion/Scuff Damage;Impact Break;Diagonal Cracking;Forklift Damage;Petroleum Product Damage;Branding Damage;Aging Crack/Weathering;Damage Induced Sidewall Separation;Chain Damage;Cuts and Snags;Steer Axle Shoulder Step/Chamfer Wear;'+
            										'Feather Wear;Cupping/Scallop Wear;Diagonal Wear;Steer Axle Overall Fast Wear;Erratic Depression Wear;Full Shoulder Wear;Erosion/River/Channel Wear;Steer Axle One Sided Wear;Eccentric/Out-Of-Round Wear;Rib Depression/Punch Wear;Drive Axle Shoulder Step/Chamfer Wear;Alternate Lug Wear;'
            										+'Drive Axle Overall Fast Wear;Heel/Toe Wear;Break Skid/Flat Spot Wear;Break Skid Flat Spot Wear;Multiple Flat Spotting Wire;Shoulder Scrubbing/Scuffing Wear;Erratic Depression Wear;Erosion/River/Channel Wear;Diagonal Wear;Rapid Shoulder Wear – Both Shoulder;Trailer Axle One Sided Wear;Rib Depression/Punch Wear;Open Inner Liner Splice;Inner Liner Cracking;Tearing, Mount/Dismount Damage;';
       // FleetlineItem
        insert FleetlineItem;
        Test.stopTest();
    }
    
       @isTest public Static void CodeCoverage1(){
        
        Lead lead = new Lead();
        lead.Company = 'test';
        lead.LastName = 'dubai';
           lead.Phone = '98765432';
        insert lead;
        
        Account acc = new Account();
        acc.Name = 'Test account';
        insert acc;
        
        Contact cont = new Contact();
        cont.Phone = '+971 546789765';
        cont.AccountId = acc.Id;
        cont.LastName = 'devpleena';
        insert cont;
        
        ETT_Fleet_Inspection__c FleetInspection = new ETT_Fleet_Inspection__c();
        FleetInspection.ETT_Account__c = acc.Id;
        FleetInspection.Lead__c = lead.Id;
        insert FleetInspection;
        Test.startTest();
        Fleet_Inspection_Line_Item__c FleetlineItem = new Fleet_Inspection_Line_Item__c();
        FleetlineItem.Fleet_Inspection__c = FleetInspection.id;
        FleetlineItem.ETT_Bad_Reason_Complaint__c = 'Run Flat;Impact Break;Penetrating Object;Inner Liner Bubbles, Blisters and Separations;Failed Inner Liner Repair;Lug Base Cracking/Tearing;Improper Tread Width;Repair Related Bulge;Buckled Tread;Delamination;Tread Surface Porosity;Wing Lift;Failed Repair from Under Inflation;Open Tread Splice;Bridged Repair;Belt Separation Repair Related;Missed Puncture;Tread Edge Lifting;Tread Chunking at Splice;Tread Separation;Tread Chunking at Splice;Bond Line Porosity;Bias Repair in Radial Tyre;Bridged Repair;Bad Bead Repair;Failed Repair – Injury Not Removed;On the Wheel Repair;Improper Nail Hole Repair;Improperly Aligned repair;Spot Repair Should be a Section Repair;Bad Spot Repair;Sidewall Bumps (Blisters);Open Sidewall Splice;Circumferential Fatigue Rupture (Zipper);Pulled/Loose Cords;Foreign Object Inner Liner Damage In Tubeless Tyre;Pinch Shock;Electrical Discharge';
        insert FleetlineItem;
        Test.stopTest();
    }
}