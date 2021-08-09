//
//  CFSDB.h
//  CFSlogger
//
//  Created by pac-apps on 30/11/13.
//  Copyright (c) 2013 pac-apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "CFSRecord.h"
//#import "ActivityTbl.h"

@interface CFSDB : NSObject{
    sqlite3 * database;
}

//-(void)updateDB:(CFSRecord *)Record;

+(CFSDB *) database;

//-(sqlite3_int64)insertDateRecord:(NSString *)Record;
-(void)insertActivity:(CFSRecord *)Record;
//-(sqlite3_int64)insertSymptom:(CFSRecord *)Record;
-(void)updateActivity:(CFSRecord *)Record;
//-(void)updateSymptoms:(CFSRecord *)Record;
//-(void)getAllSymptoms:(NSInteger)sdateid;
//-(void)getAllSymptoms:(NSInteger)symid sdateid:(NSInteger) sdateid;


//@property (nonatomic, assign)NSInteger symId;
//@property (nonatomic, assign)NSInteger sdateId;
@property (nonatomic, strong)NSString *username;
@property (nonatomic, strong)NSString *symptomName;
@property (nonatomic, strong)NSString *symptomTitle;
@property (nonatomic, strong)NSString *symptomDesc;
@property (nonatomic, strong)NSString *severity;
//@property (nonatomic, assign)NSInteger drdateId;
@property (nonatomic, strong)NSString *recordedDate;
//@property (nonatomic, assign)NSInteger adateId;
@property (nonatomic, assign)NSInteger actId;
//@property (nonatomic, assign)NSInteger serverRecordID;
@property (nonatomic, strong)NSString *fromTime;
@property (nonatomic, strong)NSString *toTime;
@property (nonatomic, strong)NSString *activityType;
@property (nonatomic, strong)NSString *activityTitle;
@property (nonatomic, strong)NSString *activityDesc;
@property (nonatomic, assign)int energyLevel;
@property (nonatomic, strong)NSString* field1;
@property (nonatomic, strong)NSString* field2;


-(NSMutableArray *)searchRecords;
-(NSMutableArray *)getAllRecords:(NSString *)mySelectedDate;
-(NSMutableArray *)getAllRecordsSync:(NSString *)CalendarFirstDate claLastDate:(NSString *) CalendarLastDate;
-(sqlite3_int64)checkExistingRecords:(NSString *)mySelectedDate;
-(NSMutableArray *)getLatestRecords;


@end
