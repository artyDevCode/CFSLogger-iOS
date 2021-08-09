//
//  CFSDB.m
//  CFSlogger
//
//  Created by pac-apps on 30/11/13.
//  Copyright (c) 2013 pac-apps. All rights reserved.
//

#import "CFSDB.h"


@implementation CFSDB
    

@synthesize username, symptomName, symptomTitle, field2, symptomDesc ,severity,recordedDate, actId,fromTime, toTime, activityType, activityTitle, activityDesc, energyLevel, field1;
//adateId


static CFSDB *database;


+(CFSDB *)database{
	if (database == nil){
		database = [[CFSDB alloc] init];
	}
	return database;
}

- (id) init {
	self = [super init];
	if (self) {
        
        NSString *documentsFolder = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *documentsPath   = [[documentsFolder stringByAppendingPathComponent:@"CFS"] stringByAppendingPathExtension:@"sqlite"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:documentsPath])
        {
            NSString *sqliteDB = [[NSBundle mainBundle] pathForResource:@"CFS" ofType:@"sqlite"];
            NSError *error;
            [fileManager copyItemAtPath:sqliteDB toPath:documentsPath error:&error];
            if (error != nil) {
                NSLog(@"[Database:Error] %@", error);
            }
            else
            {
                NSURL *fromURL = [NSURL fileURLWithPath:documentsPath];
                [self addSkipBackupAttributeToItemAtURL:fromURL];
            }
        }
       
       if (sqlite3_open_v2([documentsPath UTF8String], &database, SQLITE_OPEN_READWRITE|SQLITE_OPEN_CREATE, NULL) != SQLITE_OK){
			NSLog(@"Failed to load database ");
		}
        
	}
    
	return self;
}

-(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath:[URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    
    return success;
}

-(void)insertActivity:(CFSRecord *)RecordData
{
    const char *query = "INSERT INTO Activity (RecordedDate, ActId, FromTime, ToTime, ActivityType, ActivityTitle, ActivityDesc, Field2, EnergyLevel, Field1, SymptomName, SymptomTitle, SymptomDesc, Severity, UserName) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
   	sqlite3_stmt *statement=nil;
	
    if (sqlite3_prepare_v2(database, query, -1, &statement, nil)== SQLITE_OK)
	{
        
        NSUserDefaults *UserEmail = [NSUserDefaults standardUserDefaults];
        NSString *userEmail = [UserEmail stringForKey:@"UserEmail"];

        sqlite3_bind_text(statement,1,[RecordData.RecordedDate UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int64(statement,2, RecordData.ActId);
        sqlite3_bind_text(statement,3,[RecordData.FromTime UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,4, [RecordData.ToTime UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,5,[RecordData.ActivityType UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,6, [RecordData.ActivityTitle UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,7, [RecordData.ActivityDesc UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,8, [RecordData.Field2 UTF8String], -1, SQLITE_TRANSIENT);;
        sqlite3_bind_int64(statement,9, RecordData.EnergyLevel);
        sqlite3_bind_text(statement,10, [RecordData.Field1 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,11,[RecordData.SymptomName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,12, [RecordData.SymptomTitle UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,13, [RecordData.SymptomDesc UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,14, [RecordData.Severity UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,15,[userEmail UTF8String], -1, SQLITE_TRANSIENT);


        
        if(SQLITE_DONE != sqlite3_step(statement))
        {
            NSLog(@"Error updating record = %s", sqlite3_errmsg(database));
            
            NSAssert1(0, @"Error updating record", sqlite3_errmsg(database));
        }
        
        sqlite3_reset(statement);
    }
    else
    {
        const char *err = sqlite3_errmsg(database);
        NSString *errMsg = [NSString stringWithFormat:@"%s",err];
        NSLog(@"err insert activity = %@", errMsg);
    }
    sqlite3_finalize(statement);
    //sqlite3_int64 lastRowId = sqlite3_last_insert_rowid(database);

    //return lastRowId;
}



-(void)updateActivity:(CFSRecord *)Record
{
    const char *query = "UPDATE Activity SET RecordedDate = ?, ActId = ?, FromTime = ?, ToTime = ?, ActivityType = ?, ActivityTitle = ?, ActivityDesc = ?, EnergyLevel = ?, Field1 = ?, Field2 = ?, SymptomName = ?, SymptomTitle = ?, SymptomDesc = ?, Severity = ?, ActId = ? WHERE RecordedDate = ? and ActID = ? and UserName = ?"; //and ADateID = ?
   	sqlite3_stmt *statement=nil;
    if (sqlite3_prepare_v2(database, query, -1, &statement, nil)== SQLITE_OK)
	{
        NSUserDefaults *UserEmail = [NSUserDefaults standardUserDefaults];
        NSString *userEmail = [UserEmail stringForKey:@"UserEmail"];
        
        sqlite3_bind_text(statement,1,[Record.RecordedDate UTF8String], -1, SQLITE_TRANSIENT);
       // sqlite3_bind_int64(statement,2, Record.ServerRecordID);
        sqlite3_bind_int64(statement,2, Record.ActId);
        sqlite3_bind_text(statement,3,[Record.FromTime UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,4, [Record.ToTime UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,5,[Record.ActivityType UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,6, [Record.ActivityTitle UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,7, [Record.ActivityDesc UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int64(statement,8, Record.EnergyLevel);
        sqlite3_bind_text(statement,9, [Record.Field1 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,10, [Record.Field2 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,11,[Record.SymptomName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,12, [Record.SymptomTitle UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,13, [Record.SymptomDesc UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,14, [Record.Severity UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int64(statement,15, Record.ActId);
        sqlite3_bind_text(statement,16,[Record.RecordedDate UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int64(statement,17, Record.ActId);
        sqlite3_bind_text(statement,18,[userEmail UTF8String], -1, SQLITE_TRANSIENT);

        
        if(SQLITE_DONE != sqlite3_step(statement))
        {
            NSLog(@"Error updating record = %s", sqlite3_errmsg(database));
            
            NSAssert1(0, @"Error updating record", sqlite3_errmsg(database));
        }
        
        sqlite3_reset(statement);
    }
    sqlite3_finalize(statement);
}



-(NSMutableArray *)getAllRecords:(NSString *)mySelectedDate
{
	NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement = nil;
   
    const char *query = "SELECT Activity.RecordedDate, Activity.ActID, Activity.FromTime, Activity.ToTime, Activity.ActivityType, Activity.ActivityTitle, Activity.ActivityDesc, Activity.EnergyLevel, Activity.Field1, Activity.Field2, Activity.UserName, Activity.SymptomName, Activity.SymptomTitle, Activity.SymptomDesc, Activity.Severity from  Activity  where Activity.RecordedDate = ? and Activity.UserName = ? ORDER BY Activity.ActID ASC"; //Activity.ADateID,
    
    if (sqlite3_prepare_v2(database, query, -1, &statement, nil)== SQLITE_OK)
	{
        NSUserDefaults *UserEmail = [NSUserDefaults standardUserDefaults];
        NSString *userEmail = [UserEmail stringForKey:@"UserEmail"];
        
       sqlite3_bind_text(statement,1,[mySelectedDate UTF8String], -1, SQLITE_TRANSIENT);
       sqlite3_bind_text(statement,2,[userEmail UTF8String], -1, SQLITE_TRANSIENT);

        CFSRecord * nad = [[CFSRecord alloc] initWithUniqueId:
                                                 mySelectedDate
                                                     UserName:userEmail
                                                        ActId:0
                                                     FromTime:@""
                                                       ToTime:@""
                                                 ActivityType:@""
                                                ActivityTitle:@""
                                                 ActivityDesc:@""
                                                  EnergyLevel:0
                                                    Field1:@""
                                                   Field2:@""
                                                   SymptomName:@""
                                                     Severity:@""
                                                 SymptomTitle:@""
                                                  SymptomDesc:@""
                           ];
        [returnArray addObject:nad];
        
        
        
        
        
        
        
        
		while (sqlite3_step(statement)==SQLITE_ROW)
		{
            recordedDate = @"";
            username = userEmail;
            actId = 0;
            fromTime = @"";
            toTime = @"";
            activityType = @"";
            activityTitle = @"";
            activityDesc = @"";
            energyLevel = 0;
            field1 = @"";
            field2 = @"";
            symptomName = @"";
            symptomTitle = @"";
            symptomDesc = @"";
            severity = @"";

            
			char *cd_RecordedDate = (char *) sqlite3_column_text(statement, 0);

            int cd_ActId = sqlite3_column_int(statement, 1);
            char *cd_FromTime = (char *)sqlite3_column_text(statement, 2);
            char *cd_ToTime = (char *) sqlite3_column_text(statement, 3);
            char *cd_ActivityType =(char *) sqlite3_column_text(statement, 4);
            char *cd_ActivityTitle =(char *) sqlite3_column_text(statement, 5);
            char *cd_ActivityDesc =(char *) sqlite3_column_text(statement, 6);
           	int cd_EnergyLevel = sqlite3_column_int(statement, 7);
            char *cd_Field1 = (char *) sqlite3_column_text(statement, 8);
            char *cd_Field2 = (char *) sqlite3_column_text(statement, 9);
            char *cd_Username = (char *) sqlite3_column_text(statement, 10);
            char *cd_SymptomName = (char *) sqlite3_column_text(statement, 11);
            char *cd_SymptomTitle = (char *) sqlite3_column_text(statement, 12);
            char *cd_SymptomDesc = (char *) sqlite3_column_text(statement, 13);
            char *cd_Severity = (char *) sqlite3_column_text(statement, 14);

            recordedDate = [[NSString alloc] initWithUTF8String:cd_RecordedDate];
            username = [[NSString alloc] initWithUTF8String:cd_Username];
            actId = cd_ActId;
            fromTime = [[NSString alloc] initWithUTF8String:cd_FromTime];
            toTime = [[NSString alloc] initWithUTF8String:cd_ToTime];
            activityType = [[NSString alloc] initWithUTF8String:cd_ActivityType];
            activityTitle = [[NSString alloc] initWithUTF8String:cd_ActivityTitle];
            activityDesc = [[NSString alloc] initWithUTF8String:cd_ActivityDesc];
            energyLevel = cd_EnergyLevel;
            field1 = [[NSString alloc] initWithUTF8String:cd_Field1];
            field2 = [[NSString alloc] initWithUTF8String:cd_Field2];
            symptomName = [[NSString alloc] initWithUTF8String:cd_SymptomName];
            symptomTitle = [[NSString alloc] initWithUTF8String:cd_SymptomTitle];
            symptomDesc = [[NSString alloc] initWithUTF8String:cd_SymptomDesc];
            if (cd_Severity == NULL)
                severity = @"";
            else
                severity = [[NSString alloc] initWithUTF8String:cd_Severity];
            

            CFSRecord *nad = [[CFSRecord alloc] initWithUniqueId:
                                                        recordedDate
                                                        UserName:username
                                                           ActId:actId
                                                        FromTime:fromTime
                                                          ToTime:toTime
                                                    ActivityType:activityType
                                                   ActivityTitle:activityTitle
                                                    ActivityDesc:activityDesc
                                                     EnergyLevel:energyLevel
                                                       Field1:field1
                                                          Field2:field2
                                                     SymptomName:symptomName
                                                        Severity:severity
                                                    SymptomTitle:symptomTitle
                                                     SymptomDesc:symptomDesc
                              ];
            [returnArray addObject:nad];
            nad = nil;
            
        }
        sqlite3_reset(statement);
    }
    else
    {
        const char *err = sqlite3_errmsg(database);
        NSString *errMsg = [NSString stringWithFormat:@"%s",err];
        NSLog(@"err = %@", errMsg);
    }
    
    sqlite3_finalize(statement);
    return returnArray;
	
}


-(NSMutableArray *)getLatestRecords
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement = nil;
    
    const char *query = "SELECT Activity.RecordedDate, Activity.ActID, Activity.FromTime, Activity.ToTime, Activity.ActivityType, Activity.ActivityTitle, Activity.ActivityDesc, Activity.EnergyLevel, Activity.Field1, Activity.Field2, Activity.UserName, Activity.SymptomName, Activity.SymptomTitle, Activity.SymptomDesc, Activity.Severity from Activity where Activity.UserName = ? ORDER BY Activity.RecordedDate DESC Limit 6"; //Activity.ADateID,
    
    if (sqlite3_prepare_v2(database, query, -1, &statement, nil)== SQLITE_OK)
    {
        NSUserDefaults *UserEmail = [NSUserDefaults standardUserDefaults];
        NSString *userEmail = [UserEmail stringForKey:@"UserEmail"];
        
        sqlite3_bind_text(statement,1,[userEmail UTF8String], -1, SQLITE_TRANSIENT);
        
             
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            recordedDate = @"";
            username = userEmail;
            actId = 0;
         //   serverRecordID = 0;
            fromTime = @"";
            toTime = @"";
            activityType = @"";
            activityTitle = @"";
            activityDesc = @"";
            energyLevel = 0;
            field1 = @"";
            field2 = @"";
            symptomName = @"";
            symptomTitle = @"";
            symptomDesc = @"";
            severity = @"";

            
            char *cd_RecordedDate = (char *) sqlite3_column_text(statement, 0);
            
            int cd_ActId = sqlite3_column_int(statement, 1);
         //   int cd_ServerRecordID = sqlite3_column_int(statement, 2);
            
            char *cd_FromTime = (char *)sqlite3_column_text(statement, 2);
            char *cd_ToTime = (char *) sqlite3_column_text(statement,3);
            char *cd_ActivityType =(char *) sqlite3_column_text(statement, 4);
            char *cd_ActivityTitle =(char *) sqlite3_column_text(statement, 5);
            char *cd_ActivityDesc =(char *) sqlite3_column_text(statement, 6);
           	int cd_EnergyLevel = sqlite3_column_int(statement, 7);
            char *cd_Field1 = (char *) sqlite3_column_text(statement, 8);
            char *cd_Field2 = (char *) sqlite3_column_text(statement, 9);
            char *cd_Username = (char *) sqlite3_column_text(statement, 10);
            char *cd_SymptomName = (char *) sqlite3_column_text(statement, 11);
            char *cd_SymptomTitle = (char *) sqlite3_column_text(statement, 12);
            char *cd_SymptomDesc = (char *) sqlite3_column_text(statement, 13);
            char *cd_Severity = (char *) sqlite3_column_text(statement, 14);
            
            recordedDate = [[NSString alloc] initWithUTF8String:cd_RecordedDate];
            username = [[NSString alloc] initWithUTF8String:cd_Username];
            actId = cd_ActId;
          //  serverRecordID = cd_ServerRecordID;
            fromTime = [[NSString alloc] initWithUTF8String:cd_FromTime];
            toTime = [[NSString alloc] initWithUTF8String:cd_ToTime];
            activityType = [[NSString alloc] initWithUTF8String:cd_ActivityType];
            activityTitle = [[NSString alloc] initWithUTF8String:cd_ActivityTitle];
            activityDesc = [[NSString alloc] initWithUTF8String:cd_ActivityDesc];
            energyLevel = cd_EnergyLevel;
            field1 = [[NSString alloc] initWithUTF8String:cd_Field1];
            field2 = [[NSString alloc] initWithUTF8String:cd_Field2];
            symptomName = [[NSString alloc] initWithUTF8String:cd_SymptomName];
            symptomTitle = [[NSString alloc] initWithUTF8String:cd_SymptomTitle];
            symptomDesc = [[NSString alloc] initWithUTF8String:cd_SymptomDesc];
            if (cd_Severity == NULL)
                severity = @"";
            else
                severity = [[NSString alloc] initWithUTF8String:cd_Severity];
            
            
            CFSRecord *nad = [[CFSRecord alloc] initWithUniqueId:
                              recordedDate
                                                        UserName:username
                                                           ActId:actId
                                                //  ServerRecordID:serverRecordID
                                                        FromTime:fromTime
                                                          ToTime:toTime
                                                    ActivityType:activityType
                                                   ActivityTitle:activityTitle
                                                    ActivityDesc:activityDesc
                                                     EnergyLevel:energyLevel
                                                          Field1:field1
                                                          Field2:field2
                                                     SymptomName:symptomName
                                                        Severity:severity
                                                    SymptomTitle:symptomTitle
                                                     SymptomDesc:symptomDesc
                              ];
            [returnArray addObject:nad];
            nad = nil;
            
        }
        sqlite3_reset(statement);
    }
    else
    {
        const char *err = sqlite3_errmsg(database);
        NSString *errMsg = [NSString stringWithFormat:@"%s",err];
        NSLog(@"err = %@", errMsg);
    }
    
    sqlite3_finalize(statement);
    return returnArray;
    
}



-(NSMutableArray *)getAllRecordsSync:(NSString *)CalendarFirstDate claLastDate:(NSString *) CalendarLastDate
{
   
	NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement = nil;
  
    const char *query = "SELECT RecordedDate, ActID, FromTime, ToTime, ActivityType, ActivityTitle, ActivityDesc, EnergyLevel, Field1, Field2, UserName, SymptomName, SymptomTitle, SymptomDesc, Severity from  Activity where RecordedDate BETWEEN ? and ? and UserName = ? ORDER BY FromTime DESC";  //ADateID

    if (sqlite3_prepare_v2(database, query, -1, &statement, nil)== SQLITE_OK)
	{
        NSUserDefaults *UserEmail = [NSUserDefaults standardUserDefaults];
        NSString *userEmail = [UserEmail stringForKey:@"UserEmail"];

        
        sqlite3_bind_text(statement,1,[CalendarFirstDate UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,2,[CalendarLastDate UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,3,[userEmail UTF8String], -1, SQLITE_TRANSIENT);


        
		while (sqlite3_step(statement)==SQLITE_ROW)
		{
            recordedDate = @"";
            username = userEmail;
            actId = 0;
           // serverRecordID = 0;
            fromTime = @"";
            toTime = @"";
            activityType = @"";
            activityTitle = @"";
            activityDesc = @"";
            energyLevel = 0;
            field1 = @"";
            field2 = @"";
            symptomName = @"";
            symptomTitle = @"";
            symptomDesc = @"";
            severity = @"";
            
			char *cd_RecordedDate = (char *) sqlite3_column_text(statement, 0);
            
            int cd_ActId = sqlite3_column_int(statement, 1);
         //   int cd_ServerRecordID = sqlite3_column_int(statement, 2);
            char *cd_FromTime = (char *)sqlite3_column_text(statement, 2);
            char *cd_ToTime = (char *) sqlite3_column_text(statement, 3);
            char *cd_ActivityType =(char *) sqlite3_column_text(statement, 4);
            char *cd_ActivityTitle =(char *) sqlite3_column_text(statement, 5);
            char *cd_ActivityDesc =(char *) sqlite3_column_text(statement, 6);
           	int cd_EnergyLevel = sqlite3_column_int(statement, 7);
            char * cd_Field1 = (char *) sqlite3_column_text(statement, 8);
            char * cd_Field2 = (char *) sqlite3_column_text(statement, 9);
            char *cd_Username =(char *) sqlite3_column_text(statement, 10);
            char *cd_SymptomName = (char *) sqlite3_column_text(statement, 11);
            char *cd_SymptomTitle = (char *) sqlite3_column_text(statement, 12);
            char *cd_SymptomDesc = (char *) sqlite3_column_text(statement, 13);
            char *cd_Severity = (char *) sqlite3_column_text(statement, 14);

            
            recordedDate = [[NSString alloc] initWithUTF8String:cd_RecordedDate];
            username = [[NSString alloc] initWithUTF8String:cd_Username];
            actId = cd_ActId;
           // serverRecordID = cd_ServerRecordID;
            fromTime = [[NSString alloc] initWithUTF8String:cd_FromTime];
            toTime = [[NSString alloc] initWithUTF8String:cd_ToTime];
            activityType = [[NSString alloc] initWithUTF8String:cd_ActivityType];
            activityTitle = [[NSString alloc] initWithUTF8String:cd_ActivityTitle];
            activityDesc = [[NSString alloc] initWithUTF8String:cd_ActivityDesc];
            energyLevel = cd_EnergyLevel;
            field1 = [[NSString alloc] initWithUTF8String:cd_Field1];
            field2 = [[NSString alloc] initWithUTF8String:cd_Field2];
            symptomName = [[NSString alloc] initWithUTF8String:cd_SymptomName];
            symptomTitle = [[NSString alloc] initWithUTF8String:cd_SymptomTitle];
            symptomDesc = [[NSString alloc] initWithUTF8String:cd_SymptomDesc];
            if (cd_Severity == NULL)
                severity = @"";
            else
                severity = [[NSString alloc] initWithUTF8String:cd_Severity];

            CFSRecord *nad = [[CFSRecord alloc] initWithUniqueId:
                                                        recordedDate
                                                        UserName:username
                                                           ActId:actId
                                                  //ServerRecordID:serverRecordID
                                                        FromTime:fromTime
                                                          ToTime:toTime
                                                    ActivityType:activityType
                                                   ActivityTitle:activityTitle
                                                    ActivityDesc:activityDesc
                                                     EnergyLevel:energyLevel
                                                       Field1:field1
                                                   Field2:field2
                                                   SymptomName:symptomName
                                                        Severity:severity
                                                    SymptomTitle:symptomTitle
                                                     SymptomDesc:symptomDesc
                              ];
            [returnArray addObject:nad];
            nad = nil;
            
        }
        sqlite3_reset(statement);
    }
    else
    {
        const char *err = sqlite3_errmsg(database);
        NSString *errMsg = [NSString stringWithFormat:@"%s",err];
        NSLog(@"err = %@", errMsg);
    }
    
    sqlite3_finalize(statement);
    return returnArray;

	
}





-(sqlite3_int64)checkExistingRecords:(NSString *)mySelectedDate
{
	sqlite3_int64 cd_ActID = 0;
    sqlite3_stmt *statement = nil;
    
    const char *query = "SELECT Activity.ActID from Activity where Activity.RecordedDate = ? and Activity.UserName = ? ";
    
    if (sqlite3_prepare_v2(database, query, -1, &statement, nil)== SQLITE_OK)
	{
        NSUserDefaults *UserEmail = [NSUserDefaults standardUserDefaults];
        NSString *userEmail = [UserEmail stringForKey:@"UserEmail"];
        
        sqlite3_bind_text(statement,1,[mySelectedDate UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,2,[userEmail UTF8String], -1, SQLITE_TRANSIENT);

     
        
		while (sqlite3_step(statement)==SQLITE_ROW)
		{
            cd_ActID = sqlite3_column_int(statement, 0);
        }
    }
    sqlite3_finalize(statement);
    return cd_ActID;
}




-(NSMutableArray *)searchRecords
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement = nil;
    
    const char *query = "SELECT Activity.RecordedDate, Activity.ActID, Activity.FromTime, Activity.ToTime, Activity.ActivityType, Activity.ActivityTitle, Activity.ActivityDesc, Activity.EnergyLevel, Activity.Field1, Activity.Field2, Activity.UserName, Activity.SymptomName, Activity.SymptomTitle, Activity.SymptomDesc, Activity.Severity from  Activity  where  Activity.UserName = ? and Activity.RecordedDate IS NOT NULL ORDER BY Activity.FromTime DESC"; //Activity.ADateID,
    
    if (sqlite3_prepare_v2(database, query, -1, &statement, nil)== SQLITE_OK)
    {
        NSUserDefaults *UserEmail = [NSUserDefaults standardUserDefaults];
        NSString *userEmail = [UserEmail stringForKey:@"UserEmail"];
        
        sqlite3_bind_text(statement,1,[userEmail UTF8String], -1, SQLITE_TRANSIENT);
        
        
        
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            
            recordedDate = @"";
            username = userEmail;
            actId = 0;
           // serverRecordID = 0;
            fromTime = @"";
            toTime = @"";
            activityType = @"";
            activityTitle = @"";
            activityDesc = @"";
            energyLevel = 0;
            field1 = @"";
            field2 = @"";
            symptomName = @"";
            symptomTitle = @"";
            symptomDesc = @"";
            severity = @"";

            
            char *cd_RecordedDate = (char *) sqlite3_column_text(statement, 0);
            
            int cd_ActId = sqlite3_column_int(statement, 1);
           // int cd_ServerRecordID = sqlite3_column_int(statement, 2);
            
            char *cd_FromTime = (char *)sqlite3_column_text(statement, 2);
            char *cd_ToTime = (char *) sqlite3_column_text(statement, 3);
            char *cd_ActivityType =(char *) sqlite3_column_text(statement, 4);
            char *cd_ActivityTitle =(char *) sqlite3_column_text(statement, 5);
            char *cd_ActivityDesc =(char *) sqlite3_column_text(statement, 6);
           	int cd_EnergyLevel = sqlite3_column_int(statement, 7);
            char *cd_Field1 = (char *) sqlite3_column_text(statement, 8);
            char *cd_Field2 = (char *) sqlite3_column_text(statement, 9);
            char *cd_Username = (char *) sqlite3_column_text(statement, 10);
            char *cd_SymptomName = (char *) sqlite3_column_text(statement, 11);
            char *cd_SymptomTitle = (char *) sqlite3_column_text(statement, 12);
            char *cd_SymptomDesc = (char *) sqlite3_column_text(statement, 13);
            char *cd_Severity = (char *) sqlite3_column_text(statement, 14);
            
            recordedDate = [[NSString alloc] initWithUTF8String:cd_RecordedDate];
            username = [[NSString alloc] initWithUTF8String:cd_Username];
           // serverRecordID = cd_ServerRecordID;
            actId = cd_ActId;
            fromTime = [[NSString alloc] initWithUTF8String:cd_FromTime];
            toTime = [[NSString alloc] initWithUTF8String:cd_ToTime];
            activityType = [[NSString alloc] initWithUTF8String:cd_ActivityType];
            activityTitle = [[NSString alloc] initWithUTF8String:cd_ActivityTitle];
            activityDesc = [[NSString alloc] initWithUTF8String:cd_ActivityDesc];
            energyLevel = cd_EnergyLevel;
            field1 = [[NSString alloc] initWithUTF8String:cd_Field1];
            field2 = [[NSString alloc] initWithUTF8String:cd_Field2];
            symptomName = [[NSString alloc] initWithUTF8String:cd_SymptomName];
            symptomTitle = [[NSString alloc] initWithUTF8String:cd_SymptomTitle];
            symptomDesc = [[NSString alloc] initWithUTF8String:cd_SymptomDesc];
            if (cd_Severity == NULL)
                severity = @"";
            else
                severity = [[NSString alloc] initWithUTF8String:cd_Severity];
            
            
            CFSRecord *nad = [[CFSRecord alloc] initWithUniqueId:
                              recordedDate
                                                        UserName:username
                                                           ActId:actId
                                               //   ServerRecordID:serverRecordID
                                                        FromTime:fromTime
                                                          ToTime:toTime
                                                    ActivityType:activityType
                                                   ActivityTitle:activityTitle
                                                    ActivityDesc:activityDesc
                                                     EnergyLevel:energyLevel
                                                          Field1:field1
                                                          Field2:field2
                                                     SymptomName:symptomName
                                                        Severity:severity
                                                    SymptomTitle:symptomTitle
                                                     SymptomDesc:symptomDesc
                              ];
            [returnArray addObject:nad];
            nad = nil;

        }
        sqlite3_reset(statement);
    }
    else
    {
        const char *err = sqlite3_errmsg(database);
        NSString *errMsg = [NSString stringWithFormat:@"%s",err];
        NSLog(@"err = %@", errMsg);
    }
   
    sqlite3_finalize(statement);
    return returnArray;
	
}


@end
