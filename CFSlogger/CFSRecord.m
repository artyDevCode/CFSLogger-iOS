//
//  CFSRecord.m
//  MECFSJournal
//
//  Created by Arturo Plottier on 12/02/2014.
//  Copyright (c) 2014 pac-apps. All rights reserved.
//

#import "CFSRecord.h"

@implementation CFSRecord

@synthesize UserName, RecordedDate, SymptomTitle, Field2, Severity, SymptomName, SymptomDesc, Field1, ActId, ActivityTitle, FromTime, ToTime, ActivityType, ActivityDesc, EnergyLevel ; //ADateId

-(id) initWithUniqueId:(NSString *)aRecordedDate
          UserName:(NSString *)aUsername
                 ActId:(NSInteger)aActId
               //  ServerRecordID:(NSInteger)aServerRecordID
              FromTime:(NSString *)aFromTime
                ToTime:(NSString *)aToTime
          ActivityType:(NSString *)aActivityType
         ActivityTitle:(NSString *)aActivityTitle
          ActivityDesc:(NSString *)aActivityDesc
           EnergyLevel:(int)aEnergyLevel
             Field1:(NSString *)aField1
         Field2:(NSString *)aField2
            //    SymId:(NSInteger)aSymId
           // SDateId:(NSInteger)aSDateId
            SymptomName:(NSString *)aSymptomName
              Severity:(NSString *)aSeverity
            SymptomTitle:(NSString *)aSymptomTitle
            SymptomDesc:(NSString *)aSymptomDesc


{
  	self = [super init];
	
	if (self)
	{
		//self.DRDateId = aDRDateId;
        self.RecordedDate = aRecordedDate;
        self.UserName = aUsername;
        self.ActId = aActId;
      //  self.ServerRecordID = aServerRecordID;
        self.FromTime = aFromTime;
        self.ToTime = aToTime;
        self.ActivityType = aActivityType;
        self.ActivityTitle = aActivityTitle;
        self.ActivityDesc = aActivityDesc;
        self.EnergyLevel = aEnergyLevel;
        self.Field1 = aField1;
        self.Field2 = aField2;
       // self.SymId = aSymId;
       // self.SDateId = aSDateId;
        self.SymptomName = aSymptomName;
        self.Severity = aSeverity;
        self.SymptomTitle = aSymptomTitle;
        self.SymptomDesc = aSymptomDesc;
        
          }
	return self;
}

-(id) copyArray: (CFSRecord *)record
{
       // self = [super init];
        
    NSMutableArray * array1 = [[NSMutableArray alloc]init];
    [array1  addObject:record];
   // array1 = [record mutableCopy];
    return self;

}

@end
