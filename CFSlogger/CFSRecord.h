//
//  CFSRecord.h
//  MECFSJournal
//
//  Created by Arturo Plottier on 12/02/2014.
//  Copyright (c) 2014 pac-apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFSRecord : NSObject
{
    
    NSString *RecordedDate;
    NSString *UserName;
    NSInteger ActId;
   // NSInteger ServerRecordID;
  //  NSInteger ADateId;
    NSString *FromTime;
    NSString *ToTime;
    NSString *ActivityType;
    NSString *ActivityTitle;
    NSString *ActivityDesc;
    int EnergyLevel;
    NSString *Field1;
    NSString *Field2;
   // NSInteger SymId;
   // NSInteger SDateId;
    NSString *Severity;
    NSString *SymptomName;
    NSString *SymptomTitle;
    NSString *SymptomDesc;
    
 
}


//table Activity
@property (strong, nonatomic) NSString *UserName;
@property (strong, nonatomic) NSString *RecordedDate;
@property (nonatomic, assign)NSInteger ActId;
//@property (nonatomic, assign)NSInteger ServerRecordID;
//@property (nonatomic, assign)NSInteger ADateId;
@property (strong, nonatomic) NSString *FromTime;
@property (strong, nonatomic) NSString *ToTime;
@property (strong, nonatomic) NSString *ActivityType;
@property (strong, nonatomic) NSString *ActivityTitle;
@property (strong, nonatomic) NSString *ActivityDesc;
@property int EnergyLevel;
@property (strong, nonatomic) NSString *Field2;
@property (strong, nonatomic) NSString *Field1;
//@property (nonatomic, assign)NSInteger SymId;
//@property (nonatomic, assign)NSInteger SDateId;
@property (strong, nonatomic) NSString *SymptomName;
@property (strong, nonatomic) NSString *Severity;
@property (strong, nonatomic) NSString *SymptomTitle;
@property (strong, nonatomic) NSString *SymptomDesc;

-(id) initWithUniqueId:(NSString *)aRecordedDate
              UserName:(NSString *)aUsername
                 ActId:(NSInteger)aActId
        // ServerRecordID:(NSInteger)aServerRecordID
              FromTime:(NSString *)aFromTime
                ToTime:(NSString *)aToTime
          ActivityType:(NSString *)aActivityType
         ActivityTitle:(NSString *)aActivityTitle
          ActivityDesc:(NSString *)aActivityDesc
           EnergyLevel:(int)aEnergyLevel
             Field1:(NSString *)aField1
         Field2:(NSString *)aField2
                     SymptomName:(NSString *)aSymptomName
              Severity:(NSString *)aSeverity
          SymptomTitle:(NSString *)aSymptomTitle
           SymptomDesc:(NSString *)aSymptomDesc;



-(id) copyArray: (NSMutableArray *)record;


@end
